//
//  NSArray+Helper.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Helper)

+ (instancetype)safty_arrayWithArray:(NSObject *)array;

- (id)safty_objectAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
