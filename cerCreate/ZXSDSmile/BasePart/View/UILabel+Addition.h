//
//  UILabel+Addition.h
//  NavDemo
//
//  Created by chrislos Chen on 2017/12/13.
//  Copyright © 2017年 Chrislos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Addition)

/// 分割线
+ (instancetype)sepLab;

/**
 *  @brief  根据label对齐参数创建label
 *
 *  @param alignment alignment description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment;

/**
 *  @brief  根据label对齐，字体颜色参数创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                         textColor:(UIColor *)textColor;

/**
 *  @brief  根据label对齐，字体颜色，字体参数创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *  @param font      font description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font;

/**
 *  @brief  根据label对齐，字体颜色，字体，文字参数创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *  @param font      font description
 *  @param text      text description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                              text:(NSString *)text;

/**
 *  @brief  根据label对齐，字体颜色，字体，行数创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *  @param font      font description
 *  @param lines     lines description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                             lines:(NSInteger)lines;

/**
 *  @brief  根据label对齐，字体颜色，字体，行数，文字创建label
 *
 *  @param alignment alignment description
 *  @param textColor textColor description
 *  @param font      font description
 *  @param lines     lines description
 *  @param text      text description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithAlignment:(NSTextAlignment)alignment
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                             lines:(NSInteger)lines
                              text:(NSString *)text;

/**
 *  @brief 字体颜色，字体，行数，文字创建label
 *
 *  @param textColor textColor description
 *  @param font      font description
 *  @param text      text description
 *
 *  @return UILabel
 */
+ (instancetype)labelWithText:(NSString*)text textColor:(UIColor *)textColor font:(UIFont *)font;


/**
 *  @brief 渲染指定文本的行高和行距
 *
 *  @param text      原始文本
 *  @param heigit    行高
 *  @param space     行间距
 *
 *  @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)renderText:(NSString *)text lineHeight:(CGFloat)heigit lineSpace:(CGFloat)space;


@end
