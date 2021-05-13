//
//  NSMutableDictionary+SafeSetter.m
//  FlowManage
//
//  Created by Fane on 2017/6/18.
//  Copyright © 2017年 Fane. All rights reserved.
//

#import "NSMutableDictionary+SafeSetter.h"

@implementation NSMutableDictionary (SafeSetter)

- (void)setSafeValue:(id)value forKey:(NSString*)key{
    
    if(value != nil && key != nil)
    {
        [self setValue:value forKey:key];
    }

}

- (void)setSafeObject:(id)object forKey:(NSString*)key
{
    if(object == nil || (NSNull*)object == [NSNull null])
    {
        [self setValue:@"" forKey:key];
    } else {
        [self setValue:object forKey:key];
    }
}

- (void)setSafeValue:(id)value withDefault:(id)defaultForUnsafeValue forKey:(NSString*)key{
    NSParameterAssert(defaultForUnsafeValue);
    
    if (key != nil) {
        [self setValue:value ? value : defaultForUnsafeValue forKey:key];
    }
}

@end
