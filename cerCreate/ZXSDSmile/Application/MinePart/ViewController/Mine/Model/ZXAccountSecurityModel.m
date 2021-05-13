//
//  ZXAccountSecurityModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/27.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAccountSecurityModel.h"

@implementation ZXAccountSecurityModel

- (NSArray *)societyAccounts{
    if (!_societyAccounts) {
        NSMutableArray *tmps = @[].mutableCopy;
        ZXAccountSecurityModel *wxModel = [[ZXAccountSecurityModel alloc] init];
        wxModel.img = UIImageNamed(@"icon_accountSecurity_wx");
        wxModel.title = @"微信";
        [tmps addObject:wxModel];
        
        _societyAccounts = tmps.copy;
    }
    
    return _societyAccounts;
}

@end
