//
//  EPNetworkConfig.h
//  EPNetwork
//
//  Created by chrislos on 2017/3/27.
//  Copyright © 2017年 chrislos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPNetworkResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EPNetworkCompletionBlock)(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error);


@protocol EPRequestInterceptor

/**
    在请求开始前对originalRequest做特定的处理
 */
- (NSMutableURLRequest *)interceptBeforeRequest:(NSMutableURLRequest *)originalRequest;

@end

@protocol EPMakeSignature <NSObject>

- (NSDictionary *)generateSignWithParams:(NSDictionary *)originParams forAPI:(NSString *)api;

@end


@protocol EPResponseHandler <NSObject>

@required
- (void)handleFailure:(EPNetworkCompletionBlock)failure
             withTask:(nullable NSURLSessionDataTask *)task
                error:(NSError *)error;


- (void)handleSuccess:(EPNetworkCompletionBlock)success
             withTask:(NSURLSessionDataTask *)task
          decodeClass:(Class)decodeClass
       responseObject:(id)responseObject
           parameters:(NSDictionary *)parameters;

@end



/**
    配置app的网络运行环境，需要使用EPNetworkSettingDefaultConfig提前注册
 */

@interface EPNetworkConfig : NSObject

@property (nonatomic, strong, readonly) NSMutableOrderedSet<id<EPRequestInterceptor>> *interceptors;

@property (nonatomic, assign) BOOL needSign;

@property (nonatomic, weak) id<EPMakeSignature> signatureMaker;

@property (nonatomic, weak) id<EPResponseHandler> responseHandler;

+ (instancetype)sharedConfig;

#pragma mark - Interceptor 


/**
 添加/删除拦截器 （注意，目前拦截器的增删必须在使用EPNetworkConfig时提前配置好，暂不支持动态修改）

 @param interceptor 请求拦截器
 */
- (void)addInterceptor:(id<EPRequestInterceptor>)interceptor;

- (void)removeInterceptor:(id<EPRequestInterceptor>)interceptor;

- (void)clearAllInterceptors;


#pragma mark - Need Override

- (NSString *)baseURL;

- (NSString *)apiBasePath;

- (NSTimeInterval)apiRequestTimeout;

@end

NS_ASSUME_NONNULL_END
