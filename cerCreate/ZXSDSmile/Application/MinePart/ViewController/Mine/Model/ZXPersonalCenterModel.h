//
//  ZXPersonalCenterModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/7.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXPersonalCenterModel : ZXBaseModel
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;

///跳转路由
@property (nonatomic, strong) NSString *action;

///是否需要4要素认证
@property (nonatomic, assign) BOOL needVerify;


/// 个人中心
+ (NSArray*)personalCenterItems;

/// 个人资料
+ (NSArray*)personalProfileItems;


/// 设置
+ (NSArray*)personalSettingItems;
///账户安全
+ (NSArray*)personalAcountSecurityItems;

@end

NS_ASSUME_NONNULL_END
