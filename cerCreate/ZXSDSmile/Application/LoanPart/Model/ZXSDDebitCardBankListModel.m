//
//  ZXSDDebitCardBankListModel.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDDebitCardBankListModel.h"

@implementation ZXSDDebitCardBankListModel

+ (NSMutableArray *)parsingDataWithJson:(id)data {
    NSMutableArray *returnList = [[NSMutableArray alloc] init];
    if ([data isKindOfClass:[NSArray class]]) {
        for (NSDictionary *bankDic in data) {
            ZXSDDebitCardBankListModel *model = [ZXSDDebitCardBankListModel new];
            
            if ([[bankDic objectForKey:@"bankPic"] isKindOfClass:[NSString class]]) {
                model.bankPic = [bankDic objectForKey:@"bankPic"];
            } else {
                model.bankPic = @"";
            }
            
            if ([[bankDic objectForKey:@"bankName"] isKindOfClass:[NSString class]]) {
                model.bankName = [bankDic objectForKey:@"bankName"];
            } else {
                model.bankName = @"";
            }
            
            if ([[bankDic objectForKey:@"bankCode"] isKindOfClass:[NSString class]]) {
                model.bankCode = [bankDic objectForKey:@"bankCode"];
            } else {
                model.bankCode = @"";
            }
            
            [returnList addObject:model];
        }
    }
    return returnList;
}

@end
