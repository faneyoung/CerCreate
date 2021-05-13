//
//  ZXAmoutEvaluateInfoModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/11.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAmoutEvaluateInfoModel.h"

@implementation ZXAmountEvaluateItemModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"taskItems":@"statusDTOS",
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"taskItems":ZXTaskCenterItem.class,
    };
}

@end

@implementation ZXAmoutEvaluateInfoModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"des":@"description",
        @"evaluateItemModels":@"taskCenterVOList",
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"evaluateItemModels":ZXAmountEvaluateItemModel.class,
    };
}

@end
