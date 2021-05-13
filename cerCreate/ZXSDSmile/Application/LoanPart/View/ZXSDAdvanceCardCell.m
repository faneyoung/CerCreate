//
//  ZXSDAdvanceCardCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAdvanceCardCell.h"
#import "CJLabel.h"

@interface ZXSDAdvanceCardCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *memberDateLab;

@property (nonatomic, strong) UILabel *tipsLab;
@property (nonatomic, strong) CJLabel *protocolLabel;

@property (nonatomic, assign) BOOL checked;

@end

@implementation ZXSDAdvanceCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _checked = NO;
    }
    return self;
}

- (void)setStatus:(MemberReviewStatus)status
{
    _status = status;
    [self initView];
}

- (void)updateMemberDate:(NSString *)start end:(NSString *)end
{
    NSString *value = [NSString stringWithFormat:@"有效期  %@-%@", start, end];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:value];
    [attr addAttribute:NSFontAttributeName value:FONT_SFUI_X_Regular(16) range:NSMakeRange(5, value.length - 5)];
    self.memberDateLab.attributedText = attr;
}

- (void)initView
{
    if (self.titleLab.superview) {
        return;
    }
    
    //self.backgroundColor = [UIColor purpleColor];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self);
    }];
    
    if (self.status == MemberReviewStatus1) {
        self.titleLab.text = @"开通即可预支工资";
    } else if (self.status == MemberReviewStatus2) {
        self.titleLab.text = @"您是否想要预支更高的工资 ？";
    }
    
    UILabel *descLab = [UILabel labelWithText:@"成为“创世薪朋友”即可获得单笔最高 ¥2000 的预支特权服务；" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(14)];
    descLab.numberOfLines = 2;
    [self addSubview:descLab];
    [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.titleLab.mas_bottom).offset(8);
    }];
    
    [self addSubview:self.tipsLab];
    [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(descLab.mas_bottom).offset(4);
    }];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.tipsLab.text];
    [attr setAttributes:@{
        NSForegroundColorAttributeName:kThemeColorMain,
        NSFontAttributeName:FONT_SFUI_X_Regular(14)
        
    } range:NSMakeRange(3, 1)];
    self.tipsLab.attributedText = attr;
    
    if (self.status == MemberReviewStatus1) {
        [descLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.tipsLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(descLab.mas_bottom).offset(0);
        }];
    }
    
    UIImageView *container = [UIImageView new];
    container.image = [UIIMAGE_FROM_NAME(@"smile_member_cardbg") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:(UIImageResizingModeStretch)];
    container.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self.tipsLab.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH() - 10);
        make.height.equalTo(container.mas_width).with.multipliedBy(188.0/335.0);
    }];
    
    UILabel *discountLab = [UILabel labelWithText:@"¥ 30/3个月" textColor:[UIColor whiteColor] font:FONT_PINGFANG_X(16)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", discountLab.text]];
    
    [attrStr addAttributes:@{
                             NSFontAttributeName:FONT_SFUI_X_Bold(30)}
                     range:NSMakeRange(2, 2)];
    [attrStr addAttributes:@{
            NSFontAttributeName:FONT_SFUI_X_Regular(16)}
    range:NSMakeRange(5, 1)];
    discountLab.attributedText = attrStr;
    [container addSubview:discountLab];
    [discountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(26);
        make.centerX.equalTo(container);
    }];
    
    UILabel *originalLab = [UILabel labelWithText:@"原价 ¥ 84 /3个月" textColor:UICOLOR_FROM_HEX(0x9ABBFF) font:FONT_PINGFANG_X(12)];
    [container addSubview:originalLab];
    [originalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(discountLab.mas_bottom).offset(8);
        make.centerX.equalTo(container);
    }];
    
    NSDictionary * underAttribtDic  = @{
        NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
        NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x9ABBFF)};
    NSMutableAttributedString * underAttr = [[NSMutableAttributedString alloc] initWithString:originalLab.text attributes:underAttribtDic];
    originalLab.attributedText = underAttr;
    
    UIView *line = [UIView new];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originalLab.mas_bottom).offset(30);
        make.centerX.equalTo(container);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(container).offset(20);
    }];
    
    
    UILabel *memberDateLab = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:FONT_PINGFANG_X(14)];
    [container addSubview:memberDateLab];
    [memberDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.centerX.equalTo(container);
        make.bottom.equalTo(container).offset(-20);
    }];
    self.memberDateLab = memberDateLab;
    
    UIView *lastView = nil;
    if (self.status == MemberReviewStatus1) {
        UILabel *memeberTipsLab = [UILabel labelWithText:@"缴费时间为您的发薪日，有效期为 3 个月" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(14)];
        [self addSubview:memeberTipsLab];
        [memeberTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(container.mas_bottom).offset(16);
        }];
        lastView = memeberTipsLab;
    } else if (self.status == MemberReviewStatus2) {
        UIView *footer = [self buildFooter];
        [self addSubview:footer];
        [footer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(container.mas_bottom).offset(16);
            make.height.mas_equalTo(30);
        }];
        lastView = footer;
    }
    
    UILabel *sepLine = [[UILabel alloc] init];
    sepLine.backgroundColor = kThemeColorLine;
    [self.contentView addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastView.mas_bottom).inset(24);
        make.left.right.inset(0);
        make.height.mas_equalTo(8);
    }];
    

}

- (UIView *)buildFooter
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    /* 协议规则从卡片移到主页面
    UIButton *check = [UIButton buttonWithNormalImage:UIIMAGE_FROM_NAME(@"smile_loan_agreement_unselected") highlightedImage:nil];
    check.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -20, -15);
    [check addTarget:self action:@selector(checkProtocol:) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:check];
    [check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.width.height.mas_equalTo(20);
        make.top.equalTo(footerView).offset(5);
    }];
    
    [footerView addSubview:self.protocolLabel];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(check.mas_right).offset(16);
        make.height.mas_equalTo(20);
        make.top.equalTo(footerView).offset(5);
    }];*/
    
    UIView *dot = [UIView new];
    dot.backgroundColor = kThemeColorMain;
    dot.layer.cornerRadius = 4.0;
    dot.layer.masksToBounds = YES;
    [footerView addSubview:dot];
    [dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.top.equalTo(footerView).offset(11);
        make.width.height.mas_equalTo(8);
    }];
    
    UILabel *tips = [UILabel labelWithText:@"缴费时间为您的发薪日" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(14)];
    [footerView addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dot.mas_right).offset(8);
        make.centerY.equalTo(dot);
    }];
    
    return footerView;
}


- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel labelWithText:@"开通即可预支工资" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(16)];
    }
    return _titleLab;
}

- (UILabel *)tipsLab
{
    if (!_tipsLab) {
        _tipsLab = [UILabel labelWithText:@"已有 3 位同事成为“创世薪朋友”" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(14)];
    }
    return _tipsLab;
}

- (CJLabel *)protocolLabel
{
    if (!_protocolLabel) {
        NSString *protocolString = @"阅读已同意《服务协议》";
        UIFont *currentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
        if (iPhone4() || iPhone5()) {
            currentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11.0];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:protocolString];
        _protocolLabel = [[CJLabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT() - 40 - NAVIBAR_HEIGHT(), SCREEN_WIDTH() - 40, 20)];
        if (iPhoneXSeries()) {
            CGFloat safeAreaHeight = 34;
            _protocolLabel.frame = CGRectMake(20, SCREEN_HEIGHT() - 40 - safeAreaHeight - NAVIBAR_HEIGHT(), SCREEN_WIDTH() - 40, 20);
        }
        _protocolLabel.numberOfLines = 0;
        _protocolLabel.textAlignment = NSTextAlignmentCenter;
        
        WEAKOBJECT(self);
        attributedString = [CJLabel configureAttributedString:attributedString
                                                      atRange:NSMakeRange(0, attributedString.length)
                                                   attributes:@{
                                                       NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x999999),
                                                       NSFontAttributeName:currentFont,
                                                   }];
        
        attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                       withString:@"《服务协议》"
                                                 sameStringEnable:NO
                                                   linkAttributes:@{
                                                       NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                       NSFontAttributeName:currentFont,
                                                   }
                                             activeLinkAttributes:nil
                                                        parameter:nil
                                                   clickLinkBlock:^(CJLabelLinkModel *linkModel){
            [weakself jumpToZXSDProtocolController];
        }longPressBlock:^(CJLabelLinkModel *linkModel){
            [weakself jumpToZXSDProtocolController];
        }];
        _protocolLabel.attributedText = attributedString;
        _protocolLabel.extendsLinkTouchArea = YES;
    }
    return _protocolLabel;
}

- (void)checkProtocol:(UIButton *)sender
{
    _checked = !_checked;
    UIImage *image = _checked ?UIIMAGE_FROM_NAME(@"smile_loan_agreement_selected") :UIIMAGE_FROM_NAME(@"smile_loan_agreement_unselected");
    [sender setImage:image forState:UIControlStateNormal];

    if (self.delegate && [self.delegate respondsToSelector:@selector(protocolChanged:)]) {
        [self.delegate protocolChanged:_checked];
    }
}

- (void)jumpToZXSDProtocolController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showProtocol)]) {
        [self.delegate showProtocol];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
