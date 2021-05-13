//
//  EPNetworkManager.h
//  EPNetwork
//
//  Created by chrislos on 2017/3/20.
//  Copyright © 2017年 chrislos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPNetworkResponse.h"
#import "EPNetworkConfig.h"
#import "EPNetworkError.h"
#import <AFNetworking/AFHTTPSessionManager.h>
//#import <AFNetworking/AFHTTPRequestOperationManager.h>

NS_ASSUME_NONNULL_BEGIN


@interface EPNetworkManager : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *sessionManager;


+ (instancetype)defaultManager;

- (instancetype)initWithBaseURL:(nullable NSURL *)url;

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration;


- (void)cancelAllTasks;



#pragma mark - GET
- (NSURLSessionDataTask *)getAPI:(NSString *)api
                      parameters:(nullable NSDictionary *)parameters
                     decodeClass:(nullable Class)decodeClass
                      completion:(EPNetworkCompletionBlock)completionBlock;
/**
GET 请求封装

@param api api路径
@param apiBasePath api路径的基础路径, 不传则默认为空
@param parameters 请求参数
@param decodeClass 返回的业务数据填充模型
@param completionBlock 请求完成的回掉
@return NSURLSessionDataTask
*/
- (NSURLSessionDataTask *)getAPI:(NSString *)api
                     apiBasePath:(nullable NSString *)apiBasePath
                      parameters:(nullable NSDictionary *)parameters
                     decodeClass:(nullable Class)decodeClass
                      completion:(EPNetworkCompletionBlock)completionBlock;



#pragma mark - POST
- (NSURLSessionDataTask *)postAPI:(NSString *)api
                       parameters:(nullable id)parameters
                      decodeClass:(nullable Class)decodeClass
                       completion:(EPNetworkCompletionBlock)completionBlock;

/**
POST 请求封装

@param api api路径
@param apiBasePath api路径的基础路径, 不传则默认为空
@param parameters 请求参数
@param decodeClass 返回的业务数据填充模型
@param completionBlock 请求完成的回调
@return NSURLSessionDataTask
*/
- (NSURLSessionDataTask *)postAPI:(NSString *)api
                      apiBasePath:(nullable NSString *)apiBasePath
                       parameters:(nullable id)parameters
                      decodeClass:(nullable Class)decodeClass
                       completion:(EPNetworkCompletionBlock)completionBlock;

/**
POST 请求封装

@param api api路径
@param apiBasePath api路径的基础路径, 不传则默认为空
@param parameters 请求参数
@param decodeClass 返回的业务数据填充模型
@param block post请求的body数据封装
@param completionBlock 请求完成的回调
@return NSURLSessionDataTask
*/
- (NSURLSessionDataTask *)postAPI:(NSString *)api
                      apiBasePath:(nullable NSString *)apiBasePath
                       parameters:(nullable id)parameters
                      decodeClass:(nullable Class)decodeClass
        constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> formData))block
                       completion:(EPNetworkCompletionBlock)completionBlock;



#pragma mark - PUT
- (NSURLSessionDataTask *)putAPI:(NSString *)api
                      parameters:(nullable NSDictionary *)parameters
                     decodeClass:(nullable Class)decodeClass
                      completion:(EPNetworkCompletionBlock)completionBlock;
/**
PUT 请求封装

@param api api路径
@param apiBasePath api路径的基础路径, 不传则默认为空
@param parameters 请求参数
@param decodeClass 返回的业务数据填充模型
@param completionBlock 请求完成的回掉
@return NSURLSessionDataTask
*/
- (NSURLSessionDataTask *)putAPI:(NSString *)api
                     apiBasePath:(nullable NSString *)apiBasePath
                      parameters:(nullable NSDictionary *)parameters
                     decodeClass:(nullable Class)decodeClass
                      completion:(EPNetworkCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
