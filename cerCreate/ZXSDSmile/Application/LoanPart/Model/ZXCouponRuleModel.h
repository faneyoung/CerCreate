//
//  ZXCouponRuleModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCouponRuleModel : ZXBaseModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *expires;
@property (nonatomic, strong) NSString *faceValue;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;

@end

NS_ASSUME_NONNULL_END

/**
 "name":"", //券名称
 "created":"", //开始时间
 "expires":"", //失效时间
 "description":"", //描述
 "faceValue":"", //面值
 "type":"", //优惠券类型 01:10元券  02:20元券 03:预支神券(5元)

 */
