//
//  ZXSDSystemInformation.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDSystemInformation : NSObject

+ (NSString *)deviceVersion; // 获取设备型号 例：iPhone X
+ (NSString *)idfv;
+ (NSString *)idfa;//广告标识符
+ (NSString *)screen;//手机屏幕
+ (NSString *)systemVersion;//系统版本 例: iOS 11.4

@end

NS_ASSUME_NONNULL_END
