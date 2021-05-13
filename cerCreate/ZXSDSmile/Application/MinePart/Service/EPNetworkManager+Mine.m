//
//  EPNetworkManager+Mine.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/21.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "EPNetworkManager+Mine.h"

// 全局可选项配置信息
#define QUERY_OPTIONAL_DATA  @"/rest/anon/option"

// 设置银行卡为默认卡
#define BIND_HOST_BANKCARD(refID)  [NSString stringWithFormat:@"/rest/bankCard/setDefault?refId=%@", refID]
// 获取用户添加的所有银行卡
#define USER_ALLBANKCARDS  @"/rest/bankCard/all"

@implementation EPNetworkManager (Mine)

+ (NSURLSessionDataTask *)getOptionalConfigs:(NSDictionary *)params completion:(void (^)(ZXSDOptionalConfigs *model, NSError *error))completion
{
    return [[EPNetworkManager defaultManager] getAPI:QUERY_OPTIONAL_DATA parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
        } else {
            ZXSDOptionalConfigs *loanInfo = [ZXSDOptionalConfigs modelWithJSON:response.originalContent];
            completion(loanInfo, nil);
        }
        
    }];
}


+ (NSURLSessionDataTask *)getUserBankCards:(NSDictionary *)params completion:(void (^)(NSArray<ZXSDBankCardItem*> *records, NSError *error))completion
{
    return [[EPNetworkManager defaultManager] getAPI:USER_ALLBANKCARDS parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
        } else {
            if ([response.originalContent isKindOfClass:[NSArray class]]) {
                
                NSArray *records = [NSArray yy_modelArrayWithClass:[ZXSDBankCardItem class] json:response.originalContent];
                completion(records, nil);
                
            } else {
                completion(@[], nil);
            }
        }
        
    }];
}

+ (NSURLSessionDataTask *)bindHostBankCard:(NSString *)refID completion:(void (^)(NSError *error))completion
{
    return [[EPNetworkManager defaultManager] getAPI:BIND_HOST_BANKCARD(refID) parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(error);
        } else {
            completion(nil);
        }
        
    }];
}
@end
