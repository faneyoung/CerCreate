//
//  ZXSDAdvanceRecordsModel.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAdvanceRecordsModel.h"

@implementation ZXSDAdvanceExtendModel

@end

@implementation ZXSDAdvanceRecordsModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
        @"loanStatus":@"status",
        @"loanDate":@"created",
        @"loanMoney":@"principal",
        @"repaymentDate":@"repayTime",
        @"loanStatusDes":@"statusDesc",
        @"loanID":@"refId",
        
        @"oldRepaymentDate":@"oldRepayTime"
        //@"extendModel" :@"extendButton"
    };
}

@end
