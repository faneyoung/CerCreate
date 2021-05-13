//
//  ZXSDUploadBankDetailsController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/16.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDUploadBankDetailsController.h"
#import "ZXSDUploadDetailsResultController.h"
#import "ZXSDCertificationCenterController.h"
#import "ZXSDCerFlowInfoModel.h"
#import "TPKeyboardAvoidingScrollView.h"
//#import <UIView+YYAdd.h>

static const NSString *GET_BANKCARD_DETAILS_URL = @"/rest/certificate/getEmail?certType=cert_wage_flow";
static const NSString *UPLOAD_BANKCARD_DETAILS_URL = @"/rest/certificate/submit";

@interface ZXSDUploadBankDetailsController ()<UITextFieldDelegate> {
    UILabel *_bankDetailsLabel;
    UILabel *_contentLabel;
    UILabel *_emailLabel;
    UITextField *_zipTextField;
    UIView *_lineView;
    UIButton *_submitButton;
    
    NSString *_bankName;
    NSString *_bankDetails;
    NSString *_email;
    NSString *_flowCode;
    
    TPKeyboardAvoidingScrollView *_scrollView;
    
    BOOL _isShowZipTextField;//是否显示输入框
    BOOL _isNecessaryInput;//是否必须填写解压码
}

@end

@implementation ZXSDUploadBankDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传工资明细";
    self.enableInteractivePopGesture = self.enablePopGesture;
    
    [self addUserInterfaceConfigure];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    TrackEvent(kSalary);
}

- (void)backButtonClicked:(id)sender
{
    BOOL isFinded = NO;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[ZXSDCertificationCenterController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            isFinded = YES;
        }
    }
    if (!isFinded) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareDataConfigure];
}

- (void)prepareDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,GET_BANKCARD_DETAILS_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取银行卡账单邮箱信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        ZXSDCerFlowInfoModel *model = [ZXSDCerFlowInfoModel modelWithJSON:responseObject];
        self->_bankDetails = model.title;
        self->_email = model.recipient;
        self->_bankName = model.flowFullName;
        self->_flowCode = model.flowCode;
        
        self->_isShowZipTextField = model.encrypted;
        self->_isNecessaryInput = model.forceEncrypted;
        
        [self updateUserInterfaceConfigure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)addUserInterfaceConfigure {
    _scrollView = [TPKeyboardAvoidingScrollView new];
    _scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT() - NAVIBAR_HEIGHT());
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    _bankDetailsLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xC8A028) font:FONT_PINGFANG_X(12)];
    _bankDetailsLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 40);
    _bankDetailsLabel.textAlignment = NSTextAlignmentCenter;
    _bankDetailsLabel.backgroundColor = UIColorFromHex(0xFFF4D4);
    [_scrollView addSubview:_bankDetailsLabel];
    
    
    UIImageView *bankImageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"icon_upload_detail")];
    bankImageView.frame = CGRectMake((SCREEN_WIDTH() - 219)/2, CGRectGetMaxY(_bankDetailsLabel.frame) + 40, 219, 166);
    bankImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:bankImageView];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(bankImageView.frame) + 15, SCREEN_WIDTH() - 2*60, 40)];
    _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH() - 2*60;
    _contentLabel.numberOfLines = 2;
    _contentLabel.text = @"选择至少 1 年的工资卡收支明细\n并发送到邮箱";
    _contentLabel.textColor = TextColorSubTitle;
    _contentLabel.font = FONT_PINGFANG_X(14);
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_contentLabel];
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentLabel.frame) + 40, SCREEN_WIDTH(), 8)];
    sepView.backgroundColor = kThemeColorLine;
    [_scrollView addSubview:sepView];

    UILabel *emailTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sepView.frame)+16, 60, 20)];
    emailTitleLab.font = FONT_PINGFANG_X(14.0);
    emailTitleLab.textColor = TextColorTitle;
    emailTitleLab.text =@"复制邮箱";
    [_scrollView addSubview:emailTitleLab];
    
    _emailLabel = [[UILabel alloc] init];
    _emailLabel.font = FONT_PINGFANG_X(14);
    _emailLabel.textColor = TextColorgray;
    _emailLabel.textAlignment = NSTextAlignmentRight;
    _emailLabel.frame = CGRectMake(emailTitleLab.right+10, sepView.bottom, SCREEN_WIDTH()-46-(emailTitleLab.right+10), 52);

    [_scrollView addSubview:_emailLabel];
    
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.frame = CGRectMake(_emailLabel.right, _emailLabel.top, 46, 52);
    [copyButton setImage:UIIMAGE_FROM_NAME(@"smile_email_copy") forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(copyEmail) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:copyButton];

    
    _zipTextField = [[UITextField alloc] init];
    _zipTextField.frame = CGRectMake(20, sepView.bottom+52, SCREEN_WIDTH()-2*20, 40);
    _zipTextField.placeholder = @"请输入";
    _zipTextField.keyboardType = UIKeyboardTypeAlphabet;
    _zipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _zipTextField.font = FONT_SFUI_X_Regular(14);
    _zipTextField.textColor = UICOLOR_FROM_HEX(0x3C465A);
    _zipTextField.delegate = self;
    
    UIView *leftBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 69, 40)];
    leftBackView.backgroundColor = [UIColor clearColor];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 69, 40)];
    leftLabel.text = @"解压密码";
    leftLabel.textColor = UICOLOR_FROM_HEX(0x3C465A);
    leftLabel.font = FONT_PINGFANG_X(14);
    [leftBackView addSubview:leftLabel];
    
    _zipTextField.leftView = leftBackView;
    _zipTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:_zipTextField];
    _zipTextField.hidden = YES;
    [_scrollView addSubview:_zipTextField];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_zipTextField.frame) + 10, SCREEN_WIDTH() - 40, SEPARATE_SINGLE_LINE_WIDTH())];
    _lineView.backgroundColor = UICOLOR_FROM_HEX(0xDDDDDD);
    _lineView.hidden = YES;
    [_scrollView addSubview:_lineView];
    
    CGFloat safaAreaBottom = iPhoneXSeries() ? 34 : 0;
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 64 - 44 - safaAreaBottom, SCREEN_WIDTH() - 40, 44);
    _submitButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [_submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.cornerRadius = 22.0;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.hidden = YES;
    [self.view addSubview:_submitButton];
    
    UILabel *bankGuideLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 24 - 20 - safaAreaBottom, SCREEN_WIDTH() - 40, 20)];
    bankGuideLabel.text = @"如何上传？";
    bankGuideLabel.textColor = UICOLOR_FROM_HEX(0x5886E2);
    bankGuideLabel.font = FONT_PINGFANG_X(14);
    bankGuideLabel.textAlignment = NSTextAlignmentCenter;
    bankGuideLabel.userInteractionEnabled = YES;
    [self.view addSubview:bankGuideLabel];
    
    UITapGestureRecognizer *bankGuideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToBankGuideH5)];
    [bankGuideLabel addGestureRecognizer:bankGuideTap];
}

- (void)updateUserInterfaceConfigure {
    _bankDetailsLabel.text = _bankDetails;
    _submitButton.hidden = NO;
    
//    CGSize emailSize = [ZXSDPublicClassMethod labelAutoCalculateRectWith:_email Font:_emailLabel.font MaxSize:CGSizeMake(MAXFLOAT, 20)];
//    _emailLabel.frame = CGRectMake((SCREEN_WIDTH() - emailSize.width)/2 - 15, CGRectGetMaxY(_contentLabel.frame) + 20, emailSize.width, emailSize.height);
    _emailLabel.text = _email;
    
//    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    copyButton.frame = CGRectMake(CGRectGetMaxX(_emailLabel.frame) + 15, CGRectGetMaxY(_contentLabel.frame) + 24, 12, 12);
//    [copyButton setBackgroundImage:UIIMAGE_FROM_NAME(@"smile_email_copy") forState:UIControlStateNormal];
//    [copyButton addTarget:self action:@selector(copyEmail) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollView addSubview:copyButton];
    
//#warning --test--
//    _isShowZipTextField = YES;
//#warning --test--

    if (_isShowZipTextField) {
        if (_isNecessaryInput) {
            _zipTextField.hidden = NO;
            _lineView.hidden = NO;
            
            _submitButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
            [_submitButton setTitleColor:UICOLOR_FROM_HEX(0xCCCCCC) forState:UIControlStateNormal];
            _submitButton.userInteractionEnabled = NO;
        } else {
            _zipTextField.hidden = NO;
            _lineView.hidden = NO;
            
            _submitButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
            [_submitButton setTitleColor:UICOLOR_FROM_HEX(0xCCCCCC) forState:UIControlStateNormal];
            _submitButton.userInteractionEnabled = NO;
            
            UIView *rightBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 40)];
            rightBackView.backgroundColor = [UIColor clearColor];
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.frame = CGRectMake(0, 0, 55, 40);
            [rightButton setTitle:@"无密码" forState:UIControlStateNormal];
            [rightButton setTitleColor:kThemeColorMain forState:UIControlStateNormal];
            rightButton.titleLabel.font = FONT_PINGFANG_X(14);
            [rightButton addTarget:self action:@selector(noZipCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [rightBackView addSubview:rightButton];
            
            _zipTextField.rightView = rightBackView;
            _zipTextField.rightViewMode = UITextFieldViewModeAlways;
        }
    }
    
    [self.view layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSLog(@"----------%@",self->_submitButton);
        
        self->_scrollView.contentSize = CGSizeMake(SCREEN_WIDTH(), CGRectGetMaxY(self->_zipTextField.frame) + 64 + 44 + 2*20 + kBottomSafeAreaHeight);
        [self.view layoutIfNeeded];
    });
    
    
}

- (void)copyEmail {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (IsValidString(_email)) {
        pasteboard.string = _email;
    }
    [self showToastWithText:@"复制邮箱成功"];
}

- (void)noZipCodeButtonClicked {
    _zipTextField.hidden = YES;
    _lineView.hidden = YES;
    
    _isShowZipTextField = NO;
    _submitButton.userInteractionEnabled = YES;
    _submitButton.backgroundColor = kThemeColorMain;
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)submitButtonClicked {
    NSDictionary *parameters;
    NSString *certificateType = @"cert_wage_flow";
    if (_isShowZipTextField ) {
        if (_isNecessaryInput) {
            //必填解压码
            parameters = @{@"bankName":_bankName,@"certificateType":certificateType,@"zipCode":_zipTextField.text};
        } else {
            //不确定是否要填,用户未点无密码的时候
            if (_zipTextField.text.length > 0) {
                parameters = @{@"bankName":_bankName,@"certificateType":certificateType,@"zipCode":_zipTextField.text};
            } else {
                parameters = @{@"bankName":_bankName,@"certificateType":certificateType,
                    @"zipCode":@""};
            }
        }
    } else {
        parameters = @{@"bankName":_bankName,
                       @"certificateType":certificateType,
                       @"zipCode":@""};
    }
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,UPLOAD_BANKCARD_DETAILS_URL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"提交银行收支明细信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        [self jumpToUploadResultController];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)jumpToUploadResultController {
    ZXSDUploadDetailsResultController *viewController = [ZXSDUploadDetailsResultController new];
    viewController.certType = self.certType;
    viewController.certStatus = @"Submit";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)jumpToBankGuideH5 {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@/instructions/%@/details.html", H5_URL, _flowCode];
    viewController.title = @"如何上传？";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textChange:(NSNotification *)notification {
    if (_isShowZipTextField) {
        UITextField *textField = notification.object;
        _submitButton.userInteractionEnabled = textField.text.length > 0;
        _submitButton.backgroundColor = _submitButton.userInteractionEnabled ? kThemeColorMain : UICOLOR_FROM_HEX(0xF5F5F5);
        [_submitButton setTitleColor:_submitButton.userInteractionEnabled ? [UIColor whiteColor] : UICOLOR_FROM_HEX(0xCCCCCC) forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *blank = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if(![string isEqualToString:blank]) {
        return NO;
    }
    return YES;
}

#pragma mark - 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
