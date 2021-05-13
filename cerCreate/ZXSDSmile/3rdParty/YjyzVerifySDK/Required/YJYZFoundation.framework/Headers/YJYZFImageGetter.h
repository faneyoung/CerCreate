//
//  YJYZFImageGetter.h
//  YJYZFoundation
//
//  Created by fenghj on 16/1/21.
//  Copyright © 2016年 YJYZ. All rights reserved.
//

#import "YJYZFImageObserver.h"
#import "YJYZFImageServiceTypeDef.h"
#import <Foundation/Foundation.h>

@class YJYZFImageCachePolicy;

/**
 *  图片获取器
 */
@interface YJYZFImageGetter : NSObject

/**
 *  获取共享图片服务实例
 *
 *  @return 图片服务实例
 */
+ (instancetype)sharedInstance;

/**
 初始化图片服务实例

 @param cachePolicy 缓存策略
 @return 图片服务实例
 */
- (instancetype)initWithCachePolicy:(YJYZFImageCachePolicy *)cachePolicy;

/**
 *  是否存在图片缓存
 *
 *  @param url 图片URL
 *
 *  @return YES 表示图片已缓存，NO 图片未缓存
 */
- (BOOL)existsImageCacheWithURL:(NSURL *)url;

/**
 *  获取图片
 *
 *  @param url           图片路径
 *  @param resultHandler 返回事件
 *
 *  @return 服务观察者
 */
- (YJYZFImageObserver *)getImageWithURL:(NSURL *)url
                                result:(YJYZFImageGetterResultHandler)resultHandler;


/**
 *  获取图片
 *
 *  @param url            图片路径
 *  @param allowReadCache 是否允许读取缓存
 *  @param resultHandler  返回事件
 *
 *  @return 服务观察者
 */
- (YJYZFImageObserver *)getImageWithURL:(NSURL *)url
                        allowReadCache:(BOOL)allowReadCache
                                result:(YJYZFImageGetterResultHandler)resultHandler;

/**
 获取图片数据

 @param url           图片路径
 @param resultHandler 返回事件

 @return 服务观察者
 */
- (YJYZFImageObserver *)getImageDataWithURL:(NSURL *)url
                                    result:(YJYZFImageDataGetterResultHandler)resultHandler;

/**
 获取图片数据
 
 @param url            图片路径
 @param allowReadCache 是否允许读取缓存
 @param resultHandler  返回事件
 
 @return 服务观察者
 */
- (YJYZFImageObserver *)getImageDataWithURL:(NSURL *)url
                            allowReadCache:(BOOL)allowReadCache
                                    result:(YJYZFImageDataGetterResultHandler)resultHandler;

/**
 *  移除图片观察者
 *
 *  @param imageObserver 图片观察者
 */
- (void)removeImageObserver:(YJYZFImageObserver *)imageObserver;

/**
 *  删除磁盘中缓存中图片
 *
 *  @param url 图片地址
 */
- (void)removeImageForURL:(nullable NSURL *)url;

/**
 *  删除当前缓存策略下磁盘目录中所有图片
 *
 */
- (void)clearDisk;

@end
