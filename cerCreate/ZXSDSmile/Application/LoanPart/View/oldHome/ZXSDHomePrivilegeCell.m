//
//  ZXSDHomePrivilegeCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomePrivilegeCell.h"
#import "ZXSDHomeLoanInfo.h"

@interface ZXSDHomePrivilegeCell ()

@property(nonatomic, strong) UILabel *lowestAmountLabel;
@property(nonatomic, strong) UILabel *highestAmountLabel;

@end

@implementation ZXSDHomePrivilegeCell

- (void)initView
{
    UILabel *titleLabel = [UILabel labelWithText:@"专属特权" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(20)];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    NSArray *configs = @[
        @{@"icon":@"privilege_icon_1", @"title":@"免费", @"amount":@"500"},
        @{@"icon":@"privilege_icon_0", @"title":@"利息", @"amount":@"0"},
        @{@"icon":@"privilege_icon_2", @"title":@"最高", @"amount":@"2000"}
    ];
    
    CGFloat gap = 6;
    CGFloat offsetX = 20;
    NSInteger count = configs.count;
    CGFloat width = (SCREEN_WIDTH() - offsetX * 2 - gap * (count - 1))/3.0;
    
    for (NSInteger k = 0; k < configs.count; k++) {
        NSDictionary *item = configs[k];
        UIView *card = [self buildPrivilegeCard:item index:k];
        [self.contentView addSubview:card];
        //card.frame = CGRectMake(0 , 0, width, 120);
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(offsetX + (gap + width) * k);
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(62);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
        card.backgroundColor = [UIColor whiteColor];
        
        /*
        UIRectCorner corners = 0;
        UIColor *color = nil;
        if (k == 0) {
            corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            color = UICOLOR_FROM_HEX(0x19E678);
        } else if (k == 1) {
            color = UICOLOR_FROM_HEX(0x79A5FF);
        } else if (k == 2) {
            corners = UIRectCornerTopRight | UIRectCornerBottomRight;
            color = UICOLOR_FROM_HEX(0x8FA2C9);
        }
        
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:card.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(8.0, 8.0)];
        CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
        cornerRadiusLayer.frame = card.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        card.layer.mask = cornerRadiusLayer;
        card.backgroundColor = color;
        */
        
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
    
    ZXSDHomeLoanInfo *loanInfo = renderData;
    ZXSDHomeCreditItem *item = loanInfo.loanModel.creditUnitList.firstObject;
    if (item) {
        self.lowestAmountLabel.text = @(item.unit).stringValue;
    }
    
    ZXSDHomeCreditItem *maxItem = loanInfo.loanModel.creditUnitList.lastObject;
    if (maxItem) {
        self.highestAmountLabel.text = @(maxItem.unit).stringValue;
    }
}

- (UIView *)buildPrivilegeCard:(NSDictionary *)item index:(NSInteger)index
{
    UIView *card = [UIView new];

    UILabel *amountLabel = [UILabel labelWithText:item[@"amount"] textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_SFUI_X_Semibold(32)];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(0);
        make.centerX.equalTo(card);
    }];
    
    if (index == 0) {
        self.lowestAmountLabel = amountLabel;
    } else if (index == 2) {
        self.highestAmountLabel = amountLabel;
    }
    
    /*
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor whiteColor];
    [card addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(card).offset(16);
        make.top.equalTo(amountLabel.mas_bottom).offset(21);
        make.centerX.equalTo(card);
        make.height.mas_equalTo(0.5);
    }];*/
    
    UILabel *titleLabel = [UILabel labelWithText:item[@"title"] textColor:UICOLOR_FROM_HEX(0xA0AFC3) font:FONT_PINGFANG_X(14)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [card addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(4);
        //make.bottom.equalTo(card).offset(-12);
        make.centerX.equalTo(card);
    }];
    
    /*
    UIImageView *icon = [UIImageView new];
    icon.image = [UIImage imageNamed:item[@"icon"]];
    [card addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(card).offset(9);
        make.bottom.equalTo(card).offset(5);
        make.width.height.mas_equalTo(60);
    }];*/
    
    return card;
}


@end
