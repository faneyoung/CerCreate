//
//  ZXSDHeaderInterceptor.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/31.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHeaderInterceptor.h"

@interface ZXSDHeaderInterceptor ()

@property (nonatomic, strong) NSMutableDictionary *header;

@end

@implementation ZXSDHeaderInterceptor

+ (instancetype)sharedHeaderInterceptor
{
    static ZXSDHeaderInterceptor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZXSDHeaderInterceptor new];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initPrivateHeader];
    }
    return self;
}


- (void)initPrivateHeader
{
    NSMutableDictionary *header = [NSMutableDictionary new];
    
    NSString *encodedString = [NSString stringWithFormat:@"%@%@",MARS_HMAC_KEY,MARS_HMAC_SEND_MS];
    NSString *hmacSignature = [encodedString hmacSHA512StringWithKey:MARS_APP_SECRET];
    NSString *signature = [hmacSignature lowercaseString];
    [header setValue:signature forKey:@"HMAC-SIGNATURE"];
    
    
    [header setValue:[NSString stringWithFormat:@"%@%@",USER_AGENT,APP_VERSION()] forKey:@"User-Agent"];
    [header setValue:MARS_HMAC_KEY forKey:@"HMAC-KEY"];
    [header setValue:MARS_HMAC_SEND_MS forKey:@"HMAC-SEND-MS"];
    
    // 设备信息
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [header setValue:version forKey:@"version"];
    [header setValue:@"iOS" forKey:@"deviceType"];
    [header setValue:kSourceChannel forKey:@"sourceChannel"];
    //OS版本
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    [header setValue:osVersion forKey:@"X-OSV"];
    
    
    
    self.header = header;
}

- (nonnull NSMutableURLRequest *)interceptBeforeRequest:(nonnull NSMutableURLRequest *)originalRequest
{
    NSMutableDictionary *header = [[ZXSDHeaderInterceptor sharedHeaderInterceptor] header];
    
    NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
    if(userSession.length > 0) {
        [header setValue:userSession forKey:@"USER-SESSION"];
    }

    for (NSString *key in header.allKeys) {
        [originalRequest setValue:[header objectForKey:key] forHTTPHeaderField:key];
    }
    return originalRequest;
}

@end
