//
//  ZXCouponRuleModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCouponRuleModel.h"

@implementation ZXCouponRuleModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"desc":@"description",
    };
}


@end
