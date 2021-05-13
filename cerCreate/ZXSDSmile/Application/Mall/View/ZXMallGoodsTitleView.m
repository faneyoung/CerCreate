//
//  ZXMallGoodsTitleView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/14.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMallGoodsTitleView.h"

@interface ZXMallGoodsTitleView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CAShapeLayer *shadowLayer;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation ZXMallGoodsTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kThemeColorBg;
        
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = kThemeColorBg;
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(16);
            make.top.bottom.inset(0);
        }];
        
        CGRect rect = UIEdgeInsetsInsetRect(self.containerView.bounds, UIEdgeInsetsMake(5, 0, 0, 0));

        CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
        normalLayer.frame = rect;
        normalLayer.backgroundColor = UIColor.whiteColor.CGColor;
        
        
        self.containerView = containerView;
        [self.containerView.layer insertSublayer:normalLayer atIndex:0];
        self.shadowLayer = normalLayer;
        
        _titleLab = [UILabel labelWithText:@"优选好物" textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(17)];
        [containerView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(16);
            make.top.inset(5);
            make.bottom.inset(0);
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //刷新shadowLayer的frame
    CGRect rect = UIEdgeInsetsInsetRect(self.containerView.bounds, UIEdgeInsetsMake(5, 0, 0, 0));
    self.shadowLayer.frame = rect;
    
    // 圆角角度
    CGFloat radius = 4.f;
    
    UIBezierPath *bezierPath = nil;
    // 每组最后一行（添加左下和右下的圆角）
    bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    
    self.shadowLayer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    self.shadowLayer.shadowOpacity = 0.2;
    self.shadowLayer.shadowOffset = CGSizeMake(0, -5);
    self.shadowLayer.path = bezierPath.CGPath;
    self.shadowLayer.shadowPath = bezierPath.CGPath;
    self.shadowLayer.cornerRadius = radius;
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    self.shadowLayer.path = bezierPath.CGPath;
    self.shadowLayer.fillColor = UIColor.whiteColor.CGColor;

    
    
}

@end
