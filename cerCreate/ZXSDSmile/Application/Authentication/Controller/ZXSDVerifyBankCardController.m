//
//  ZXSDVerifyBankCardController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDVerifyBankCardController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZXSDVerifyInfoCell.h"
#import "ZXSDVerifyInputCell.h"
#import "ZXSDEmployeeInfo.h"

static const NSString *EMPLOYER_CONFIRM_QUERY_URL = @"/rest/company/employee";
static const NSString *SEND_VERIFY_SMS_CODE_URL = @"/rest/bankCard/validate/prepare";
static const NSString *BIND_DEBIT_CARD_URL = @"/rest/bankCard/validate/confirm";

@interface ZXSDVerifyBankCardController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) TPKeyboardAvoidingTableView *infoTableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) ZXSDEmployeeInfo *employee;

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *refId;//发送验证码成功后返回的参数，用于验卡
@property (nonatomic, copy) NSString *uniqueCode;//发送验证码成功后返回的参数，用于验卡
@property (nonatomic, copy) NSString *channel;//发送验证码成功后返回的参数，用于验卡

@end

@implementation ZXSDVerifyBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定工资卡";
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
}

- (void)backButtonClicked:(id)sender
{
    if (self.forbidBack) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (UIView *)buildFooterView
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.right.equalTo(footerView).offset(-20);
        make.top.equalTo(footerView).offset(10);
        make.height.mas_equalTo(44);
    }];
    self.footerView = footerView;
    
    return footerView;
}

- (void)addUserInterfaceConfigure
{
    [self.view addSubview:self.infoTableView];
    UIView *bottomView = [self buildFooterView];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    
    [self.infoTableView registerClass:[ZXSDVerifyInfoCell class] forCellReuseIdentifier:[ZXSDVerifyInfoCell identifier]];
    [self.infoTableView registerClass:[ZXSDVerifyInputCell class] forCellReuseIdentifier:[ZXSDVerifyInputCell identifier]];
}

- (void)prepareDataConfigure {
    NSArray *section0 = @[@"名字",@"身份证", @"工资卡", @"发薪日", @"基本工资"];
    if (self.bindCard) {
        NSArray *section1 = @[@"银行预留手机号",@"验证码"];
        self.titleArray = @[section0, section1];
    } else {
        self.titleArray = @[section0];
    }
    

    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,EMPLOYER_CONFIRM_QUERY_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"查询雇主员工信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.employee = [ZXSDEmployeeInfo modelWithJSON:responseObject];
            [self.infoTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.titleArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *key = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        
        ZXSDVerifyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDVerifyInfoCell identifier] forIndexPath:indexPath];
        cell.keyLabel.text = key;
        [self configCell:cell path:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        ZXSDVerifyInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDVerifyInputCell identifier] forIndexPath:indexPath];
        [cell setRenderData:key];
        
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        if (indexPath.row == 1) {
            cell.sendButton.hidden = NO;
            [cell.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [cell.sendButton addTarget:self action:@selector(sendCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            cell.sendButton.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)configCell:(ZXSDVerifyInfoCell *)cell path:(NSIndexPath *)path
{
    NSString *value = @"";
    switch (path.row) {
        case 0:
        {
            cell.valueLabel.font = FONT_PINGFANG_X(14);
            cell.valueLabel.text = self.employee.name;
        }
            break;
        case 1:
            {
                cell.valueLabel.font = FONT_SFUI_X_Regular(14);
                cell.valueLabel.text = self.employee.idCard;
            }
            break;
        case 2:
            
            {
                cell.valueLabel.font = FONT_SFUI_X_Regular(14);
                cell.valueLabel.text = self.employee.cardNumber;
            }
            break;
        case 3:
        {
            if (CHECK_VALID_STRING(self.employee.payDay)) {
                value = [NSString stringWithFormat:@"每月 %@ 号",self.employee.payDay];
                
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:value];
                [attr addAttributes:@{NSFontAttributeName:FONT_SFUI_X_Regular(14)} range:NSMakeRange(3, self.employee.payDay.length)];
                cell.valueLabel.attributedText = attr;
            }
            
            break;
        }
            
        case 4:
        {
            if (CHECK_VALID_STRING(self.employee.salary)) {
                value = [NSString stringWithFormat:@"¥%@",self.employee.salary];
                 cell.valueLabel.text = value;
                 cell.valueLabel.font = FONT_SFUI_X_Regular(14);
            }
            
            break;
        }
            
            
        default:
            break;
    }
    
    //cell.valueLabel.text = value;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!self.bindCard) {
        return 0;
    }
    return section == 0 ? 8:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.bindCard) {
        return nil;
    }
    
    if (section == 0) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 8)];
        footer.backgroundColor = UICOLOR_FROM_HEX(0xF7F9FB);
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 52;
    }
    return 90;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    ZGLog(@"结束编辑:%@", textField.text);
    switch (textField.tag) {
        case 0:
        {
            self.phoneNumber = textField.text;
        }
            break;
        case 1:
        {
            self.smsCode = textField.text;
        }
            break;
            
        default:
            break;
    }
}

static int MaxSMSCodeLenght = 6;
static int MaxPhoneLenght = 11;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    //字母和数字判断
    if (![string isEqualToString:filtered]) {
        return NO;
    }
    
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = textField.text.length + string.length - range.length;

    if (textField.tag == 0) {
        return newLength <= MaxPhoneLenght;
    }
    else if(textField.tag == 1){
        return newLength <= MaxSMSCodeLenght;
    }
    
    return YES;
}



#pragma mark - Action

- (void)submitButtonClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    
    if (!self.bindCard) {
        self.bindCardCompleted?self.bindCardCompleted(YES, nil):nil;
        return;
    }
    
    if ([self validateAllTextFieldsAreAllowed]) {
        btn.userInteractionEnabled = NO;
        NSDictionary *dic = @{
            @"channel":self.channel,
            @"refId":self.refId,
            @"smsCode":self.smsCode,
            @"uniqueCode":self.uniqueCode};
        [self showLoadingProgressHUDWithText:@"正在加载..."];
        
        AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
        [manager PUT:[NSString stringWithFormat:@"%@%@",MAIN_URL,BIND_DEBIT_CARD_URL] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dismissLoadingProgressHUD];
            btn.userInteractionEnabled = YES;
            ZGLog(@"绑定银行卡接口成功返回数据---%@",responseObject);
            self.bindCardCompleted?self.bindCardCompleted(YES, nil):nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self dismissLoadingProgressHUD];
            btn.userInteractionEnabled = YES;
            [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"绑定失败"];
            self.bindCardCompleted?self.bindCardCompleted(NO, error):nil;
        }];
    }
}

//发送验证码
- (void)sendCodeButtonClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    if (!self.employee) {
        return;
    }
    
    if ([self validateSmsCodeCanSend]) {
        btn.userInteractionEnabled = NO;
        NSDictionary *dic = @{
            @"bankCardNo":self.employee.cardNumber,
            @"bankCode":self.employee.bankCode,
            @"bankName":self.employee.bankName,
            @"phone":self.phoneNumber};
        [self showLoadingProgressHUDWithText:@"正在加载..."];
        
        AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
        [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,SEND_VERIFY_SMS_CODE_URL] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dismissLoadingProgressHUD];
            btn.userInteractionEnabled = YES;
            ZGLog(@"绑定银行卡发送验证码接口成功返回数据---%@",responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                self.refId = [[responseObject objectForKey:@"refId"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"refId"];
                self.channel = [[responseObject objectForKey:@"channel"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"channel"];
                self.uniqueCode = [[responseObject objectForKey:@"uniqueCode"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"uniqueCode"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showToastWithText:@"验证码已成功发送"];
                    [self updateSendCondeButton:btn];
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
}

- (void)updateSendCondeButton:(UIButton *)btn {
    __block NSInteger timeout = 59;
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                btn.userInteractionEnabled = YES;
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                [btn setTitleColor:kThemeColorMain forState:UIControlStateNormal];
            });
        } else {
            NSInteger seconds = timeout % (timeout + 1);
            NSString *stringTime = [NSString stringWithFormat:@"%ld",(long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                btn.userInteractionEnabled = NO;
                [btn setTitle:[NSString stringWithFormat:@"%@ s", stringTime] forState:UIControlStateNormal];
                [btn setTitleColor:UICOLOR_FROM_HEX(0x666666) forState:UIControlStateNormal];
            });
            timeout --;
        }
    });
    dispatch_resume(timer);
}

- (BOOL)validateAllTextFieldsAreAllowed {
    [self.view endEditing:YES];
    
    if (self.phoneNumber.length == 0) {
        [self showToastWithText:@"请输入银行预留手机号"];
        return NO;
    } else {
        self.phoneNumber = [self removingSapceString:self.phoneNumber];
        if (![self.phoneNumber validateStringIsPhoneNumberFormate]) {
            [self showToastWithText:@"请输入正确的手机号"];
            return NO;
        }
    }
    
    if (self.smsCode.length == 0) {
        [self showToastWithText:@"请输入短信验证码"];
        return NO;
    }
    
    if (!CHECK_VALID_STRING(self.channel) || !CHECK_VALID_STRING(self.refId) || !CHECK_VALID_STRING(self.uniqueCode)) {
        [self showToastWithText:@"请先获取短信验证码"];
        return NO;
    }
    
    return YES;
}

//校验是否可以发送验证码
- (BOOL)validateSmsCodeCanSend  {
    
    if (self.phoneNumber.length == 0) {
        [self showToastWithText:@"请输入银行预留手机号"];
        return NO;
    } else {
        self.phoneNumber = [self removingSapceString:self.phoneNumber];
        if (![self.phoneNumber validateStringIsPhoneNumberFormate]) {
            [self showToastWithText:@"请输入正确的手机号"];
            return NO;
        }
    }
    
    return YES;
}

- (NSString *)removingSapceString:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - Getter
- (TPKeyboardAvoidingTableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [TPKeyboardAvoidingTableView new];
        _infoTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _infoTableView.backgroundColor = [UIColor whiteColor];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.showsVerticalScrollIndicator = NO;
        _infoTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _infoTableView.separatorColor = UICOLOR_FROM_HEX(0xEAEFF2);
        _infoTableView.tableFooterView = [UIView new];
    }
    return _infoTableView;
    
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [_confirmButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = FONT_PINGFANG_X(14);
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

@end
