//
//  ZXSDRepaymentAmountCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDRepaymentAmountCell.h"

@interface ZXSDRepaymentAmountCell ()

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *keyLabel;
@end

@implementation ZXSDRepaymentAmountCell

- (void)setRenderData:(id)renderData
{
    CGFloat fee = 0;
    if ([renderData isKindOfClass:[ZXSDExtendModel class]]) {
        ZXSDExtendModel *model = renderData;
        fee = model.extendFee;
        self.keyLabel.text = @"本次展期应付 (元)";
    } else if ([renderData isKindOfClass:[ZXSDRepaymentInfoModel class]]){
        ZXSDRepaymentInfoModel *model = renderData;
        fee = model.actualAmount;
        self.keyLabel.text = @"本次应还金额 (元)";
    }
    
    self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", fee];
}

- (void)initView
{
    UILabel *keyLabel = [UILabel labelWithText:@"本次展期应付 (元)" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
    [self.contentView addSubview:keyLabel];
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.contentView).offset(20);
//        make.bottom.equalTo(self.contentView).offset(-20);
        make.top.left.inset(20);
        make.bottom.inset(28);

        make.height.mas_equalTo(20);
    }];
    self.keyLabel = keyLabel;
    
    UIButton *infoBt = [UIButton buttonWithNormalImage:UIIMAGE_FROM_NAME(@"smile_info_icon") highlightedImage:nil];
    infoBt.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -20, -15, -20);
    [infoBt addTarget:self action:@selector(showChargeDetails) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:infoBt];
    [infoBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(keyLabel.mas_right).offset(8);
        make.width.height.mas_equalTo(14);
        make.centerY.equalTo(keyLabel);
    }];
    

    [self.contentView addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(20);
        make.centerY.equalTo(keyLabel);
    }];
    
    UILabel *sepLab = [[UILabel alloc] init];
    sepLab.backgroundColor = kThemeColorLine;
    [self.contentView addSubview:sepLab];
    [sepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(8);
    }];
}

- (void)showChargeDetails
{
    if (self.showChargeAlert) {
        self.showChargeAlert();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel =  [UILabel labelWithText:@"" textColor:TextColorTitle font:FONT_PINGFANG_X(14)];
    }
    return _amountLabel;
}

@end
