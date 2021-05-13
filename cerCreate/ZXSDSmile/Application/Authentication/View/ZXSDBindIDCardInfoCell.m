//
//  ZXSDBindIDCardInfoCell.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/20.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBindIDCardInfoCell.h"

@implementation ZXSDBindIDCardInfoCell

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.startButton];
    [self.contentView addSubview:self.endButton];
    [self.contentView addSubview:self.lineView];
    
    CGFloat topGap = iPhone4() || iPhone5() ? 7 : 15;
    CGFloat buttonWidth = (SCREEN_WIDTH() - 95 - 20 - 20)/2;
    self.titleLabel.frame = CGRectMake(20, topGap, 65, 30);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(100);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.endButton.mas_left).offset(-16);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(2);
    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineView.mas_left).offset(-20);
        make.top.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    
}

- (void)setCanChoice:(BOOL)canChoice
{
    _canChoice = canChoice;
    if (self.canChoice) {
        self.textField.hidden = YES;
        self.startButton.hidden = NO;
        self.endButton.hidden = NO;
        self.lineView.hidden = NO;
    
    } else {
        self.textField.hidden = NO;
        self.startButton.hidden = YES;
        self.endButton.hidden = YES;
        self.lineView.hidden = YES;

    }
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    /*
    CGFloat topGap = iPhone4() || iPhone5() ? 7 : 15;
    CGFloat buttonWidth = (SCREEN_WIDTH() - 95 - 20 - 20)/2;
    self.titleLabel.frame = CGRectMake(20, topGap, 65, 30);
    if (iPhone4() || iPhone5()) {
        self.textField.frame = CGRectMake(106, topGap, SCREEN_WIDTH() - 106 - 20, 30);
    } else {
        
        
        if (iPhone8() || iPhoneX()) {
            self.textField.frame = CGRectMake(117, topGap, SCREEN_WIDTH() - 117 - 20, 30);
        } else {
            self.textField.frame = CGRectMake(128, topGap, SCREEN_WIDTH() - 128 - 20, 30);
        }
    }
    
    self.startButton.frame = CGRectMake(95, topGap, buttonWidth, 30);
    self.endButton.frame = CGRectMake(95 + buttonWidth + 20, topGap, buttonWidth, 30);
    self.lineView.frame = CGRectMake(95 + buttonWidth, (self.frame.size.height - 2)/2, 20, 2);
    
    if (self.canChoice) {
        self.textField.hidden = YES;
        self.startButton.hidden = NO;
        self.endButton.hidden = NO;
        self.lineView.hidden = NO;
    } else {
        self.textField.hidden = NO;
        self.startButton.hidden = YES;
        self.endButton.hidden = YES;
        self.lineView.hidden = YES;
    }*/
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = UICOLOR_FROM_HEX(0x626F8A);
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.font = FONT_PINGFANG_X(14);
    }
    return _textField;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.backgroundColor = [UIColor clearColor];
        [_startButton setTitleColor:UICOLOR_FROM_HEX(0x626F8A) forState:UIControlStateNormal];
        _startButton.titleLabel.font = FONT_SFUI_X_Regular(14);
        _startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _startButton;
}

- (UIButton *)endButton {
    if (!_endButton) {
        _endButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _endButton.backgroundColor = [UIColor clearColor];
        [_endButton setTitleColor:UICOLOR_FROM_HEX(0x626F8A) forState:UIControlStateNormal];
        _endButton.titleLabel.font = FONT_SFUI_X_Regular(14);
        _endButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _endButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UICOLOR_FROM_HEX(0x999999);
    }
    
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
