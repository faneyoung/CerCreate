//
//  UILabel+Addition.m
//  NavDemo
//
//  Created by chrislos Chen on 2017/12/13.
//  Copyright © 2017年 Chrislos. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

+ (instancetype)sepLab{
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 1);
    lab.backgroundColor = kThemeColorLine;
    return lab;
}

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment {
    UILabel *label = [UILabel new];
    label.textAlignment = alignment;
    return label;
}

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor {
    UILabel *label = [UILabel labelWithAlignment:alignment];
    label.textColor = textColor;
    return label;
}

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = [UILabel labelWithAlignment:alignment textColor:textColor];
    label.font = font;
    return label;
}

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font text:(NSString *)text {
    UILabel *label = [UILabel labelWithAlignment:alignment textColor:textColor font:font];
    label.text = text;
    return label;
}

+ (UILabel *)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines {
    UILabel *label = [UILabel labelWithAlignment:alignment textColor:textColor font:font];
    label.numberOfLines = lines;
    return label;
}

+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines text:(NSString *)text {
    UILabel *label = [UILabel labelWithAlignment:alignment textColor:textColor font:font lines:lines];
    label.text = text;
    return label;
}

+ (instancetype)labelWithText:(NSString*)text textColor:(UIColor *)textColor font:(UIFont *)font{
    
    UILabel *label = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:textColor font:font];
    label.text = text;
    
    return label;
}

+ (NSMutableAttributedString *)renderText:(NSString *)text lineHeight:(CGFloat)heigit lineSpace:(CGFloat)space
{
    NSMutableAttributedString *modified = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.maximumLineHeight = heigit;
    style.minimumLineHeight = heigit;
    style.lineSpacing = space;
    
    [modified addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    return modified;
    
}
@end
