//
//  ZXCouponListModel.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXCouponListModel.h"

@implementation ZXCouponListModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"desc" : @"description",
        @"couponRefId" : @[@"couponRefId",@"refId"],
    };
}

+ (NSArray*)modelsWithData:(NSArray*)datas{
    if (!IsValidArray(datas)) {
        return nil;
    }
    
    __block NSMutableArray *tmps = @[].mutableCopy;
    [datas enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXCouponListModel *model = [ZXCouponListModel instanceWithDictionary:obj];
        [tmps addSafeObject:model];
    }];
    
    return tmps.copy;
}

#pragma mark - mock -

+ (NSArray*)testModels{
    
    NSMutableArray *tmps = @[].mutableCopy;
    for (int i = 0; i<3; i++) {
        ZXCouponListModel *model = [[ZXCouponListModel alloc] init];
        model.name = [NSString stringWithFormat:@"会员抵扣券%d",i];
        model.couponRefId = [NSString stringWithFormat:@"00000%d",i+1];
        if (i % 2 == 0) {
            model.status = 2;
        }
        else if(i%3 == 0){
            model.status = 3;
        }
        model.desc = @"新用户需完成认证和任务中心的任务，点击“立即预支”后，在支付会员费时，系统默认为您“使用优惠券”。";
        [tmps addObject:model];
    }
    
    return tmps.copy;
}

@end
