//
//  YJYZFImageCachePolicy.h
//  YJYZFoundation
//
//  Created by yjyz on 2017/4/12.
//  Copyright © 2017年 YJYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJYZFImageServiceTypeDef.h"

@interface YJYZFImageCachePolicy : NSObject

/**
 缓存名称，用于对不同的图片缓存划分到不同的缓存路径中，如果名称相同则缓存位置相同。
 */
@property (nonatomic, copy) NSString *cacheName;

/**
 缓存处理回调，当有图片需要进行缓存时会先调用该方法
 */
@property (nonatomic, strong) YJYZFImageGetterCacheHandler cacheHandler;

/**
 获取默认的缓存策略

 @return 缓存策略
 */
+ (instancetype)defaultCachePolicy;

@end
