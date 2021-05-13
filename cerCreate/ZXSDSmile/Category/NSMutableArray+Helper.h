//
//  NSMutableArray+Helper.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Helper)

- (void)insertOrReplaceObject:(id)object AtIndex:(NSUInteger)index;

- (void)addSafeObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
