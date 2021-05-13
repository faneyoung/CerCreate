//
//  ZXSDLoginService.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/25.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YjyzVerify/YJYZSDK.h>
#import <YjyzVerify/YJYZSDKManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDLoginService : NSObject

+ (void)startYJLogin:(UIViewController *)authController;
+ (void)startSMSLogin:(UIViewController *)fromController;
+ (void)startAutoLogin:(UIViewController *)fromController;

+ (void)gotoMainHome:(UINavigationController *)navController;

+ (void)uploadDeviceInfo;
+ (void)judgeNextActionFrom:(ZXSDBaseViewController *)controller
                withNavCtrl:(UINavigationController *)navController;
+ (void)judgeNextAction;

+ (void)saveSession:(NSString *)userSession phone:(NSString *)phone;


/// 微信授权
/// @param block 授权返回block
+ (void)wxAuthComplete:(void(^)(NSDictionary*,NSError *))block;

@end

NS_ASSUME_NONNULL_END
