//
//  ZXSDLaunchManager.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/25.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDLaunchManager.h"
#import "AppDelegate.h"
#import "ZXSDMandatoryRequirementController.h"
#import "ZXSDGuidePageController.h"

@interface ZXSDLaunchManager ()

@property (nonatomic, strong) UIWindow *launchWindow;
@property (nonatomic, strong) UINavigationController *rootNav;

@end

@implementation ZXSDLaunchManager

+ (instancetype)manager
{
    static ZXSDLaunchManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZXSDLaunchManager new];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.launchWindow.backgroundColor = [UIColor whiteColor];
        //[self regitserNotification];
    }
    return self;
}

- (void)startLaunch
{
    [self showPreLoadView];
    [self.launchWindow makeKeyAndVisible];
}


- (void)showPreLoadView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ZXSDMandatoryRequirementController *vc = [[ZXSDMandatoryRequirementController alloc] init];
        vc.jumpAgreementBlock = ^{
            [self showAppGuide];
            [ZXSDUserDefaultHelper storeValueIntoUserDefault:@"true" forKey:USERACCEPTAGREEMENTVALUE];
        };
        if ([self.rootNav.topViewController isKindOfClass:[ZXSDMandatoryRequirementController class]]) {
            return;
        }
        [self.rootNav pushViewController:vc animated:NO];
    });
}

- (void)showAppGuide
{
    [self checkLaunchWindow];
    ZXSDGuidePageController *vc = [ZXSDGuidePageController new];
    vc.jumpGuideBlock = ^{

        [ZXSDUserDefaultHelper storeValueIntoUserDefault:APP_VERSION() forKey:CURRENTAPPLICATIONVERSION];
        
        // 切换
        [self switchToMainWindow];
    };
    [self.rootNav pushViewController:vc animated:NO];
}

- (void)switchToMainWindow
{
    // 温和的过度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resignLaunchWindow];
    });
    /*
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window makeKeyAndVisible];*/

    // 通知外部引导页展示完成
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_APPGUIDE_FINISH object:nil];
}

- (void)checkLaunchWindow
{
    if (self.launchWindow.hidden == YES || !self.launchWindow.isKeyWindow) {
        [self.launchWindow makeKeyAndVisible];
    }
}

- (void)resignLaunchWindow
{
    [self.launchWindow resignKeyWindow];
    self.launchWindow.hidden = YES;
    self.launchWindow.rootViewController = nil;
    self.rootNav = nil;
    self.launchWindow = nil;
}

- (UIWindow *)launchWindow
{
    if (!_launchWindow) {
        _launchWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _launchWindow.windowLevel = UIWindowLevelAlert + 50;
        
        _rootNav = [UINavigationController new];
        _rootNav.navigationBarHidden = YES;
        _launchWindow.rootViewController = _rootNav;
        _launchWindow.rootViewController.extendedLayoutIncludesOpaqueBars = YES;
    }
    return _launchWindow;
}

@end
