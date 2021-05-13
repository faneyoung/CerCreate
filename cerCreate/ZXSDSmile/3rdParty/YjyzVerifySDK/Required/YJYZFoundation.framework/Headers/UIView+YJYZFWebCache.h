//
//  UIView+YJYZFWebCache.h
//  YJYZFoundation
//
//  Created by wukx on 2018/6/6.
//  Copyright © 2018年 YJYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYZFSetImageBlock)(UIImage * _Nullable image, NSError *error);

@interface UIView (YJYZFWebCache)

- (void)yjyzf_internalSetImageWithURL:(nullable NSURL *)url
                       setImageBlock:(nullable YJYZFSetImageBlock)setImageBlock;

@end
