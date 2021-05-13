//
//  IYJYZFPlugin.h
//  YJYZFoundation
//
//  Created by fenghj on 15/6/2.
//  Copyright (c) 2015年 YJYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  插件协议
 */
@protocol IYJYZFPlugin <NSObject>

@required

/**
 *  插件加载时调用
 *
 *  @param key 插件标识
 */
- (void)load:(NSString *)key;

/**
 *  插件卸载时调用
 */
- (void)unload;

@end
