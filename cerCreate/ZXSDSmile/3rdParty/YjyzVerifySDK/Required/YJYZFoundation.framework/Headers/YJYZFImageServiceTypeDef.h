//
//  YJYZFImageServiceTypeDef.h
//  YJYZFoundation
//
//  Created by fenghj on 15/6/8.
//  Copyright (c) 2015年 YJYZ. All rights reserved.
//

#ifndef YJYZFoundation_YJYZFImageServiceTypeDef_h
#define YJYZFoundation_YJYZFImageServiceTypeDef_h

#import <UIKit/UIKit.h>


/**
 图片缓存处理
 
 @param imageData 图片的数据
 */
typedef NSData* (^YJYZFImageGetterCacheHandler)(NSData *imageData);

/**
 *  图片加载返回
 *
 *  @param image 图片对象
 *  @param error 错误信息
 */
typedef void (^YJYZFImageGetterResultHandler)(UIImage *image, NSError *error);

/**
 *  图片加载返回
 *
 *  @param imageData 图片数据
 *  @param error 错误信息
 */
typedef void (^YJYZFImageDataGetterResultHandler)(NSData *imageData, NSError *error);

#endif
