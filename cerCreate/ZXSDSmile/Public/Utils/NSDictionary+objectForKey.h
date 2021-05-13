//
//  NSDictionary+objectForKey.h
//  ShiHui
//
//  Created by Fane on 2018/11/21.
//  Copyright © 2018 ShiHui. All rights reserved.
//
//该分类是为了解决[NSDictionary objectForKey]类型检查问题.

#import <Foundation/Foundation.h>

@interface NSDictionary (objectForKey)

- (NSString*)stringObjectForKey:(id)aKey;
- (int)intValueForKey:(id)aKey;
- (float)floatValueForKey:(id)aKey;
- (double)doubleValueForKey:(id)aKey;
- (long) longValueForKey:(id) aKey;
- (BOOL)boolValueForKey:(id)aKey;
- (long long) longLongValueForKey:(id) aKey;
- (unsigned long long) unsignedLongLongValueForKey:(id) aKey;
- (NSUInteger)unsignedIntegerValueForKey:(id) aKey;

- (NSArray*)arrayObjectForKey:(id)aKey;
- (NSDictionary*)dictionaryObjectForKey:(id)aKey;

- (id)myObjectForKey:(id)aKey;

///默认返回@“”
- (NSString*)stringDefaultObjectForKey:(id)aKey;

@end


/**
 *  根据多个key获取对象
 *  试用于服务器返回的同一字段命名不同的情况，如：
 *  activityId 可能有多种命名：activityId、activityID、activity_id、id
 */
@interface NSDictionary (objectForKeys)

- (NSString*)stringObjectForKeys:(id)keys;
- (int)intValueForKeys:(id)keys;


@end
