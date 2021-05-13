//
//  ZXAmountEvaluateListModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAmountEvaluateListModel.h"

@implementation ZXAmountEvaluateListModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        
        @"title":@"description",
        @"taskItems":@"statusDTOS",
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"taskItems":ZXTaskCenterItem.class,
    };
}

@end
