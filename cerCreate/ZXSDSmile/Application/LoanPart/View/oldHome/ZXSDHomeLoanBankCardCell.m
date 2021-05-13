//
//  ZXSDHomeLoanBankCardCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomeLoanBankCardCell.h"

@interface ZXSDHomeLoanBankCardCell ()

@property (nonatomic, strong) UIView *bgImageView;//背景图片
@property (nonatomic, strong) UIView *header; // 头部信息

// header's  content
@property (nonatomic, strong) UIImageView *sloganIcon;
@property (nonatomic, strong) UIImageView *companyIcon;
@property (nonatomic, strong) UIView *companyIconBG;
@property (nonatomic, strong) UILabel *companyLabel;

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *employerBtn;

// 已认证状态信息
@property (nonatomic, strong) UIImageView *bankImageView;
@property (nonatomic, strong) UIImageView *unionPayImageView;
@property (nonatomic, strong) UILabel *bankCardLabel;


// 未认证状态信息
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) ZXSDHomeLoanInfo *loanInfo;

@end

@implementation ZXSDHomeLoanBankCardCell

- (void)initView
{
    UIImage *image = [UIImage imageNamed:@"smile_home_head_bg"];
    UIImageView *headBG = [[UIImageView alloc] initWithImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 10) resizingMode:(UIImageResizingModeStretch)]];
    
    [self.contentView addSubview:headBG];
    [headBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(-STATUSBAR_HEIGHT());
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(173);
    }];
    
    [self.contentView addSubview:self.header];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.contentView).offset(0);
       make.left.right.equalTo(self.contentView);
       make.height.mas_equalTo(44);
    }];
    [self configHeader];
    
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(58);
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self).with.offset(-20);
        make.height.equalTo(self.bgImageView.mas_width).with.multipliedBy(214.0/355.0);
    }];
    
    _bgImageView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    _bgImageView.layer.shadowOpacity = 1;
    _bgImageView.layer.shadowOffset = CGSizeMake(0, 2);
    _bgImageView.layer.shadowRadius = 4;
    
    self.certifiedStatus = ZXSDCertifiedStatusNone;
}

- (void)setCertifiedStatus:(ZXSDCertifiedStatus)certifiedStatus
{
    _certifiedStatus = certifiedStatus;
    [self.bgImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (self.certifiedStatus) {
        case ZXSDCertifiedStatusNone:
            [self showCertifyingView:NO];
            break;
         case ZXSDCertifiedStatusDoing:
            [self showCertifyingView:YES];
            break;
         case ZXSDCertifiedStatusDone:
            [self showCertifiedView];
            break;
        default:
            break;
    }
    
    CGFloat ratio = 214.0/355.0;
    if (self.certifiedStatus == ZXSDCertifiedStatusDoing) {
        ratio = 264.0/355.0;
    }
    [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.bgImageView.mas_width).with.multipliedBy(ratio);
    }];
    [self.actionBtn addTarget:self action:@selector(doCertifyAction) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)freshHeader
{
    
    BOOL verifiedSmilePlus = [self.loanInfo.extraInfo.userRole isEqualToString:@"smile"] && [self.loanInfo.extraInfo.smileStatus isEqualToString:@"Accept"];
    
    if (verifiedSmilePlus && self.loanInfo.extraInfo.logoUrl.length > 0) {
        [self.companyIcon sd_setImageWithURL:[NSURL URLWithString:self.loanInfo.extraInfo.logoUrl]];
        self.companyLabel.text = self.loanInfo.extraInfo.companyName;
        self.companyIconBG.hidden = NO;
        self.companyLabel.hidden = NO;
        
        self.sloganIcon.hidden = YES;
    } else {
        self.companyIconBG.hidden = YES;
        self.companyLabel.hidden = YES;
        
        self.sloganIcon.hidden = NO;
    }
    
    /*
    if (self.loanInfo.extraInfo.companyName.length > 0) {
        _userNameLabel.text = self.loanInfo.extraInfo.companyName;
    }
    
    BOOL showEntrace = self.loanInfo.extraInfo.canEditJobInfo;
    _userNameLabel.hidden = !showEntrace;
    _employerBtn.hidden = !showEntrace;*/
    
    BOOL showEntrace = self.loanInfo.extraInfo.canEditJobInfo;
    self.employerBtn.userInteractionEnabled = showEntrace;
}

- (void)configHeader
{
    UIImageView *sloganIcon = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"home_smile_slogan")];
    [self.header addSubview:sloganIcon];
    [sloganIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.header);
        make.left.equalTo(self.header).with.offset(20);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(20);
    }];
    self.sloganIcon = sloganIcon;
    
    self.companyIconBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    self.companyIconBG.backgroundColor = [UIColor whiteColor];
    //self.companyIconBG.layer.cornerRadius = 16;
    //self.companyIconBG.clipsToBounds = YES;
    [self.header addSubview:self.companyIconBG];
    [self.companyIconBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sloganIcon);
        make.left.equalTo(self.header).with.offset(20);
        make.width.height.mas_equalTo(36);
    }];
    self.companyIconBG.hidden = YES;
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.companyIconBG.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
    cornerRadiusLayer.frame = self.companyIconBG.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    self.companyIconBG.layer.mask = cornerRadiusLayer;
    
    
    UIImageView *companyIcon = [UIImageView new];
    [self.companyIconBG addSubview:companyIcon];
    [companyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.companyIconBG);
        make.width.height.mas_equalTo(32);
    }];
    self.companyIcon = companyIcon;
    
    UILabel *companyLabel = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:FONT_PINGFANG_X_Medium(16)];
    [self.header addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sloganIcon);
        make.left.equalTo(self.companyIconBG.mas_right).with.offset(10);
    }];
    companyLabel.hidden = YES;
    self.companyLabel = companyLabel;
    
    //
    UIButton *employerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    employerBtn.backgroundColor = [UIColor clearColor];
    [employerBtn addTarget:self action:@selector(doEmployerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:employerBtn];
    [employerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.header);
        make.left.equalTo(self.header).with.offset(20);
        make.width.mas_equalTo(120);
    }];
    self.employerBtn = employerBtn;
    
    /* 右边内容
    UIImage *image = [UIIMAGE_FROM_NAME(@"smile_add_icon") imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    UIButton *employerBtn = [UIButton buttonWithNormalImage:image highlightedImage:nil];
    employerBtn.tintColor = [UIColor whiteColor];
    employerBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
    [employerBtn addTarget:self action:@selector(doEmployerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:employerBtn];
    [employerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sloganIcon);
        make.right.equalTo(self.header).with.offset(-20);
        make.width.height.mas_equalTo(20);
        
    }];
    employerBtn.hidden = YES;
    self.employerBtn = employerBtn;
    
    
    self.userNameLabel = [UILabel labelWithText:@"雇主" textColor:[UIColor whiteColor] font:FONT_PINGFANG_X(14)];
    [self.header addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(employerBtn);
        make.right.equalTo(employerBtn.mas_left).with.offset(-5);
    }];
    self.userNameLabel.hidden = YES;
    */
}

- (void)showCertifyingView:(BOOL)certifying
{
    [self.bgImageView addSubview:self.actionBtn];
    [self.bgImageView addSubview:self.tipsLabel];
    
    UILabel *limitLabel = [UILabel labelWithText:@"最高预支额度 (¥)" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(14)];
    limitLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:limitLabel];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgImageView);
        make.top.equalTo(self.bgImageView).with.offset(20);
    }];
    
    UILabel *amountLabel = [UILabel labelWithText:@"2,000.00" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(40)];
    if (iPhone4() || iPhone5()) {
        amountLabel.font = FONT_PINGFANG_X(24);
    }
    
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgImageView);
        make.top.equalTo(limitLabel.mas_bottom).with.offset(2);
    }];
    
    UILabel *tipLabel = [UILabel labelWithText:@"企业合作员工，每月免费获得 ¥500" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgImageView);
        make.top.equalTo(amountLabel.mas_bottom).with.offset(12);
    }];
    
    
    if (certifying) {
        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView).offset(20);
            make.right.equalTo(self.bgImageView).offset(-20);
            make.top.equalTo(tipLabel.mas_bottom).with.offset(20);
            make.height.mas_equalTo(44);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = UICOLOR_FROM_HEX(0xE8E8E8);
        [self.bgImageView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView).offset(16);
            make.right.equalTo(self.bgImageView).offset(-16);
            make.top.equalTo(self.actionBtn.mas_bottom).with.offset(20);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(line);
            make.top.equalTo(line.mas_bottom).with.offset(16);
            make.bottom.equalTo(self.bgImageView).with.offset(-16);
        }];
    } else {
        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView).offset(20);
            make.right.equalTo(self.bgImageView).offset(-20);
            make.top.equalTo(tipLabel.mas_bottom).with.offset(20);
            make.height.mas_equalTo(44);
            make.bottom.equalTo(self.bgImageView).with.offset(-20);
        }];
    }
    
    [self.actionBtn setTitle:certifying?@"继续认证":@"立刻认证" forState:(UIControlStateNormal)];
}

- (void)showCertifiedView
{
    if (self.loanInfo.extraInfo.vaActivitySwitch) {
        [self showActivityOfVA];
        return;
    }
    
    [self.bgImageView addSubview:self.bankImageView];
    [self.bgImageView addSubview:self.bankCardLabel];
    [self.bgImageView addSubview:self.unionPayImageView];
    
    [self.bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).with.offset(20);
        make.top.equalTo(self.bgImageView).with.offset(20);
    }];
    
    [self.bankCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(20);
        make.right.equalTo(self.bgImageView).offset(-20);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.unionPayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.bgImageView).with.offset(-20);
        make.bottom.equalTo(self.bgImageView).with.offset(-20);
    }];
}

- (void)showActivityOfVA
{
    UILabel *nameLabel = [UILabel labelWithText:@"VA 新人专享福利" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X_Medium(18)];
    nameLabel.userInteractionEnabled = YES;
    
    UIButton *shareBtn = [UIButton buttonWithNormalImage:UIIMAGE_FROM_NAME(@"home_va_share") highlightedImage:nil];
    [shareBtn addTarget:self action:@selector(shareActivity) forControlEvents:(UIControlEventTouchUpInside)];
    shareBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-35, -30, -25, -35);
    
    UILabel *descLabel = [UILabel labelWithText:@"预支后即可领取 ¥100" textColor:UICOLOR_FROM_HEX(0xA0AFC3) font:FONT_PINGFANG_X(14)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:descLabel.text];
    [attributedString addAttributes: @{
        NSForegroundColorAttributeName:kThemeColorMain} range:NSMakeRange(descLabel.text.length - 4, 4)];
    descLabel.attributedText = attributedString;
    
    
    UIButton *btn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"立刻领取" textColor:kThemeColorMain];
    btn.backgroundColor = UICOLOR_FROM_HEX(0xF7F9FB);
    btn.layer.cornerRadius = 16;
    [btn addTarget:self action:@selector(joinActivity) forControlEvents:(UIControlEventTouchUpInside)];
    btn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -15, -25, -25);
    
    UIImageView *activity = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"home_va_activity")];
    
    [self.bgImageView addSubview:activity];
    [self.bgImageView addSubview:nameLabel];
    [self.bgImageView addSubview:shareBtn];
    [self.bgImageView addSubview:descLabel];
    [self.bgImageView addSubview:btn];
    
    
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView).offset(-16);
        make.width.mas_equalTo(133);
        make.height.mas_equalTo(120);
        make.centerY.equalTo(self.bgImageView);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(40);
        make.left.equalTo(self.bgImageView).offset(16);
        make.right.equalTo(activity.mas_left).offset(-10);
    }];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nameLabel.mas_right).offset(8);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(21);
        make.centerY.equalTo(nameLabel);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(8);
        make.left.right.equalTo(nameLabel);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(24);
        make.left.equalTo(nameLabel);
        make.width.mas_equalTo(102);
        make.height.mas_equalTo(32);
    }];
    
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDHomeLoanInfo class]]) {
        return;
    }
    
    ZXSDHomeLoanInfo *info = renderData;
    BOOL lighted = info.extraInfo.userBank2Done;
    self.bankImageView.image = UIIMAGE_FROM_NAME(lighted ? @"smile_bankcard_logo": @"smile_bankcard_logo_gray");
    self.unionPayImageView.image = UIIMAGE_FROM_NAME(lighted ? @"smile_bank_unionpay": @"smile_bank_unionpay_gray");
    
    self.bankCardLabel.text = [self formatBankCardNumber:info.loanModel.bank2Number];
    self.loanInfo = info;
    
    [self freshHeader];
}

- (NSString *)formatBankCardNumber:(NSString *)number
{
    NSMutableString *result = [NSMutableString stringWithString:number];
    for (int k = 0; k < number.length; k++) {
        if (k > 0 && k % 4 == 0) {
            [result insertString:@"#" atIndex:k+(k/4 - 1)];
        }
    }
    
    [result replaceOccurrencesOfString:@"#" withString:@"      " options:(NSLiteralSearch) range:NSMakeRange(0, result.length)];
    
    return result;
}

- (void)renderButton:(UIButton *)button highlighted:(BOOL)highlighted
{
    UIColor *color = highlighted?kThemeColorMain:UICOLOR_FROM_HEX(0x999999);
    
    [button setTitleColor:color forState:(UIControlStateNormal)];
    button.layer.cornerRadius = 8;
    button.layer.borderWidth = 1.5;
    button.layer.borderColor = color.CGColor;
    
}

#pragma mark - Action

- (void)doCertifyAction
{
    if (self.certifiedAction) {
        self.certifiedAction();
    }
}

- (void)doEmployerAction
{
    if (self.employerAction) {
        self.employerAction();
    }
}

- (void)joinActivity
{
    if (self.activityAction) {
        self.activityAction();
    }
}

- (void)shareActivity
{
   if (self.shareAction) {
        self.shareAction();
    }
}

#pragma mark - Getter

- (UIView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [UIView new];
        _bgImageView.backgroundColor = [UIColor whiteColor];
        _bgImageView.layer.cornerRadius = 8;
    }
    return _bgImageView;
}

- (UIImageView *)bankImageView
{
    if (!_bankImageView) {
        _bankImageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_bankcard_logo_gray")];
    }
    return _bankImageView;
}

- (UIImageView *)unionPayImageView
{
    if (!_unionPayImageView) {
        _unionPayImageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_bank_unionpay_gray")];
    }
    return _unionPayImageView;
}

- (UILabel *)bankCardLabel
{
    if (!_bankCardLabel) {
        _bankCardLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_SFUI_X_Medium(20)];
        _bankCardLabel.adjustsFontSizeToFitWidth = YES;
        
    }
    return _bankCardLabel;
}

- (UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [UIButton buttonWithFont:FONT_PINGFANG_X_Medium(16) title:@"立刻认证" textColor:UICOLOR_FROM_HEX(0xFFFFFF)];
        [_actionBtn setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        _actionBtn.layer.cornerRadius = 20;
        
        _actionBtn.layer.shadowColor = [kThemeColorMain colorWithAlphaComponent:0.4].CGColor;
        _actionBtn.layer.shadowOpacity = 0;
        _actionBtn.layer.shadowOffset = CGSizeMake(0, 4);
        _actionBtn.layer.shadowRadius = 4;
        _actionBtn.layer.masksToBounds = YES;
        
    }
    return _actionBtn;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel labelWithText:@"您还未完成认证，请继续完成" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UIView *)header
{
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 44)];
        _header.backgroundColor = [UIColor clearColor];
    }
    return _header;
}

@end
