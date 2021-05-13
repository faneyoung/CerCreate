//
//  ZXSDWithdrawBankCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDWithdrawBankCell.h"
#import "ZXSDBankCardModel.h"
#import "ZXSDWithdrawInfoModel.h"

@interface ZXSDWithdrawBankCell ()

@property (nonatomic, strong) UIImageView *bankImageView;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UILabel *cardIDLabel;

@end

@implementation ZXSDWithdrawBankCell

- (void)initView
{
    UILabel *type = [UILabel labelWithText:@"到账银行卡 ( 2 小时内到账 )" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
    [self.contentView addSubview:type];
    [type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.contentView addSubview:self.bankImageView];
    [self.bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(type);
        make.top.equalTo(type.mas_bottom).offset(20);
        make.width.height.mas_equalTo(22);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    [self.contentView addSubview:self.bankLabel];
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankImageView.mas_right).offset(16);
        make.centerY.equalTo(self.bankImageView);
    }];
    
    [self.contentView addSubview:self.cardIDLabel];
    [self.cardIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-41);
        make.centerY.equalTo(self.bankImageView);
    }];
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDWithdrawInfoModel class]]) {
        return;
    }
    
    ZXSDWithdrawInfoModel *model = renderData;
    
    self.bankLabel.text = model.bankName;
    self.cardIDLabel.text = model.number;
    [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:model.bankIcon] placeholderImage:nil];
}

- (UIImageView *)bankImageView
{
    if (!_bankImageView) {
        _bankImageView = [UIImageView new];
    }
    return _bankImageView;
}

- (UILabel *)bankLabel
{
    if (!_bankLabel) {
        _bankLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
    }
    return _bankLabel;
}

- (UILabel *)cardIDLabel
{
    if (!_cardIDLabel) {
        _cardIDLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
    }
    return _cardIDLabel;
}


@end
