//
//  ZXSDPhoneNumberLoginController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDPhoneNumberLoginController.h"
#import "ZXSDPhoneNumberVerifySMSCodeController.h"
#import "CJLabel.h"
#import "UITextField+ExtendRange.h"

static const NSString *SEND_SMSCODE_URL = @"/rest/anon/sms";

@interface ZXSDPhoneNumberLoginController ()<UITextFieldDelegate> {
    UITextField *_phoneNumberTextField;
    UILabel *_selectLabel;
    UIButton *_confirmButton;
    NSInteger index;
}

@end

@implementation ZXSDPhoneNumberLoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
    
    // 去掉页面关闭按钮
    if (!self.isCanBack) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [ZXAppTrackManager event:kPhoneLoginInputPage];
}

- (void)backButtonClicked:(id)sender
{
    if (self.isCanBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)prepareDataConfigure {
    index = 0;
}

- (void)addUserInterfaceConfigure {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"手机号登录";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [self.view addSubview:titleLabel];
    
    UILabel *changeLab = [UILabel labelWithText:@"原手机号如已变更, " textColor:UIColorFromHex(0x999999) font:FONT_PINGFANG_X(14)];
    changeLab.frame = CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 10, 0, 0);
    [self.view addSubview:changeLab];
    [changeLab sizeToFit];
    
    UIButton *changeBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"点击更换绑定" textColor:kThemeColorMain];
    changeBtn.frame = CGRectMake(CGRectGetMaxX(changeLab.frame), CGRectGetMinY(changeLab.frame), 180, 20);
    changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:changeBtn];
    [changeBtn bk_addEventHandler:^(id sender) {
        NSLog(@"----------");
        [URLRouter routerUrlWithPath:kRouter_modifyPhone extra:@{@"pageType":@(1),@"backViewController":self}];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(changeLab.frame) + 10, SCREEN_WIDTH() - 40, 20)];
    promptLabel.text = @"未登录手机号登录后自动注册";
    promptLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    [self.view addSubview:promptLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(promptLabel.frame) + 88, SCREEN_WIDTH() - 40, SEPARATE_SINGLE_LINE_WIDTH())];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xE8E8E8);
    [self.view addSubview:lineView];
    
    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(promptLabel.frame) + 20, SCREEN_WIDTH() - 40, 48)];
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberTextField.placeholder = @"请输入手机号码";
    _phoneNumberTextField.textColor = UICOLOR_FROM_HEX(0x333333);
    _phoneNumberTextField.font = FONT_SFUI_X_Regular(20);
    _phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumberTextField.delegate = self;
    
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc] initWithString:_phoneNumberTextField.placeholder attributes:@{NSForegroundColorAttributeName : UICOLOR_FROM_HEX(0xCCCCCC),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:20.0]}];
    _phoneNumberTextField.attributedPlaceholder = arrStr;
    
    [self.view addSubview:_phoneNumberTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:_phoneNumberTextField];
    [_phoneNumberTextField addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *leftBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 69, 48)];
    leftBackView.backgroundColor = [UIColor clearColor];
    leftBackView.userInteractionEnabled = YES;
    
    _selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 48)];
    _selectLabel.text = @"+86  ";
    _selectLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    _selectLabel.font = FONT_SFUI_X_Regular(20);
    [leftBackView addSubview:_selectLabel];
    
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 24, 48)];
    logoLabel.text = @"▼";
    logoLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    logoLabel.font = [UIFont systemFontOfSize:12.0];
    [leftBackView addSubview:logoLabel];
    
    UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountryCode)];
    [leftBackView addGestureRecognizer:selectTap];

    _phoneNumberTextField.leftView = leftBackView;
    _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(20, CGRectGetMaxY(lineView.frame) + 20, SCREEN_WIDTH() - 40, 44);
    _confirmButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
    [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xCCCCCC) forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.layer.cornerRadius = 22.0;
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.userInteractionEnabled = NO;
    [self.view addSubview:_confirmButton];
    
    NSString *protocolString = @"登录即代表已同意《薪朋友用户服务协议》、《薪朋友平台用户隐私政策》和《个人综合信息授权书》";
    UIFont *currentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
    if (iPhone4() || iPhone5()) {
        currentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11.0];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:protocolString];
    CJLabel *protocolLabel = [[CJLabel alloc] initWithFrame:CGRectZero];
//    if (iPhoneXSeries()) {
//        CGFloat safeAreaHeight = 34;
//        protocolLabel.frame = CGRectMake(20, SCREEN_HEIGHT() - 40 - safeAreaHeight - NAVIBAR_HEIGHT(), SCREEN_WIDTH() - 40, 20);
//    }
    protocolLabel.numberOfLines = 0;
    protocolLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:protocolLabel];
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(30);
        make.bottom.inset(kBottomSafeAreaHeight+40);
    }];
    
    WEAKOBJECT(self);
    attributedString = [CJLabel configureAttributedString:attributedString
                                                  atRange:NSMakeRange(0, attributedString.length)
                                               attributes:@{
                                                   NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x999999),
                                                   NSFontAttributeName:currentFont,
                                               }];
    attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                   withString:@"《薪朋友用户服务协议》"
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
    
    attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                   withString:@"《薪朋友平台用户隐私政策》"
                                             sameStringEnable:NO
                                               linkAttributes:@{
                                                   NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                   NSFontAttributeName:currentFont,
                                               }
                                         activeLinkAttributes:nil
                                                    parameter:nil
                                               clickLinkBlock:^(CJLabelLinkModel *linkModel){
        [weakself jumpToPrivacyAgreementController];
    }longPressBlock:^(CJLabelLinkModel *linkModel){
        [weakself jumpToPrivacyAgreementController];
    }];

    attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                   withString:@"《个人综合信息授权书》"
                                             sameStringEnable:NO
                                               linkAttributes:@{
                                                   NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                   NSFontAttributeName:currentFont,
                                               }
                                         activeLinkAttributes:nil
                                                    parameter:nil
                                               clickLinkBlock:^(CJLabelLinkModel *linkModel){
        [weakself jumpToPersernalPrivacyAgreementController];
    }longPressBlock:^(CJLabelLinkModel *linkModel){
        [weakself jumpToPersernalPrivacyAgreementController];
    }];
    
    
    protocolLabel.attributedText = attributedString;
    protocolLabel.extendsLinkTouchArea = YES;
}


//选择国家区号，功能待设计提供并完善
- (void)selectCountryCode {
    ZGLog(@"暂未实现，等待相关设计内容");
}

//跳转验证短信码
- (void)confirmButtonClicked:(UIButton *)btn {
    NSString *phoneString = [_phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![phoneString validateStringIsPhoneNumberFormate]) {
        [self showToastWithText:@"请正确填写手机号码"];
    } else {
        [self hideKeyboard];
        btn.userInteractionEnabled = NO;
        
        NSDictionary *dic = @{@"phone":phoneString};
        [self showLoadingProgressHUDWithText:@"正在加载..."];

        AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
        [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,SEND_SMSCODE_URL] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dismissLoadingProgressHUD];
            btn.userInteractionEnabled = YES;
            ZGLog(@"发送验证码接口成功返回数据---%@",responseObject);

            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *smsCodeToken = [[responseObject objectForKey:@"otpCodeToken"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"otpCodeToken"];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ZXSDPhoneNumberVerifySMSCodeController *viewController = [ZXSDPhoneNumberVerifySMSCodeController new];
                    viewController.phoneString = self->_phoneNumberTextField.text;
                    viewController.phoneNumber = phoneString;
                    viewController.smsCodeToken = smsCodeToken;
                    [self.navigationController pushViewController:viewController animated:YES];
                });
            } else {
                [self showToastWithText:@"验证码发送失败"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self dismissLoadingProgressHUDImmediately];
            btn.userInteractionEnabled = YES;
            [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"验证码获取失败"];
        }];
    }
}

//跳转至众薪速达协议
- (void)jumpToZXSDProtocolController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,USER_SERVICE_URL];
    
    viewController.title = @"薪朋友用户服务协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

//跳转至隐私保护指引
- (void)jumpToPrivacyAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,PRIVACY_AGREEMENT_URL];
    
    viewController.title = @"薪朋友平台用户隐私政策";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)jumpToPersernalPrivacyAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,PERSONAL_INFO_AGREEMENT_URL];
    
    viewController.title = @"个人综合信息授权书";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Hide Keyboard
- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    NSString *phoneString = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    _confirmButton.userInteractionEnabled = phoneString.length >= 11;
    _confirmButton.backgroundColor = _confirmButton.userInteractionEnabled ? kThemeColorMain : UICOLOR_FROM_HEX(0xF5F5F5);
    [_confirmButton setTitleColor:_confirmButton.userInteractionEnabled ? [UIColor whiteColor] : UICOLOR_FROM_HEX(0xCCCCCC) forState:UIControlStateNormal];
}

- (void)textFieldDidEditing:(UITextField *)textField {
    if (textField.text.length > index) {
        if (textField.text.length == 4 || textField.text.length == 9 ) {
            //输入
            NSMutableString *string = [[NSMutableString alloc] initWithString:textField.text];
            [string insertString:@" " atIndex:(textField.text.length - 1)];
            textField.text = string;
        } if (textField.text.length >= 13) {
            //输入完成
            textField.text = [textField.text substringToIndex:13];
        }
        index = textField.text.length;
    } else if (textField.text.length < index) {
        //删除
        if (textField.text.length == 4 || textField.text.length == 9) {
            textField.text = [NSString stringWithFormat:@"%@",textField.text];
            textField.text = [textField.text substringToIndex:(textField.text.length - 1)];
        }
        index = textField.text.length;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *phoneNumber = [beingString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //校验手机号号只能是数字，且不能超过11位
    if ((string.length != 0 && ![phoneNumber validateStringIsIntegerFormate]) || phoneNumber.length > 11) {
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
