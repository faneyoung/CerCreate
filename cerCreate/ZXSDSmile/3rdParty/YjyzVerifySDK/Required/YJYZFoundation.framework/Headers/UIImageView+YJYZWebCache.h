//
//  UIImageView+YJYZFWebCache.h
//  YJYZFoundation
//
//  Created by wukx on 2018/6/6.
//  Copyright © 2018年 YJYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YJYZFWebCache)

- (void)yjyzf_setImageWithURL:(nullable NSURL *)url;

- (void)yjyzf_setImageWithURL:(nullable NSURL *)url
            placeholderImage:(nullable UIImage *)placeholder;

@end
