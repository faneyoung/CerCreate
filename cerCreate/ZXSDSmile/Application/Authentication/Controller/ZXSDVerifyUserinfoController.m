//
//  ZXSDVerifyUserinfoController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDVerifyUserinfoController.h"
#import "CJLabel.h"
#import "ZXSDVerifyBankCardController.h"
#import "ZXSDBaseTabBarController.h"
#import "ZXSDLoginService.h"

static const NSString *EMPLOYER_CONFIRM_URL = @"/rest/company/confirm";

@interface ZXSDVerifyUserinfoController ()

@property (nonatomic, strong) UIImageView *employerBrandView;
@property (nonatomic, strong) CJLabel *protocolLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *reReloginButton;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UILabel *charLabel;

@property (nonatomic, assign) BOOL checked;

@end

@implementation ZXSDVerifyUserinfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"雇主审核";
    if (!self.company) {
        self.company = [[ZXSDCurrentUser currentUser] company];
    }
    [self addUserInterfaceConfigure];
}

- (void)backButtonClicked:(id)sender
{
    if (self.forbidBack) {
        return;
    }
    
    NSMutableArray *tmpVCs = self.navigationController.viewControllers.mutableCopy;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"ZXSDNecessaryCertFourthStepController")]) {
            [tmpVCs removeObject:obj];
            *stop = YES;
        }
    }];
    
    self.navigationController.viewControllers = tmpVCs.copy;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addUserInterfaceConfigure
{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(350);
    }];
    
    
    UIImageView *leftView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"verify_brand_smile")];
    [header addSubview:leftView];
    
    UIImageView *centerView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"verify_center_icon")];
    [header addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.centerX.equalTo(header);
        make.top.equalTo(header).offset(57);
    }];
    
    self.employerBrandView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"verify_brand_va")];
    [header addSubview:self.employerBrandView];
    
    UIView *leftLine = [UIView new];
    leftLine.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF2);
    [header addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView.mas_left).offset(-5);
        make.height.mas_equalTo(.75);
        make.width.mas_equalTo(20);
        make.centerY.equalTo(centerView);
    }];
    
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF2);
    [header addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_right).offset(5);
        make.height.mas_equalTo(.75);
        make.width.mas_equalTo(20);
        make.centerY.equalTo(centerView);
    }];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(56);
        make.centerY.equalTo(centerView);
        make.right.equalTo(leftLine.mas_left).offset(-12);
    }];
    
    [self.employerBrandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(56);
        make.centerY.equalTo(centerView);
        make.left.equalTo(rightLine.mas_right).offset(12);
    }];
    
    if (CHECK_VALID_STRING(self.company.logoUrl)) {
        [self.employerBrandView sd_setImageWithURL:[NSURL URLWithString:self.company.logoUrl] placeholderImage:nil];
    } else {
        [header addSubview:self.charLabel];
        [self.charLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(56);
            make.centerY.equalTo(centerView);
            make.left.equalTo(rightLine.mas_right).offset(12);
        }];
        self.charLabel.text = [self transformToPinyin:self.company.shortName];
    }
    
    NSString *tips = [NSString stringWithFormat:@"%@ 是您在“%@”预留的手机号码吗？",[ZXSDCurrentUser currentUser].phone, self.company.companyName];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:tips];
    [attr addAttributes:@{NSFontAttributeName:FONT_SFUI_X_Medium(16)} range:NSMakeRange(0, [ZXSDCurrentUser currentUser].phone.length)];
    
    UILabel *infoLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(16)];
    infoLabel.attributedText = attr;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 2;
    [header addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(24);
        make.right.equalTo(header).offset(-24);
        make.top.equalTo(centerView.mas_bottom).offset(57);
    }];
    
    UIButton *check = [UIButton buttonWithNormalImage:UIIMAGE_FROM_NAME(@"smile_loan_agreement_unselected") highlightedImage:nil];
    check.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -20, -15);
    [check addTarget:self action:@selector(checkProtocol:) forControlEvents:(UIControlEventTouchUpInside)];
    [header addSubview:check];
    [check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(20);
        make.width.height.mas_equalTo(20);
        make.top.equalTo(infoLabel.mas_bottom).offset(40);
    }];
    [header addSubview:self.protocolLabel];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(check.mas_right).offset(16);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(check);
    }];
    
    [header addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(20);
        make.right.equalTo(header).offset(-20);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.protocolLabel.mas_bottom).offset(40);
    }];
    
    //[self buildFooterView];
    
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    [self.footer mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (void)buildFooterView
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footer];
    [footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    self.footer = footer;
    
    UILabel *tips = [UILabel labelWithText:@"如果不是，请重新登录" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(16)];
    tips.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footer);
        make.top.equalTo(footer).offset(5);
    }];
    
    UIView *leftLine = [UIView new];
    leftLine.backgroundColor = UICOLOR_FROM_HEX(0xCCD6DD);
    [footer addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tips.mas_left).offset(-18);
        make.left.equalTo(footer).offset(20);
        make.height.mas_equalTo(.5);
        make.centerY.equalTo(tips);
    }];
    
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = UICOLOR_FROM_HEX(0xCCD6DD);
    [footer addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tips.mas_right).offset(18);
        make.right.equalTo(footer).offset(-20);
        make.height.mas_equalTo(.5);
        make.centerY.equalTo(tips);
    }];
    
    [footer addSubview:self.reReloginButton];
    [self.reReloginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer).offset(44);
        make.right.equalTo(footer).offset(-44);
        make.height.mas_equalTo(44);
        make.top.equalTo(tips.mas_bottom).offset(40);
    }];
}

#pragma mark - Action
- (void)jumpToZXSDProtocolController
{
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,PRIVACY_AGREEMENT_URL];
    
    viewController.title = @"隐私保护指引";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)checkProtocol:(UIButton *)sender
{
    _checked = !_checked;
    UIImage *image = _checked ?UIIMAGE_FROM_NAME(@"smile_loan_agreement_selected") :UIIMAGE_FROM_NAME(@"smile_loan_agreement_unselected");
    [sender setImage:image forState:UIControlStateNormal];
}

- (void)verifyUserInfoAction
{
    if (!self.checked) {
        [self showToastWithText:@"请先同意协议"];
        return;
    }
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,EMPLOYER_CONFIRM_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"确认雇主员工信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            BOOL success = [[responseObject objectForKey:@"success"] boolValue];
            NSString *message = [responseObject objectForKey:@"message"];
            BOOL bindBankCard = [[responseObject objectForKey:@"value"] boolValue];
            [ZXSDCurrentUser currentUser].bindBankCard = bindBankCard;
            
            // 处理成功
            if (success) {
                [self toConfirmBankCardInfo:bindBankCard];
            } else {
                [self showToastWithText:message];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)reLoginAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_USERLOGOUT object:nil];
}

- (void)toConfirmBankCardInfo:(BOOL)bindCard
{
    ZXSDVerifyBankCardController *vc = [ZXSDVerifyBankCardController new];
    vc.bindCard = bindCard;
    [vc setBindCardCompleted:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [self gotoMainHome];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoMainHome
{
    // 是从登录流程进入的
    if (self.fromLogin) {
        [ZXSDLoginService gotoMainHome:self.navigationController];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (NSString *)transformToPinyin:(NSString *)source
{
    NSMutableString *str = [NSMutableString stringWithString:source];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);

    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}


#pragma mark - Getter
- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(verifyUserInfoAction) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

- (UIButton *)reReloginButton
{
    if (!_reReloginButton) {
        _reReloginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_reReloginButton setBackgroundImage:[UIImage resizableImageWithGradient:@[UICOLOR_FROM_HEX(0xF7F9FB),UICOLOR_FROM_HEX(0xEAEFF2)] direction:UIImageGradientDirectionHorizontal] forState:(UIControlStateNormal)];
        [_reReloginButton setTitleColor:UICOLOR_FROM_HEX(0x626F8A) forState:UIControlStateNormal];
        [_reReloginButton addTarget:self action:@selector(reLoginAction) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_reReloginButton setTitle:@"重新登录" forState:UIControlStateNormal];
        _reReloginButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        _reReloginButton.layer.cornerRadius = 22.0;
        _reReloginButton.layer.masksToBounds = YES;
    }
    return _reReloginButton;
}

- (CJLabel *)protocolLabel
{
    if (!_protocolLabel) {
        NSString *protocolString = @"阅读即代表已同意《隐私保护指引》并确认授权";
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
                                                       withString:@"《隐私保护指引》"
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

- (UILabel *)charLabel
{
    if (!_charLabel) {
        _charLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xFFFFFF) font:FONT_PINGFANG_X_Medium(24)];
        _charLabel.textAlignment = NSTextAlignmentCenter;
        _charLabel.backgroundColor = kThemeColorMain;
        _charLabel.layer.cornerRadius = 28;
        _charLabel.clipsToBounds = YES;
    }
    return _charLabel;
}

@end
