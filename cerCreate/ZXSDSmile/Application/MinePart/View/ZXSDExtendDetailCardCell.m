//
//  ZXSDExtendDetailCardCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDExtendDetailCardCell.h"

@interface ZXSDExtendDetailCardCell ()

@property (nonatomic, strong) UILabel *oldDateValue;
@property (nonatomic, strong) UILabel *freshDateValue;

@property (nonatomic, strong) UILabel *oldAmountValue;
@property (nonatomic, strong) UILabel *freshAmountValue;

@property (nonatomic, strong) UILabel *oldPaymentValue;
@property (nonatomic, strong) UILabel *freshPaymentValue;

@end

@implementation ZXSDExtendDetailCardCell

- (void)initView
{
    UIView *container = [UIView new];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 8;
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH() - 40);
        make.height.mas_equalTo(216);
        make.bottom.equalTo(self).offset(-20);
    }];
    container.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    container.layer.shadowOpacity = 1;
    container.layer.shadowOffset = CGSizeMake(0, 2);
    container.layer.shadowRadius = 4;
    
    // 预支日期
    UIView *vline1 = [UIView new];
    vline1.backgroundColor = UICOLOR_FROM_HEX(0xE5E5E5);
    [container addSubview:vline1];
    [vline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(20);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(70);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *oldDateLabel = [UILabel labelWithText:@"预支日期" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
    [container addSubview:oldDateLabel];
    [oldDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(20);
        make.left.equalTo(container).offset(20);
        make.right.equalTo(vline1.mas_left).offset(-5);
    }];
    UILabel *oldDateValue = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x151515) font:FONT_PINGFANG_X(14)];
    [container addSubview:oldDateValue];
    [oldDateValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldDateLabel.mas_bottom).offset(5);
        make.left.right.equalTo(oldDateLabel);
    }];
    self.oldDateValue = oldDateValue;
    
    UILabel *newDateLabel = [UILabel labelWithText:@"预支日期" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
    newDateLabel.textAlignment = NSTextAlignmentRight;
    [container addSubview:newDateLabel];
    [newDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldDateLabel);
        make.right.equalTo(container).offset(-20);
        make.left.equalTo(vline1.mas_right).offset(5);
    }];
    UILabel *newDateValue = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x151515) font:FONT_PINGFANG_X(14)];
    newDateValue.textAlignment = NSTextAlignmentRight;
    [container addSubview:newDateValue];
    [newDateValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newDateLabel.mas_bottom).offset(5);
        make.left.right.equalTo(newDateLabel);
    }];
    self.freshDateValue = newDateValue;
    
    // 应还金额
    UIImageView *transfer = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_transfer_icon")];
    [container addSubview:transfer];
    [transfer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vline1.mas_bottom).offset(9);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *oldAmountLabel = [UILabel labelWithText:@"应还金额 (元)" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
    [container addSubview:oldAmountLabel];
    [oldAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldDateValue.mas_bottom).offset(26);
        make.left.equalTo(oldDateValue);
        make.right.equalTo(transfer.mas_left).offset(-5);
    }];
    UILabel *oldAmountValue = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x151515) font:FONT_PINGFANG_X(14)];
    [container addSubview:oldAmountValue];
    [oldAmountValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldAmountLabel.mas_bottom).offset(5);
        make.left.right.equalTo(oldAmountLabel);
    }];
    self.oldAmountValue = oldAmountValue;
    
    UILabel *newAmountLabel = [UILabel labelWithText:@"应还金额 (元)" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
    newAmountLabel.textAlignment = NSTextAlignmentRight;
    [container addSubview:newAmountLabel];
    [newAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldAmountLabel);
        make.right.equalTo(newDateValue);
        make.left.equalTo(transfer.mas_right).offset(5);
    }];
    UILabel *newAmountValue = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x151515) font:FONT_PINGFANG_X(14)];
    newAmountValue.textAlignment = NSTextAlignmentRight;
    [container addSubview:newAmountValue];
    [newAmountValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldAmountValue);
        make.left.right.equalTo(newAmountLabel);
    }];
    self.freshAmountValue = newAmountValue;
    
    // 扣款日
    UIView *vline2 = [UIView new];
    vline2.backgroundColor = UICOLOR_FROM_HEX(0xE5E5E5);
    [container addSubview:vline2];
    [vline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transfer.mas_bottom).offset(9);
        make.width.mas_equalTo(0.5);
        //make.height.mas_equalTo(70);
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(container).offset(-20);
    }];
    
    UILabel *oldPaymentLabel = [UILabel labelWithText:@"扣款日" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
    [container addSubview:oldPaymentLabel];
    [oldPaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldAmountValue.mas_bottom).offset(26);
        make.left.equalTo(oldAmountValue);
        make.right.equalTo(vline2.mas_left).offset(-5);
    }];
    UILabel *oldPaymentValue = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x151515) font:FONT_PINGFANG_X(14)];
    [container addSubview:oldPaymentValue];
    [oldPaymentValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldPaymentLabel.mas_bottom).offset(5);
        make.left.right.equalTo(oldPaymentLabel);
        //make.bottom.equalTo(container).offset(-20);
    }];
    self.oldPaymentValue = oldPaymentValue;
    
    UILabel *newPaymentLabel = [UILabel labelWithText:@"扣款日" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
    newPaymentLabel.textAlignment = NSTextAlignmentRight;
    [container addSubview:newPaymentLabel];
    [newPaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldPaymentLabel);
        make.left.equalTo(vline2.mas_right).offset(5);
        make.right.equalTo(newAmountValue);
    }];
    UILabel *newPaymentValue = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xFF4C00) font:FONT_PINGFANG_X(14)];
    newPaymentValue.textAlignment = NSTextAlignmentRight;
    [container addSubview:newPaymentValue];
    [newPaymentValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(oldPaymentValue);
        make.left.right.equalTo(newPaymentLabel);
    }];
    self.freshPaymentValue = newPaymentValue;
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDExtendModel class]]) {
        return;
    }
    
    ZXSDExtendModel *model = renderData;
    
    ZXSDExtendLoanInfo *oldLoan = model.oldLoan;
    ZXSDExtendLoanInfo *freshLoan = model.extendLoan;
    
    self.oldDateValue.text = oldLoan.fundDate;
    self.freshDateValue.text = freshLoan.fundDate;
    
    self.oldAmountValue.text = [NSString stringWithFormat:@"%.2f", oldLoan.principal];
    self.freshAmountValue.text = [NSString stringWithFormat:@"%.2f", freshLoan.principal];
    
    self.oldPaymentValue.text = oldLoan.repayDate;
    self.freshPaymentValue.text = freshLoan.repayDate;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
