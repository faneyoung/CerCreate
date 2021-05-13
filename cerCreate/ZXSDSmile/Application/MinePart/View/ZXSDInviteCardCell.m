//
//  ZXSDInviteCardCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDInviteCardCell.h"
#import "ZXSDInviteInfoModel.h"

@interface ZXSDInviteCardCell ()

@property (nonatomic, strong) UILabel *balanceLabel;

@end

@implementation ZXSDInviteCardCell

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDInviteInfoModel class]]) {
        return;
    }
    
    ZXSDInviteInfoModel *model = renderData;
    self.balanceLabel.text = [NSString stringWithFormat:@"¥ %.2f", model.balance];
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.balanceLabel.text]];
//
//    [attrStr addAttributes:@{
//                             NSFontAttributeName:FONT_PINGFANG_X(34)}
//                     range:NSMakeRange(2, self.balanceLabel.text.length - 7)];
//    self.balanceLabel.attributedText = attrStr;
}

- (void)initView
{
    UIImageView *container = [UIImageView new];
    container.image = [UIIMAGE_FROM_NAME(@"smile_member_cardbg") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:(UIImageResizingModeStretch)];
    container.contentMode = UIViewContentModeScaleAspectFill;
    container.userInteractionEnabled = YES;
    [self.contentView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(5);
        make.top.inset(10);
        make.bottom.inset(30);
        make.height.equalTo(container.mas_width).with.multipliedBy(180.0/374.0);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container);
        make.centerY.equalTo(container).offset(18);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(container).offset(20);
    }];
    
    [container addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line.mas_top).offset(-36);
        make.centerX.equalTo(container);
    }];
    
    self.balanceLabel.text = @"¥ 0.00";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.balanceLabel.text]];
    
    [attrStr addAttributes:@{
                             NSFontAttributeName:FONT_PINGFANG_X(34)}
                     range:NSMakeRange(2, 1)];
    self.balanceLabel.attributedText = attrStr;
    
    
    
    
    UILabel *originalLab = [UILabel labelWithText:@"提现记录" textColor:UICOLOR_FROM_HEX(0xFFFFFF) font:FONT_PINGFANG_X(12)];
    originalLab.userInteractionEnabled = YES;
    [container addSubview:originalLab];
    [originalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).inset(20);
        make.centerX.equalTo(container);
        make.height.mas_equalTo(30);
    }];
    
    NSDictionary * underAttribtDic  = @{
        NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
        NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0xFFFFFF)};
    NSMutableAttributedString * underAttr = [[NSMutableAttributedString alloc] initWithString:originalLab.text attributes:underAttribtDic];
    originalLab.attributedText = underAttr;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWithdrawHistory)];
    [originalLab addGestureRecognizer:tap];
}

- (void)showWithdrawHistory
{
    if (self.historyAction) {
        self.historyAction();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xFFFFFF) font:FONT_PINGFANG_X(34)];
    }
    return _balanceLabel;
}

@end
