//
//  ZXMembershipFeeModel.m
//  ZXSDSmile
//
//  Created by Fane on 2020/11/30.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMembershipFeeModel.h"

static int kMemberFee = 30;

@implementation ZXMembershipFeeModel

- (NSString *)memberFee{
    return [@(kMemberFee) stringValue];
}

@end
