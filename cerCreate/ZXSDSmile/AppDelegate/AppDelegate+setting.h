//
//  AppDelegate+setting.h
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (setting) <JPUSHRegisterDelegate>

- (void)settingWithOptions:(NSDictionary *)launchOptions;


- (BOOL)c_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
- (BOOL)c_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)c_application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler;



- (void)didRegisterForRemoteNotificationsWithDeviceToken;
- (void)registeJPushAlias;
+ (void)clearBadge;

@end

NS_ASSUME_NONNULL_END
