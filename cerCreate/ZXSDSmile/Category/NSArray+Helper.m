//
//  NSArray+Helper.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "NSArray+Helper.h"

@implementation NSArray (Helper)

+ (instancetype)safty_arrayWithArray:(NSObject *)array {
    if ([array isKindOfClass:[NSArray class]]) {
        return [self arrayWithArray:(NSArray *)array];
    } else {
        return [self array];
    }
}

- (id)safty_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [[self objectAtIndex:index] isEqual:[NSNull null]] ? nil : [self objectAtIndex:index];
    }
    return nil;
}

@end
