//
//  UIView+help.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/16.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (help)


/// 圆角设置
/// @param radius radius
/// @param corners corners 
- (void)addRoundedCornerWithRadius:(CGFloat)radius corners:(UIRectCorner)corners;

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayerLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

- (void)removeAllSubviews;

///shadow setting
- (void)makeInsetShadowWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions;

- (void)homeCardShadowSetting;



///阴影&&圆角
/// @param shadowOpacity 阴影透明度
/// @param shadowRadius 阴影半径
/// @param cornerRadius 圆角半径
- (void)addShadowOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius;
@end

NS_ASSUME_NONNULL_END
