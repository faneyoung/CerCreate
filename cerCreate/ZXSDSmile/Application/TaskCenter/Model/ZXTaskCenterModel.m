//
//  ZXTaskCenterModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/18.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXTaskCenterModel.h"

/**
 item.certTitle = @"收起提额任务";
 item.url = @"kAmountDes";
 [tmps addObject:item];

 */
@implementation ZXTaskCenterItem

- (NSString *)placeholdImg{
    
    NSString *img = [NSString stringWithFormat:@"icon_taskList_%@",self.certKey];
    
    if (!UIImageNamed(img)) {
        img = @"icon_common_none";
    }
    
    return img;
    
}

+ (ZXTaskCenterItem*)expandItem{
    ZXTaskCenterItem *item = [[ZXTaskCenterItem alloc] init];
    item.certTitle = @"收起提额任务";
    item.url = @"kAmountDes";
    return item;
}

- (BOOL)isExpandItem{
    return [self.url isEqualToString:@"kAmountDes"];
}

- (BOOL)showProgressView{
//#warning &&&& test -->>>>>
//    self.certStatus = @"Expired";
//#warning <<<<<<-- test &&&&

    if ([self.certStatus isEqualToString:@"Success"] ||
        [self.certStatus isEqualToString:@"Expired"]) {
        return YES;
    }

    return NO;
}

@end

@implementation ZXTaskCenterModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"taskItems":@"statusDTOS",
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"taskItems" : ZXTaskCenterItem.class,
    };
}


@end
