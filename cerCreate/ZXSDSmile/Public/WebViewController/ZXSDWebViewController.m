//
//  ZXSDWebViewController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/10/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDWebViewController.h"
#import "ZXSDScriptMessageHandler.h"
#import "EPNetworkManager+Home.h"

@interface ZXSDWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *myWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, strong) ZXSDScriptMessageHandler *scriptMessageHandler;
@end

@implementation ZXSDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableInteractivePopGesture = YES;
    
    [self initWebView];
    self.currentURL = [NSURL URLWithString:[self.requestURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
//    self.navigationItem.leftBarButtonItems = @[[self backBarButtonItem]];
    self.navigationItem.leftBarButtonItems = @[[self backBarButtonItem], [self closeBarButtonItem]];

    [self doLoadWithURL:self.currentURL];

    if (self.showPdfBtn) {
        [self addPdfSaveBtn];
    }
}

- (void)setIsHideTitle:(BOOL)isHideTitle{
    _isHideTitle = isHideTitle;
    self.isHideNavigationBar = isHideTitle;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
#pragma mark - help methods -

- (void)setRequestURL:(NSString *)requestURL{
    _requestURL = requestURL;
    
    if (self.bannerAnaly) {
        [EPNetworkManager analysisBanner:requestURL Completion:^(id  _Nonnull data, NSError * _Nonnull error) {
            if (!error) {
                NSLog(@"----------埋点success:%@",requestURL);
            }
        }];
    }

    NSMutableDictionary *pms = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
    [pms setSafeValue:GetString(userSession) forKey:@"session"];

    if (IsValidDictionary(pms)) {
        _requestURL = QueryStrEncoding(requestURL, pms.copy);
    }
    
}

#pragma mark - action methods -


- (void)backButtonClicked:(id)sender
{
    if (self.routeBlock) {
        self.routeBlock();
    }
    
    if ([self.myWebView canGoBack]) {
        
        [self.myWebView goBack];
        
    } else {
        [self closeButtonClicked:sender];
    }
}

- (void)closeButtonClicked:(id)sender
{
    // backCompletion内部负责导航控制处理
    if (self.backCompletion) {
        self.backCompletion();
        return;
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
    if (self.navigationController.viewControllers.count > 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        if (self.navigationController && self.navigationController.presentingViewController) {
            [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)initWebView
{
    if (_myWebView) {
        [_myWebView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
        [_myWebView removeObserver:self forKeyPath:@"title" context:nil];
        [_scriptMessageHandler removeScriptHandlers];
        _myWebView.navigationDelegate = nil;
        _myWebView.UIDelegate = nil;
        [_myWebView removeFromSuperview];
        _myWebView = nil;
    }
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    WKPreferences *preferences = [[WKPreferences alloc]init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    
    self.myWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    
    // 用于前端识别是否是WKWebView
    NSString *wkScriptStr = @"window.smileIosApp={}";
    WKUserScript *wkScript = [[WKUserScript alloc] initWithSource:wkScriptStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.myWebView.configuration.userContentController addUserScript:wkScript];
    

    
    // WKWebView中，从a页面到b页面，再回到a页面时，不会从服务端获取刷新a页面，而是从缓存中获取a页面，导致a页面期望的状态改变不会发生
    // 下面的js代码可强制从服务端获取刷新页面
    // js代码由前端H5针对单独页面设置，iOS暂不对所有页面进行这样的设置
    /*
    NSString *reloadScriptStr = @"var browserRule = /^.*((iPhone)|(iPad)|(Safari))+.*$/;if (browserRule.test(navigator.userAgent)) {window.onpageshow = function(event) {if (event.persisted) {window.location.reload()}};}";
    WKUserScript *reloadScript = [[WKUserScript alloc] initWithSource:reloadScriptStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.myWebView.configuration.userContentController addUserScript:reloadScript];
    */
    
    if (@available(iOS 10.0, *)) {
        self.myWebView.configuration.dataDetectorTypes = WKDataDetectorTypeLink|WKDataDetectorTypePhoneNumber;
    }
    self.myWebView.configuration.allowsInlineMediaPlayback = YES;
    
    if (@available(iOS 10.0, *)) {
        self.myWebView.configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    } 

    self.myWebView.backgroundColor = [UIColor whiteColor];
    self.myWebView.opaque = NO;
    self.myWebView.scrollView.bounces = NO;
    self.myWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    
    if (self.progressView == nil) {
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 2)];
        self.progressView.trackTintColor = [UIColor clearColor];
        self.progressView.progressTintColor = UICOLOR_FROM_HEX(0x00B050);
    }
    self.progressView.progress = 0.0;
    
    [self.view addSubview:self.myWebView];
    [self.view addSubview:self.progressView];

    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(self.view);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.myWebView);
        make.height.equalTo(@2);
    }];
    
    self.myWebView.navigationDelegate = self;
    self.myWebView.UIDelegate = self;
    
    [self.myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    [self.myWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    self.scriptMessageHandler = [[ZXSDScriptMessageHandler alloc] initWithWebView:self.myWebView navigationController:self.navigationController];
    [self.scriptMessageHandler addScriptHandlers];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.myWebView.estimatedProgress animated:YES];
        if (1.0 - self.myWebView.estimatedProgress < 0.01) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = 0.0;
            });
        }
    }
    else if ([keyPath isEqualToString:@"title"]){
        self.title = self.myWebView.title;
        
    }
}

- (void)doLoadWithURL:(NSURL *)url
{
    if (url) {
        ZGLog(@"Start loading url: %@", url);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                                timeoutInterval:60.f];
      [self.myWebView loadRequest:request];
    } else if (self.localHtml && self.localHtml.length > 0) {
        NSString *type = @"";
        if (![self.localHtml hasSuffix:@".html"]) {
            type = @"html";
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:self.localHtml ofType:type];
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    } else if (self.htmlStr && self.htmlStr.length > 0) {
        [self.myWebView loadHTMLString:self.htmlStr baseURL:nil];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    ZGLog(@"Should start load url: %@", url);
    
    /*
    if ([URL hasPrefix:SCHEMA_RISK_WEBVIEW_CLOSE]) {
        [self.navigationController popViewControllerAnimated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }*/
    
    if ([url hasPrefix:@"taobao"] ||
        [url hasPrefix:@"tmall"] ||
        [url hasPrefix:@"tbopen"] ||
        [url hasPrefix:@"jd"] ||
        [url hasPrefix:@"openApp.jdMobile"] ||
        [url hasPrefix:@"yhd"] ||
        [url hasPrefix:@"vipshop"]
        ) {

        if ([self checkInstalledTaobaoAppWithUrl:url]){
            [[UIApplication sharedApplication] openURL:url.URLByCheckCharacter options:@{} completionHandler:^(BOOL success) {
            }];
        }
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    NSURL *URL = navigationAction.request.URL;
    if ([URL.scheme isEqualToString:@"weixin"] ||
        [URL.scheme isEqualToString:@"alipay"]) {
        if ( [[UIApplication sharedApplication] canOpenURL:URL]) {
            
            [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:nil];

            decisionHandler(WKNavigationActionPolicyCancel);
            
            return;
        }
    }


    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}


#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView
 createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
            forNavigationAction:(WKNavigationAction *)navigationAction
                 windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame] || frameInfo == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

// js端调用alert函数时，会触发此代理方法
- (void)                   webView:(WKWebView *)webView
runJavaScriptAlertPanelWithMessage:(NSString *)message
                  initiatedByFrame:(WKFrameInfo *)frame
                 completionHandler:(void (^)(void))completionHandler {
    // message约定格式：titleText&content&confirmBtnText
    NSArray *contents = [message componentsSeparatedByString:@"&"];
    
    NSString *title = @"";
    NSString *alertMessage = message;
    NSString *buttonText = @"确定";
    
    if (contents.count == 3) {
        title = contents[0];
        alertMessage = contents[1];
        buttonText = contents[2];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:buttonText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}


// js端调用confirm函数时，会触发此代理方法
-(void)                      webView:(WKWebView *)webView
runJavaScriptConfirmPanelWithMessage:(NSString *)message
                    initiatedByFrame:(WKFrameInfo *)frame
                   completionHandler:(void (^)(BOOL result))completionHandler {
    // message约定格式：titleText&content&confirmBtnText&cancelBtnText
    NSArray *contents = [message componentsSeparatedByString:@"&"];
    
    NSString *title = @"";
    NSString *confirmMessage = message;
    NSString *confirmBtnText = @"确定";
    NSString *cancelBtnText = @"取消";
 
    if (contents.count == 4) {
        title = contents[0];
        confirmMessage = contents[1];
        confirmBtnText = contents[2];
        cancelBtnText = contents[3];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:confirmMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:cancelBtnText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:confirmBtnText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// js端调用prompt函数时，会触发此代理方法
- (void)                      webView:(WKWebView *)webView
runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
                          defaultText:(nullable NSString *)defaultText
                     initiatedByFrame:(WKFrameInfo *)frame
                    completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText ?: @"";
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *value = alertController.textFields[0].text?:@"";
        completionHandler(value);
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dealloc
{
    ZGLog(@"dealloc....");
    [_myWebView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    [_myWebView removeObserver:self forKeyPath:@"title" context:nil];
    [_scriptMessageHandler removeScriptHandlers];
    _myWebView.navigationDelegate = nil;
    _myWebView.UIDelegate = nil;
    
    
}

#pragma mark - help methods -
- (BOOL)checkInstalledTaobaoAppWithUrl:(NSString*)url{
    
    if ([[UIApplication sharedApplication] canOpenURL:url.URLByCheckCharacter]) {
        return YES;
    }

    NSString *msg = @"该应用";
    if([url hasPrefix:@"tmall://"]){
        msg = @"手机天猫";
    }
    else if ([url hasPrefix:@"taobao"] ||
             [url hasPrefix:@"tbopen"]){
        msg = @"手机淘宝";
    }
    else if ([url hasPrefix:@"taobaolite://"]){
        msg = @"淘宝特价版";
    }
    
    [self showSystemAlertWithMessage:[NSString stringWithFormat:@"您还未安装 %@,请先到App Store下载",msg] confirmBlock:^{
        
    }];
    
    return NO;
}

- (void)showSystemAlertWithMessage:(NSString *)message confirmBlock:(void(^)(void))confirmBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *nextAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    [alertController addAction:nextAction];
    
    [[EasyShowUtils easyShowViewTopViewController] presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - pdf -

- (void)addPdfSaveBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 70, 30);
    btn.backgroundColor = kThemeColorMain;
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_SFUI_X_Medium(18);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    ViewBorderRadius(btn, 8, 1, UIColor.whiteColor);
    
    [btn bk_addEventHandler:^(id sender) {
        [self savePDF];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

}

/// 保存webView页面为pdf
- (void)savePDF{
    
    NSData *data = [self converToPDF];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    
    NSString *fileName = [formatter stringFromDate:[NSDate date]];
    NSString *path = [NSHomeDirectory()    stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.pdf",fileName]];

    BOOL result = [data writeToFile:path atomically:YES];
    NSLog(@"----------pdfpath=%@",path);

    if (result) {//"保存成功"
        [EasyTextView showText:@"保存成功"];

    }
    else{//"保存失败";
        [EasyTextView showText:@"保存失败"];
    }
     
     //从本地获取路径进行显示PDF
//    NSURL *pdfURL = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:pdfURL];
////    [self.myWebView setScalesPageToFit:YES];
//    [self.myWebView loadRequest:request];
}


- (NSData *)converToPDF{

    UIViewPrintFormatter *fmt = [self.myWebView viewPrintFormatter];

    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];

    [render addPrintFormatter:fmt startingAtPageAtIndex:0];

    CGRect page;

    page.origin.x=0;

    page.origin.y=0;

    page.size.width=600;

    page.size.height=768;

    CGRect printable=CGRectInset( page, 50, 50 );

    [render setValue:[NSValue valueWithCGRect:page] forKey:@"paperRect"];

    [render setValue:[NSValue valueWithCGRect:printable] forKey:@"printableRect"];

    NSMutableData * pdfData = [NSMutableData data];

    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );

    for (NSInteger i=0; i < [render numberOfPages]; i++)

    {

        UIGraphicsBeginPDFPage();

        CGRect bounds = UIGraphicsGetPDFContextBounds();

        [render drawPageAtIndex:i inRect:bounds];

    }

    UIGraphicsEndPDFContext();

    return pdfData;

}



@end
