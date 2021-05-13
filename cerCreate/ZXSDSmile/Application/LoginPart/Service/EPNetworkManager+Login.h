//
//  EPNetworkManager+Login.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/31.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "EPNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface EPNetworkManager (Login)

+ (NSURLSessionDataTask *)uploadDeviceInformation:(nullable NSDictionary *)params completion:(void (^)(NSError *error))completion;

+ (NSURLSessionDataTask *)doYJLoginWithParams:(nullable NSDictionary *)params completion:(void (^)(NSString *phone, NSError *error))completion;

+ (NSURLSessionDataTask *)doSMSLoginWithParams:(nullable NSDictionary *)params completion:(void (^)(NSError *error))completion;

@end

NS_ASSUME_NONNULL_END

