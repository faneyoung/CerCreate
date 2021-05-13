//
//  ZXSDScriptMessageHandler.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/28.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDScriptMessageHandler.h"
#import "ZXShareManager.h"

#import "ZXWithdrawViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "ZXSDBaseTabBarController.h"

#define ZXSD_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

typedef void(^FunctionResultHandler)(id result);

@interface ZXSDScriptMessageHandler ()<WKScriptMessageHandler>

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) UINavigationController *currentNaviController;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation ZXSDScriptMessageHandler


- (instancetype)initWithWebView:(WKWebView *)webView navigationController:(nonnull UINavigationController *)naviController {
    self = [super init];
    if (self) {
        self.webView = webView;
        self.currentNaviController = naviController;
        self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:webView];
        [self.bridge setWebViewDelegate:naviController.topViewController];
        [self regitsterHanler];
    }
    return self;
}


- (void)regitsterHanler
{
    [self.bridge registerHandler:@"getUserSession" handler:^(id data, WVJBResponseCallback responseCallback) {
        ZGLog(@"getUserSession called with param: %@", data);
        NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
        
        responseCallback(userSession);
    }];
    
    [self.bridge registerHandler:@"pushNativePage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self openNativePage:data];
    }];
    
    [self.bridge registerHandler:@"callPhone" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self callPhone:data];
    }];
    
    [self.bridge registerHandler:@"shareWechat" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self showShareActionViewWithData:data];
    }];

    [self.bridge registerHandler:@"onBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.currentNaviController popToRootViewControllerAnimated:YES];
    }];
    
    [self.bridge registerHandler:@"hideTitleBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        ZXSDWebViewController *webView =  (ZXSDWebViewController*)self.currentNaviController.topViewController;
        webView.isHideNavigationBar = YES;
        [self.currentNaviController setNavigationBarHidden:YES animated:YES];
    }];
}
#pragma mark - js调native -
- (void)showShareActionViewWithData:(NSDictionary*)data{
    [ZXShareManager.sharedManager showImageShareViewWithData:data];
}


- (void)openNativePage:(id)param
{
    if (!param || ![param isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *pageName = [param objectForKey:@"pageName"];
        // 提现
        if ([pageName isEqualToString:@"withdrawal"]) {
            ZXWithdrawViewController *vc = [[ZXWithdrawViewController alloc] init];
            vc.fromActivity = YES;
            [self.currentNaviController pushViewController:vc animated:YES];
        }
        
        // 返回用户中心
        if ([pageName isEqualToString:@"userCenter"]) {
            
            [self.currentNaviController popToRootViewControllerAnimated:NO];
            UIViewController *root = [UIApplication sharedApplication].delegate.window.rootViewController;
            if ([root isKindOfClass:[ZXSDBaseTabBarController class]]) {
                ZXSDBaseTabBarController *tabbar = (ZXSDBaseTabBarController *)root;
                [tabbar selectTab:ZXTabBarTypeMine];
            }
        }
        
        if ([pageName isEqualToString:@"orderCenter"]) {
            [self.currentNaviController popToRootViewControllerAnimated:NO];
            [URLRouter routerUrlWithPath:kRouter_orderPage extra:nil];
        }
        else if ([pageName isEqualToString:@"shoppingMall"]) {
            [self goToMall];
        }
        
    });
}

- (void)goToMall{
    [self.currentNaviController popToRootViewControllerAnimated:NO];
    [[AppDelegate appDelegate].tabBarController selectTab:ZXTabBarTypeMall];
}


- (void)callPhone:(NSDictionary *)params
{
    NSString *value = [NSString stringWithFormat:@"tel://%@", [params objectForKey:@"phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:value]];
}

/**
js和native通信代码
functionParam: 为字符串或字典，字典中的value也是字符串
window.webkit.messageHandlers.smileApp.postMessage({functionName:'aFuncName',functionParam:('' || {}), callback:''});
*/
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"smileApp"]) {
        NSDictionary *param = message.body;
        NSString *functionName = [param objectForKey:@"functionName"];
        id functionParam = [param objectForKey:@"functionParam"];
        NSString *callback = [param objectForKey:@"callback"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self excuteFunction:functionName functionParam:functionParam jsCallback:callback];
        });
    }
}

- (void)excuteFunction:(NSString *)functionName
         functionParam:(id)functionParam
            jsCallback:(NSString *)callback
{
    if (functionName.length) {
        FunctionResultHandler resultHandler = ^(id result){
            if (result) {
                [self nativeApp2JS:result forFunctionName:functionName jsCallback:callback];
            }
        };
        
        NSString *localFunctionName = [NSString stringWithFormat:@"%@:completeHandler:", functionName];
        if ([self respondsToSelector:NSSelectorFromString(localFunctionName)]) {
            ZXSD_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self performSelector:NSSelectorFromString(localFunctionName) withObject:functionParam withObject:resultHandler];);
        }
    }
}

- (void)nativeApp2JS:(id)functionResult
     forFunctionName:(NSString *)functionName
          jsCallback:(NSString *)callback
{
    if (functionResult && functionName.length) {

        NSString *jsParamStr = nil;
        if ([functionResult isKindOfClass:[NSString class]]) {
            jsParamStr = functionResult;
        } else if ([functionResult isKindOfClass:[NSDictionary class]]) {
            NSError *e = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:functionResult
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&e];
            if (jsonData.length && e == nil) {
                NSString *json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSMutableString *jsonStr = [NSMutableString stringWithString:json];
                NSRange range = {0, json.length};
                [jsonStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
                NSRange range2 = {0, jsonStr.length};
                [jsonStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
                
                jsParamStr = jsonStr;
            }
        } else {
            return;
        }
        
        if (callback.length) {
            NSString *js;
            if (jsParamStr.length) {
                js = [NSString stringWithFormat:@"%@('%@')", callback, jsParamStr];
            } else {
                js = [NSString stringWithFormat:@"%@()", callback];
            }
            
            [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable r, NSError * _Nullable error) {
                if (error) {
                    ZGLog(@"evaluateJavaScript error: %@", error);
                }
            }];
        }
        
    }
}

- (void)addScriptHandlers
{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"smileApp"];
}

- (void)removeScriptHandlers
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"smileApp"];
}

- (void)getUserSession:(id)param
       completeHandler:(FunctionResultHandler)resultHandler
{
    NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
    resultHandler(userSession);
}

- (void)pushNativePage:(id)param completeHandler:(FunctionResultHandler)resultHandler
{
    if (!param || ![param isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *pageName = [param objectForKey:@"pageName"];
        if ([pageName isEqualToString:@"withdrawal"]) {
            ZXWithdrawViewController *vc = [[ZXWithdrawViewController alloc] init];
            vc.fromActivity = YES;
            [self.currentNaviController pushViewController:vc animated:YES];
        }
        
        // 返回用户中心
        if ([pageName isEqualToString:@"userCenter"]) {
            
            [self.currentNaviController popToRootViewControllerAnimated:NO];
            UIViewController *root = [UIApplication sharedApplication].delegate.window.rootViewController;
            if ([root isKindOfClass:[ZXSDBaseTabBarController class]]) {
                ZXSDBaseTabBarController *tabbar = (ZXSDBaseTabBarController *)root;
                [tabbar selectTab:ZXTabBarTypeMine];
            }
        }
        
        if ([pageName isEqualToString:@"orderCenter"]) {
            [self.currentNaviController popToRootViewControllerAnimated:NO];
            [URLRouter routerUrlWithPath:kRouter_orderPage extra:nil];
        }
        
        if ([pageName isEqualToString:@"shoppingMall"]) {
            [self goToMall];
        }

    });

}

@end
