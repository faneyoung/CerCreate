//
//  NSDictionary+Helper.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)

+ (instancetype)safty_dictionaryWithDictionary:(NSObject *)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        return [self dictionaryWithDictionary:(NSDictionary *)dictionary];
    } else {
        return [self dictionary];
    }
}

- (id)safty_objectForKey:(NSString *)key {
    id object = [self objectForKey:key];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
