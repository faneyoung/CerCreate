//
//  NSMutableArray+Helper.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "NSMutableArray+Helper.h"

@implementation NSMutableArray (Helper)

- (void)insertOrReplaceObject:(id)object AtIndex:(NSUInteger)index {
    id originObject = [self safty_objectAtIndex:index];
    if (originObject) {
        [self replaceObjectAtIndex:index withObject:object];
    } else {
        [self insertObject:object atIndex:index];
    }
}

- (void)addSafeObject:(id)anObject{
    if (!anObject) {
        return;
    }
    
    if ([anObject isKindOfClass:NSNull.class]) {
        return;
    }
    
    [self addObject:anObject];
}

@end
