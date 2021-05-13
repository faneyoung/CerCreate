//
//  ZXSDVerifyInputCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDVerifyInputCell.h"

@interface ZXSDVerifyInputCell ()

@property (nonatomic, strong) UILabel *keyLabel;

@end

@implementation ZXSDVerifyInputCell

- (void)initView
{
    [self.contentView addSubview:self.keyLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.sendButton];
    
    [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(16);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.keyLabel.mas_bottom).offset(16);
        make.bottom.equalTo(self.contentView).offset(-16);
        make.right.equalTo(self.contentView).offset(-120);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.textField);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    
    
}

- (void)setRenderData:(id)renderData
{
    self.keyLabel.text = renderData;
}

- (UILabel *)keyLabel
{
    if (!_keyLabel) {
        _keyLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    }
    return _keyLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = UICOLOR_FROM_HEX(0x626F8A);
        _textField.font = FONT_SFUI_X_Medium(16);
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.placeholder = @"请输入";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.backgroundColor = [UIColor clearColor];
        _sendButton.titleLabel.font = FONT_PINGFANG_X(14);
        [_sendButton setTitleColor:kThemeColorMain forState:UIControlStateNormal];
        [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        //[_sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendButton;
}


@end
