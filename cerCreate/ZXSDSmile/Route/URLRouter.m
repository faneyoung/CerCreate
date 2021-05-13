//
//  URLRouter.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "URLRouter.h"
#import <NSString+YYAdd.h>
//#import <YYThreadSafeArray.h>
#import <UMShare/UMShare.h>
#import <WXApi.h>
#import <WXApiObject.h>


#import "NSArray+Helper.h"

#import "NSURL+QueryDictionary.h"
#import "ZXSDWebViewController.h"
#import "ZXSDNavigationController.h"
#import "URLRouterHeader.h"
#import "ZXBannerModel.h"


@interface URLRouter ()

@property (nonatomic, assign) BOOL needCheckUser;

@property (nonatomic, copy) NSDictionary *vcConfigs;
@property (nonatomic, copy) NSDictionary *actionConfigs;

@end

@implementation URLRouter

static id sharedInstance = nil;
+(instancetype)sharedInstance{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self.class alloc] init];
        }
    }
    return sharedInstance;
}


- (instancetype)init{
    self = [super init];
    if (self){
        
        NSString *configsJson = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"URLRouters" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *configs = [configsJson jsonValueDecoded];
        
        self.vcConfigs = [configs objectForKey:@"vcs"];
        self.actionConfigs = [configs objectForKey:@"actions"];
    }
    return self;
}

#pragma mark - help methods -

+ (void)routeToMainPageTab{
    [[AppDelegate appDelegate].tabBarController selectTab:ZXTabBarTypeHome];
}

+ (void)routeToTaskCenterTab{
    [[AppDelegate appDelegate].tabBarController selectTab:ZXTabBarTypeTaskCenter];
}


- (NSURL *)urlRouterWithPath:(NSString *)path component:(NSString *)component params:(NSDictionary *)params{
    
    if (!IsValidString(path)) {
        return nil;
    }
    
    NSURL *url = path.URLByCheckCharacter;
    
    if ([path rangeOfString:@"http"].location != NSNotFound ||
        [path rangeOfString:@"https"].location != NSNotFound) {
        
        if (IsValidString(component)) {
            url = [url URLByAppendingPathComponent:component];
        }
        if (IsValidDictionary(params)) {
            url = [url uq_URLByAppendingQueryDictionary:params];
        }

        return url;
    }
    else if ([path rangeOfString:kAPPBaseURL].location != NSNotFound){

        if (IsValidString(component)) {
            url = [url URLByAppendingPathComponent:component];
        }
        if (IsValidDictionary(params)) {
            url = [url uq_URLByAppendingQueryDictionary:params];
        }
        
        return url;

    }
    

    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",kAPPBaseURL,path];
    url = [NSURL URLWithString:urlStr];
    if (IsValidString(component)) {
        url = [url URLByAppendingPathComponent:component];
    }
    if (IsValidDictionary(params)) {
        url = [url uq_URLByAppendingQueryDictionary:params];
    }
    
    return url;
}

#pragma mark - route methods -

+ (void)routerUrlWithBannerModel:(ZXBannerModel*)banner extra:(NSDictionary* _Nullable)extra{
    
    if (!IsValidString(banner.url)) {
        return;
    }
    
    NSString *bannerUrl = banner.url;
    NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];

    if (banner.needLogin &&
        IsValidString(userSession)) {
        bannerUrl = QueryStrEncoding(bannerUrl, @{@"session":userSession});
    }
    
    NSMutableDictionary *tmps = [NSMutableDictionary dictionaryWithDictionary:extra];
    [tmps setSafeValue:@(banner.isHideTitle) forKey:@"isHideTitle"];
    extra = tmps.copy;
    
    [URLRouter routerUrlWithPath:bannerUrl extra:extra outLink:banner.linkFlag];
    
}


+ (void)routerUrlWithPath:(NSString *)path extra:(NSDictionary * _Nullable)extra{
    [[URLRouter sharedInstance] routerWithUrl:[[URLRouter sharedInstance] urlRouterWithPath:path component:nil params:nil] fromNav:nil parameters:extra option:RouterOption_New];
}

+ (void)routerUrlWithPath:(NSString *)path extra:(NSDictionary * _Nullable)extra outLink:(BOOL)outLink{
    if (outLink) {
        if (!IsValidString(path)) {
            return;
        }
        
        if ([[UIApplication sharedApplication] canOpenURL:path.URLByCheckCharacter]) {
            [[UIApplication sharedApplication] openURL:path.URLByCheckCharacter options:@{} completionHandler:nil];
        }
        return;
    }
    [[URLRouter sharedInstance] routerWithUrl:[[URLRouter sharedInstance] urlRouterWithPath:path component:nil params:nil] fromNav:nil parameters:extra option:RouterOption_New];
}


- (void)routerWithUrl:(NSURL*)url fromNav:(UINavigationController * _Nullable)fromNav parameters:(id _Nullable)pms option:(RouterOption)options{

    if (!url) {
        return;
    }
    
    //actionConfigs
    if ([self actionWithUrl:url extra:pms complete:nil]) {
        return;
    }
    
    
    UIViewController *vc = [self viewControllerWithUrl:url extra:pms];
    if (!vc) {
        return;
    }
    
    
    vc.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *navc = fromNav?:[URLRouter currentNavigationController];
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:navc.viewControllers];
    
    if(options & RouterOption_Close){
        [vcs removeLastObject];
    }
    
    NSInteger existedIndex = -1;
    if ([vc isKindOfClass:[ZXSDBaseViewController class]] && ((options & RouterOption_Existed) || (options & RouterOption_Refresh))) {
        ZXSDBaseViewController *baseVc = (ZXSDBaseViewController *)vc;
        for (NSInteger i = 0; i < vcs.count; i ++ ) {
            id obj = [vcs objectAtIndex:i];
            if ([baseVc isKindOfClass:[obj class]]) {
                existedIndex = i;
                break;
            }
        }
        
        if(existedIndex >= 0 && (options & RouterOption_Refresh)){
            
            ZXSDBaseViewController *existedVc = [vcs objectAtIndex:existedIndex];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[url uq_queryDictionary]];
            if (IsValidDictionary(pms)) {
                [params addEntriesFromDictionary:pms];
            }
            [existedVc yy_modelSetWithDictionary:params.copy];
            
            [existedVc refreshAllData];
        }
    }
    
    if (existedIndex >= 0  && existedIndex < vcs.count) {
        NSArray *newVcs = [vcs subarrayWithRange:NSMakeRange(0, existedIndex+1)];
        [navc setViewControllers:newVcs animated:YES];
    }else{
        UIViewController *presentedVc = nil;
        if(options & RouterOption_Present){
            presentedVc = vc;
        }else if (options & RouterOption_PresentNav){
            ZXSDNavigationController *nav = [[ZXSDNavigationController alloc] initWithRootViewController:vc];
            presentedVc = nav;
        }
        if (presentedVc) {
            dispatch_safe_async_main(^{
                [[URLRouter currentRootViewController] presentViewController:presentedVc animated:YES completion:nil];
            });
        }else{
            dispatch_safe_async_main(^{
                [[URLRouter currentNavigationController] pushViewController:vc animated:YES];
            });

        }
    }

    
}

#pragma mark 根据URL匹配界面
- (UIViewController *)viewControllerWithUrl:(NSURL *)url extra:(NSDictionary *)extra{
    UIViewController *resultVc = nil;
    NSString *scheme = url.scheme;
    if ([scheme hasPrefix:@"http"]
        || [scheme hasPrefix:@"https"]) {
        ZXSDWebViewController *webVc = [[ZXSDWebViewController alloc] init];
        [webVc yy_modelSetWithDictionary:extra];
        webVc.requestURL = [url absoluteString];
        resultVc = webVc;
    }else if([scheme hasPrefix:kAPPScheme]) {
        NSString *path = url.path;
        if (!IsValidString(path)) {
            return nil;
        }
        if ([path containsString:@"/"]) {
            NSArray *paths = [path componentsSeparatedByString:@"/"];
            if (paths.count > 1) {
                path = [paths safty_objectAtIndex:1];
            }
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[url uq_queryDictionary]];
        if (extra && extra.count > 0) {
            [params addEntriesFromDictionary:extra];
        }
        
        NSDictionary *config = [self.vcConfigs objectForKey:path];
        NSString *className = [config objectForKey:@"className"];
        if (IsValidString(className)) {
            Class vcClass = NSClassFromString(className);
            UIViewController *vc = nil;
            if (vcClass) {
                vc = [[vcClass alloc] init];
            }
            
            if (vc && [vc isKindOfClass:[ZXSDBaseViewController class]]) {
                resultVc = vc;
                
                NSDictionary *param = [config objectForKey:@"params"];
                if (param && param.count > 0) {
                    [params addEntriesFromDictionary:param];
                }
            }
            
        }
        
        if (params.count > 0) {
            [resultVc yy_modelSetWithDictionary:params];
        }
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self tabSelectWithPath:path params:params];
//        });

        BOOL noNeedLogin = [[params objectForKey:kURLParam_needLogin] boolValue];
        if (noNeedLogin) {
//            if ([AccountManager sharedManager].loginState != LoginState_In) {
//                [[AccountManager sharedManager] logout];
//                return nil;
//            }
        }
        
        
        
    }
    
    return resultVc;
}

#pragma mark - 根据action进行跳转 -

- (BOOL)actionWithUrl:(NSURL *)url extra:(NSDictionary *)extra complete:(void(^)(id result, NSError *error))completeBlock{
    BOOL result = NO;

    NSString *scheme = url.scheme;

    if ([scheme hasPrefix:@"http"] ||
        [scheme hasPrefix:@"https"]) {
        
        return NO;
        
    }else if([scheme hasPrefix:kAPPScheme]) {
        NSString *path = url.path;
        if (!IsValidString(path)) {
            return NO;
        }
        if ([path containsString:@"/"]) {
            NSArray *paths = [path componentsSeparatedByString:@"/"];
            if (paths.count > 1) {
                path = [paths safty_objectAtIndex:1];
            }
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[url uq_queryDictionary]];
        if (extra && extra.count > 0) {
            [params addEntriesFromDictionary:extra];
        }
        
        
        NSDictionary *config = [self.actionConfigs objectForKey:path];
        
        BOOL hasAction = NO;
        if (config && config.count > 0) {
            NSString *methodName = [config objectForKey:@"methodName"];
            if (IsValidString(methodName)) {
                SEL selector = NSSelectorFromString(methodName);
                if (selector && [self respondsToSelector:selector]) {
                    IMP imp = [self methodForSelector:selector];
                    NSDictionary *paramter = [config objectForKey:@"params"];
                    if (paramter && paramter.count > 0) {
                        [params addEntriesFromDictionary:paramter];
                    }
                    
                    BOOL noNeedLogin = [[params objectForKey:kURLParam_needLogin] boolValue];
                    if (noNeedLogin) {
//                        if ([AccountManager sharedManager].loginState != LoginState_In) {
//                            [[AccountManager sharedManager] logout];
//                            return YES;
//                        }
                    }

                    if ([self respondsToSelector:selector]) {
                        [self performSelector:selector withObject:params];
                    }
                    else{
                        NSLog(@"----------");

                    }

                    
                    hasAction = YES;
                }
            }
        }
        
        if (hasAction) {
            result = YES;
        }else{
            
        }

    }else{

    }

    return result;
}

#pragma mark - UI methods -

+ (UIViewController *)currentRootViewController{
    UIViewController *tabbarVc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    
    return tabbarVc;
}

+ (UINavigationController *)currentNavigationController{
    
    UINavigationController *nav = nil;
    
    UIViewController *rootVc = [self currentRootViewController];
    
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)rootVc;
    }else if ([rootVc isKindOfClass:[UITabBarController class]]){
        UIViewController *currentVc = [(UITabBarController *)rootVc selectedViewController];
        if ([currentVc isKindOfClass:[UINavigationController class]]) {
            nav = (UINavigationController *)currentVc;
        }
    }
    
    if (rootVc.presentedViewController && [rootVc.presentedViewController isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)rootVc.presentedViewController;
    }
    
    return nav;
}

#pragma mark - 推送跳转处理 -
/**
 跳转字段规则：如果url字段不为空，这跳转url ；如果url字段为nil，则取code字段
 */
+ (void)routerRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"----------routerRemoteNotification=%@",userInfo.modelToJSONString);


    NSString *urlStr = [userInfo stringObjectForKey:@"url"];
    if(!IsValidString(urlStr)){
        urlStr = [userInfo stringObjectForKey:@"code"];
    }
    
    
//    #warning -- test --
//        wcsz://wcsz.com/fixedPrice?categoryId="分类Id"
//    #warning -- test --

    
    if (!IsValidString(urlStr)) {
        return;
    }
    
    NSURL *url = [[URLRouter sharedInstance] urlRouterWithPath:urlStr component:nil params:nil];

    dispatch_queue_after_S(1, ^{
        [[URLRouter sharedInstance] routerWithUrl:url fromNav:nil parameters:nil option:RouterOption_Refresh];
    });
    
    TrackEventExtra(kTrackRemoteNotificationClickEvent, @{@"app_url":url.absoluteString});

}

#pragma mark - share action -
///刷新首页
- (void)refreshHome{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_REFRESH_HOME object:nil];
}
///刷新任务中心
- (void)refreshTask{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshTaskCenter object:nil];
}
///刷新额度评估页面
- (void)refreshQuota{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshAmountEvaluate object:nil];
}
///刷新商城顶部badge
- (void)refreshOrder{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshOrderCount object:nil];
}
///分享
- (void)shareAction:(NSDictionary *)params{
    ///  >=0 友盟分享平台 -1 系统分享 -2 保存图片/复制
    NSInteger platform = [[params objectForKey:@"platform"] integerValue];
    UIImage *image = [params objectForKey:@"image"];
    NSString *text = [params objectForKey:@"text"];
    
    NSArray *items = nil;
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    if (image) {//
        if (platform >= 0) {
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            shareObject.shareImage = image;
            messageObject.shareObject = shareObject;
        }else if (platform == -1){
            items = @[image];
        }else if (platform == -2){
            UIView *view = [URLRouter currentNavigationController].view;
            
            [ZXLoadingManager showLoading:kLoadingTip inView:view];
            [AppUtility saveImage:image complete:^(NSError * _Nonnull error) {
                LoadingManagerHidden();
                if (!error) {
                    [EasyTextView showText:@"保存成功"];
                    
                }
            }];
        }
    }
    else if (IsValidString(text)){
        if (platform >= 0) {
            messageObject.text = text;
        }else if (platform == -1){
            items = @[text];
        }else if (platform == -2){
            [[UIPasteboard generalPasteboard] setString:text];
            [EasyTextView showText:@"复制成功"];
        }
    }
    else{
        NSString *title = [params objectForKey:@"title"];
        NSString *desc = [params objectForKey:@"desc"];
        NSString *link = [params objectForKey:@"link"];
        UIImage *thumImage = [params objectForKey:@"thumImage"];

        if (platform >= 0) {
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:thumImage?:APPIcon];
            shareObject.webpageUrl = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            messageObject.shareObject = shareObject;
        }else if (platform == -1){
            items = @[[link URLByCheckCharacter], thumImage?:APPIcon, desc];
        }
        
    }
    
    if (items && items.count) {
//        [self systemShareWithItems:items complete:completeBlock];
    }
    
    if (platform >= 0) {
        [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                [EasyTextView showText:@"分享失败"];
                return;
            }
            
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
            
            [EasyTextView showText:@"分享完成"];
        }];
    }
    
}

///清除缓存action
- (void)clearCache:(NSDictionary *)params complete:(RouterCompleteBlock)completeBlock{
    LoadingManagerShowText(@"清理中...");
    [self clearWebCache];
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:^{
        LoadingManagerHidden();
        ToastShow(@"已清除缓存");
        if (completeBlock) {
            completeBlock(nil, nil);
        }
    }];
}

- (void)clearWebCache{
    //清除cookies
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //    清除webView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)systemShareWithItems:(NSArray *)items complete:(RouterCompleteBlock)completeBlock{
    UIActivityViewController *activityController=[[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            if (completeBlock) {
                completeBlock(nil, nil);
            }
        }else{
            if (completeBlock) {
                completeBlock(nil,activityError?:[NSError new]);
            }
        }
    };
    if ( [activityController respondsToSelector:@selector(popoverPresentationController)] ) {
        // iOS8
        activityController.popoverPresentationController.sourceView = [URLRouter currentRootViewController].view;
        activityController.popoverPresentationController.sourceRect = CGRectMake(SCREEN_WIDTH(), SCREEN_HEIGHT(), 0, 0);
    }
    [[URLRouter currentRootViewController] presentViewController:activityController animated:YES completion:nil];
}

- (void)evaluation{
    [AppUtility showAppstoreEvaluationView];
}

#pragma mark - wx 小程序 -
+ (BOOL)isWxInstalled{
    if (![WXApi isWXAppInstalled]) {
        ToastShow(@"打开微信失败，请检查是否安装了微信");
        return NO;
    }
    return YES;
}

+ (BOOL)isAlipayInstalled{

    BOOL res = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]];
    if (!res) {
        ToastShow(@"打开支付宝失败，请检查是否安装了支付宝");
        return NO;
    }
    
    return res;
}

+ (void)jumptoWXMiniProgramScoreCompletion:(void(^)(BOOL success))completionBlock{
    
    WXLaunchMiniProgramReq *req = [[WXLaunchMiniProgramReq alloc] init];
    req.userName = @"gh_12a2693ea860";
    req.path = @"pages/index/index";
    
//    launchMiniProgramReq.path=@"/pages/home/home";   //拉起小程序页面的可带参路径，不填默认拉起小程序首页

    //拉起小程序的类型 //**< 正式版  */
      req.miniProgramType=WXMiniProgramTypeRelease;
    [WXApi sendReq:req completion:completionBlock];
}

@end
