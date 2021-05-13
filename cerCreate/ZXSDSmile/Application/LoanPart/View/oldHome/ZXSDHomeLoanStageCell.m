//
//  ZXSDHomeLoanStageCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/11/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomeLoanStageCell.h"
#import "ZXSDHomeLoanInfo.h"

@interface ZXSDHomeLoanStageCell ()

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UILabel *amoubtLabel;
@property (nonatomic, strong) UILabel *amoubtDescLabel;

@end

@implementation ZXSDHomeLoanStageCell

- (void)initView
{
    UILabel *titleLabel = [UILabel labelWithText:@"预支驿站" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(20)];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    NSArray *configs = @[
        @{ @"title":@"可预支 (次)", @"amount":@"0"},
        @{ @"title":@"已预支 (元)", @"amount":@"0"}
    ];
    
    CGFloat gap = 10;
    CGFloat offsetX = 20;
    NSInteger count = configs.count;
    CGFloat width = (SCREEN_WIDTH() - offsetX * count - gap * (count -1))/2.0;
    
    for (NSInteger k = 0; k < configs.count; k++) {
        NSDictionary *item = configs[k];
        UIView *card = [self buildInfoCard:item index:k];
        [self.contentView addSubview:card];
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(offsetX + (gap + width) * k);
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(62);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
        card.backgroundColor = [UIColor whiteColor];
        
        if (k == configs.count - 1) {
            return;
        }
        
        UIView *vline = [UIView new];
        vline.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF2);
        [self.contentView addSubview:vline];
        [vline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(offsetX + width * (k+1) + gap * k + gap * 0.5);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(42);
            make.centerY.equalTo(card);
            
        }];
    }
    
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDHomeLoanInfo class]]) {
        return;
    }
    
    ZXSDHomeLoanInfo *info = renderData;
    
    // 逾期
    if ([info.actionModel.action isEqualToString:ZXSDHomeUserApplyStatus_OVERDUE_REPAY]) {
        self.countLabel.text = @(0).stringValue;
        self.amoubtLabel.text = @(info.loanModel.overdueCalculation.amount).stringValue;
        self.amoubtDescLabel.text = @"已逾期 (元)";
    } else {
        self.countLabel.text = @(info.loanModel.loanCountMax - info.loanModel.loanNumberCurrentCycle).stringValue;
        self.amoubtLabel.text = @(info.loanModel.sumLoan).stringValue;
        self.amoubtDescLabel.text = @"已预支 (元)";
    }
    
}

- (UIView *)buildInfoCard:(NSDictionary *)item index:(NSInteger)index
{
    UIView *card = [UIView new];

    UILabel *amountLabel = [UILabel labelWithText:item[@"amount"] textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_SFUI_X_Semibold(32)];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(0);
        make.centerX.equalTo(card);
    }];
    
    UILabel *titleLabel = [UILabel labelWithText:item[@"title"] textColor:UICOLOR_FROM_HEX(0xA0AFC3) font:FONT_PINGFANG_X(14)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(4);
        make.centerX.equalTo(card);
    }];
    
    if (index == 0) {
        self.countLabel = amountLabel;
    } else {
        self.amoubtLabel = amountLabel;
        self.amoubtDescLabel = titleLabel;
    }
    
    return card;
}

@end
