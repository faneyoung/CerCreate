//
//  ZXSDAdvanceDetailCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAdvanceDetailCell.h"

@interface ZXSDAdvanceDetailCell ()

@property (nonatomic, strong) UILabel *loanLabel;
@property (nonatomic, strong) UILabel *interestLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *totalLabel;

@end

@implementation ZXSDAdvanceDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)config:(NSString *)loan
      interest:(NSString *)interest
          date:(NSString *)date
         total:(NSString *)total
{
    self.loanLabel.text = [NSString stringWithFormat:@"¥%@", loan];
    self.interestLabel.text = [NSString stringWithFormat:@"¥%@", interest];
    self.dateLabel.text = date;
    self.totalLabel.text = [NSString stringWithFormat:@"¥%@", total];
}

- (void)initView
{
    //self.backgroundColor = [UIColor redColor];
    UILabel *descLab = [UILabel labelWithText:@"您预支的工资信息" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(16)];
    [self addSubview:descLab];
    [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self);
    }];
    
    UIView *container = [UIView new];
    container.backgroundColor = UICOLOR_FROM_HEX(0xECF5FF);
    container.layer.cornerRadius = 8;
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(105);
        make.width.mas_equalTo(SCREEN_WIDTH() - 40);
        make.top.equalTo(descLab.mas_bottom).offset(20);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR_FROM_HEX(0xCCD6DD);
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(16);
        make.right.equalTo(container).offset(-16);
        make.height.mas_equalTo(.5);
        make.centerY.equalTo(container);
    }];
    
    UIView *tlBox = [self boxView:@"金额" value:@"" index:0];
    [container addSubview:tlBox];
    UIView *trBox = [self boxView:@"利息" value:@"0" index:1];
    [container addSubview:trBox];
    [tlBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(container);
        make.height.mas_equalTo(52);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
    
    [trBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(container);
        make.height.mas_equalTo(52);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
    
    
    
    UIView *blBox = [self boxView:@"扣款日" value:@"" index:2];
    [container addSubview:blBox];
    UIView *brBox = [self boxView:@"应还本息" value:@"¥1500" index:3];
    [container addSubview:brBox];
    [blBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container);
        make.top.equalTo(line);
        make.height.mas_equalTo(52);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
    
    [brBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container);
        make.top.equalTo(line);
        make.height.mas_equalTo(52);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
}

- (UIView *)boxView:(NSString *)key value:(NSString*)value index:(NSInteger)index
{
    UIView *box = [UIView new];
    UILabel *keyLabel = [UILabel labelWithText:key textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(14)];
    [box addSubview:keyLabel];
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box).offset(16);
        make.centerY.mas_equalTo(0);
        make.width.equalTo(box).multipliedBy(0.4);
        
    }];
    
    UILabel *valueLabel = [UILabel labelWithText:value textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_SFUI_X_Regular(14)];
    [box addSubview:valueLabel];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(keyLabel.mas_right).offset(0);
        make.right.equalTo(box);
        make.centerY.mas_equalTo(0);
    }];
    if (index == 0) {
        self.loanLabel = valueLabel;
    } else if (index == 1) {
        self.interestLabel = valueLabel;
    } else if (index == 2) {
        self.dateLabel = valueLabel;
    } else if (index == 3) {
        self.totalLabel = valueLabel;
    }
    
    return box;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
