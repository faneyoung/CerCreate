//
//  NSDictionary+objectForKey.m
//  LanShan
//
//  Created by Fane on 2018/11/21.
//  Copyright © 2018 ShiHui. All rights reserved.
//

#import "NSDictionary+objectForKey.h"

@implementation NSDictionary (objectForKey)

- (NSString*)stringObjectForKey:(id)aKey {
    id object = [self myObjectForKey:aKey];
    if (object == [NSNull null]) {
        return  nil;
    }

    return [object description];
}

- (NSString*)stringDefaultObjectForKey:(id)aKey{
    
    id object = [self myObjectForKey:aKey];
    if (object == [NSNull null]) {
        return  @"";
    }
    
    if(!object){
        return @"";
    }
    
    return [object description];

    
}

- (int)intValueForKey:(id)aKey {
    id object = [self myObjectForKey:aKey];
    if (object == [NSNull null])
    {
        return  0;
    }
    if ([object respondsToSelector:@selector(intValue)]) {
        return [object intValue];
    }
    return 0;
    
}
- (float)floatValueForKey:(id)aKey {
    id object = [self myObjectForKey:aKey];
    if (object == [NSNull null]) {
        return  0;
    }
    if ([object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    }
    return 0;
}

- (double)doubleValueForKey:(id)aKey {
    id object = [self myObjectForKey:aKey];
    
    if (object == [NSNull null]) {
        return  0;
    }
    
    if ([object respondsToSelector:@selector(doubleValue)]) {
        return [object doubleValue];
    }
    return 0;
}

-(long) longValueForKey:(id) aKey
{
    id object = [self myObjectForKey:aKey];
    if (object == [NSNull null]) {
        return  0;
    }
    
    if ([object respondsToSelector:@selector(longValue)]) {
        return [object longValue];
    } else if ([object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    }
    return 0;
}

-(long long) longLongValueForKey:(id) aKey
{
    id object = [self myObjectForKey:aKey];
    
    if (object == [NSNull null]) {
        return  0;
    }
    
    
    if ([object respondsToSelector:@selector(longLongValue)]) {
        return [object longLongValue];
    }
    return 0;
}

-(unsigned long long) unsignedLongLongValueForKey:(id) aKey
{
    id object = [self myObjectForKey:aKey];
    
    if (object == [NSNull null]) {
        return  0;
    }
    
    if ([object respondsToSelector:@selector(unsignedLongLongValue)]) {
        return [object unsignedLongLongValue];
    }
    return 0;
}

- (BOOL)boolValueForKey:(id)aKey {
    id object = [self myObjectForKey:aKey];
    
    if (object == [NSNull null]) {
        return  0;
    }
    if ([object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    }
    return 0;
}

- (NSArray*)arrayObjectForKey:(id)aKey {
    id object = [self myObjectForKey:aKey];
    if (![object isKindOfClass:[NSArray class]]) {
        return  nil;
    }
    return object;
}

- (NSDictionary*)dictionaryObjectForKey:(id)aKey {
    id object = [self myObjectForKey:aKey];
    if ([object isKindOfClass:[NSString class]]) {
        NSString* str = (NSString*)object;
        NSError *error;
       object = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    }
    if (![object isKindOfClass:[NSDictionary class]]) {
        return  nil;
    }
    return object;
}

-(NSUInteger)unsignedIntegerValueForKey:(id) aKey
{
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(unsignedIntegerValue)]) {
        return [object unsignedIntegerValue];
    }
    return 0;
}

- (id)myObjectForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if (object == [NSNull null]) {
        return nil;
    }
    return object;
}

@end



@implementation NSDictionary (objectForKeys)

- (NSString*)stringObjectForKeys:(id)keys {
    for (NSString *key in keys) {
        NSString *ret = [self stringObjectForKey:key];
        if (ret) {
            return ret;
        }
    }
    return nil;
}


- (int)intValueForKeys:(id)keys {
    for (NSString *key in keys) {
        int ret = [self intValueForKey:key];
        if (ret) {
            return ret;
        }
    }
    return 0;
}




@end



