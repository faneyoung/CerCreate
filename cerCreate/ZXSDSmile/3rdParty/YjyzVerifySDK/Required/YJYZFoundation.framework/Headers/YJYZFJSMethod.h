//
//  YJYZFJSMethod.h
//  YJYZFoundation
//
//  Created by 冯 鸿杰 on 15/2/27.
//  Copyright (c) 2015年 YJYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJYZFJSTypeDefine.h"

/**
 *  JS方法
 */
@interface YJYZFJSMethod : NSObject

/**
 *  方法名称
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  方法实现
 */
@property (nonatomic, strong, readonly) YJYZFJSMethodIMP imp;

/**
 *  初始化方法
 *
 *  @param name 方法名称
 *  @param imp  方法实现
 *
 *  @return 方法对象
 */
- (id)initWithName:(NSString *)name imp:(YJYZFJSMethodIMP)imp;

@end
