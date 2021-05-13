//
//  EPNetworkManager+Login.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/31.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "EPNetworkManager+Login.h"

// 上传设备信息
#define UPLOAD_DEVICE_INFORMATION_URL  @"/rest/device"

// 一键登陆
#define YJDL_LOGIN_URL  @"/rest/anon/oneClickLogin"

// 验证码登陆
#define SMSCODE_LOGIN_URL  @"/rest/anon/login"


@implementation EPNetworkManager (Login)

+ (NSURLSessionDataTask *)uploadDeviceInformation:(nullable NSDictionary *)params completion:(void (^)(NSError *error))completion
{
    return [[EPNetworkManager defaultManager] postAPI:UPLOAD_DEVICE_INFORMATION_URL parameters:params decodeClass:NULL completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        completion(error);
    }];
}

+ (NSURLSessionDataTask *)doYJLoginWithParams:(nullable NSDictionary *)params completion:(void (^)(NSString *phone, NSError *error))completion
{
    return [[EPNetworkManager defaultManager] postAPI:YJDL_LOGIN_URL parameters:params decodeClass:NULL completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
        } else {
            NSString *phone = [[response.originalContent objectForKey:@"account"] objectForKey:@"phone"];
            completion(phone, nil);
        }
        
    }];
}


+ (NSURLSessionDataTask *)doSMSLoginWithParams:(nullable NSDictionary *)params completion:(void (^)(NSError *error))completion
{
    return [[EPNetworkManager defaultManager] postAPI:SMSCODE_LOGIN_URL parameters:params decodeClass:NULL completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        completion(error);
    }];
}

@end
