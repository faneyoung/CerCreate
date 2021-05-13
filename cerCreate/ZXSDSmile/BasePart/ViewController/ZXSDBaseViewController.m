//
//  ZXSDBaseViewController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"
#import <EasyLoadingView.h>

#import "UIBarButtonItem+Convince.h"
#import <YjyzVerify/YJYZSDK.h>
#import "EPNetworkError.h"
#import "ZXAppTrackManager.h"

@interface ZXSDBaseViewController ()

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation ZXSDBaseViewController

- (void)dealloc{
    NSLog(@"----------dealloc--%@",NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarButtonItems];
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self umTrackWithEnable:YES];

    if (self.isHideNavigationBar == NO) {
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self umTrackWithEnable:NO];
}


#pragma mark - views -
- (void)setupSubViews{
    
}

- (void)setShowNavBottomSepLine:(BOOL)showNavBottomSepLine{
    _showNavBottomSepLine = showNavBottomSepLine;
    UIColor *sepColor = nil;
    if (showNavBottomSepLine) {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
//        [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        sepColor = kThemeColorBg;
        [navigationBar setShadowImage:[UIImage imageWithColor:sepColor]];
    }
}

#pragma mark - Set button items

- (void)setNavigationBarButtonItems
{
    if (self.presentingViewController ||
        self.navigationController.presentingViewController) {
        [self setLeftBarButtonItem:ZXSDLeftBarButtonCloseToNormal];
        if ([self.navigationController.viewControllers count] > 1) {
            [self setLeftBarButtonItem:ZXSDLeftBarButtonBackToPrevious];
        }
    } else {
        if ([self.navigationController.viewControllers count] > 1) {
            [self setLeftBarButtonItem:ZXSDLeftBarButtonBackToPrevious];
        }
    }
}

- (void)setLeftBarButtonItem:(ZXSDLeftBarButtonBackType)backType
{
    switch (backType) {
        
        case ZXSDLeftBarButtonCloseToNormal:
            self.navigationItem.leftBarButtonItem = [self closeBarButtonItem];
            break;
            
        case ZXSDLeftBarButtonBackToPrevious:
            self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
            break;
           
        default:
            break;
    }
}


- (void)ZXSDNavgationBarConfigure {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = UICOLOR_FROM_HEX(0x3C465A);
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{
        NSFontAttributeName:FONT_PINGFANG_X_Medium(16),
        NSForegroundColorAttributeName:COMMON_APP_NAVBARTITLE_COLOR}];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

#pragma mark - Loading & Toast

- (void)showLoadingProgressHUDWithText:(NSString *)text {
    [ZXLoadingManager showLoading:text inView:self.view];
}

- (void)dismissLoadingProgressHUDImmediately {
    dispatch_safe_async_main(^{
        [ZXLoadingManager hideLoading];
    });
}

- (void)dismissLoadingProgressHUD {
    dispatch_queue_after_S(1.0, ^{
        [ZXLoadingManager hideLoading];
    });
}

//显示toast文案
- (void)showToastWithText:(NSString *)text {
    if (IsValidString(text)) {
        [EasyTextView showText:text];
    }
}

#pragma mark - Request Handler

- (void)errowAlertViewWithTask:(NSURLSessionDataTask *)task error:(NSError *)error title:(NSString *)string block:(void(^)(id data))block {
    NSHTTPURLResponse *newResponse = (NSHTTPURLResponse *)task.response;
    [self errowAlertViewWithResponse:newResponse error:error title:string block:block];
}

- (void)errowAlertViewWithResponse:(NSURLResponse *)response error:(NSError *)error title:(NSString *)string block:(void(^)(id data))block{
    if (string.length < 1) {
        string = @"服务异常,请稍后重试!";
    }
    NSHTTPURLResponse *newResponse = (NSHTTPURLResponse *)response;
    if (newResponse.statusCode == 400 || newResponse.statusCode == 403) {
        NSDictionary *errorDic = [NSDictionary safty_dictionaryWithDictionary:error.userInfo];
        NSData *innerError = [errorDic valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (innerError) {
            id object = [NSJSONSerialization JSONObjectWithData:innerError options:NSJSONReadingAllowFragments error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                 NSString *failedString = [object safty_objectForKey:@"message"];
                 failedString = failedString.length > 0 ? failedString : string;
                if (block) {
                    block(object);
                }
                else{
                    [self showToastWithText:failedString];
                }
             } else {
                 [self showToastWithText:string];
             }
        } else {
            [self showToastWithText:string];
        }
    } else if(newResponse.statusCode == 401) {
        [self authorizationFailed];
    } else if(newResponse.statusCode == 500 || newResponse.statusCode == 503) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [ignoreAction setValue:kThemeColorMain forKey:@"titleTextColor"];
        [alertController addAction:ignoreAction];
        [[self ZXSD_GetController] presentViewController:alertController animated:YES completion:nil];
    } else if (newResponse.statusCode == 504) {
        [self showToastWithText:@"网络超时,请检查网络后重试！"];
    } else {
        //NSString *errorMsg = newResponse.statusCode == 404 ? @"服务器发生未知的网络错误,请稍后重试!" : string;
        
        NSString *errorMsg = @"";
        if (newResponse.statusCode >= 500 && newResponse.statusCode <= 505) {
            errorMsg = @"服务异常，请稍后再试";
        } else if ([self isConnectionError:error]) {
            errorMsg = @"网络连接异常，请检查后再试";
        } else {
            errorMsg = @"未知错误，请稍后再试";
        }
        
        
        [self showToastWithText:errorMsg];
    }
}

- (void)showNetworkErrowAlertView:(NSURLSessionDataTask *)task andError:(NSError *)error andDefaultTitle:(NSString *)string {
    if (string.length < 1) {
        string = @"系统错误,请稍后重试!";
    }
    NSHTTPURLResponse *newResponse = (NSHTTPURLResponse *)task.response;
    if (newResponse.statusCode == 400 || newResponse.statusCode == 403) {
        NSDictionary *errorDic = [NSDictionary safty_dictionaryWithDictionary:error.userInfo];
        NSData *innerError = [errorDic valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (innerError) {
            id object = [NSJSONSerialization JSONObjectWithData:innerError options:NSJSONReadingAllowFragments error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                 NSString *failedString = [object safty_objectForKey:@"message"];
                 failedString = failedString.length > 0 ? failedString : string;
                 [self showToastWithText:failedString];
             } else {
                 [self showToastWithText:string];
             }
        } else {
            [self showToastWithText:string];
        }
    } else if(newResponse.statusCode == 401) {
        [self authorizationFailed];
    } else if(newResponse.statusCode == 500 || newResponse.statusCode == 503) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [ignoreAction setValue:kThemeColorMain forKey:@"titleTextColor"];
        [alertController addAction:ignoreAction];
        [[self ZXSD_GetController] presentViewController:alertController animated:YES completion:nil];
    } else if (newResponse.statusCode == 504) {
        [self showToastWithText:@"网络超时,请检查网络后重试！"];
    } else {
        //NSString *errorMsg = newResponse.statusCode == 404 ? @"服务器发生未知的网络错误,请稍后重试!" : string;
        
        NSString *errorMsg = @"";
        if (newResponse.statusCode >= 500 && newResponse.statusCode <= 505) {
            errorMsg = @"服务异常，请稍后再试";
        } else if ([self isConnectionError:error]) {
            errorMsg = @"网络连接异常，请检查后再试";
        } else {
            errorMsg = @"未知错误，请稍后再试";
        }
        
        
        [self showToastWithText:errorMsg];
    }
}

- (BOOL)handleError:(NSError *)error response:(EPNetworkResponse*)resp{
    if (error) {
        [self handleRequestError:error];
        return YES;
    }
    
    if (resp.resultModel.code != 0) {
        if (IsValidString(resp.resultModel.responseMsg)) {
            ToastShow(resp.resultModel.responseMsg);
        }
        return YES;
    }
    
    return NO;
}

- (void)handleRequestError:(NSError *)error
{
    if (error.code == EPNetworkErrorTypeSessionInvalid) {
        [self authorizationFailed];
    }
    else {
        if(error.code == 1){
            NSString *errDes = [error.userInfo stringObjectForKey:@"NSLocalizedDescription"];
            if (IsValidString(errDes) &&
                [errDes isEqualToString:@"用户不存在~"]) {
                NSLog(@"----------");
                ToastShow(errDes);

                [self authorizationFailed];
                return;
            }
        }

        NSString *message = error.localizedDescription;
        ToastShow(message);
    }
}

- (BOOL)appErrorWithData:(NSDictionary*)resp{
    if (!resp) {
        return YES;
    }
    
    NSString *respCode = [resp stringObjectForKey:@"responseCode"];
    if (IsValidString(respCode)) {
        NSString *respMsg = [resp stringObjectForKey:@"responseMsg"];

        if (![respCode isEqualToString:@"000000"]) {
            if (IsValidString(respMsg)) {
                [EasyTextView showText:respMsg];
            }
            return YES;
        }
    }
    
    
    return NO;
}

- (BOOL)isConnectionError:(NSError *)error
{
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        if (error.code == NSURLErrorTimedOut ||
            error.code == NSURLErrorCannotFindHost ||
            error.code == NSURLErrorCannotConnectToHost ||
            error.code == NSURLErrorNetworkConnectionLost ||
            error.code == NSURLErrorDNSLookupFailed ||
            error.code == NSURLErrorNotConnectedToInternet) {
            return YES;
        }
    }
    return NO;
}


- (void)authorizationFailed
{
    ZXSDBaseViewController *entraceVC = [self ZXSD_GetController];
    if ([entraceVC isKindOfClass:NSClassFromString(@"ZXSDEntraceHolderController")]) {
        [entraceVC.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
    dispatch_queue_after_S(0.3, ^{
        [ZXSDCurrentUser clearUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_USERLOGOUT object:nil];

    });

}

#pragma mark - Current UIViewController
//获取当前屏幕显示的viewcontroller
- (UIViewController *)ZXSD_GetController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentViewController = [self ZXSD_GetCurrentViewControllerFrom:rootViewController];
    return currentViewController;
}

- (UIViewController *)ZXSD_GetCurrentViewControllerFrom:(UIViewController *)rootViewController {
    UIViewController *currentViewController;
    
    if ([rootViewController presentedViewController]) {
        //视图是被presented出来的
        rootViewController = [rootViewController presentedViewController];
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        //根视图为UITabBarController
        currentViewController = [self ZXSD_GetCurrentViewControllerFrom:[(UITabBarController *)rootViewController selectedViewController]];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        //根视图为UINavigationController
        currentViewController = [self ZXSD_GetCurrentViewControllerFrom:[(UINavigationController *)rootViewController visibleViewController]];
    } else {
        //根视图为非导航类
        currentViewController = rootViewController;
    }
    return currentViewController;
}

//获取当前视图控制器(如果当前视图未知,使用该方法)
- (UIViewController *)ZXSD_GetControllerUnknown {
    UIViewController *resultController;
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        resultController = nextResponder;
    } else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil) {
        resultController = topWindow.rootViewController;
    } else{
        NSAssert(NO, @"Could not find a root view controller. ");
    }
    return resultController;
}

// 获取当前视图的控制器(如果已知当前视图)
- (UIViewController *)ZXSD_GetViewControllerWithView:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    return nil;
}

#pragma mark - Button actions
- (void)backButtonClicked:(nullable id)sender
{
    if (self.backCompletion) {
        self.backCompletion();
    } else {
        if (self.backViewController) {
            UIViewController *parentVC = self.backViewController;
            while ([self.navigationController.viewControllers indexOfObject:parentVC] == NSNotFound) {
                parentVC = parentVC.parentViewController;
            }
            
            if (!parentVC) {
                // 出于业务方面考虑，退回到栈底而不是栈顶
                parentVC = self.navigationController.viewControllers.firstObject;
            }
            [self.navigationController popToViewController:parentVC animated:YES];
            
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)closeButtonClicked:(nullable id)sender
{
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if (self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UIBarButtonItem
- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    return [self barButtonItemWithImage:image target:target action:action frame:ZXSD_BARBUTTON_ITEM_FRAME];
}

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action templateMode:(BOOL)templateMode
{
    return [UIBarButtonItem itemWithTarget:self action:action image:image templateMode:templateMode];
}

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action frame:(CGRect)frame
{
    return [UIBarButtonItem itemWithTarget:self action:action image:image];
}


#pragma mark - Button items

- (UIBarButtonItem *)backBarButtonItem
{
    return [self barButtonItemWithImage:[self backButtonImage] target:self action:@selector(backButtonClicked:)];
}

- (UIBarButtonItem *)closeBarButtonItem
{
    return [self barButtonItemWithImage:[self closeButtonImage] target:self action:@selector(closeButtonClicked:)];
}

- (UIButton*)testBtnAction:(void(^)(UIButton*btn))block{
    UIButton *testBtn = [self.view viewWithTag:10983737828];
    [testBtn removeFromSuperview];
    
    testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.tag = 10983737828;
    testBtn.backgroundColor = UIColor.lightGrayColor;
    ViewBorderRadius(testBtn, 25, 1, UIColor.whiteColor);
    [self.view addSubview:testBtn];
    [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.inset(10);
        make.width.height.mas_equalTo(50);
    }];
    
    @weakify(testBtn);
    [testBtn bk_addEventHandler:^(id sender) {
        if (block) {
            block(testBtn_weak_);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    return testBtn;
}

- (void)testBtns:(NSArray*)titles action:(void(^)(UIButton*btn))block{
    
    CGFloat vSpace = 30;
   __block CGFloat itemWidth = 50;
    CGFloat itemHeight = 50;
    
    [titles enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        testBtn.tag = idx;
        testBtn.backgroundColor = UIColor.lightGrayColor;
        [testBtn setTitle:obj forState:UIControlStateNormal];
        [testBtn setTitleColor:TextColorTitle forState:UIControlStateNormal];
        testBtn.titleLabel.font = FONT_PINGFANG_X(12);
        ViewBorderRadius(testBtn, 25, 1, UIColor.whiteColor);
      CGFloat width =  [obj boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, itemHeight) options:0 attributes:@{} context:nil].size.width;
        itemWidth = width>itemWidth ? width+10 : itemWidth;
        [self.view addSubview:testBtn];
        [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset((itemHeight+vSpace)*idx);
            make.right.inset(20);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(itemHeight);
        }];
        
        @weakify(testBtn);
        [testBtn bk_addEventHandler:^(id sender) {
            if (block) {
                block(testBtn_weak_);
            }
        } forControlEvents:UIControlEventTouchUpInside];

    }];
    
}

- (void)showPdfBtnWithUrl:(NSString*)url fileName:(NSString*)file html:(NSString*)html{
    @weakify(self);
    [self testBtnAction:^(UIButton * _Nonnull btn) {
        @strongify(self);
        ZXSDWebViewController *webVC = [[ZXSDWebViewController alloc] init];
        webVC.showPdfBtn = YES;
        
        if (IsValidString(url)) {
            webVC.requestURL = url;
        }
        else if(IsValidString(file)){
            webVC.localHtml = file;
        }
        else{
            webVC.htmlStr = html;
        }

        [self.navigationController pushViewController:webVC animated:YES];
    }];

}

#pragma mark - Button images
- (UIImage *)backButtonImage
{
    return [UIImage imageNamed:@"icon_nav_back_black"];
}

- (UIImage *)closeButtonImage
{
    return [UIImage imageNamed:@"smile_close"];
}

#pragma mark - Getter
//- (MBProgressHUD *)progressHUD {
//    if (!_progressHUD) {
//        _progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        _progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//        _progressHUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
//        _progressHUD.contentColor = [UIColor whiteColor];
//        _progressHUD.removeFromSuperViewOnHide = YES;
//
//        [self.view addSubview:_progressHUD];
//    }
//    return _progressHUD;
//}

- (void)refreshAllData{
    NSLog(@"----------%@",self);

}

- (void)refreshNavVCsWithName:(NSArray*)vcs{
    if (!IsValidArray(vcs)) {
        return;
    }
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof ZXSDBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [vcs enumerateObjectsUsingBlock:^(__kindof ZXSDBaseViewController * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            
            if ([obj isKindOfClass:obj1.class]) {
                dispatch_safe_async_main(^{
                    [obj1 refreshAllData];
                });
                if (vcs.count == 1) {
                    *stop = YES;
                }
            }
        }];
    }];

}

#pragma mark - track -
//umeng页面统计
- (void)umTrackWithEnable:(BOOL)able{
    if (!self.disableUMPageLog) {
        if (able) {
            [ZXAppTrackManager beginLogPageView:NSStringFromClass([self class])];
        }else{
            [ZXAppTrackManager endLogPageView:NSStringFromClass([self class])];
        }
    }
}

#pragma mark - help methods -
- (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg confirm:(NSString*)confirm cancel:(NSString*)cancel confirmBlock:(void(^)(void))cBlock cancelBlock:(void(^)(void))block{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (IsValidString(confirm)) {
        UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cBlock) {
                cBlock();
            }
        }];
        [ignoreAction setValue:kThemeColorMain forKey:@"titleTextColor"];
        [alertController addAction:ignoreAction];
    }
    
    if (IsValidString(cancel)) {
        UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block();
            }
        }];
        [ignoreAction setValue:TextColorSubTitle forKey:@"titleTextColor"];
        [alertController addAction:ignoreAction];
    }
    
    [[self ZXSD_GetController] presentViewController:alertController animated:YES completion:nil];
}


@end
