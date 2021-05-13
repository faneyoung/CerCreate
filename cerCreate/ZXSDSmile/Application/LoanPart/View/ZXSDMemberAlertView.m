//
//  ZXSDMemberAlertView.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDMemberAlertView.h"

@interface ZXSDMemberAlertView ()

@property (nonatomic, strong) NSArray<NSString *> *rules;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *rule1;
@property (nonatomic, strong) UILabel *rule2;
@property (nonatomic, strong) UILabel *rule3;
@property (nonatomic, strong) UILabel *rule4;

@end

@implementation ZXSDMemberAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUserInterfaceConfigure];
    }
    return self;
}

- (void)configWithType:(NSInteger)type
{
    if (type == 0) {
        self.titleLab.text = @"薪朋友";
        self.rule1.text = @"1.未开通“创世薪朋友”无法享受预支工资的专属服务；";
        self.rule2.text = @"2.开通后，首月享受最高 ¥500 的预支额度；";
        self.rule3.text = @"3.首月正常还款后，次月之后即可享受 ¥1000 的预支额度。";
        
        NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:self.rule2.text];
        [attr2 setAttributes:@{NSForegroundColorAttributeName:kThemeColorMain} range:NSMakeRange(13, 4)];
        self.rule2.attributedText = attr2;
        
        NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc] initWithString:self.rule3.text];
        [attr3 setAttributes:@{NSForegroundColorAttributeName:kThemeColorMain} range:NSMakeRange(19, 5)];
        self.rule3.attributedText = attr3;
        
        [self.rule4 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        [self.confirmButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rule3.mas_bottom).offset(40);
        }];
        
    } else {
        self.titleLab.text = @"薪朋友+";
        self.rule1.text = @"1.“薪朋友+”是合作雇主的员工；";
        self.rule2.text = @"2.可以免费享受最高 ¥500 预支额度；";
        self.rule3.text = @"3.开通“创世薪朋友”后，可以最高享受   ¥2000 的预支额度；";
        self.rule4.text = @"4.所有的用户，当月最多只能预支一次。";
        
        NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:self.rule2.text];
        [attr2 setAttributes:@{NSForegroundColorAttributeName:kThemeColorMain} range:NSMakeRange(11, 4)];
        self.rule2.attributedText = attr2;
        
        NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc] initWithString:self.rule3.text];
        [attr3 setAttributes:@{NSForegroundColorAttributeName:kThemeColorMain} range:NSMakeRange(22, 5)];
        self.rule3.attributedText = attr3;
    }
}

- (void)confirmButtonClicked
{
    if (self.confirmAction) {
        self.confirmAction();
    }
}

- (void)addUserInterfaceConfigure
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12.0;
    self.layer.masksToBounds = YES;
    
    self.titleLab = [UILabel labelWithText:@"薪朋友" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(20)];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
    }];
    
    self.rule1 = [self ruleLabel];
    [self addSubview:self.rule1];
    [self.rule1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(16);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    self.rule2 = [self ruleLabel];;
    [self addSubview:self.rule2];
    [self.rule2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rule1.mas_bottom).offset(16);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    
    self.rule3 = [self ruleLabel];;
    [self addSubview:self.rule3];
    [self.rule3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rule2.mas_bottom).offset(16);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    self.rule4 = [self ruleLabel];
    [self addSubview:self.rule4];
    [self.rule4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rule3.mas_bottom).offset(16);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    [self addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rule4.mas_bottom).offset(40);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(44);
    }];
}

- (UILabel *)ruleLabel
{
    UILabel *rule = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(14)];
    rule.numberOfLines = 2;
    return rule;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        
        [_confirmButton setTitle:@"我知道了" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
        
    }
    return _confirmButton;
}

@end
