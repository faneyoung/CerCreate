//
//  SHCoverBackgroundView.h
//  ShiHui
//
//  Created by Fane on 2018/3/8.
//  Copyright © 2018年 HZMC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CoverViewShowModeCenter,
    CoverViewShowModeBottom,
    CoverViewShowModeBlur,
} CoverViewShowMode;

@interface CoverBackgroundView : UIView

/// 显示前是否取消前面的弹窗
@property (nonatomic, assign) BOOL cancelPrevious;

///背景是否可交互
@property (nonatomic, assign) BOOL bgViewUserEnable;
@property (nonatomic, assign) CoverViewShowMode showMode;
@property (nonatomic, strong) CoverBackgroundView *coverBgview;

@property (nonatomic, strong) UIView *bgView;
@property(nonatomic,strong) UIButton *bgBtn;

@property (nonatomic, strong) UIView *contentview;


///约束布局
/// @param contentView      contentView  size必须要设置
/// @param showMode     showMode
+ (instancetype)instanceWithContentView:(UIView*)contentView mode:(CoverViewShowMode)showMode;

/// 约束布局
/// @param contentView contentView
/// @param showMode showMode
/// @param block contentView的约束，显示到正常位置的约束
+ (instancetype)instanceWithContentView:(UIView*)contentView mode:(CoverViewShowMode)showMode viewMake:(void(^)(MASConstraintMaker *))block;
/// @param tView contentView的父view
+ (instancetype)instanceWithTargetView:(UIView*)tView contentView:(UIView*)contentView mode:(CoverViewShowMode)showMode viewMake:(void(^)(MASConstraintMaker *))block;

+ (instancetype)instanceWithContentView:(UIView*)contentView mode:(CoverViewShowMode)showMode cancelPrevious:(BOOL)cancelPre viewMake:(void(^)(MASConstraintMaker *))block;

/// 更新contentView的高度，必须用上面的方法初始化的才可以
/// @param height 新高度
- (void)contentViewHeight:(CGFloat)height;


///frame布局
+ (instancetype)instanceCoverBackgroundViewWithSubView:(UIView*)subView mode:(CoverViewShowMode)showMode;

/// frame布局
/// @param frame  cover的frame
/// @param subView subView，要有frame
/// @param showMode showMode 
+ (instancetype)instanceWithFrame:(CGRect)frame subView:(UIView*)subView mode:(CoverViewShowMode)showMode;


///dismiss 
- (void)hide;

+ (void)hide;


/// 是否正在显示
+ (BOOL)isShow;

@end
