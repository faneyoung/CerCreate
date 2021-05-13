//
//  UIBarButtonItem+Convince.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "UIBarButtonItem+Convince.h"

@implementation UIBarButtonItem (Convince)

#pragma mark - 图片按钮
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image
{
    return [self itemWithTarget:target action:action image:image imageEdgeInsets:UIEdgeInsetsZero];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image templateMode:(BOOL)templateMode
{
    return [self itemWithTarget:target action:action image:image imageEdgeInsets:UIEdgeInsetsZero frame:ZXSD_BARBUTTON_ITEM_FRAME templateMode:templateMode];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
    return [self itemWithTarget:target action:action image:image imageEdgeInsets:imageEdgeInsets frame:ZXSD_BARBUTTON_ITEM_FRAME templateMode:YES];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                              image:(UIImage *)normalImage
                    imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                              frame:(CGRect)frame
                       templateMode:(BOOL)templateMode

{
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:[nomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (higeLightedImage) {
        [button setImage:higeLightedImage forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    if (button.bounds.size.width < 40) {
        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 40);
    }
    if (button.bounds.size.height > 40) {
        CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
        button.bounds = CGRectMake(0, 0, 40, height);
    }
    button.imageEdgeInsets = imageEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];*/
    /*
    UIButton *wBarBtn = [[UIButton alloc] init];
    wBarBtn.frame = frame;
    
    if (templateMode) {
        if (normalImage && normalImage.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
    
    [wBarBtn setImage:normalImage forState:UIControlStateNormal];
    [wBarBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * wBarItem = [[UIBarButtonItem alloc] initWithCustomView:wBarBtn];
    return wBarItem;*/
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStylePlain target:target action:action];
    return item;
}


#pragma mark - 文字按钮
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    return [self itemWithTarget:target action:action title:title font:nil titleColor:nil highlightedColor:nil titleEdgeInsets:UIEdgeInsetsZero];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    return [self itemWithTarget:target action:action title:title font:nil titleColor:nil highlightedColor:nil titleEdgeInsets:titleEdgeInsets];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                              title:(NSString *)title
                               font:(UIFont *)font
                         titleColor:(UIColor *)titleColor
                   highlightedColor:(UIColor *)highlightedColor
                    titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:titleColor?titleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor?highlightedColor:nil forState:UIControlStateHighlighted];
    
    [button sizeToFit];
    if (button.bounds.size.width < 40) {
        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 40);
    }
    if (button.bounds.size.height > 40) {
        CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
        button.bounds = CGRectMake(0, 0, 40, height);
    }
    button.titleEdgeInsets = titleEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 占位按钮
+ (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width
{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}


@end
