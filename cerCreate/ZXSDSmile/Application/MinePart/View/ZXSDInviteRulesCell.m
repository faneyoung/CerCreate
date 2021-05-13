//
//  ZXSDInviteRulesCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDInviteRulesCell.h"

@interface ZXSDInviteRulesCell ()

@property (nonatomic, strong) UILabel *rewardLab1;
@property (nonatomic, strong) UILabel *rewardLab2;
@property (nonatomic, strong) UILabel *rewardLab3;

@end

@implementation ZXSDInviteRulesCell

- (void)initView
{
    UILabel *titleLab = [UILabel labelWithText:@"活动规则" textColor:TextColorTitle font:FONT_PINGFANG_X(28)];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self);
    }];
    
    UILabel *descLab = [UILabel labelWithText:@"邀请好友一起尊享预支工资特权吧" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(14)];
    [self addSubview:descLab];
    [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(titleLab.mas_bottom).offset(8);
    }];
    
    
    self.rewardLab1 = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(16)];
    [self addSubview:self.rewardLab1];
    [self.rewardLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(descLab);
        make.top.equalTo(descLab.mas_bottom).offset(15);
    }];
    
    
    self.rewardLab2 = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(16)];
    [self addSubview:self.rewardLab2];
    [self.rewardLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.rewardLab1);
        make.top.equalTo(self.rewardLab1.mas_bottom).offset(15);
    }];
    
    self.rewardLab3 = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(16)];
    [self addSubview:self.rewardLab3];
    [self.rewardLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.rewardLab1);
        make.top.equalTo(self.rewardLab2.mas_bottom).offset(15);
    }];
    
    
    UILabel *noteTitleLab = [UILabel labelWithText:@"其他说明" textColor:TextColorTitle font:FONT_PINGFANG_X(28)];
    [self addSubview:noteTitleLab];
    [noteTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(20);
        make.top.mas_equalTo(self.rewardLab3.mas_bottom).inset(20);
    }];
    
    UILabel *noteLab = [UILabel labelWithText:@"以上邀请奖励，从新用户注册登录算起，7个自然日内需要完成对应任务，超过7个自然日则无法获得奖励" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(16)];
    noteLab.numberOfLines = 0;
    [self addSubview:noteLab];
    [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.top.equalTo(noteTitleLab.mas_bottom).inset(16);
        make.bottom.inset(40);
    }];

    
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDInviteInfoModel class]]) {
        return;
    }
    
    ZXSDInviteInfoModel *info = renderData;
    
    NSString *value1 = [NSString stringWithFormat:@"¥ %.1f  / 好友完成注册及认证，获得奖励", info.certifyAmount];
    NSString *value2 = [NSString stringWithFormat:@"¥ %.1f  / 好友完成上传流水，获得奖励", info.wageAmount];
    NSString *value3 = [NSString stringWithFormat:@"¥ %.1f  / 好友第一次预支成功，再得奖励", info.advanceAmount];
    
    self.rewardLab1.attributedText = [self attributedString:value1 amount:[NSString stringWithFormat:@"%.1f", info.certifyAmount]];
    self.rewardLab2.attributedText = [self attributedString:value2 amount:[NSString stringWithFormat:@"%.1f", info.wageAmount]];
    self.rewardLab3.attributedText = [self attributedString:value3 amount:[NSString stringWithFormat:@"%.1f", info.advanceAmount]];
    
}

- (NSMutableAttributedString *)attributedString:(NSString *)value amount:(NSString *)amount
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:value];
    [attr addAttributes:@{NSForegroundColorAttributeName:kThemeColorMain} range:NSMakeRange(0, amount.length + 2)];
    [attr addAttributes:@{NSFontAttributeName:FONT_PINGFANG_X(30)} range:NSMakeRange(2, amount.length)];
    
    return attr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
