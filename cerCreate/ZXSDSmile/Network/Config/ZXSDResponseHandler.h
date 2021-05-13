//
//  ZXSDResponseHandler.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/28.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPNetworkConfig.h"
#import "EPNetworkError.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDResponseHandler : NSObject <EPResponseHandler>

+ (instancetype)sharedResponseHandler;

@end

@interface EPNetworkError (ZXSDService)

+ (instancetype)sessionInvalidError:(NSError *)originalError;

@end

NS_ASSUME_NONNULL_END
