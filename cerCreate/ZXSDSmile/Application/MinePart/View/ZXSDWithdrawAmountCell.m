//
//  ZXSDWithdrawAmountCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDWithdrawAmountCell.h"
#import "ZXSDWithdrawInfoModel.h"

@interface ZXSDWithdrawAmountCell ()

//@property (nonatomic, strong) UITextField *amoutTF;
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation ZXSDWithdrawAmountCell

- (void)initView
{
    UILabel *type = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
    [self.contentView addSubview:type];
    [type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(20);
    }];
    self.typeLabel = type;
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR_FROM_HEX(0xE8E8E8);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.top.equalTo(type.mas_bottom).offset(74);
        make.height.mas_equalTo(.5);
    }];
    
    UILabel *unitLabel = [UILabel labelWithText:@"¥" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(16)];
    [self.contentView addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(line.mas_top).offset(-12);
        make.width.mas_equalTo(10);
    }];
    
    
    [self.contentView addSubview:self.amoutTF];
    [self.amoutTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(unitLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(line.mas_top).offset(-5);
    }];
    
    
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDWithdrawInfoModel class]]) {
        return;
    }
    
    ZXSDWithdrawInfoModel *model = renderData;
    self.typeLabel.text = [NSString stringWithFormat:@"提现金额  ( 服务费 ¥%@ /次 )", model.fee];
}


- (UITextField *)amoutTF
{
    if (!_amoutTF) {
        _amoutTF = [UITextField new];
        _amoutTF.borderStyle = UITextBorderStyleNone;
        _amoutTF.textColor = UICOLOR_FROM_HEX(0x333333);
        _amoutTF.font = FONT_PINGFANG_X_Medium(34);
        _amoutTF.userInteractionEnabled = NO;
    }
    return _amoutTF;
}

@end
