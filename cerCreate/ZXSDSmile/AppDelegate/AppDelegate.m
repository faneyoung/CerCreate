//
//  AppDelegate.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>

#import <YjyzVerify/YJYZSDK.h>
#import <SDWebImage/SDWebImage.h>
#import "ZXSDNetworkFastConfig.h"
#import "EPNetwork.h"
#import "ZXSDHeaderInterceptor.h"

#import "ZXSDLaunchManager.h"
#import "ZXSDLoginService.h"
#import <Bugly/Bugly.h>

#import "AppDelegate+setting.h"
#import "ZXLocationManager.h"
#import "ZXCerViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)appDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SDImageCache sharedImageCache] clearMemory];
    });
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:NSClassFromString(@"ZXSDPhoneNumberVerifySMSCodeController")];

    
    [self initNetworkConfig];
    [self registerYJYZWithLaunchOptions:launchOptions];
    
    [self regitserNotification];
    [self checkLaunchStatus];
    
    [self settingWithOptions:launchOptions];

    [ZXLocationManager.sharedManger requestLocationAuth];
    
    return YES;
}
#pragma mark - help methods -

- (void)regitserNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainWindow) name:ZXSD_NOTIFICATION_APPGUIDE_FINISH object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchLogin) name:ZXSD_NOTIFICATION_USERLOGOUT object:nil];
}

- (void)checkLaunchStatus
{
    NSString *value = [ZXSDUserDefaultHelper readValueForKey:USERACCEPTAGREEMENTVALUE];
    NSString *version = [ZXSDUserDefaultHelper readValueForKey:CURRENTAPPLICATIONVERSION];
    
    if ([value boolValue] == YES && [version isEqualToString:APP_VERSION()]){
        
        [self showMainWindow];
    } else {
        [self showLaunchWindow];
    }
}

- (void)showLaunchWindow
{
    NSString *value = [ZXSDUserDefaultHelper readValueForKey:USERACCEPTAGREEMENTVALUE];
    NSString *version = [ZXSDUserDefaultHelper readValueForKey:CURRENTAPPLICATIONVERSION];
    
    if ([value boolValue] == NO) {
        [[ZXSDLaunchManager manager] startLaunch];
        
    } else if (![version isEqualToString:APP_VERSION()]){
        
        [[ZXSDLaunchManager manager] showAppGuide];
    }

}

- (void)showMainWindow
{
    ZXSDBaseTabBarController *tabBarController = [[ZXSDBaseTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    
    NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
    NSString *userId = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
    // 不需要登陆
    if (CHECK_VALID_STRING(userSession) && CHECK_VALID_STRING(userId)) {
        [ZXSDLoginService startAutoLogin:self.window.rootViewController];
    
    } else {
        [self checkYjyzOrSmsCodeLogin];
    }
}

#pragma mark - 一键登录配置 -

- (void)checkYjyzOrSmsCodeLogin
{
    [YJYZSDK yjyzPreGetPhoneNumber:^(NSDictionary * _Nullable resultDic, NSError * _Nullable error) {
        if (!error) {
            ZGLog(@"预取号成功==%@",resultDic);
            NSString *operatorName = [resultDic objectForKey:@"operatorName"];
            if (CHECK_VALID_STRING(operatorName)) {
                [ZXSDGlobalObject sharedGlobal].operatorName = operatorName;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZXSDLoginService startYJLogin:self.window.rootViewController];
            });
        } else {
            ZGLog(@"预取号失败==%@",error);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [ZXSDLoginService startSMSLogin:self.window.rootViewController];
            });
        }
    }];
}

#pragma mark - life cycle -

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.deviceToken = deviceToken;
    [self didRegisterForRemoteNotificationsWithDeviceToken];
    
    [self registeJPushAlias];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  ZGLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - umeng setting -
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self c_application:application openURL:url options:nil];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    return  [self c_application:app openURL:url options:options];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self c_application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
}

///微信和QQ完整版都需要开发者配置正确的Universal link和对应的Universal link系统回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
    return [self c_application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    
}



#pragma mark - Config Service

- (void)initNetworkConfig
{
    // INIT NETWORK CONFIG
    ZXSDNetworkFastConfig *networkConfig = [ZXSDNetworkFastConfig new];
    EPNetworkSettingDefaultConfig(networkConfig);
    [[EPNetworkConfig sharedConfig] addInterceptor:[ZXSDHeaderInterceptor new]];
    
    [[ZXSDGlobalObject sharedGlobal] startNetworkMonitoring];
}

- (void)registerYJYZWithLaunchOptions:(NSDictionary *)launchOptions
{
    //一键验证,登录手机号
    [YJYZSDK yjyzRegisterAppKey:YJYZSDKAPPKEY appSecret:YJYZSDKAPPSECRET operationType:0];
    [YJYZSDK yjyzSetTimeoutInterval:3.0];
}

- (void)switchLogin
{
    /*
    UIViewController *root = self.window.rootViewController;
    if ([root isKindOfClass:[ZXSDBaseTabBarController class]]) {
        ZXSDBaseTabBarController *tabbar = (ZXSDBaseTabBarController *)root;
        [tabbar selectTab:0];
    }*/
    
    [self checkYjyzOrSmsCodeLogin];
}

//#pragma mark- JPUSHRegisterDelegate
//
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
////// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
//{
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//
//
//    completionHandler(UNNotificationPresentationOptionAlert);
//    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
//}
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
//{
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler();  // 系统要求执行这个方法
//}
//#endif
//
//#ifdef __IPHONE_12_0
//// iOS 12 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification
//{
//    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //从通知界面直接进入应用
//    } else {
//        //从通知设置界面进入应用
//    }
//}
//#endif

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//
//  // Required, iOS 7 Support
//  [JPUSHService handleRemoteNotification:userInfo];
//  completionHandler(UIBackgroundFetchResultNewData);
//
//}

// 配置页面方向
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIViewController *currentVC = [ZXSDPublicClassMethod ZXSD_GetController];
    if (currentVC && [currentVC isKindOfClass:ZXCerViewController.class]) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
