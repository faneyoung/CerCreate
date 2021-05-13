//
//  EPNetworkError.m
//  Anne
//
//  Created by chrislos on 2017/4/5.
//  Copyright © 2017年 joindata. All rights reserved.
//

#import "EPNetworkError.h"

NSString* const kEPNetworkErrorDomain = @"com.eparty.network";

NSString* const KEPNetworkErrorUnKnownDescription = @"未知错误";
NSString* const KEPNetworkErrorTimeOutDescription = @"服务不给力，请稍后再试";
NSString* const KEPNetworkErrorBadRequestDescription = @"请求格式错误";
NSString* const KEPNetworkErrorHostNotConnectDescription = @"服务器连接异常";
NSString* const KEPNetworkErrorInternetNotConnectDescription = @"网络连接异常，请检查后再试";
NSString* const KEPNetworkErrorServerUnavailableDescription = @"服务异常，请稍后再试";

NSString* const KEPNetworkErrorRequestCancelledDescription = @"请求取消";

@implementation EPNetworkError

+ (instancetype)unKnownError:(NSError *)originalError
{
    return [self errorWithMessage:KEPNetworkErrorUnKnownDescription code:EPNetworkErrorTypeUnKnown originalError:originalError];
}

+ (instancetype)timeoutError:(NSError *)originalError
{
    return [self errorWithMessage:KEPNetworkErrorTimeOutDescription code:EPNetworkErrorTypeTimeOut originalError:originalError];
}

+ (instancetype)badRuqestError:(NSError *)originalError
{
    return [self errorWithMessage:KEPNetworkErrorBadRequestDescription code:EPNetworkErrorTypeBadRequest originalError:originalError];
}

+ (instancetype)hostNotConnectedError:(NSError *)originalError
{
    return [self errorWithMessage:KEPNetworkErrorHostNotConnectDescription code:EPNetworkErrorTypeCannotConnectToHost originalError:originalError];
}

+ (instancetype)internetNotConnectedError:(NSError *)originalError
{
    return [self errorWithMessage:KEPNetworkErrorInternetNotConnectDescription code:EPNetworkErrorTypeCannotConnectToInternet originalError:originalError];
}

+ (instancetype)serverUnavailableError:(NSError *)originalError
{
    return [self errorWithMessage:KEPNetworkErrorServerUnavailableDescription code:EPNetworkErrorTypeServerUnavailable originalError:originalError];
}

+ (instancetype)requestCancelledError:(NSError *)originalError
{
    return [self errorWithMessage:KEPNetworkErrorRequestCancelledDescription code:EPNetworkErrorTypeCancelled originalError:originalError];
}

+ (instancetype)errorWithMessage:(NSString *)message
                   originalError:(NSError *)error
{
    return [self errorWithMessage:message code:EPNetworkErrorTypeUnKnown originalError:error];
}

+ (instancetype)errorWithMessage:(NSString *)message
                            code:(NSInteger)code
                   originalError:(NSError *)error
{
    NSString *failedURLString = [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey];
    return [self errorWithDomain:kEPNetworkErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: message ? : [NSString stringWithFormat:@"%ld", (long) code],NSURLErrorFailingURLStringErrorKey: failedURLString ?:@""}];
}

+ (instancetype)errorWithMessage:(NSString *)message
                            code:(NSInteger)code
                       failedURL:(NSString *)failedURL
{
    
    return [self errorWithDomain:kEPNetworkErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: message ? : [NSString stringWithFormat:@"%ld", (long) code],NSURLErrorFailingURLStringErrorKey: failedURL ?:@""}];
}


- (NSString *)errorMessage
{
    return self.userInfo[NSLocalizedDescriptionKey];
}

- (BOOL)isBadNetwork
{
    if (self.code == EPNetworkErrorTypeCannotConnectToHost || self.code == EPNetworkErrorTypeCannotConnectToInternet || self.code == EPNetworkErrorTypeTimeOut) {
        return YES;
    }
    return NO;
}

@end
