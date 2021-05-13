//
//  ZXSDSmileUUID.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDSmileUUID : NSObject

+ (id)sharedInsance;

- (NSString *)getUUID;

@end

NS_ASSUME_NONNULL_END
