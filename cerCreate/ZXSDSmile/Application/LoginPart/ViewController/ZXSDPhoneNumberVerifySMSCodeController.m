//
//  ZXSDPhoneNumberVerifySMSCodeController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDPhoneNumberVerifySMSCodeController.h"
#import "CRBoxInputView.h"
#import "ZXSDSmileUUID.h"
#import "ZXSDSystemInformation.h"

#import "ZXSDLoginService.h"
#import "EPNetworkManager+Login.h"

static const NSString *SEND_SMSCODE_URL = @"/rest/anon/sms";
static const NSString *SMSCODE_LOGIN_URL = @"/rest/anon/login";
static const NSInteger SMSCODE_TIME_MAX_LENGTH = 59;
static const NSInteger SMSCODE_LENGTH = 6;
static const NSString *UPLOAD_DEVICE_INFORMATION_URL = @"/rest/device";

@interface ZXSDPhoneNumberVerifySMSCodeController () {
    NSString *_promptAlertTitle;
    NSString *_promptAlertMessage;
    
    UIButton *_sendCodeButton;
    CRBoxInputView *_boxInputView;
}

@end

@implementation ZXSDPhoneNumberVerifySMSCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
    [self updateSendCondeButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ZXAppTrackManager event:kSmscodeLoginPage];
//    [self ZXSDNavgationBarConfigure];
}

- (void)prepareDataConfigure {
    _promptAlertTitle = @"手机号无法接收短信";
    _promptAlertMessage = @"\n1. 请检查验证码短信是否被拦截；\n2. 请检查网络环境是否良好。\n";
}

- (void)addUserInterfaceConfigure {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"输入验证码";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [self.view addSubview:titleLabel];
    
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 10, SCREEN_WIDTH() - 40, 20)];
    explainLabel.text = [NSString stringWithFormat:@"验证码已发送至 +86 %@",self.phoneString];
    explainLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    explainLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    [self.view addSubview:explainLabel];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:explainLabel.text];
    [attributedString addAttributes: @{NSFontAttributeName:FONT_SFUI_X_Regular(20)} range: NSMakeRange(7, explainLabel.text.length - 7)];
    explainLabel.attributedText = attributedString;
    
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    cellProperty.showLine = YES;
    cellProperty.cellCursorWidth = 3.0;
    cellProperty.cellCursorHeight = 24.0;
    cellProperty.cellCursorColor = kThemeColorMain;
    cellProperty.cornerRadius = 0;
    cellProperty.borderWidth = 0;
    cellProperty.cellFont = FONT_SFUI_X_Regular(20);
    cellProperty.cellTextColor = UICOLOR_FROM_HEX(0x333333);
    cellProperty.customLineViewBlock = ^CRLineView * _Nonnull{
        CRLineView *lineView = [CRLineView new];
        lineView.underlineColorNormal = [UICOLOR_FROM_HEX(0x333333) colorWithAlphaComponent:0.3];
        lineView.underlineColorSelected = [UICOLOR_FROM_HEX(0x333333) colorWithAlphaComponent:0.7];
        lineView.underlineColorFilled = UICOLOR_FROM_HEX(0x333333);
        [lineView.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.right.bottom.offset(0);
        }];
        return lineView;
    };

    _boxInputView = [CRBoxInputView new];
    _boxInputView.frame = CGRectMake(25, CGRectGetMaxY(explainLabel.frame) + 30, SCREEN_WIDTH() - 50, 60);
    _boxInputView.codeLength = SMSCODE_LENGTH;
    _boxInputView.customCellProperty = cellProperty;
    [_boxInputView loadAndPrepareViewWithBeginEdit:YES];
    [self.view addSubview:_boxInputView];
    
    WEAKOBJECT(self);
    _boxInputView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
        if (isFinished && text.length > 0) {
            [weakself verifySmsCodeAndLogin:text];
        }
    };
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(explainLabel.frame) + 110, SCREEN_WIDTH()/2, 20)];
    promptLabel.text = @"手机号无法接收短信";
    promptLabel.textColor = UICOLOR_FROM_HEX(0x666666);
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    promptLabel.userInteractionEnabled = YES;
    [self.view addSubview:promptLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPromptAlert)];
    [promptLabel addGestureRecognizer:tap];
    
    _sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendCodeButton.frame = CGRectMake(SCREEN_WIDTH() - 80, CGRectGetMaxY(explainLabel.frame) + 100, 60, 40);
    _sendCodeButton.backgroundColor = [UIColor clearColor];
    [_sendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [_sendCodeButton setTitleColor:UICOLOR_FROM_HEX(0x666666) forState:UIControlStateNormal];
    [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _sendCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    _sendCodeButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _sendCodeButton.userInteractionEnabled = YES;
    [self.view addSubview:_sendCodeButton];
}

- (void)updateSendCondeButton {
    __block NSInteger timeout = SMSCODE_TIME_MAX_LENGTH;
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_sendCodeButton.userInteractionEnabled = YES;
                [self->_sendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
            });
        } else {
            NSInteger seconds = timeout % (timeout + 1);
            NSString *stringTime = [NSString stringWithFormat:@"%ld",(long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_sendCodeButton.userInteractionEnabled = NO;
                [self->_sendCodeButton setTitle:[NSString stringWithFormat:@"%@ s", stringTime] forState:UIControlStateNormal];
            });
            timeout --;
        }
    });
    dispatch_resume(timer);
}

- (void)cancelButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPromptAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_promptAlertTitle message:_promptAlertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    NSDictionary *titleDic = @{NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x333333),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:17.0]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_promptAlertTitle attributes:titleDic];
    [alertController setValue:attributedString forKey:@"attributedTitle"];
    
    //设置内容的对齐方式
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentLeft;
    
    NSDictionary *messageDic = @{
        NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x151515),
        NSParagraphStyleAttributeName:style,
        NSFontAttributeName:FONT_PINGFANG_X(15)};
    
    NSMutableAttributedString *attributedMessageString = [[NSMutableAttributedString alloc]initWithString:_promptAlertMessage attributes:messageDic];
    [alertController setValue:attributedMessageString forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:kThemeColorMain forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - data handle -

//重新发送验证码
- (void)sendCodeButtonClicked:(UIButton *)btn {
    btn.userInteractionEnabled = NO;
    NSDictionary *dic = @{@"phone":self.phoneNumber};
    [self showLoadingProgressHUDWithText:@"正在加载..."];

    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,SEND_SMSCODE_URL] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissLoadingProgressHUD];
        btn.userInteractionEnabled = YES;
        ZGLog(@"发送验证码接口成功返回数据---%@",responseObject);

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.smsCodeToken = [[responseObject objectForKey:@"otpCodeToken"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"otpCodeToken"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showToastWithText:@"验证码已成功发送"];
                [self updateSendCondeButton];
            });
        } else {
            [self showToastWithText:@"验证码发送失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        btn.userInteractionEnabled = YES;
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"验证码获取失败"];
    }];
}

//验证短信验证码并登录
- (void)verifySmsCodeAndLogin:(NSString *)smsCodeString
{
    NSDictionary *dic = @{
        @"phone":self.phoneNumber,
        @"otpCode":smsCodeString,
        @"otpCodeToken":self.smsCodeToken
        
    };
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    
    __block NSURLSessionDataTask *task = nil;
    task = [EPNetworkManager doSMSLoginWithParams:dic completion:^(NSError * _Nonnull error) {
        
        [self dismissLoadingProgressHUDImmediately];
        
        if (error) {
            [self handleRequestError:error];
            
            NSMutableDictionary *errorDic = @{}.mutableCopy;
            [errorDic setSafeValue:error.localizedDescription forKey:@"smsLoginErr"];
            [ZXAppTrackManager event:kSmscodeLogin extra:@{}];

            return;
        }
        
        [ZXAppTrackManager event:kSmscodeLogin];
        
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse*)task.response;
        NSDictionary *headersDic = httpURLResponse.allHeaderFields;
        NSString *userSession = [headersDic objectForKey:@"USER-SESSION"];
        
        [ZXSDLoginService saveSession:userSession phone:self.phoneNumber];
        
//        [ZXSDLoginService uploadDeviceInfo];
//        [ZXSDLoginService judgeNextAction];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZXSDLoginService uploadDeviceInfo];
            [ZXSDLoginService judgeNextActionFrom:self withNavCtrl:self.navigationController];
        });

    }];

}

#pragma mark - 点击
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
