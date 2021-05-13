//
//  ZXBannerModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXBannerModel : ZXBaseModel

///广告位类型
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *name;
///商品id
@property (nonatomic, strong) NSString *productId;

///图片
@property (nonatomic, strong) NSString *cover;
///跳转链接
@property (nonatomic, strong) NSString *url;
///是否需要登录
@property (nonatomic, assign) BOOL needLogin;
///是否外链
@property (nonatomic, assign) BOOL linkFlag;

/// 是否隐藏webView标题
@property (nonatomic, assign) BOOL isHideTitle;

///特色充值 金额
@property (nonatomic, strong) NSString *amount;
///展示价格
@property (nonatomic, strong) NSString *showAmount;

///特色充值 折扣
@property (nonatomic, strong) NSString *discount;
///特色充值 描述
@property (nonatomic, strong) NSString *desc;




@end

@interface ZXHomeBannerModel : ZXBaseModel
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *titleList;

+ (ZXHomeBannerModel *)mockItemWithType:(NSString*)type;

@end

NS_ASSUME_NONNULL_END
