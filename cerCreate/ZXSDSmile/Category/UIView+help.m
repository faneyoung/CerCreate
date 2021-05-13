//
//  UIView+help.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/16.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "UIView+help.h"

#define kShadowViewTag 21327860
#define kValidDirections [NSArray arrayWithObjects: @"top", @"bottom", @"left", @"right",nil]

@implementation UIView (help)

/**
  *  圆角设置
 **/
- (void)addRoundedCornerWithRadius:(CGFloat)radius corners:(UIRectCorner)corners{
    if (radius <= 0) {
        return;
    }

    self.layer.mask = nil;
    [self layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;

    });
    
}

#pragma mark - help -

/**
 *  通过 CAShapeLayer 方式绘制虚线
 **/
- (void)drawLineOfDashByCAShapeLayerLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    
    UIView *lineView = self;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];

    [shapeLayer setBounds:lineView.bounds];

    if (isHorizonal) {

        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];

    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }

    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {

        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);

    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }

    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (void)removeAllSubviews{
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

#pragma mark - shadow setting -
- (void)makeInsetShadow{
    
    NSArray *shadowDirections = [NSArray arrayWithObjects:@"top", @"bottom", @"left" , @"right" , nil];
    UIColor *color = [UIColor colorWithRed:(0.0) green:(0.0) blue:(0.0) alpha:0.5];
    
    UIView *shadowView = [self createShadowViewWithRadius:3 Color:color Directions:shadowDirections];
    shadowView.tag = kShadowViewTag;
    
    [self addSubview:shadowView];
}

- (void)makeInsetShadowWithRadius:(float)radius Alpha:(float)alpha{
    
    NSArray *shadowDirections = @[@"top", @"bottom", @"left" , @"right"];
    UIColor *color = [UIColor colorWithRed:(0.0) green:(0.0) blue:(0.0) alpha:alpha];
    
    UIView *shadowView = [self createShadowViewWithRadius:radius Color:color Directions:shadowDirections];
    shadowView.tag = kShadowViewTag;
    
    [self addSubview:shadowView];
}

- (void)makeInsetShadowWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions {
    
    UIView *shadowView = [self createShadowViewWithRadius:radius Color:color Directions:directions];
    shadowView.tag = kShadowViewTag;
    
    [self addSubview:shadowView];
}

- (UIView *)createShadowViewWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions {
    
    [self layoutIfNeeded];
    
   __block UIView *shadowView = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        shadowView.backgroundColor = [UIColor clearColor];
        
        // Ignore duplicate direction
        NSMutableDictionary *directionDict = [[NSMutableDictionary alloc] init];
        for (NSString *direction in directions) [directionDict setObject:@"1" forKey:direction];
        
        for (NSString *direction in directionDict) {
            // Ignore invalid direction
            if ([kValidDirections containsObject:direction])
            {
                CAGradientLayer *shadow = [CAGradientLayer layer];
                
                if ([direction isEqualToString:@"top"]) {
                    [shadow setStartPoint:CGPointMake(0.5, 0.0)];
                    [shadow setEndPoint:CGPointMake(0.5, 1.0)];
                    shadow.frame = CGRectMake(0, 0, self.bounds.size.width, radius);
                }
                else if ([direction isEqualToString:@"bottom"])
                {
                    [shadow setStartPoint:CGPointMake(0.5, 1.0)];
                    [shadow setEndPoint:CGPointMake(0.5, 0.0)];
                    shadow.frame = CGRectMake(0, self.bounds.size.height - radius, self.bounds.size.width, radius);
                } else if ([direction isEqualToString:@"left"])
                {
                    shadow.frame = CGRectMake(0, 0, radius, self.bounds.size.height);
                    [shadow setStartPoint:CGPointMake(0.0, 0.5)];
                    [shadow setEndPoint:CGPointMake(1.0, 0.5)];
                } else if ([direction isEqualToString:@"right"])
                {
                    shadow.frame = CGRectMake(self.bounds.size.width - radius, 0, radius, self.bounds.size.height);
                    [shadow setStartPoint:CGPointMake(1.0, 0.5)];
                    [shadow setEndPoint:CGPointMake(0.0, 0.5)];
                }
                
                shadow.colors = [NSArray arrayWithObjects:(id)[color CGColor], (id)[[UIColor clearColor] CGColor], nil];
                [shadowView.layer insertSublayer:shadow atIndex:0];
            }
        }

    });
    
    
    return shadowView;
}

- (void)homeCardShadowSetting{
    CALayer *shadowLayer = self.layer;
    shadowLayer.cornerRadius = 4;
    shadowLayer.shadowColor = [UIColor colorWithWhite:0 alpha:0.15].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(1,1);
    shadowLayer.shadowRadius = 4;
    shadowLayer.shadowOpacity = 0.45;
    shadowLayer.masksToBounds = NO;
}

///阴影同时圆角
- (void)addShadowOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
{
     //shadow 
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = self.layer.frame;
    
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(0, 2);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
     //cornerRadius
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [self.superview.layer insertSublayer:shadowLayer below:self.layer];
}

@end
