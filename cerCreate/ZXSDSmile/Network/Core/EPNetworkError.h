//
//  EPNetworkError.h
//  Anne
//
//  Created by chrislos on 2017/4/5.
//  Copyright © 2017年 joindata. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kEPNetworkErrorDomain;

typedef NS_ENUM(NSInteger, EPNetworkErrorTypes) {
    EPNetworkErrorTypeUnKnown = 1,
    EPNetworkErrorTypeTimeOut = 2,
    EPNetworkErrorTypeCannotConnectToHost = 3,
    EPNetworkErrorTypeCannotConnectToInternet = 4,
    EPNetworkErrorTypeServerUnavailable = 5,
    EPNetworkErrorTypeBadRequest = 6,
    EPNetworkErrorTypeCancelled = 7,
    EPNetworkErrorTypeSessionInvalid = 8

};

@interface EPNetworkError : NSError

+ (instancetype)unKnownError:(NSError *)originalError;

+ (instancetype)timeoutError:(NSError *)originalError;

+ (instancetype)badRuqestError:(NSError *)originalError;

+ (instancetype)hostNotConnectedError:(NSError *)originalError;

+ (instancetype)internetNotConnectedError:(NSError *)originalError;

+ (instancetype)serverUnavailableError:(NSError *)originalError;

+ (instancetype)requestCancelledError:(NSError *)originalError;

+ (instancetype)errorWithMessage:(NSString *)message originalError:(NSError *)error;

+ (instancetype)errorWithMessage:(NSString *)message code:(NSInteger)code originalError:(NSError *)error;

+ (instancetype)errorWithMessage:(NSString *)message code:(NSInteger)code failedURL:(NSString *)failedURL;

- (NSString *)errorMessage;

- (BOOL)isBadNetwork;

@end
