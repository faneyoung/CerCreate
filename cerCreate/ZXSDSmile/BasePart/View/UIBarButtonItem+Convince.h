//
//  UIBarButtonItem+Convince.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Convince)

#pragma mark - 图片按钮
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image;

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image templateMode:(BOOL)templateMode;

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;

+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                              image:(UIImage *)nomalImage
                    imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                              frame:(CGRect)frame
                       templateMode:(BOOL)templateMode;


#pragma mark - 文字按钮
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title;

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets;

+ (UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                  highlightedColor:(UIColor *)highlightedColor
                   titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets;

#pragma mark - 占位按钮
+ (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width;


@end

