//
//  NSMutableDictionary+SafeSetter.h
//  FlowManage
//
//  Created by Fane on 2017/6/18.
//  Copyright © 2017年 Fane. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @category NSMutableDictionary (SafeSetter)
 @brief safelly set key with value for mutableDictionary
 */

@interface NSMutableDictionary (SafeSetter)

- (void)setSafeValue:(id)value forKey:(NSString*)key;

- (void)setSafeObject:(id)object forKey:(NSString*)key;

- (void)setSafeValue:(id)value withDefault:(id)defaultForUnsafeValue forKey:(NSString*)key;

@end
