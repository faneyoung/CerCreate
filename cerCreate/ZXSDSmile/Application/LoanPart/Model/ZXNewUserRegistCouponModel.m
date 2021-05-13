//
//  ZXNewUserRegistCouponModel.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXNewUserRegistCouponModel.h"

@implementation ZXNewUserRegistCouponModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"faceValue":@"data.valueMap.faceValue",
        @"url":@"data.url",
    };
}
@end
