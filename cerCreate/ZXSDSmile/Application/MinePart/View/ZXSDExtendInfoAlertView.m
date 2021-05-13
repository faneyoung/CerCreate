//
//  ZXSDExtendInfoAlertView.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDExtendInfoAlertView.h"

@interface ZXSDExtendInfoAlertView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *leftDateLab;
@property (nonatomic, strong) UILabel *rightDateLab;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, weak) UIView *container;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation ZXSDExtendInfoAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUserInterfaceConfigure];
    }
    return self;
}

- (void)configDate:(NSString *)oldDate freshDate:(NSString *)freshDate
{
    self.leftDateLab.text = oldDate;
    self.rightDateLab.text = freshDate;
}

- (void)showInView:(UIView *)container
{
    if (!container) {
        return;
    }
    self.container = container;
    
    UIView *maskView = [[UIView alloc] initWithFrame:container.bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [container addSubview:maskView];
    self.maskView = maskView;
    
    [container addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(container);
        make.width.mas_equalTo(296);
        make.height.mas_equalTo(194);
    }];
}

- (void)confirmButtonClicked
{
    //[self.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.maskView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)addUserInterfaceConfigure
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12.0;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.leftDateLab];
    [self addSubview:self.rightDateLab];
    [self addSubview:self.confirmButton];
    
    self.titleLab = [UILabel labelWithText:@"展期扣款日变更" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(20)];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
    }];
    
    UIImageView *transfer = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_transfer_icon")];
    [self addSubview:transfer];
    [transfer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLab.mas_bottom).offset(26);
    }];
    
    [self.leftDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(transfer.mas_left).offset(-10);
        make.centerY.equalTo(transfer);
    }];
    
    [self.rightDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(transfer.mas_right).offset(10);
        make.centerY.equalTo(transfer);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self).offset(-20);
    }];
}

- (UILabel *)leftDateLab
{
    if (!_leftDateLab) {
        _leftDateLab = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(14)];
        _leftDateLab.textAlignment = NSTextAlignmentCenter;
    }
    return _leftDateLab;
}

- (UILabel *)rightDateLab
{
    if (!_rightDateLab) {
        _rightDateLab = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(14)];
        _rightDateLab.textAlignment = NSTextAlignmentCenter;
    }
    return _rightDateLab;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        
        [_confirmButton setTitle:@"知道了" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
        
    }
    return _confirmButton;
}

@end
