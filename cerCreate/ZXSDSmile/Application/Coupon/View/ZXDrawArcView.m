//
//  ZXDrawArcView.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/16.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXDrawArcView.h"
#import "UIView+help.h"

@interface ZXDrawArcView ()
//虚线距view顶部的距离
@property (nonatomic, assign) CGFloat topMargin;
//中间两个小半圆的半径
@property (nonatomic, assign) CGFloat radius;

@end

@implementation ZXDrawArcView


- (void)drawRect:(CGRect)rect {
    
    _topMargin = 71.f;
    _radius = 6.f;

    CGFloat viewWidth = rect.size.width;
    CGFloat viewHieght = rect.size.height;
    
    //获取绘图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //绘制整体背景
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, viewWidth, 0);
    CGContextAddLineToPoint(ctx, viewWidth, self.topMargin);
    
    //CG_EXTERN void CGContextAddArc(Context, CGFloat x, CGFloat y,CGFloat radius, CGFloat startAngle,CGFloat endAngle, int clockwise)

    CGContextAddArc(ctx, viewWidth, self.topMargin, self.radius, 2*M_PI, -M_PI_2, 1);
    CGContextAddLineToPoint(ctx, viewWidth, viewHieght);
    CGContextAddLineToPoint(ctx, 0, viewHieght);
    CGContextAddLineToPoint(ctx, 0, self.topMargin);
    CGContextAddArc(ctx, 0, self.topMargin, self.radius, 2.5*M_PI, M_PI, 1);
    CGContextAddLineToPoint(ctx, 0, 0);
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(_radius, _topMargin, viewWidth-2*_radius, 1);
    [self addSubview:line];

    [line drawLineOfDashByCAShapeLayerLineLength:4 lineSpacing:5 lineColor:UIColorFromHex(0xEAEFF2) lineDirection:YES];

    
}


@end
