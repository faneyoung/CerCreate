//
//  ZXUserModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/27.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXUserModel.h"

@implementation ZXUserModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"avatar" : @"headimgurl",
        @"nickname":@[@"nickname",@"nickName"],
    };
}

@end
