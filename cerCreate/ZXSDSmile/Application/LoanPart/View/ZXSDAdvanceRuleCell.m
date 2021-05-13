//
//  ZXSDAdvanceRuleCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAdvanceRuleCell.h"

@interface ZXSDAdvanceRuleCell ()

@property (nonatomic, strong) UILabel *ruleLab;

@end

@implementation ZXSDAdvanceRuleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)setStatus:(MemberReviewStatus)status
{
    _status = status;
    [self initView];
}

#pragma mark - Action

- (void)showNormalRules
{
    if (self.showRules) {
        self.showRules(NO);
    }
}

- (void)showPlusRules
{
    if (self.showRules) {
        self.showRules(YES);
    }
}

- (void)recommendMyCompany
{
    if (self.recommendCompany) {
        self.recommendCompany();
    }
}

- (void)initView
{
    if (self.ruleLab.superview) {
        return;
    }
    
    UILabel *descLab = [UILabel labelWithText:@"预支规则" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(20)];
    [self.contentView addSubview:descLab];
    [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(20);
        make.top.inset(16);
    }];
    
    // 标题组
    UIView *title = [self titleView];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLab.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    // 未开通组
    UIView *value1 = [self value1View];
    [self addSubview:value1];
    [value1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    //已开通组
    UIView *value2 = [self value2View];
    [self addSubview:value2];
    [value2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(value1.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    
    // 规则说明
    UIView *dotView = [UIView new];
    dotView.backgroundColor = kThemeColorMain;
    dotView.layer.cornerRadius = 4;
    [self addSubview:dotView];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(value2.mas_bottom).offset(20);
        make.width.height.mas_equalTo(8);
    }];
    
    [self addSubview:self.ruleLab];
    [self.ruleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotView.mas_right).offset(10);
        make.centerY.equalTo(dotView);
        make.height.mas_equalTo(17);
    }];
    
    BOOL smilePlus = [ZXSDCurrentUser currentUser].isSmilePlus;
    if (!smilePlus) {
        UILabel *rule2 = [UILabel labelWithText:@"我司还不是薪朋友合作企业，邀请我司" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
        [self addSubview:rule2];
        [rule2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ruleLab);
            make.top.equalTo(self.ruleLab.mas_bottom).offset(8);
            make.height.mas_equalTo(17);
        }];
        
        NSDictionary * attribtDic  = @{
            NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x999999), NSFontAttributeName:FONT_PINGFANG_X(12)};
        
        NSDictionary * underAttribtDic  = @{
            NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
            NSForegroundColorAttributeName:kThemeColorMain, NSFontAttributeName:FONT_PINGFANG_X(12)};
        NSMutableAttributedString * underAttr = [[NSMutableAttributedString alloc] initWithString:@"我司还不是薪朋友合作企业，" attributes:attribtDic];
        NSAttributedString *last = [[NSAttributedString alloc] initWithString:@"邀请我司" attributes:underAttribtDic];
        [underAttr appendAttributedString:last];
        rule2.attributedText = underAttr;
        
        rule2.userInteractionEnabled = YES;
        UIControl *tap = [UIControl new];
        [rule2 addSubview:tap];
        [tap mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rule2).offset(150);
            make.top.bottom.right.equalTo(rule2);
        }];
        [tap addTarget:self action:@selector(recommendMyCompany) forControlEvents:(UIControlEventTouchUpInside)];
    }
}


- (UIView *)titleView
{
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 44)];
    
    CGFloat width = SCREEN_WIDTH()/7.0;
    UIView *box1, *box2, *box3;
    for (NSInteger k = 0; k < 3; k++) {
        UIView *box = [UIView new];
        if (k == 0) {
            box.frame = CGRectMake(0, 0, width * 2, 44);
            box1 = box;
        } else if (k == 1) {
            box.frame = CGRectMake(width * 2, 0, width * 2.2, 44);
            box2 = box;
        } else {
            box.frame = CGRectMake(width * 4.2, 0, width * 2.8, 44);
            box3 = box;
        }
        [background addSubview:box];
    }
    
    UILabel *type = [UILabel labelWithText:@"用户类型" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    [box1 addSubview:type];
    [type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box1).offset(20);
        make.top.bottom.equalTo(box1);
    }];
    
    UILabel *smileLab = [UILabel labelWithText:@"薪朋友" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    [box2 addSubview:smileLab];
    [smileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box2);
        make.centerY.mas_equalTo(0);
    }];
    UIButton *smileBt = [UIButton buttonWithNormalImage:UIIMAGE_FROM_NAME(@"smile_info_icon") highlightedImage:nil];
    smileBt.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -20, -15, -20);
    [smileBt addTarget:self action:@selector(showNormalRules) forControlEvents:(UIControlEventTouchUpInside)];
    [box2 addSubview:smileBt];
    [smileBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(smileLab.mas_right).offset(8);
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(0);
    }];
    
    UILabel *smilePlusLab = [UILabel labelWithText:@"薪朋友+" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    [box3 addSubview:smilePlusLab];
    [smilePlusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box3);
        make.centerY.mas_equalTo(0);
    }];
    UIButton *smilePlusBt = [UIButton buttonWithNormalImage:UIIMAGE_FROM_NAME(@"smile_info_icon") highlightedImage:nil];
    smilePlusBt.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -20, -15, -20);
    [smilePlusBt addTarget:self action:@selector(showPlusRules) forControlEvents:(UIControlEventTouchUpInside)];
    [box3 addSubview:smilePlusBt];
    [smilePlusBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(smilePlusLab.mas_right).offset(8);
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(0);
    }];
    
    return background;
}

- (UIView *)value1View
{
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH(), 44)];
    background.backgroundColor = UICOLOR_FROM_HEX(0xFFFFFF);
    
    CGFloat width = SCREEN_WIDTH()/7.0;
    UIView *box1, *box2, *box3;
    for (NSInteger k = 0; k < 3; k++) {
        UIView *box = [UIView new];
        if (k == 0) {
            box.frame = CGRectMake(0, 0, width * 2, 44);
            box1 = box;
        } else if (k == 1) {
            box.frame = CGRectMake(width * 2, 0, width * 2.2, 44);
            box2 = box;
        } else {
            box.frame = CGRectMake(width * 4.2, 0, width * 2.8, 44);
            box3 = box;
        }
        [background addSubview:box];
    }
    
    UILabel *type = [UILabel labelWithText:@"未开通" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(12)];
    [box1 addSubview:type];
    [type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box1).offset(20);
        make.top.bottom.equalTo(box1);
    }];
    
    UILabel *value1 = [UILabel labelWithText:@"——" textColor:UICOLOR_FROM_HEX(0xCCD6DD) font:FONT_PINGFANG_X(12)];
    [box2 addSubview:value1];
    [value1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box2).offset(0);
        make.top.bottom.equalTo(box2);
    }];
    
    UILabel *value2 = [UILabel labelWithText:@"¥500" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_SFUI_X_Regular(12)];
    [box3 addSubview:value2];
    [value2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box3).offset(0);
        make.top.bottom.equalTo(box3);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR_FROM_HEX(0xE8E8E8);
    [background addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset(20);
        make.right.equalTo(background).offset(-20);
        make.bottom.equalTo(background);
        make.height.mas_equalTo(0.5);
    }];
    
    return background;
}

- (UIView *)value2View
{
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH(), 44)];
    background.backgroundColor = UICOLOR_FROM_HEX(0xFFFFFF);
    
    CGFloat width = SCREEN_WIDTH()/7.0;
    UIView *box1, *box2, *box3;
    for (NSInteger k = 0; k < 3; k++) {
        UIView *box = [UIView new];
        if (k == 0) {
            box.frame = CGRectMake(0, 0, width * 2, 44);
            box1 = box;
        } else if (k == 1) {
            box.frame = CGRectMake(width * 2, 0, width * 2.2, 44);
            box2 = box;
        } else {
            box.frame = CGRectMake(width * 4.2, 0, width * 2.8, 44);
            box3 = box;
        }
        [background addSubview:box];
    }
    
    UILabel *type = [UILabel labelWithText:@"已开通" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(12)];
    [box1 addSubview:type];
    [type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box1).offset(20);
        make.top.bottom.equalTo(box1);
    }];
    
    UILabel *value1 = [UILabel labelWithText:@"¥0 ~ ¥1000" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_SFUI_X_Regular(12)];
    [box2 addSubview:value1];
    [value1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box2).offset(0);
        make.top.bottom.equalTo(box2);
    }];
    
    UILabel *value2 = [UILabel labelWithText:@"¥1000 / ¥1500 / ¥2000" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_SFUI_X_Regular(12)];
    [box3 addSubview:value2];
    [value2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(box3).offset(0);
        make.top.bottom.equalTo(box3);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR_FROM_HEX(0xE8E8E8);
    [background addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset(20);
        make.right.equalTo(background).offset(-20);
        make.bottom.equalTo(background);
        make.height.mas_equalTo(0.5);
    }];
    
    return background;
}

- (UILabel *)ruleLab
{
    if (!_ruleLab) {
        _ruleLab = [UILabel labelWithText:@"当月最多只能预支一次" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(12)];
    }
    return _ruleLab;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
