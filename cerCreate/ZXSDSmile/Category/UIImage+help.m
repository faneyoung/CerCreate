//
//  UIImage+help.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "UIImage+help.h"
#import <UIImage+YYAdd.h>

@implementation UIImage (help)

///渐变色图片
- (UIImage*)gradientImageWithColors:(NSArray*)colors direction:(UIImageGradientDirection)direc{
    if (!IsValidArray(colors)) {
        return [UIImage imageWithColor:UIColor.whiteColor];
    }
    
    if (colors.count < 2) {
        return [UIImage imageWithColor:colors.firstObject];
    }
    
    return [UIImage resizableImageWithGradient:colors direction:direc];
}

- (UIImage*)imageByResizeToSize:(CGSize)size{
    return [self imageByResizeToSize:size];
}

@end
