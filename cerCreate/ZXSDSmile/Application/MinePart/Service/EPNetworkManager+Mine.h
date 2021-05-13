//
//  EPNetworkManager+Mine.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/21.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "EPNetworkManager.h"
#import "ZXSDOptionalConfigs.h"
#import "ZXSDBankCardModel.h"

@interface EPNetworkManager (Mine)

+ (NSURLSessionDataTask *)getOptionalConfigs:(NSDictionary *)params completion:(void (^)(ZXSDOptionalConfigs *model, NSError *error))completion;

+ (NSURLSessionDataTask *)getUserBankCards:(NSDictionary *)params completion:(void (^)(NSArray<ZXSDBankCardItem*> *records, NSError *error))completion;

+ (NSURLSessionDataTask *)bindHostBankCard:(NSString *)refID completion:(void (^)(NSError *error))completion;

@end


