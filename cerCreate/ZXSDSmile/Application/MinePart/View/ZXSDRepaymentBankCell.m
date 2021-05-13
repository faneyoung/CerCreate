//
//  ZXSDRepaymentBankCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDRepaymentBankCell.h"

@interface ZXSDRepaymentBankCell ()

@property (nonatomic, strong) UIImageView *bankImageView;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UILabel *cardIDLabel;

@end

@implementation ZXSDRepaymentBankCell

- (void)initView
{
    UILabel *type = [UILabel labelWithText:@"支付方式" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
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
    NSString *bankName = @"";
    NSString *bankAccount = @"";
    NSString *logoURL = @"";
    
    if ([renderData isKindOfClass:[ZXSDExtendModel class]]) {
        ZXSDExtendModel *model = renderData;
        bankName = model.bankName;
        bankAccount = model.bankAccount;
        logoURL = model.bankLogoUrl;
    } else if ([renderData isKindOfClass:[ZXSDRepaymentInfoModel class]]){
        ZXSDRepaymentInfoModel *model = renderData;
        bankName = model.bankName;
        bankAccount = model.bankAccount;
        logoURL = model.bankLogoUrl;
    } else {
        return;
    }
    
    self.bankLabel.text = bankName;
    self.cardIDLabel.text = bankAccount;
    [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:logoURL] placeholderImage:nil];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
