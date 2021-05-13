//
//  ZXLocationManager.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXLocationManager : NSObject

@property (nonatomic, strong) NSDictionary *locationDic;

+ (instancetype)sharedManger;

- (void)requestLocationAuth;

- (void)startLocationWithSuccessBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
