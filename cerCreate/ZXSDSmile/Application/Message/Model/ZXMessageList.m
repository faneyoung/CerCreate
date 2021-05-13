//
//  ZXMessageList.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMessageList.h"

@implementation ZXMessageItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"msgId" : @"id",
        @"title" : @[@"title",@"msg"],
    };
}

@end

@implementation ZXMessageList
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"messages" : @"resultList",
    };
}
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"messages":ZXMessageItem.class
    };
}
@end
