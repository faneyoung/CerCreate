//
//  ZXCompanyCheckModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/12.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCompanyCheckModel.h"

@implementation ZXCompanyCheckModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"oldPhone":@"value.oldPhone",
        @"phone":@"value.newPhone",
    };
}

@end
