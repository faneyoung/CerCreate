//
//  NSObject+ZXHelp.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "NSObject+ZXHelp.h"

@implementation NSObject (ZXHelp)
- (NSString *)modelToJSONString {
    NSData *jsonData = [self yy_modelToJSONData];
    if (jsonData.length == 0) return nil;
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
