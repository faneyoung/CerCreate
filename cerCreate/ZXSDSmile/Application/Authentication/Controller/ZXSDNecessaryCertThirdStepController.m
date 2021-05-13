//
//  ZXSDNecessaryCertThirdStepController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/19.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDNecessaryCertThirdStepController.h"
#import "ZXSDNecessaryCertFourthStepController.h"
#import "ZXSDDebitCardBankListController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZXSDBindDebitCardInfoCell.h"
#import "UITextField+ExtendRange.h"
#import "ZXSDVerifyProgressCell.h"
#import "ZXSDVerifyManager.h"

#import "ZXResultNoteViewController.h"

#import "EPNetworkManager.h"
#import "ZXSDDebitCardBankListModel.h"


static const NSString *QUERY_IDCARD_INFO_URL = @"/rest/userInfo/personInfo";
static const NSString *SEND_VERIFY_SMS_CODE_URL = @"/rest/bankCard/validate/prepare";
static const NSString *BIND_DEBIT_CARD_URL = @"/rest/bankCard/validate/confirm";
static const NSString *PERSON_IDCARD_AGREEMENT_URL = @"";
static const NSInteger SMSCODE_TIME_MAX_LENGTH = 59;
static const NSInteger kGroupSize = 4;

@interface ZXSDNecessaryCertThirdStepController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    TPKeyboardAvoidingTableView *_infoTableView;
    
    NSArray *_titleArray;
    NSInteger index;
}

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) TPKeyboardAvoidingTableView *infoTableView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *idCardNumber;
@property (nonatomic, copy) NSString *bankCardNumber;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankCode;//银行简码，用于发送验证码
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *refId;//发送验证码成功后返回的参数，用于验卡
@property (nonatomic, copy) NSString *uniqueCode;//发送验证码成功后返回的参数，用于验卡
@property (nonatomic, copy) NSString *channel;//发送验证码成功后返回的参数，用于验卡

@end

@implementation ZXSDNecessaryCertThirdStepController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份认证";
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
    [self refreshDataConfigure];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.customTitle) {
        self.title = self.customTitle;
    }
}

#pragma mark - views -

- (void)setHasNote:(BOOL)hasNote{
    _hasNote = hasNote;
    if (hasNote) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 40)];
        headerView.backgroundColor = kThemeColorNote;
        
        UILabel *noteLab = [[UILabel alloc] init];
        noteLab.font = FONT_PINGFANG_X(14);
        noteLab.textColor = UIColorFromHex(0xC8A028);
        noteLab.text = @"请绑定持卡人本人的工资卡";
        [headerView addSubview:noteLab];
        [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.inset(0);
        }];
        
        self.infoTableView.tableHeaderView = headerView;
    }
}

#pragma mark - action methods -


- (void)backButtonClicked:(id)sender
{
    if (self.backViewController) {
        [super backButtonClicked:sender];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)prepareDataConfigure {
    _titleArray = @[@"姓名",@"身份证号", @"银行卡号", @"选择银行", @"银行预留手机号",@"短信验证码"];
    
    self.userName = @"";
    self.idCardNumber = @"";
    self.bankCardNumber = @"";
    self.bankName = @"";
    self.phoneNumber= @"";
    self.bankCode = @"";
    self.smsCode = @"";
    self.refId = @"";
    self.uniqueCode = @"";
    self.channel = @"";
    
    index = 0;
}
#pragma mark - data handle -

- (void)refreshDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_IDCARD_INFO_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取用户身份信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.userName = [[responseObject objectForKey:@"name"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"name"];
            self.idCardNumber = [[responseObject objectForKey:@"idNo"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"idNo"];
        }

        [self->_infoTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)requestCardInfoWithNum:(NSString*)cardNum{
    if (cardNum.length != 19 && cardNum.length != 16) {
        return;
    }
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:cardNum forKey:@"bankCardNo"];
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:kBankNameByNoPath parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        int section = self.addCardMode ? 0 : 1;
        ZXSDBindDebitCardInfoCell *cell = [self.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:section]];

        if(error){
            cell.textLabel.text = @"选择银行";
            cell.imageView.image = nil;
            self.bankName = nil;
            self.bankCode = nil;
            return;
        }
        
        ZXSDDebitCardBankListModel *model = [ZXSDDebitCardBankListModel modelWithDictionary:response.originalContent];

        cell.textLabel.text = model.bankName;
        self.bankName = model.bankName;
        self.bankCode = model.bankCode;
        if (IsValidString(model.bankPic)) {
            [cell.imageView sd_setImageWithURL:model.bankPic.URLByCheckCharacter placeholderImage:UIIMAGE_FROM_NAME(@"smile_bank_default")];
        }


    }];
}


- (void)addUserInterfaceConfigure {
    /*
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 110)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH() - 40, 2)];
    lineBackView.backgroundColor = UICOLOR_FROM_HEX(0xE8E8E8);
    [headerView addSubview:lineBackView];
    
    CGFloat currentStep = (SCREEN_WIDTH() - 40) / 4 * 3;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, currentStep, 2)];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [headerView addSubview:lineView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"绑定工资卡";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [headerView addSubview:titleLabel];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH() - 70, 20, 50, 40)];
    stepLabel.text = @"3/4";
    stepLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    stepLabel.textAlignment = NSTextAlignmentRight;
    stepLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:stepLabel.text];
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:28.f],NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x00B050)} range:NSMakeRange(0, 1)];
    stepLabel.attributedText = attributedString;
    [headerView addSubview:stepLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH() - 40, 40)];
    contentLabel.text = @"请绑定您的工资卡，以便激活预支额度";
    contentLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    if (iPhone4() || iPhone5()) {
        contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:24.0];
    }
    [headerView addSubview:contentLabel];
    
    _infoTableView.tableHeaderView = headerView;
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [submitButton setTitle:@"立刻绑定" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.cornerRadius = 22.0;
    submitButton.layer.masksToBounds = YES;
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
        make.top.equalTo(_infoTableView.mas_bottom).offset(20);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom -20);
        } else {
            make.bottom.equalTo(self.view).offset(-20);
        }
    }];*/
    
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
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [_infoTableView registerClass:[ZXSDVerifyProgressCell class] forCellReuseIdentifier:[ZXSDVerifyProgressCell identifier]];
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
    [footerView addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.right.equalTo(footerView).offset(-20);
        make.top.equalTo(footerView).offset(10);
        make.height.mas_equalTo(44);
    }];
    self.footerView = footerView;
    
    return footerView;
}


//发送验证码
- (void)sendCodeButtonClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    
    if ([self validateSmsCodeCanSend]) {
        btn.userInteractionEnabled = NO;
        NSDictionary *dic = @{@"bankCardNo":self.bankCardNumber,@"bankCode":self.bankCode,@"bankName":self.bankName,@"phone":self.phoneNumber};
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
    __block NSInteger timeout = SMSCODE_TIME_MAX_LENGTH;
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                btn.userInteractionEnabled = YES;
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                [btn setTitleColor:UICOLOR_FROM_HEX(0x00B050) forState:UIControlStateNormal];
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

//校验是否可以发送验证码
- (BOOL)validateSmsCodeCanSend  {    
    if (self.bankCardNumber.length == 0) {
        [self showToastWithText:@"请输入您的薪资储蓄卡号"];
        return NO;
    } else {
        self.bankCardNumber = [self removingSapceString:self.bankCardNumber];
        if (![self.bankCardNumber validateStringIsBankCardFormate]) {
            [self showToastWithText:@"请输入正确的薪资储蓄卡号"];
            return NO;
        }
    }
    
    if (self.bankName.length == 0) {
        [self showToastWithText:@"请选择薪资储蓄卡对应的银行"];
        return NO;
    }
    
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

//校验是否可以绑定银行卡
- (BOOL)validateAllTextFieldsAreAllowed {
    [self.view endEditing:YES];
    
    if (self.bankCardNumber.length == 0) {
        [self showToastWithText:@"请输入您的薪资储蓄卡号"];
        return NO;
    } else {
        self.bankCardNumber = [self removingSapceString:self.bankCardNumber];
        if (![self.bankCardNumber validateStringIsBankCardFormate]) {
            [self showToastWithText:@"请输入正确的薪资储蓄卡号"];
            return NO;
        }
    }
    
    if (self.bankName.length == 0) {
        [self showToastWithText:@"请选择薪资储蓄卡对应的银行"];
        return NO;
    }
    
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
    
    return YES;
}

- (void)submitButtonClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    
    if ([self validateAllTextFieldsAreAllowed]) {
        btn.userInteractionEnabled = NO;
        NSDictionary *dic = @{@"channel":self.channel,@"refId":self.refId,@"smsCode":self.smsCode,@"uniqueCode":self.uniqueCode};
        [self showLoadingProgressHUDWithText:@"正在加载..."];
        
        AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
        [manager PUT:[NSString stringWithFormat:@"%@%@",MAIN_URL,BIND_DEBIT_CARD_URL] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dismissLoadingProgressHUD];
            btn.userInteractionEnabled = YES;
            ZGLog(@"绑定银行卡接口成功返回数据---%@",responseObject);
            [self jumpToNecessaryCertFourthStepController];

            if (self.completionBlock) {
                self.completionBlock(self.refId);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self dismissLoadingProgressHUD];
            btn.userInteractionEnabled = YES;
            [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"绑定失败"];
        }];
    }
}

//前往完善个人信息页面
- (void)jumpToNecessaryCertFourthStepController {
    
    if (self.addCardMode) {
//        [self backButtonClicked:nil];
        ZXResultNoteViewController *resultVC = [[ZXResultNoteViewController alloc] init];
        if (self.backViewController) {
            resultVC.backViewController = self.backViewController;
        }
        resultVC.resultPageType = ResultPageTypeAddCard;
        [self.navigationController pushViewController:resultVC animated:YES];
        
    } else {
        ZXSDNecessaryCertFourthStepController *viewController = [ZXSDNecessaryCertFourthStepController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.addCardMode) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.addCardMode) {
        return _titleArray.count;
    } else {
        if (section == 1) {
            return _titleArray.count;
        }
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && !self.addCardMode) {
        ZXSDVerifyProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDVerifyProgressCell identifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ZXSDVerifyActionModel *model = [ZXSDVerifyManager bankCardBindingAction];
        [cell hideBottomLine];
        [cell setRenderData:model];
        return cell;
        
    } else {
        if (indexPath.row == 3) {
            static NSString *cellName = @"debitCardInfoCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
            cell.textLabel.textColor = UICOLOR_FROM_HEX(0x333333);
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.text = _titleArray[indexPath.row];
                    
            UIImageView *indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile_mine_arrow"]];
            indicatorView.frame = CGRectMake(0, 0, 16, 16);
            cell.accessoryView = indicatorView;
            
            return cell;
        } else {
            static NSString *cellName = @"bindDebitCardInfoCell";
            ZXSDBindDebitCardInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (cell == nil) {
                cell = [[ZXSDBindDebitCardInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = _titleArray[indexPath.row];
            cell.textField.delegate = self;
            cell.textField.tag = indexPath.row;
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.canChoice = NO;
                    cell.textField.text = self.userName;
                }
                    break;
                case 1:
                {
                    cell.canChoice = NO;
                    cell.textField.text = self.idCardNumber;
                }
                    break;
                case 2:
                {
                    cell.canChoice = NO;
                    cell.textField.placeholder = @"请输入您的薪资储蓄卡号";
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                }
                    break;
                case 4:
                {
                    cell.canChoice = NO;
                    cell.textField.placeholder = @"请输入银行预留手机号";
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    [cell.textField addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
                }
                    break;
                case 5:
                {
                    cell.canChoice = NO;
                    cell.canSendSms = YES;
                    cell.textField.placeholder = @"请输入短信验证码";
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    [cell.sendButton setTitle:@"短信验证码" forState:UIControlStateNormal];
                    [cell.sendButton addTarget:self action:@selector(sendCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    
                default:
                    break;
            }
            
            [cell showBottomLine];
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.addCardMode) {
        return 60.f;
    } else {
        if (indexPath.section == 0) {
            return UITableViewAutomaticDimension;
        }
        return 60.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 3) {
        ZXSDDebitCardBankListController *viewController = [ZXSDDebitCardBankListController new];
        viewController.selectResultBlock = ^(NSString * _Nonnull bankName, NSString * _Nonnull bankLogoUrl, NSString * _Nonnull bankCode) {
            cell.textLabel.text = bankName;
            self.bankName = bankName;
            self.bankCode = bankCode;
            if (bankLogoUrl.length > 0) {
                [cell.imageView sd_setImageWithURL:bankLogoUrl.URLByCheckCharacter placeholderImage:UIIMAGE_FROM_NAME(@"smile_bank_default")];
            }
        };
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - UITextFieldDelegate 返回键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 1 || textField.tag == 3) {
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEditing:(UITextField *)textField {
    if (textField.tag == 4) {
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    ZGLog(@"结束编辑:%@", textField.text);
    switch (textField.tag) {
        case 2:
        {
            self.bankCardNumber = textField.text;
        }
            break;
        case 4:
        {
            self.phoneNumber = textField.text;
        }
            break;
        case 5:
        {
            self.smsCode = textField.text;
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //短信验证码输入校验
    if (textField.tag == 5) {
        NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *smsCodeNumber = [beingString stringByReplacingOccurrencesOfString:@" " withString:@""];
        //校验短信验证码只能是数字，且不能超过6位
        if ((string.length != 0 && ![smsCodeNumber validateStringIsIntegerFormate]) || smsCodeNumber.length > 6) {
            return NO;
        }
    }
    
    //手机号输入校验
    if (textField.tag == 4) {
        NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *phoneNumber = [beingString stringByReplacingOccurrencesOfString:@" " withString:@""];
        //校验手机号号只能是数字，且不能超过11位
        if ((string.length != 0 && ![phoneNumber validateStringIsIntegerFormate]) || phoneNumber.length > 11) {
            return NO;
        }
    }
    
    //银行卡号输入校验
    if (textField.tag == 2) {
        NSString *text = textField.text;
        NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *cardNo = [beingString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [self requestCardInfoWithNum:cardNo];

        //校验银行卡号只能是数字，且不能超过19位
        if ((string.length != 0 && ![cardNo validateStringIsIntegerFormate]) || cardNo.length > 19) {
            return NO;
        }
        //获取【光标右侧的数字个数】
        NSInteger rightNumberCount = [self removingSapceString:[text substringFromIndex:textField.selectedRange.location + textField.selectedRange.length]].length;
        //输入长度大于4 需要对数字进行分组，每4个一组，用空格隔开
        if (beingString.length > kGroupSize) {
            textField.text = [self groupedString:beingString];
        } else {
            textField.text = beingString;
        }
        text = textField.text;
        /**
         * 计算光标位置(相对末尾)
         * 光标右侧空格数 = 所有的空格数 - 光标左侧的空格数
         * 光标位置 = 【光标右侧的数字个数】+ 光标右侧空格数
         */
        NSInteger rightOffset = [self rightOffsetWithCardNoLength:cardNo.length rightNumberCount:rightNumberCount];
        NSRange currentSelectedRange = NSMakeRange(text.length - rightOffset, 0);
        
        //如果光标左侧是一个空格，则光标回退一格
        if (currentSelectedRange.location > 0 && [[text substringWithRange:NSMakeRange(currentSelectedRange.location - 1, 1)] isEqualToString:@" "]) {
            currentSelectedRange.location -= 1;
        }
        [textField setSelectedRange:currentSelectedRange];
        return NO;
    }
    
    return YES;
}

#pragma mark - Helper
// 计算光标相对末尾的位置偏移
- (NSInteger)rightOffsetWithCardNoLength:(NSInteger)length rightNumberCount:(NSInteger)rightNumberCount {
    NSInteger totalGroupCount = [self groupCountWithLength:length];
    NSInteger leftGroupCount = [self groupCountWithLength:length - rightNumberCount];
    NSInteger totalWhiteSpace = totalGroupCount - 1 > 0 ? totalGroupCount - 1 : 0;
    NSInteger leftWhiteSpace = leftGroupCount - 1 > 0 ? leftGroupCount - 1 : 0;
    return rightNumberCount + (totalWhiteSpace - leftWhiteSpace);
}

//去除字符串中包含的空格
- (NSString *)removingSapceString:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//根据长度计算分组的个数
- (NSInteger)groupCountWithLength:(NSInteger)length {
    return (NSInteger)ceilf((CGFloat)length /kGroupSize);
}

//给定字符串根据指定的个数进行分组，每一组用空格分隔
- (NSString *)groupedString:(NSString *)string {
    NSString *str = [self removingSapceString:string];
    NSInteger groupCount = [self groupCountWithLength:str.length];
    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < groupCount; i++) {
        if (i*kGroupSize + kGroupSize > str.length) {
            [components addObject:[str substringFromIndex:i*kGroupSize]];
        } else {
            [components addObject:[str substringWithRange:NSMakeRange(i*kGroupSize, kGroupSize)]];
        }
    }
    NSString *groupedString = [components componentsJoinedByString:@" "];
    return groupedString;
}

#pragma mark - 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Getter

- (UIButton *)nextButton
{
    if (!_nextButton) {
           _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
           [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [_nextButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        
           [_nextButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
           
           [_nextButton setTitle:@"立刻绑定" forState:UIControlStateNormal];
           _nextButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
           _nextButton.layer.cornerRadius = 22.0;
           _nextButton.layer.masksToBounds = YES;
       }
       return _nextButton;
}

- (TPKeyboardAvoidingTableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [TPKeyboardAvoidingTableView new];
        _infoTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _infoTableView.backgroundColor = [UIColor whiteColor];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.showsVerticalScrollIndicator = NO;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTableView.estimatedRowHeight = 90;
        _infoTableView.tableFooterView = [UIView new];
    }
    return _infoTableView;
    
}

@end
