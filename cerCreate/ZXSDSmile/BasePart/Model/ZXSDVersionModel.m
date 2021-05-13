//
//  ZXSDVersionModel.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/18.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDVersionModel.h"

@implementation ZXSDVersionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"updateDesc" :@"description",
        @"downloadUrl":@[@"appUrl",@"downloadUrl"],
    };
}

@end
