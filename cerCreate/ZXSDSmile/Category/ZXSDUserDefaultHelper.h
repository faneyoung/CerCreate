//
//  ZXSDUserDefaultHelper.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDUserDefaultHelper : NSObject

/**
 *  <#Description#>
 *
 *  @param value <#value description#>
 *  @param key   <#key description#>
 */
+ (void)storeValueIntoUserDefault:(id __nullable)value forKey:(NSString *)key;
/**
 *  <#Description#>
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
+ (id)readValueForKey:(NSString *)key;
/**
 *  <#Description#>
 *
 *  @param key <#key description#>
 */
+ (void)removeObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
