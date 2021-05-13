//
//  EPNetworkManager.m
//  EPNetwork
//
//  Created by chrislos on 2017/3/20.
//  Copyright © 2017年 chrislos. All rights reserved.
//

#import "EPNetworkManager.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface EPNetworkManager()

@property (nonatomic, strong, readwrite) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) EPNetworkConfig *networkConfig;

@property (nonatomic, strong) AFHTTPRequestSerializer *HTTPRequestSerializer;
@property (nonatomic, strong) AFHTTPRequestSerializer *JSONRequestSerializer;
@property (nonatomic, strong) AFHTTPRequestSerializer *putJSONRequestSerializer;;

@end

@implementation EPNetworkManager

#pragma mark - Getter
- (AFJSONResponseSerializer *)jsonResponseSerializer
{
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        
        //statusCode 相关信息参考： http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
        _jsonResponseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 200)];
        
    }
    return _jsonResponseSerializer;
}

- (AFHTTPRequestSerializer *)HTTPRequestSerializer
{
    if (!_HTTPRequestSerializer) {
        _HTTPRequestSerializer = [AFHTTPRequestSerializer new];
        [self configRequestSerializer:_HTTPRequestSerializer];
    }
    return _HTTPRequestSerializer;
}

- (AFHTTPRequestSerializer *)JSONRequestSerializer
{
    _JSONRequestSerializer = [AFJSONRequestSerializer new];
    [self configRequestSerializer:_JSONRequestSerializer];
    return _JSONRequestSerializer;
}

- (AFHTTPRequestSerializer *)putJSONRequestSerializer
{
    _putJSONRequestSerializer = [AFJSONRequestSerializer new];
//        [self configRequestSerializer:_JSONRequestSerializer];
    
    NSTimeInterval timeoutInterval = self.networkConfig.apiRequestTimeout;
    if (timeoutInterval < 0 || timeoutInterval > 30) {
        timeoutInterval = 30;
    }
    _putJSONRequestSerializer.timeoutInterval = timeoutInterval;
    [_putJSONRequestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [_putJSONRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return _putJSONRequestSerializer;
}


#pragma mark - init

+ (instancetype)defaultManager
{
    static EPNetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EPNetworkManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(nullable NSURL *)url
{
    return [self initWithBaseURL:url sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super init]) {
        _networkConfig = [EPNetworkConfig sharedConfig];
        NSURL *configBaseURL = [NSURL URLWithString:[_networkConfig baseURL]];
        [self updateURLSessionConfiguration:configuration baseURL:url?:configBaseURL];
    }
    return self;
}

- (void)updateURLSessionConfiguration:(NSURLSessionConfiguration *)configuration
                              baseURL:(NSURL *)baseURL
{
    
    BOOL valid = [baseURL.scheme hasPrefix:@"http"];
    NSAssert(valid, @"baseURL不合法！！！");
    
    if (self.sessionManager) {
        // 取消所有的请求
        [[self.sessionManager session] invalidateAndCancel];
    }
    
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
    
    // 安全配置
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = YES;
    self.sessionManager.securityPolicy = securityPolicy;
    
    
    // 配置响应数据信息格式
    self.sessionManager.responseSerializer = self.jsonResponseSerializer;
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"gzip"]];
    
    
    // 回调块在全局并发队列中调度
    self.sessionManager.completionQueue = dispatch_queue_create("com.eparty.networkagent.processing", DISPATCH_QUEUE_CONCURRENT);
}

#pragma mark - API Tools
- (NSURLSessionDataTask *)getAPI:(NSString *)api
                      parameters:(nullable NSDictionary *)parameters
                     decodeClass:(nullable Class)decodeClass
                      completion:(EPNetworkCompletionBlock)completionBlock
{
    NSString *apiBasePath = self.networkConfig.apiBasePath;
    return [self getAPI:api apiBasePath:apiBasePath parameters:parameters decodeClass:decodeClass completion:completionBlock];
}

- (NSURLSessionDataTask *)getAPI:(NSString *)api
                     apiBasePath:(nullable NSString *)apiBasePath
                      parameters:(nullable NSDictionary *)parameters
                     decodeClass:(nullable Class)decodeClass
                      completion:(EPNetworkCompletionBlock)completionBlock
{
    return [self dataTaskWithHTTPMethod:@"GET" api:api apiBasePath:apiBasePath parameters:parameters decodeClass:decodeClass constructingBodyWithBlock:nil completion:completionBlock];
    
}

- (NSURLSessionDataTask *)postAPI:(NSString *)api
                       parameters:(nullable id)parameters
                      decodeClass:(nullable Class)decodeClass
                       completion:(EPNetworkCompletionBlock)completionBlock
{
    NSString *apiBasePath = self.networkConfig.apiBasePath;
    return [self postAPI:api apiBasePath:apiBasePath parameters:parameters decodeClass:decodeClass constructingBodyWithBlock:NULL completion:completionBlock];
}

- (NSURLSessionDataTask *)postAPI:(NSString *)api
                      apiBasePath:(nullable NSString *)apiBasePath
                       parameters:(nullable id)parameters
                      decodeClass:(nullable Class)decodeClass
                       completion:(EPNetworkCompletionBlock)completionBlock;
{
    return [self postAPI:api apiBasePath:apiBasePath parameters:parameters decodeClass:decodeClass constructingBodyWithBlock:NULL completion:completionBlock];
}

- (NSURLSessionDataTask *)postAPI:(NSString *)api
                      apiBasePath:(nullable NSString *)apiBasePath
                       parameters:(nullable id)parameters
                      decodeClass:(nullable Class)decodeClass
        constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> formData))block
                       completion:(EPNetworkCompletionBlock)completionBlock
{
    return [self dataTaskWithHTTPMethod:@"POST" api:api apiBasePath:apiBasePath parameters:parameters decodeClass:decodeClass constructingBodyWithBlock:block completion:completionBlock];
}

- (NSURLSessionDataTask *)putAPI:(NSString *)api
                      parameters:(nullable NSDictionary *)parameters
                     decodeClass:(nullable Class)decodeClass
                      completion:(EPNetworkCompletionBlock)completionBlock
{
    NSString *apiBasePath = self.networkConfig.apiBasePath;
    return [self putAPI:api apiBasePath:apiBasePath parameters:parameters decodeClass:decodeClass completion:completionBlock];
}

- (NSURLSessionDataTask *)putAPI:(NSString *)api
                     apiBasePath:(nullable NSString *)apiBasePath
                      parameters:(nullable NSDictionary *)parameters
                     decodeClass:(nullable Class)decodeClass
                      completion:(EPNetworkCompletionBlock)completionBlock
{
    return [self dataTaskWithHTTPMethod:@"PUT" api:api apiBasePath:apiBasePath parameters:parameters decodeClass:decodeClass constructingBodyWithBlock:nil completion:completionBlock];
}


- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                             api:(NSString *)api
                                     apiBasePath:(nullable NSString *)apiBasePath
                                      parameters:(id)parameters
                                     decodeClass:(Class)decodeClass
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                      completion:(EPNetworkCompletionBlock)completionBlock
{
    if (![self isRequestAllowed]) {
        completionBlock(nil, nil, [EPNetworkError internetNotConnectedError:nil]);
        return nil;
    }
    self.sessionManager.requestSerializer = [self localRequestSerializerForMethod:method];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = nil;
    
    if (nil == apiBasePath) {
        apiBasePath = @"";
    }
    NSString *path = [apiBasePath stringByAppendingString:api];
    NSString *urlString = [[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL] absoluteString];
    ZGLog(@"\n%@: %@\n%@", [method uppercaseString], path, parameters);
    
    // 签名处理
    if (self.networkConfig.needSign) {
        parameters = [self.networkConfig.signatureMaker generateSignWithParams:parameters forAPI:api];
    }
                                              
    if (block) {
        request = [self.sessionManager.requestSerializer multipartFormRequestWithMethod:method
                                 URLString:urlString
                                parameters:parameters
                 constructingBodyWithBlock:block
                                     error:&serializationError];
        
    } else {
        request = [self.sessionManager.requestSerializer
                   requestWithMethod:method
                           URLString:urlString
                          parameters:parameters
                               error:&serializationError];
    }
    
    if (serializationError) {
        [self.networkConfig.responseHandler handleFailure:completionBlock withTask:nil error:serializationError];
        return nil;
    }
    
    return [self request:request parameters:parameters decodeClass:decodeClass completion:completionBlock];
}

- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                       parameters:(NSDictionary *)parameters
                      decodeClass:(Class)decodeClass
                       completion:(EPNetworkCompletionBlock)completion
{
    // 处理请求拦截器
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    for (id<EPRequestInterceptor> interceptor in _networkConfig.interceptors) {
        mutableRequest = [interceptor interceptBeforeRequest:mutableRequest];
    }
    
    if (!mutableRequest) {
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:mutableRequest uploadProgress:NULL downloadProgress:NULL completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        ZGLog(@"\n%@: %@\nParameters:\n%@\nResponse:\n%@\n", request.HTTPMethod, request.URL.description, parameters, ((NSObject*)responseObject).modelToJSONString);
        
        if (error) {
            [self.networkConfig.responseHandler handleFailure:completion withTask:dataTask error:error];
            ZGLog(@"request failed,url = %@\n params=%@\nerror=%@",dataTask.currentRequest.URL.absoluteString,parameters.modelToJSONString,error.description)
            NSData *data = [error.userInfo valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data) {
                ZGLog(@"\n----------%@\n",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
            }


        } else {
            [self.networkConfig.responseHandler handleSuccess:completion withTask:dataTask decodeClass:decodeClass responseObject:responseObject parameters:parameters];
        }
    }];
    [dataTask resume];
    return dataTask;
}

#pragma mark - cancel task

- (void)cancelAllTasks
{
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        [task cancel];
    }
}

#pragma mark - private 

// 是否允许进行网络请求
- (BOOL)isRequestAllowed
{
    if (self.sessionManager.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

// 根据请求方法配置合适的请求头序列化对象
- (AFHTTPRequestSerializer *)localRequestSerializerForMethod:(NSString *)method
{
    NSString *requestMethod = method.uppercaseString;
    if ([requestMethod isEqualToString:@"GET"]
        || [requestMethod isEqualToString:@"HEAD"]
        || [requestMethod isEqualToString:@"DELETE"]) {
        return self.HTTPRequestSerializer;
    }
    else if([requestMethod isEqualToString:@"PUT"]){
        return self.putJSONRequestSerializer;
    }
    else {
        return self.JSONRequestSerializer;
    }
}

// 配置请求数据信息格式
- (void)configRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
{
    NSTimeInterval timeoutInterval = self.networkConfig.apiRequestTimeout;
    if (timeoutInterval < 0 || timeoutInterval > 60) {
        timeoutInterval = 60;
    }
    requestSerializer.timeoutInterval = timeoutInterval;
    [requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];


}

@end
