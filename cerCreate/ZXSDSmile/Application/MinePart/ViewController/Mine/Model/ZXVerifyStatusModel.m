//
//  ZXVerifyStatusModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXVerifyStatusModel.h"

@implementation ZXVerifyStatusModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"faceDone" : @"idFaceDone",
    };
}

- (BOOL)shouldBindCardOrBindEmployer{
    
    if (!self.bankCardDone) {
        [URLRouter routerUrlWithPath:kRouter_bindCard extra:nil];
        return YES;
    }
    
    if (!self.jobInfoDone) {
        [URLRouter routerUrlWithPath:kRouter_bindEmployerInfo extra:nil];
        return YES;
    }
    
    return NO;
}

@end
