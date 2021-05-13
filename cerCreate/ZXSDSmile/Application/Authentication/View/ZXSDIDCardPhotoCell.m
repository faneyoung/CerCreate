//
//  ZXSDIDCardPhotoCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDIDCardPhotoCell.h"

@interface ZXSDIDCardPhotoCell ()

@end

@implementation ZXSDIDCardPhotoCell

+ (CGFloat)height
{
    return iPhone4() || iPhone5() ? 160 : 200;
}

- (void)initView
{
    CGFloat idCardViewHeight = iPhone4() || iPhone5() ? 140 : 180;
    
    UIView *cardView = [UIView new];
    cardView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(idCardViewHeight);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    CGFloat imageWidth = iPhone4() || iPhone5() ? 111 : 148;
    CGFloat imageHeight = iPhone4() || iPhone5() ? 72 : 96;
    
    [cardView addSubview:self.backImageView];
    [cardView addSubview:self.frontImageView];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.top.equalTo(cardView).offset(40);
        make.width.mas_equalTo(imageWidth);
        make.height.mas_equalTo(imageHeight);
    }];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prepareTakePhoto:)];
    [self.backImageView addGestureRecognizer:backTap];
    
    [self.frontImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-20);
        make.top.equalTo(cardView).offset(40);
        make.width.mas_equalTo(imageWidth);
        make.height.mas_equalTo(imageHeight);
    }];
    UITapGestureRecognizer *frontTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prepareTakePhoto:)];
    [self.frontImageView addGestureRecognizer:frontTap];
    
    UILabel *backDesLabel = [UILabel labelWithText:@"拍摄人像面" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    backDesLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:backDesLabel];
    [backDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backImageView);
        make.top.equalTo(self.backImageView.mas_bottom).offset(5);
    }];
    
    [cardView addSubview:self.backStatusLabel];
    [self.backStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backImageView);
        make.top.equalTo(backDesLabel.mas_bottom).offset(5);
    }];
    
    
    UILabel *frontDesLabel = [UILabel labelWithText:@"拍摄国徽面" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    frontDesLabel.textAlignment = NSTextAlignmentCenter;
    
    [cardView addSubview:frontDesLabel];
    [frontDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.frontImageView);
        make.top.equalTo(self.frontImageView.mas_bottom).offset(5);
    }];
    
    [cardView addSubview:self.frontStatuslabel];
    [self.frontStatuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.frontImageView);
        make.top.equalTo(frontDesLabel.mas_bottom).offset(5);
    }];
    
}

- (void)prepareTakePhoto:(UITapGestureRecognizer *)gesture
{
    NSInteger currentTag = [gesture view].tag;
    if (self.takePhotoAction) {
        self.takePhotoAction(currentTag);
    }
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_idcard_back")];
        _backImageView.contentMode = UIViewContentModeScaleToFill;
        _backImageView.userInteractionEnabled = YES;
        _backImageView.tag = 1000;
    }
    return _backImageView;
}

- (UIImageView *)frontImageView
{
    if (!_frontImageView) {
        _frontImageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_idcard_front")];
        _frontImageView.contentMode = UIViewContentModeScaleToFill;
        _frontImageView.userInteractionEnabled = YES;
        _frontImageView.tag = 2000;
    }
    return _frontImageView;
}

- (UILabel *)backStatusLabel
{
    if (!_backStatusLabel) {
        UIFont *statusFont = iPhone4() || iPhone5() ? FONT_PINGFANG_X(10) : FONT_PINGFANG_X(12);
        
        _backStatusLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:statusFont];
        _backStatusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _backStatusLabel;
}

- (UILabel *)frontStatuslabel
{
    if (!_frontStatuslabel) {
        UIFont *statusFont = iPhone4() || iPhone5() ? FONT_PINGFANG_X(10) : FONT_PINGFANG_X(12);
        
        _frontStatuslabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:statusFont];
        _frontStatuslabel.textAlignment = NSTextAlignmentCenter;
    }
    return _frontStatuslabel;
}

@end
