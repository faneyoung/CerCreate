//
//  UIButton+Addition.m
//  NWDBase
//
//  Created by chrislos Chen on 2018/4/19.
//  Copyright © 2018年 qmwang. All rights reserved.
//

#import "UIButton+Addition.h"

@implementation UIButton (Addition)

+ (instancetype)buttonWithFont:(UIFont *)font title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    return button;
}

+ (instancetype)buttonWithFont:(UIFont *)font title:(NSString *)title textColor:(UIColor *)color {
    UIButton *button = [UIButton buttonWithFont:font title:title];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

+ (instancetype)buttonWithFont:(UIFont *)font title:(NSString *)title textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor {
    UIButton *button = [UIButton buttonWithFont:font title:title textColor:color];
    [button setBackgroundImage:[ZXSDPublicClassMethod initImageFromColor:bgColor Size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    return button;
}

+ (instancetype)buttonWithFont:(UIFont *)font title:(NSString *)title textColor:(UIColor *)color cornerRadius:(CGFloat)radius {
    UIButton *button = [UIButton buttonWithFont:font title:title textColor:color];
    button.layer.cornerRadius = radius;
    return button;
}

+ (instancetype)buttonWithNormalImage:(UIImage *)normalImg highlightedImage:(UIImage *)highlightedImg {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImg forState:UIControlStateNormal];
    if (highlightedImg) {
        [button setImage:highlightedImg forState:UIControlStateHighlighted];
    } else {
        [button setImage:normalImg forState:UIControlStateHighlighted];
    }
    
    return button;
}


- (void)updateTarget:(id)target action:(SEL)aSel forControlEvents:(UIControlEvents)event{
    
    [self removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self addTarget:target action:aSel forControlEvents:event];
}


@end
