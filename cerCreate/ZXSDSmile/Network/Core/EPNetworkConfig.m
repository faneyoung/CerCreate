//
//  EPNetworkConfig.m
//  EPNetwork
//
//  Created by chrislos on 2017/3/27.
//  Copyright © 2017年 chrislos. All rights reserved.
//

#import "EPNetworkConfig.h"

static EPNetworkConfig *__epConfig = nil;

void EPNetworkSettingDefaultConfig(EPNetworkConfig *config)
{
    __epConfig = config;
}

@interface EPNetworkConfig ()

@property (nonatomic, strong, readwrite) NSMutableOrderedSet<id<EPRequestInterceptor>> *interceptors;

@end

@implementation EPNetworkConfig

+ (instancetype)sharedConfig
{
    NSAssert(__epConfig != nil , @"请配置EPNetworkConfig！！！");
    NSAssert(__epConfig.responseHandler != nil , @"请配置EPNetworkConfig <EPResponseHandler>！！！");
    return __epConfig;
}

- (instancetype)init
{
    if (self = [super init]) {
        _interceptors = [NSMutableOrderedSet new];
    }
    return self;
}

- (void)addInterceptor:(id<EPRequestInterceptor>)interceptor
{
    [self.interceptors addObject:interceptor];
}

- (void)removeInterceptor:(id<EPRequestInterceptor>)interceptor
{
    [self.interceptors removeObject:interceptor];
}

- (void)clearAllInterceptors
{
    [self.interceptors removeAllObjects];
}


- (NSString *)baseURL
{
    return nil;
}

- (NSString *)apiBasePath
{
    return @"";
}

- (NSTimeInterval)apiRequestTimeout
{
    return 60;
}

@end
