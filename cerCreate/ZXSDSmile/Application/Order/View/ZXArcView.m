//
//  ZXArcView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/16.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXArcView.h"

@interface ZXArcView ()

@end

@implementation ZXArcView

- (void)drawRect:(CGRect)rect {
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHieght = rect.size.height;
    
    //获取绘图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //绘制整体背景
    CGContextMoveToPoint(ctx, 0, 0);
    
    CGContextAddLineToPoint(ctx, viewWidth, 0);
    
    CGContextAddLineToPoint(ctx, viewWidth, self.topMargin);
    
    //CG_EXTERN void CGContextAddArc(Context, CGFloat x, CGFloat y,CGFloat radius, CGFloat startAngle,CGFloat endAngle, int clockwise)

    CGContextAddArc(ctx, viewWidth, self.topMargin+self.radius, self.radius, 2*M_PI, -M_PI_2, 1);
    CGContextAddLineToPoint(ctx, viewWidth, viewHieght);
    CGContextAddLineToPoint(ctx, 0, viewHieght);
    CGContextAddArc(ctx, 0, self.topMargin+self.radius, self.radius, 2.5*M_PI, M_PI, 1);
    CGContextAddLineToPoint(ctx, 0, self.topMargin);
    CGContextAddLineToPoint(ctx, 0, 0);
    
    UIColor *fColor = self.fillColor ?: UIColor.whiteColor;
    CGContextSetFillColorWithColor(ctx, fColor.CGColor);
    CGContextFillPath(ctx);
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(_radius+self.lineMargin, self.topMargin+self.radius, viewWidth - 2*self.radius-2*self.lineMargin, 1);
    [self addSubview:line];

    [line drawLineOfDashByCAShapeLayerLineLength:4 lineSpacing:0 lineColor:kThemeColorBg lineDirection:YES];

}

- (void)setTopMargin:(CGFloat)topMargin{
    _topMargin = topMargin;
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setLineMargin:(CGFloat)lineMargin{
    _lineMargin = lineMargin;
    [self setNeedsDisplay];
}

@end
