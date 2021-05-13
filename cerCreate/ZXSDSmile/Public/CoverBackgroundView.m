//
//  SHCoverBackgroundView.m
//  ShiHui
//
//  Created by Fane on 2018/3/8.
//  Copyright © 2018年 HZMC. All rights reserved.
//

#import "CoverBackgroundView.h"

#define CoverBackgroundViewTag      459324
#define CoverBgViewTag              459224
#define CoverContentViewTag         459325

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight     [UIScreen mainScreen].bounds.size.height

@interface CoverBackgroundView ()


@end

@implementation CoverBackgroundView


+ (instancetype)instanceCoverBackgroundViewWithSubView:(UIView*)subView mode:(CoverViewShowMode)showMode{

  return [CoverBackgroundView instanceWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) subView:subView mode:showMode];
}


+ (instancetype)instanceWithFrame:(CGRect)frame subView:(UIView*)subView mode:(CoverViewShowMode)showMode{
    CoverBackgroundView *coverBackgroundView = [[CoverBackgroundView alloc] initWithFrame:frame];
    coverBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    coverBackgroundView.tag = CoverBackgroundViewTag;
    [[UIApplication sharedApplication].keyWindow addSubview:coverBackgroundView];
    
    coverBackgroundView.showMode = showMode;
    [coverBackgroundView setupSubView:subView];
    
    UIButton *bgControl = [[UIButton alloc] initWithFrame:coverBackgroundView.bounds];
    [coverBackgroundView addSubview:bgControl];
    [bgControl addTarget:coverBackgroundView action:@selector(bgViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [coverBackgroundView sendSubviewToBack:bgControl];
    coverBackgroundView.bgViewUserEnable = YES;
    [coverBackgroundView actionBtn:bgControl];
    return coverBackgroundView;

}

- (void)actionBtn:(UIButton*)btn{
    self.bgBtn = btn;
}

+ (instancetype)instanceWithContentView:(UIView*)contentView mode:(CoverViewShowMode)showMode {
    CoverBackgroundView *coverBackgroundView = [[CoverBackgroundView alloc] init];
    coverBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    coverBackgroundView.tag = CoverBackgroundViewTag;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:coverBackgroundView];
    [coverBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(keyWindow);
    }];
    
    coverBackgroundView.showMode = showMode;
    [coverBackgroundView setupSubView:contentView window:keyWindow];

    return coverBackgroundView;

}

- (void)setupSubView:(UIView*)subView window:(UIWindow*)window{

    subView.tag = CoverContentViewTag;
    [self addSubview:subView];

    if (self.showMode == CoverViewShowModeCenter) {
        CGRect rect = subView.frame;
        CGFloat margin = (ScreenWidth - rect.size.width)/2;
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(window);
            make.left.right.mas_equalTo(window).inset(margin);
            make.height.mas_equalTo(rect.size.height);
        }];
        
        [UIView animateWithDuration:0.1 animations:^{
            subView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                subView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
            }];
        }];
    }
    else if (self.showMode == CoverViewShowModeBottom){
        CGSize bgSize = self.bounds.size;
        CGRect rect = subView.frame;
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(window.mas_bottom).offset(bgSize.height);
            make.centerX.mas_equalTo(window);
            make.width.mas_equalTo(rect.size.width);
            make.height.mas_equalTo(rect.size.height);
        }];
        [self layoutIfNeeded];

        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = subView.frame;
            rect.origin.y = bgSize.height - rect.size.height;
            
            [subView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(window.mas_bottom).inset(rect.origin.y);
            }];
            [self layoutIfNeeded];
        }];
    }
    else if (self.showMode == CoverViewShowModeBlur){
        
    }
    
    self.contentview = subView;

    UIButton *bgControl = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:bgControl];
    [bgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
    [bgControl addTarget:self action:@selector(bgViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self sendSubviewToBack:bgControl];
    self.bgBtn = bgControl;
    self.bgViewUserEnable = YES;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.tag = CoverBgViewTag;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
    self.bgView = bgView;
    [self sendSubviewToBack:self.bgView];
    
    
}

- (void)contentViewHeight:(CGFloat)height{
    if (self.showMode == CoverViewShowModeBottom) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.contentview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            [self.contentview layoutIfNeeded];
            [self layoutIfNeeded];
        }];
    }
    else if (self.showMode == CoverViewShowModeCenter){
        [UIView animateWithDuration:0.2 animations:^{
            [self.contentview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            [self.contentview layoutIfNeeded];
            [self layoutIfNeeded];
        }];

    }
}

#pragma mark - views -
- (void)setupSubView:(UIView*)subView{
    subView.tag = CoverContentViewTag;
    [self addSubview:subView];

    if (self.showMode == CoverViewShowModeCenter) {
        subView.center = self.center;
        
        [UIView animateWithDuration:0.1 animations:^{
            subView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                subView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
            }];
        }];
    }
    else if (self.showMode == CoverViewShowModeBottom){
        CGSize bgSize = self.bounds.size;
        subView.frame = CGRectMake((ScreenWidth-subView.bounds.size.width)/2, bgSize.height, subView.bounds.size.width, subView.bounds.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = subView.frame;
            rect.origin.y = bgSize.height - rect.size.height;
            subView.frame = rect;
        }];
    }


}

#pragma mark - action methods -

- (void)bgViewAction:(id)sender{
    if(self.bgViewUserEnable){
        [self hide];
    }
}

#pragma mark - help methods -
+ (BOOL)isShow{
    CoverBackgroundView *coverBgView = [[UIApplication sharedApplication].keyWindow viewWithTag:CoverBackgroundViewTag];
    UIView *cBgView = [[UIApplication sharedApplication].keyWindow viewWithTag:CoverBgViewTag];
    
    UIView *contentView = [coverBgView viewWithTag:CoverContentViewTag];

    if (contentView) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (void)hide{
    CoverBackgroundView *coverBgView = [[UIApplication sharedApplication].keyWindow viewWithTag:CoverBackgroundViewTag];
    UIView *cBgView = [[UIApplication sharedApplication].keyWindow viewWithTag:CoverBgViewTag];
    
    UIView *contentView = [coverBgView viewWithTag:CoverContentViewTag];
    CGRect rect = contentView.frame;
    rect.origin.y = ScreenHeight;
    
    if (coverBgView.showMode == CoverViewShowModeBottom) {
        [UIView animateWithDuration:0.2 animations:^{
            coverBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
            contentView.frame = rect;
        } completion:^(BOOL finished) {
            [coverBgView removeFromSuperview];
            [cBgView removeFromSuperview];
        }];
    }
    else{
        [coverBgView removeFromSuperview];
        [cBgView removeFromSuperview];
        
    }
}
- (void)hide{
    UIView *coverBgView = [[UIApplication sharedApplication].keyWindow viewWithTag:CoverBackgroundViewTag];
    UIView *cBgView = [[UIApplication sharedApplication].keyWindow viewWithTag:CoverBgViewTag];

    UIView *contentView = [coverBgView viewWithTag:CoverContentViewTag];
    CGRect rect = contentView.frame;
    rect.origin.y = ScreenHeight;

    if (self.showMode == CoverViewShowModeBottom) {
        [UIView animateWithDuration:0.2 animations:^{
            coverBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
            contentView.frame = rect;
        } completion:^(BOOL finished) {
            [coverBgView removeFromSuperview];
            [cBgView removeFromSuperview];
        }];
    }
    else{
        [coverBgView removeFromSuperview];
        [cBgView removeFromSuperview];

    }
    
}

#pragma mark - instance -

+ (instancetype)instanceWithContentView:(UIView*)contentView mode:(CoverViewShowMode)showMode cancelPrevious:(BOOL)cancelPre viewMake:(void(^)(MASConstraintMaker *))block{
    
    if (cancelPre) {
        [CoverBackgroundView hide];
    }

    return [CoverBackgroundView instanceWithTargetView:nil contentView:contentView mode:showMode viewMake:block];
}

+ (instancetype)instanceWithContentView:(UIView*)contentView mode:(CoverViewShowMode)showMode viewMake:(void(^)(MASConstraintMaker *))block{

    return [CoverBackgroundView instanceWithTargetView:nil contentView:contentView mode:showMode viewMake:block];
}

+ (instancetype)instanceWithTargetView:(UIView*)tView contentView:(UIView*)contentView mode:(CoverViewShowMode)showMode viewMake:(void(^)(MASConstraintMaker *))block{
    CoverBackgroundView *coverBackgroundView = [[CoverBackgroundView alloc] init];
    coverBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    coverBackgroundView.tag = CoverBackgroundViewTag;
    
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (tView) {
        keyWindow = tView;
    }
    [keyWindow addSubview:coverBackgroundView];
    [coverBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(keyWindow);
    }];
    
    coverBackgroundView.showMode = showMode;
    coverBackgroundView.coverBgview = coverBackgroundView;
    [coverBackgroundView setupSubView:contentView window:keyWindow viewMake:block ];

    return coverBackgroundView;
}


- (void)setupSubView:(UIView*)subView window:(UIView *)window viewMake:(void(^)(MASConstraintMaker *))block{

    subView.tag = CoverContentViewTag;
    [self addSubview:subView];
    [subView mas_makeConstraints:block];
    [subView layoutIfNeeded];

    if (self.showMode == CoverViewShowModeCenter) {
        [subView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
        }];
        [subView layoutIfNeeded];
        
        [UIView animateWithDuration:0.1 animations:^{
            subView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                subView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
            }];
        }];
    }
    else if (self.showMode == CoverViewShowModeBottom){

        [subView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(subView.bounds.size.height);
        }];
        [self layoutIfNeeded];

        [UIView animateWithDuration:0.2 animations:^{
            
            [subView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(0);
            }];
            [self layoutIfNeeded];
        }];
    }
    else if (self.showMode == CoverViewShowModeBlur){
        
    }
    
    self.contentview = subView;

    UIButton *bgControl = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:bgControl];
    [bgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
    [bgControl addTarget:self action:@selector(bgViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self sendSubviewToBack:bgControl];
    self.bgBtn = bgControl;
    self.bgViewUserEnable = YES;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.tag = CoverBgViewTag;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
    self.bgView = bgView;
    [self sendSubviewToBack:self.bgView];
    
    
}

@end




