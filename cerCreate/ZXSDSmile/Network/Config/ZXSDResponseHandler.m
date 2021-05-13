//
//  ZXSDResponseHandler.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/28.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDResponseHandler.h"

@implementation ZXSDResponseHandler

+ (instancetype)sharedResponseHandler
{
    static ZXSDResponseHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZXSDResponseHandler new];
    });
    return instance;
}

- (void)handleFailure:(EPNetworkCompletionBlock)failure
             withTask:(NSURLSessionDataTask *)task
                error:(NSError *)error
{
    if (failure) {
        EPNetworkError *innerError = nil;
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        innerError = [self innerError:response error:error];
        
        if (!innerError) {
            innerError = [self buildInternalErrorWithOriginalError:error];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(task.currentRequest, nil, innerError);
        });
    }
}

- (EPNetworkError *)innerError:(NSHTTPURLResponse *)response error:(NSError *)error
{
    EPNetworkError *innerError = nil;
    if (response.statusCode == 400 || response.statusCode == 403) {
        NSDictionary *errorDic = [NSDictionary safty_dictionaryWithDictionary:error.userInfo];
        NSData *errorData = [errorDic valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            id object = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"\n----------innerError:\n%@\n",object);

            if ([object isKindOfClass:[NSDictionary class]]) {
                 NSString *failedString = [object safty_objectForKey:@"message"];
                 failedString = failedString.length > 0 ? failedString : @"";
                innerError = [EPNetworkError errorWithMessage:failedString originalError:error];
             }
        }
    } else if (response.statusCode == 401) {
        innerError = [EPNetworkError sessionInvalidError:error];
    } else if (response.statusCode >= 400 && response.statusCode <= 417) {
        // 状态400~417，提示“非法请求”
        innerError = [EPNetworkError badRuqestError:error];
        
    } else if (response.statusCode >= 500 && response.statusCode <= 505) {
        innerError = [EPNetworkError serverUnavailableError:error];
    } else {
        // 其他网络错误
        if (!response) {
            innerError = [self buildInternalErrorWithOriginalError:error
                    ];
        } else {
            innerError = [EPNetworkError unKnownError:error];
        }
        
    }
    return innerError;
}

- (void)handleSuccess:(EPNetworkCompletionBlock)success
             withTask:(NSURLSessionDataTask *)task
          decodeClass:(Class)decodeClass
       responseObject:(id)responseObject
           parameters:(NSDictionary *)parameters
{
    if (success) {
        
        // 1. 检查常规的http状态码
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        EPNetworkError *error = [self checkResponseError:response];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(task.currentRequest, nil, error);
            });
            return;
        }
        
        // 2. 组装业务数据
        EPNetworkResponse *networkResponse = nil;
        if (responseObject) { // 部分接口不规范，没有返回response
            networkResponse = [[EPNetworkResponse alloc] initWithContent:responseObject response:task.response modelClass:decodeClass];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(task.currentRequest, networkResponse, nil);
        });
        
    }
}

- (EPNetworkError *)checkResponseError:(NSHTTPURLResponse *)response
{
    EPNetworkError *error = nil;
    // 检查状态码
    if (response.statusCode == 200 || response.statusCode == 304) {
        return nil;
    } else {
        NSString *message = [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode];
        if (message.length > 0) {
            error = [EPNetworkError errorWithMessage:message originalError:nil];
        }
    }
    
    return error;
}


// 处理未返回response时的错误
- (EPNetworkError *)buildInternalErrorWithOriginalError:(NSError *)error
{
    EPNetworkError *err = nil;
    if ([self isConnectionError:error]) {
        if (error.code == NSURLErrorTimedOut) {
            err = [EPNetworkError timeoutError:error];
            
        } else {
            err = [EPNetworkError internetNotConnectedError:error];
        }
    } else if (error.code == NSURLErrorCancelled) {
        err = [EPNetworkError requestCancelledError:error];
        
    } else {
        err = [EPNetworkError internetNotConnectedError:error];
    }
    return err;
}

// 是否网络连通性错误
- (BOOL)isConnectionError:(NSError *)error
{
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        if (error.code == NSURLErrorTimedOut ||
            error.code == NSURLErrorCannotFindHost ||
            error.code == NSURLErrorCannotConnectToHost ||
            error.code == NSURLErrorNetworkConnectionLost ||
            error.code == NSURLErrorDNSLookupFailed ||
            error.code == NSURLErrorNotConnectedToInternet) {
            return YES;
        }
    }
    return NO;
}


@end


@implementation EPNetworkError (ZXSDService)

+ (instancetype)sessionInvalidError:(NSError *)originalError
{
    return [self errorWithMessage:@"" code:EPNetworkErrorTypeSessionInvalid originalError:originalError];
}

@end
