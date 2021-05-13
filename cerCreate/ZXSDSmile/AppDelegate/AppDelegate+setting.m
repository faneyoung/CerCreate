//
//  AppDelegate+setting.m
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "AppDelegate+setting.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <WXApi.h>
#import <Bugly/Bugly.h>
#import <Bugtags/Bugtags.h>

#import <EasyShowView/EasyTextGlobalConfig.h>
#import <EasyLoadingGlobalConfig.h>

#import <AdSupport/ASIdentifierManager.h>
#import "ZXSDBaseTabBarController.h"

// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#pragma mark - JPUSH  -
static NSString * const kJPushAppKey = @"48aef2481ad7d7c7783869c6";
static NSString * const kUMengAppKey = @"5fcf3b09bed37e4506c60b44";

#pragma mark - wechat -
static NSString * const kWechatAppID = @"wx4643420a4175ec70";
static NSString * const kWechatKey = @"6c7ec90d1caf9a77a9d3e5e73fec2631";
///weixin&qq
static NSString * const kUniversalLink  = @"https://smilecard.cn/";

#pragma mark - bugtags -
static NSString * const kBugtagsAppKey = @"075165de9293aa70b0339fb74da3afbd";
#pragma mark - bugly -
static NSString * const kBuglyAppID = @"a7559968b3";


@implementation AppDelegate (setting)

- (void)settingWithOptions:(NSDictionary *)launchOptions{
    [self commonSetting];
    [self globleAppearanceSetting];
    [self configJpushNotification:launchOptions];
}

#pragma mark - common setting -
- (void)commonSetting{
    
    [self umengConfig];
    [self bugTagsConfig];
    [self buglyConfig];
    [self buglyConfig];

}

#pragma mark - UI setting -
- (void)globleAppearanceSetting{
    /*配置文字提示样式*/
    EasyTextGlobalConfig *config = [EasyTextGlobalConfig shared];
    config.bgColor = UIColor.blackColor;
    config.titleColor = [UIColor whiteColor];
    config.shadowColor = [UIColor clearColor];
    config.animationType =TextAnimationTypeFade;
    
//    EasyLoadingGlobalConfig *loadingConfig = [EasyLoadingGlobalConfig shared];
//    loadingConfig.bgColor = UIColorHexAlpha(0x000000, 0.7);
//    loadingConfig.tintColor = UIColor.whiteColor;
//    loadingConfig.LoadingType = LoadingShowTypeIndicator;
//    loadingConfig.superReceiveEvent = NO;
//    loadingConfig.showOnWindow = YES;
//    loadingConfig.animationType = TextAnimationTypeFade;

}

#pragma mark - tencent bugly -
- (void)buglyConfig
{
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.blockMonitorEnable = YES;
    config.debugMode = YES;
#ifdef RELEASE
    config.debugMode = NO;
#endif
    [Bugly startWithAppId:kBuglyAppID config:config];
}

#pragma mark - bugtags -
- (void)bugTagsConfig{

#if TEST
    [Bugtags startWithAppKey:kBugtagsAppKey invocationEvent:BTGInvocationEventShake];
#elif UAT
    [Bugtags startWithAppKey:kBugtagsAppKey invocationEvent:BTGInvocationEventShake];
#elif RELEASE
    
#endif

}

#pragma mark - UMeng config -
- (void)umengConfig{
    
    [UMConfigure initWithAppkey:kUMengAppKey channel:@"App Store"];

    BOOL logEnable = YES;
#if TEST
#elif UAT
#elif RELEASE
    logEnable = NO;
#endif
    [UMConfigure setLogEnabled:logEnable];

    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    

    [UMSocialGlobal shareInstance].universalLinkDic = @{
        @(UMSocialPlatformType_WechatSession):kUniversalLink,
        /*@(UMSocialPlatformType_QQ):kUniversalLink*/
    };
    
    NSString *redirectURL = @"http://mobile.umeng.com/social";

    //不同平台的配置
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechatAppID appSecret:kWechatKey redirectURL:redirectURL];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAPPID appSecret:kQQAPPKEY redirectURL:redirectURL];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kWBAPPID appSecret:kWBAPPKEY redirectURL:redirectURL];

    
//    [self debugUmengSetting];
    
}

///调试配置流程
- (void)debugUmengSetting{
    
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
        NSLog(@"----------WXLogLevelDetail %@",log);
    }];
    
    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult * _Nonnull result) {
        NSLog(@"checkUniversalLinkReady %@,result=%@,sug=%@",@(step),result.errorInfo,result.suggestion);
    }];
}
#pragma mark - umeng share appdelegate setting -
- (BOOL)c_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    
    BOOL result;
    if (!options) {
        result = [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    else{
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    }
    
    if (!result) {
        // 其他如支付等SDK的回调
        NSLog(@"----------");
    }

    
    return result;
}

- (BOOL)c_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
         // 其他如支付等SDK的回调
        NSLog(@"----------");

    }
    return result;

}

///微信和QQ完整版都需要开发者配置正确的Universal link和对应的Universal link系统回调
- (BOOL)c_application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler{
    if (![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]) {
        // 其他SDK的回调
        NSLog(@"----------");

    }
    
    return YES;
}

#pragma mark - Jpush notification setting -

- (void)configJpushNotification:(NSDictionary *)launchOptions{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginNotify:) name:ZXSD_notification_userLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutNotify) name:ZXSD_NOTIFICATION_USERLOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushInMessageRecieved:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    BOOL isProduct = NO;
#ifdef DEBUG
    isProduct = NO;
#else
    isProduct = YES;
#endif
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:kJPushAppKey
                          channel:@"App Store"
                 apsForProduction:isProduct
            advertisingIdentifier:advertisingId];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    //这个判断是在程序没有运行的情况下收到通知，点击通知跳转处理
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification){
        // 程序完全退出时，点击通知的处理。
        [JPUSHService resetBadge];

        dispatch_queue_after_S(1, ^{
            [URLRouter routerRemoteNotification:remoteNotification];
        });
    }
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken{
    [JPUSHService registerDeviceToken:self.deviceToken];
}

#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
        
    }else{
        //从通知设置界面进入应用
        
    }
}

////iOS7及以上系统，收到通知      此方法在接收到静默推送的时候会调用
//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler{
//
//    [JPUSHService handleRemoteNotification:userInfo];
//
//    [self handleNotification:userInfo];
//
////系统要求执行这个方法
//    completionHandler(UIBackgroundFetchResultNewData);
//
//}


// 前台时收到推送消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_notification_newMessage object:userInfo];
    //tabBar角标显示
//    [self.tabBarController shouldShowBadge:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshMessage object:nil userInfo:@{@"hasNew" : @(YES)}];

    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    //iOS10 前台收到远程通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [self handleNotification:userInfo];
        
    }
    else{
        //iOS10 前台收到本地通知
//        [EasyTextView showText:@"[@(application.applicationState) stringValue]"];
    }
    
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark - help methods -
+ (void)clearBadge{
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)handleNotification:(NSDictionary*)userInfo{
//    [[AppDelegate appDelegate].tabBarController selectTab:1];
//    [HKLinkerManager openUrl:[userInfo stringObjectForKey:@"href"] ];
   
    [AppDelegate clearBadge];
    
    [URLRouter routerRemoteNotification:userInfo];
}

#pragma mark - notify -

- (void)registeJPushAlias
{
    NSString *phone = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
    if (!IsValidString(phone)) {
        return;
    }
    [JPUSHService setAlias:phone
                completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        ZGLog(@"setAlias....%@...%@", iAlias, @(iResCode));
    } seq:0];
}


- (void)userLoginNotify:(NSNotification*)noti{

//    NSString * registrationID = [JPUSHService registrationID];
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (!IsValidString(phone)) {
        NSLog(@"----------push ->fail to setAlias:用户id为nil");
        return;
    }
    [JPUSHService setAlias:phone completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        //设置别名成功后，code值为0
        
        NSLog(@"++++++++push ->rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
        
    } seq:0];
    
    //提交register_id给后台（此方法为后台提供）
//    [self giveRegisterId:appdele.registerid andToken:dict[@"token"]];
 
    
}

- (void)userLogoutNotify{
    
    //删除推送的alias
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {

        [JPUSHService resetBadge];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

        NSLog(@"Logout rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
        
    } seq:0];
    

}

- (void)jpushInMessageRecieved:(NSNotification*)noti{
    NSDictionary *userInfo = noti.userInfo;
    if (!IsValidDictionary(userInfo)) {
        return;
    }
    
    NSDictionary *dic = [userInfo dictionaryObjectForKey:@"extras"];
    if (!IsValidDictionary(dic)) {
        return;;
    }
    
    [URLRouter routerRemoteNotification:dic];
    
}

@end
