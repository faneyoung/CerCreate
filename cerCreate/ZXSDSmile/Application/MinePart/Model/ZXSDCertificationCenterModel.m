//
//  ZXSDCertificationCenterModel.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDCertificationCenterModel.h"

@implementation ZXSDCertificationCenterModel

+ (NSMutableArray *)parsingDataWithJson:(id)data {
    NSMutableArray *returnList = [[NSMutableArray alloc] init];
    if ([data isKindOfClass:[NSArray class]]) {
        for (NSArray *modelsArray in data) {
            NSMutableArray *modelList = [[NSMutableArray alloc] init];
            for (NSDictionary *certDic in modelsArray) {
                ZXSDCertificationCenterModel *certModel = [ZXSDCertificationCenterModel new];

                if ([[certDic objectForKey:@"certKey"] isKindOfClass:[NSString class]]) {
                    certModel.certType = [certDic objectForKey:@"certKey"];
                } else {
                    certModel.certType = @"";
                }

                if ([[certDic objectForKey:@"certTitle"] isKindOfClass:[NSString class]]) {
                    certModel.certName = [certDic objectForKey:@"certTitle"];
                } else {
                    certModel.certName = @"";
                }

                if ([[certDic objectForKey:@"certTitleDesc"] isKindOfClass:[NSString class]]) {
                    certModel.certContent = [certDic objectForKey:@"certTitleDesc"];
                } else {
                    certModel.certContent = @"";
                }

                if ([[certDic objectForKey:@"certStatus"] isKindOfClass:[NSString class]]) {
                    certModel.certStatus = [certDic objectForKey:@"certStatus"];
                } else {
                    certModel.certStatus = @"NotDone";
                }

                if ([[certDic objectForKey:@"certStatusDesc"] isKindOfClass:[NSString class]]) {
                    certModel.certDes = [certDic objectForKey:@"certStatusDesc"];
                } else {
                    certModel.certDes = @"";
                }
                
                certModel.url = [certDic stringObjectForKey:@"url"];


                [modelList addObject:certModel];
            }

            [returnList addObject:modelList];
        }
    }

    return returnList;
}

@end
