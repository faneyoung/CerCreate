//
//  ZXSDBankCardCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/22.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBankCardCell.h"
#import "ZXSDBankCardModel.h"

@interface ZXSDBankCardCell ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *bankIcon;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *cardNumberLabel;
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UIImageView *rightIcon;
@end

@implementation ZXSDBankCardCell

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDBankCardItem class]]) {
        return;
    }
    ZXSDBankCardItem *model = renderData;
    NSDictionary *config = [model UIConfig];
    
    
    self.container.backgroundColor = UICOLOR_FROM_HEX([config[@"color"] integerValue]);
    self.rightIcon.image = [UIImage imageNamed:config[@"icon"]];
    
    [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:model.bankIcon]];
    self.bankNameLabel.text = model.bankName;
    
    self.cardNumberLabel.text = [self formatBankCardNumber:model.number];
    
    
//    NSString *value = [NSString stringWithFormat:@"%@", model.reservePhone];
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:value];
//    [attr addAttributes:@{NSFontAttributeName:FONT_PINGFANG_X(14)} range:NSMakeRange(6, value.length - 6)];
    self.phoneLabel.text = GetStrDefault(model.reservePhone, @"");
    
}

- (NSString *)formatBankCardNumber:(NSString *)number
{
    
    if (!IsValidString(number)) {
        return @"";
    }
    
    NSMutableString *result = [NSMutableString stringWithString:@""];
    /*
    for (int k = 0; k < number.length; k++) {
        if (k > 0 && k % 4 == 0) {
            [result insertString:@"#" atIndex:k+(k/4 - 1)];
        }
    }
    
    [result replaceOccurrencesOfString:@"#" withString:@"  " options:(NSLiteralSearch) range:NSMakeRange(0, result.length)];
     */
    
    [result appendString:@"****  ****  ****  "];
    NSString *last = [number substringWithRange:NSMakeRange(number.length - 4, 4)];
    [result appendString:last];
    
    
    if (result.length >= 8) {
        return [result substringWithnumber:10 reverse:YES];
    }
    
    return result;
}


- (void)initView
{
    self.contentView.backgroundColor = kThemeColorLine;
    
    UIView *container = [[UIView alloc] init];
    container.layer.cornerRadius = 8;
    container.backgroundColor = UICOLOR_FROM_HEX(0xF36353);
    [self.contentView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(20);
        make.height.mas_equalTo(120);
        make.bottom.inset(0);
    }];
    self.container = container;
    
    UIView *head = [UIView new];
    head.layer.cornerRadius = 18;
    head.backgroundColor = [UIColor whiteColor];
    [container addSubview:head];
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(container).offset(16);
        make.width.height.mas_equalTo(36);
    }];
    
    [head addSubview:self.bankIcon];
    [self.bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.center.equalTo(head);
    }];
    
    [container addSubview:self.bankNameLabel];
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.mas_right).offset(12);
        make.centerY.equalTo(head);
    }];
    
    [container addSubview:self.rightIcon];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container);
        make.centerY.equalTo(container);
    }];
    
    [container addSubview:self.cardNumberLabel];
    [self.cardNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(head);
        make.right.inset(20);
    }];
    
    UILabel *phoneTitleLab = [UILabel labelWithText:@"预留手机号:" textColor:UIColor.whiteColor font:FONT_PINGFANG_X(12)];
    [container addSubview:phoneTitleLab];
    [phoneTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(head.mas_bottom).inset(13);
        make.left.mas_equalTo(head);
        make.height.mas_equalTo(17);
    }];
    
    [container addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneTitleLab);
        make.top.equalTo(phoneTitleLab.mas_bottom).inset(4);
        make.height.mas_equalTo(16);

    }];
    
    
    [container addSubview:self.actionBtn];
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.phoneLabel);
    }];
}

- (void)actionButtonClicked
{
    if (self.mainCardAction) {
        self.mainCardAction();
    }
}

- (void)setMainCard:(BOOL)mainCard
{
    self.actionBtn.selected = mainCard;
//    self.actionBtn.userInteractionEnabled = !mainCard;
    
    // 企业用户不能修改默认卡
    if (self.isSmile) {
        
        if (mainCard) {
            self.actionBtn.hidden = NO;
        } else {
            self.actionBtn.hidden = YES;
        }
        
    } else {
        self.actionBtn.hidden = NO;
    }
    
}


- (UIImageView *)bankIcon
{
    if (!_bankIcon) {
        _bankIcon = [UIImageView new];
        _bankIcon.contentMode =  UIViewContentModeScaleAspectFit;
    }
    return _bankIcon;
}

- (UIImageView *)rightIcon
{
    if (!_rightIcon) {
        _rightIcon = [UIImageView new];
        _rightIcon.contentMode =  UIViewContentModeScaleAspectFit;
    }
    return _rightIcon;
}

- (UILabel *)bankNameLabel
{
    if (!_bankNameLabel) {
        _bankNameLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xFFFFFF) font:FONT_PINGFANG_X(14)];
    }
    return _bankNameLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel labelWithText:@"" textColor:UIColor.whiteColor font:FONT_PINGFANG_X(14)];
    }
    return _phoneLabel;
}

- (UILabel *)cardNumberLabel
{
    if (!_cardNumberLabel) {
        _cardNumberLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xFFFFFF) font:FONT_SFUI_X_Medium(18)];
        _cardNumberLabel.textAlignment = NSTextAlignmentRight;
        _cardNumberLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _cardNumberLabel;
}

- (UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionBtn = [UIButton buttonWithFont:FONT_PINGFANG_X_Medium(14) title:@"其他银行卡" textColor:UIColor.whiteColor];
//        [_actionBtn setTitleColor:kThemeColorMain forState:UIControlStateSelected];
        [_actionBtn setTitle:@"工资卡" forState:UIControlStateSelected];
        
        [_actionBtn setImage:[UIImage imageNamed:@"icon_white_sel_N"] forState:(UIControlStateNormal)];
        [_actionBtn setImage:[UIImage imageNamed:@"icon_white_sel_H"] forState:(UIControlStateSelected)];
        
        [_actionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        [_actionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 95, 0, 0)];
        [_actionBtn addTarget:self action:@selector(actionButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
        _actionBtn.userInteractionEnabled = NO;
    }
    return _actionBtn;
}

@end
