//
//  ZXSDWithdrawRecordCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDWithdrawRecordCell.h"
#import "ZXSDWithdrawItemModel.h"

@interface ZXSDWithdrawRecordCell ()

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@end

@implementation ZXSDWithdrawRecordCell

- (void)initView
{
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.bankLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.amountLabel];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(28);
        make.width.height.mas_equalTo(8);
    }];
    
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusView.mas_right).offset(8);
        make.top.equalTo(self.contentView).offset(21);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankLabel);
        make.top.equalTo(self.bankLabel.mas_bottom).offset(9);
        make.bottom.equalTo(self.contentView).offset(-21);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDWithdrawItemModel class]]) {
        return;
    }
    
    ZXSDWithdrawItemModel *model = renderData;
    self.timeLabel.text = model.withdrawTime;
    
    
    self.amountLabel.text = [NSString stringWithFormat:@"¥ %.2f", model.amount];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.amountLabel.text]];
    
    [attrStr addAttributes:@{
                             NSFontAttributeName:FONT_PINGFANG_X(12)}
                     range:NSMakeRange(0, 1)];
    self.amountLabel.attributedText = attrStr;
}

- (UIView *)statusView
{
    if (!_statusView) {
        _statusView = [UIView new];
        _statusView.layer.cornerRadius = 4.0;
        _statusView.layer.masksToBounds = YES;
        _statusView.backgroundColor = UICOLOR_FROM_HEX(0xE8E8E8);
        
    }
    return _statusView;
}

- (UILabel *)bankLabel
{
    if (!_bankLabel) {
        _bankLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(16)];
    }
    return _bankLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(14)];
    }
    return _timeLabel;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(24)];
    }
    return _amountLabel;
}

@end
