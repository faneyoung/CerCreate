//
//  ZXSDExtendDetailController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDExtendDetailController.h"
#import <IQKeyboardManager.h>

#import <MSWeakTimer.h>

#import "UITableView+help.h"
#import "UIButton+Align.h"

#import "CJLabel.h"
#import "ZXSDExtendDetailCardCell.h"
#import "ZXSDRepaymentAmountCell.h"
#import "ZXSDRepaymentBankCell.h"
#import "ZXSDExtendResultController.h"
#import "ZXSDChargeDetailAlertView.h"
#import "ZXSDExtendModel.h"
#import "ZXSDRepaymentAuthCodeCell.h"
#import "TPKeyboardAvoidingTableView.h"

//vc
#import "ZXSDNecessaryCertThirdStepController.h"

//views
#import "ZXMemberPayCardCell.h"
#import "ZXMemberSmsCodeCell.h"


#import "EPNetworkManager+Mine.h"
#import "ZXUserViewModel.h"


static const NSString *EXTEND_DETAIL_URL = @"/rest/loan/teller/applyExtend";
static const NSString *APPLY_EXTEND_URL = @"/rest/loan/teller/repayExtend";

@interface ZXSDExtendDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) CJLabel *protocolLabel;
@property (nonatomic, strong) ZXSDChargeDetailAlertView *chargeAlert;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *cardOptionBtn;
@property (nonatomic, strong) UIButton *smsCodeBtn;

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) ZXSDExtendModel *extendModel;
@property (nonatomic, copy) NSString *smsCode;

@property (nonatomic, assign) int timerCnt;
@property (nonatomic, strong) MSWeakTimer *timer;

@property (nonatomic, strong) NSArray *cardList;
@property (nonatomic, strong) NSString *selectedCardRefId;

@property (nonatomic, strong) ZXSMSChannelModel *channelModel;



@end

@implementation ZXSDExtendDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"展期";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    [self addUserInterfaceConfigure];
    [self prepareDataConfigure];
    
    [self.mainTable registerNibs:@[
        NSStringFromClass(ZXMemberPayCardCell.class),
        NSStringFromClass(ZXMemberSmsCodeCell.class),
    ]];
    
    [self checkConfirmBtnStatus];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    TrackEvent(kExtension);
    
    [self requestAllCardList];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLayoutSubviews{
    [self.cardOptionBtn alignWithType:ButtonAlignImgTypeRight margin:3];
}

#pragma mark - views -

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (void)addUserInterfaceConfigure
{
    UIView *bottomView = [self buildFooter];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(120);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    self.bottomView = bottomView;
    
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [self.mainTable registerClass:[ZXSDExtendDetailCardCell class] forCellReuseIdentifier:@"cardCell"];
    [self.mainTable registerClass:[ZXSDRepaymentAmountCell class] forCellReuseIdentifier:@"amountCell"];
//    [self.mainTable registerClass:[ZXSDRepaymentBankCell class] forCellReuseIdentifier:@"bankCell"];
//    [self.mainTable registerClass:[ZXSDRepaymentAuthCodeCell class] forCellReuseIdentifier:@"codeCell"];
}

- (UIView *)buildFooter
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
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
    }];
    
    [footerView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.right.equalTo(footerView).offset(-20);
        make.top.equalTo(self.protocolLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(44);
    }];
    
    return footerView;
}

#pragma mark - data handle -

- (void)prepareDataConfigure
{
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    NSDictionary *params = @{@"loanId": self.loanRefId};
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,EXTEND_DETAIL_URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取用户相关认证状态接口成功返回数据---%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.extendModel = [ZXSDExtendModel modelWithJSON:responseObject];
            [self.mainTable reloadData];
        }
        [self dismissLoadingProgressHUDImmediately];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)requestAllCardList{
    [self showLoadingProgressHUDWithText:kLoadingTip];
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"02" forKey:@"businessScenario"];
    [EPNetworkManager getUserBankCards:tmps.copy completion:^(NSArray<ZXSDBankCardItem *> *records, NSError *error) {
        [self dismissLoadingProgressHUDImmediately];
        
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        
        if (IsValidArray(records)) {
            if (!IsValidString(self.selectedCardRefId)) {
                ZXSDBankCardItem *card = records.firstObject;
                card.selected = YES;
            }
            else{
                [records enumerateObjectsUsingBlock:^(ZXSDBankCardItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj.refId isEqualToString:self.selectedCardRefId]) {
                        obj.selected = YES;
                    }
                }];
            }
        }

        
        self.cardList = records;
        [self.mainTable reloadData];
    }];

}

- (void)sendSMSCodeChannelRequest:(ZXSDBankCardItem*)card{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }

    [ZXLoadingManager showLoading:kLoadingTip];
    [ZXUserViewModel sendSMSCodeWithCard:card phone:phone business:@"02" completion:^(ZXSMSChannelModel *  _Nonnull data, NSError * _Nullable error) {
        [ZXLoadingManager hideLoading];

        if (error) {
            [self handleRequestError:error];
            self.smsCodeBtn.userInteractionEnabled = YES;

            return;
        }
        
        self.channelModel = data;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastWithText:@"验证码已成功发送"];
            [self startTimer];
        });

    }];
}

- (void)sendSMSCodeRequest{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }

    
    self.smsCodeBtn.userInteractionEnabled = NO;
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:phone forKey:@"phone"];
    [tmps setSafeValue:@"OTP_EXTENDED" forKey:@"type"];

    [tmps setSafeValue:[NSString stringWithFormat:@"%.2f", self.extendModel.extendFee] forKey:@"amount"];

    
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    [ZXUserViewModel sendSMSCodeRequestWithPms:tmps.copy type:SMSCodeTypeExtend completion:^(id  _Nonnull data, NSError * _Nullable error) {
        [self dismissLoadingProgressHUDImmediately];
        [self.view endEditing:YES];

        if (error) {
            [self handleRequestError:error];
            self.smsCodeBtn.userInteractionEnabled = YES;

            return;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastWithText:@"验证码已成功发送"];
            [self startTimer];
        });

    }];
}

- (ZXSDBankCardItem*)selectedCard{
    
    __block ZXSDBankCardItem *selItem = nil;
    [self.cardList enumerateObjectsUsingBlock:^(ZXSDBankCardItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            selItem = obj;
            *stop = YES;
        }
    }];
    
    return selItem;
}


#pragma mark - action -

- (void)checkProtocol:(UIButton *)sender
{
    _checked = !_checked;
    UIImage *image = _checked ?UIIMAGE_FROM_NAME(@"smile_loan_agreement_selected") :UIIMAGE_FROM_NAME(@"smile_loan_agreement_unselected");
    [sender setImage:image forState:UIControlStateNormal];
}

- (void)jumpToZXSDProtocolController
{
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,EXTEND_AGREEMENT_URL];
    
    viewController.title = @"展期协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)sendCodeBtnClick:(UIButton*)sender{
    ZXSDBankCardItem *card = [self selectedCard];
    if (!card) {
        [EasyTextView showText:@"请先选择一张银行卡"];
        return;
    }
//#warning --test--
//    card.isNeedValid = YES;
//#warning --test--

    if (card.isNeedValid) {
        [self sendSMSCodeChannelRequest:card];
    }
    else{
        [self sendSMSCodeRequest];
    }
}

- (void)sendAuthCode:(UIButton *)btn
                cell:(ZXSDRepaymentAuthCodeCell *)cell
{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (!self.extendModel || phone.length <= 0) {
        return;
    }
    
    btn.userInteractionEnabled = NO;
    NSDictionary *dic = @{
        @"phone":phone,
        @"type":@"OTP_EXTENDED",
        @"amount":[NSString stringWithFormat:@"%.2f", self.extendModel.extendFee]
    };
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,kPathSendVerifyCode] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissLoadingProgressHUD];
        btn.userInteractionEnabled = YES;
        ZGLog(@"发送验证码接口成功返回数据---%@",responseObject);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastWithText:@"验证码已成功发送"];
            [cell updateCountdownValue];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        btn.userInteractionEnabled = YES;
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"验证码获取失败"];
    }];
      
}

- (void)doExtendLoan
{
    if (!self.extendModel) {
        return;
    }
    if (!_checked) {
        [self showToastWithText:@"请阅读并同意展期协议"];
        return;
    }
    if (self.smsCode.length <= 0) {
        [self showToastWithText:@"请输入短信验证码"];
        return;
    }
    
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setSafeValue:self.loanRefId forKey:@"loanRefId"];
    [params setSafeValue:self.extendModel.channel forKey:@"channel"];
    [params setSafeValue:self.extendModel.bankcardRefId forKey:@"bankcardRefId"];
    [params setSafeValue:@(self.extendModel.total) forKey:@"repayAmount"];
    [params setSafeValue:phone forKey:@"phone"];
    [params setSafeValue:self.smsCode forKey:@"otpCode"];
    [params setSafeValue:self.extendModel.extendLoan.repayDate forKey:@"extendDueTime"];
    ZXSDBankCardItem *card = [self selectedCard];
    [params setSafeValue:@(card.isNeedValid) forKey:@"isSkipCheckSms"];
    [params setSafeValue:card.refId forKey:@"bankcardRefId"];

    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,APPLY_EXTEND_URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取用户相关认证状态接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *status = [responseObject objectForKey:@"payStatus"];
            NSString *errStr = [responseObject objectForKey:@"payMessage"];
            
            ZXSDExtendResultController *vc = [ZXSDExtendResultController new];
            vc.statusResult = [status isEqualToString:@"Success"] ? ZXSDExtendSuccess:ZXSDExtendFailure;
            vc.extendFailure = errStr;
            vc.extendValidDate = self.extendModel.extendLoan.repayDate;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
    
}

- (void)showChargeAlert
{
    if (!self.extendModel) {
        return;
    }
    UIView *maskView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.navigationController.view addSubview:maskView];
    
    [self.navigationController.view addSubview:self.chargeAlert];
    
    NSArray *items = @[
        @{@"key":@"利息(元)", @"value":[NSString stringWithFormat:@"%.2f", self.extendModel.interest]},
        @{@"key":@"展期费(元)", @"value":[NSString stringWithFormat:@"%.2f", self.extendModel.extendFee]},
    ];
    [_chargeAlert configWithData:items];
    [self.chargeAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigationController.view);
        make.width.mas_equalTo(296);
        make.height.mas_equalTo(262);
    }];
    
    @weakify(self);
    self.chargeAlert.confirmAction = ^{
        @strongify(self);
        [maskView removeFromSuperview];
        [self.chargeAlert removeFromSuperview];
    };
}

- (void)confirmBtnClick{
    
    if (!IsValidString(self.smsCode) ||
        self.smsCode.length < 6) {
        [self updataConfirmBtnEnable:NO];
        return;
    }
    
    ZXSDBankCardItem *card = [self selectedCard];
    if (!card) {
        [EasyTextView showText:@"请先选择一张银行卡"];
        return;
    }

    if (card.isNeedValid) {
        
        [ZXLoadingManager showLoading:kLoadingTip];
        [ZXUserViewModel confirmChannelBankCardWithSMSCode:self.smsCode channel:self.channelModel completion:^(id  _Nonnull data, NSError * _Nullable error) {
            [ZXLoadingManager hideLoading];
            if (error) {
                [self handleRequestError:error];
                return;
            }
            
            [self doExtendLoan];
        }];
    }
    else{
        [self doExtendLoan];
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return self.cardList.count;
    }
    else if (section == 2){
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
            NSString *cellIdentifier = nil;
        if (indexPath.row == 0) {
            cellIdentifier = @"cardCell";
        } else if (indexPath.row == 1){
            cellIdentifier = @"amountCell";
        } else if (indexPath.row == 2){
            cellIdentifier = @"bankCell";
        } else {
            cellIdentifier = @"codeCell";
        }
        
        ZXSDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cellIdentifier isEqualToString:@"amountCell"]) {
            ZXSDRepaymentAmountCell * amountCell = (ZXSDRepaymentAmountCell *)cell;
            [amountCell setShowChargeAlert:^{
                [self showChargeAlert];
            }];
        }
        if ([cellIdentifier isEqualToString:@"codeCell"]) {
            ZXSDRepaymentAuthCodeCell * codeCell = (ZXSDRepaymentAuthCodeCell *)cell;
            @weakify(codeCell);
            [codeCell setSendCodeAction:^(UIButton * _Nonnull sender, ZXSDRepaymentAuthCodeCell * _Nonnull cell) {
                @strongify(codeCell);
                [self sendAuthCode:sender cell:codeCell];
            }];
            [codeCell setUpdateAuthCode:^(NSString * _Nonnull code) {
                self.smsCode = code;
            }];
        }
        
        if (indexPath.row == 0 || indexPath.row == 3) {
            [cell hideBottomLine];
        } else {
            [cell showBottomLine];
        }
        
        [cell setRenderData:self.extendModel];
        
        return cell;

    }
    else if (indexPath.section == 1){
        ZXMemberPayCardCell *cell = [ZXMemberPayCardCell instanceCell:tableView];
        [cell updateWithData:self.cardList[indexPath.row]];
        
        return cell;
    }
    else if (indexPath.section == 2){
        ZXMemberSmsCodeCell *cell = [ZXMemberSmsCodeCell instanceCell:tableView];
        [cell.sendCodeBtn addTarget:self action:@selector(sendCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.smsCodeBtn = cell.sendCodeBtn;
        
        @weakify(self);
        cell.codeBlock = ^(NSString * _Nonnull code) {
            @strongify(self);
            if (!IsValidString(code) ||
                code.length < 6) {
                [self updataConfirmBtnEnable:NO];
                return;
            }
            self.smsCode = code;
            [self checkConfirmBtnStatus];
        };
        
        return cell;

    }
    
    return [tableView defaultReuseCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 35.0;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [tableView defaultHeaderFooterView];
    headerView.backgroundColor = UIColor.whiteColor;

    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = FONT_PINGFANG_X(14);
    titleLab.textColor = TextColorTitle;
    titleLab.text = @"支付方式";
    [headerView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(20);
        make.centerY.offset(0);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = NO;
    [btn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_PINGFANG_X(14);
    [btn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [btn setImage:UIImageNamed(@"smile_mine_arrow") forState:UIControlStateNormal];
    [headerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.inset(0);
        make.right.inset(20);
    }];

    @weakify(self);
    [headerView bk_whenTapped:^{
        @strongify(self);
        [self showAddNewCardVC];

    }];
    
    self.cardOptionBtn = btn;
    [headerView layoutIfNeeded];
    [btn alignWithType:ButtonAlignImgTypeRight margin:3];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {

        ZXSDBankCardItem *selItem = self.cardList[indexPath.row];
        if (!selItem.selected) {
            selItem.selected = !selItem.selected;
            
            [self.cardList enumerateObjectsUsingBlock:^(ZXSDBankCardItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj.refId isEqualToString:selItem.refId]) {
                    obj.selected = !selItem.selected;
                }
            }];
            
            [self.mainTable reloadData];
            [self checkConfirmBtnStatus];
            
        }
    }

}
#pragma mark - help methods -

- (void)checkConfirmBtnStatus{
    
    if (!IsValidString(self.smsCode) ||
        self.smsCode.length < 6) {
        [self updataConfirmBtnEnable:NO];
        return;
    }
    
    __block BOOL hasSelected = NO;
    [self.cardList enumerateObjectsUsingBlock:^(ZXSDBankCardItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            hasSelected = YES;
            *stop = YES;
        }
    }];
    
    [self updataConfirmBtnEnable:hasSelected];

}

- (void)updataConfirmBtnEnable:(BOOL)enable{
    
    self.confirmButton.userInteractionEnabled  = enable;

    if (!enable) {
        [self.confirmButton setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
        [self.confirmButton setBackgroundColor:TextColorDisable];
    }
    else{
        [self.confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.confirmButton setBackgroundColor:kThemeColorMain];

    }
    

}

- (void)showAddNewCardVC{
    ZXSDNecessaryCertThirdStepController *vc = [[ZXSDNecessaryCertThirdStepController alloc] init];
    vc.view.backgroundColor = UIColor.whiteColor;
    [vc setLeftBarButtonItem:ZXSDLeftBarButtonBackToPrevious];
    vc.addCardMode = YES;
    vc.backViewController = self;
    vc.customTitle = @"添加银行卡";
    vc.hasNote = YES;
    
    
    @weakify(self);
    vc.completionBlock = ^(NSString*  _Nonnull data) {
        @strongify(self);
        self.selectedCardRefId = data;
        
        [self requestAllCardList];
    };


    [self.navigationController pushViewController:vc animated:YES];

}



#pragma mark - Getter
- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [TPKeyboardAvoidingTableView new];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mainTable.estimatedRowHeight = 90;
    }
    return _mainTable;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(20, 160, SCREEN_WIDTH() - 40, 44);
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_confirmButton setTitle:@"确认支付" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

- (ZXSDChargeDetailAlertView *)chargeAlert
{
    if (!_chargeAlert) {
        _chargeAlert = [ZXSDChargeDetailAlertView new];
    }
    return _chargeAlert;
}

- (CJLabel *)protocolLabel
{
    if (!_protocolLabel) {
        NSString *protocolString = @"阅读已同意《展期协议》";
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
                                                       withString:@"《展期协议》"
                                                 sameStringEnable:NO
                                                   linkAttributes:@{
                                                       NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                       NSFontAttributeName:currentFont,
                                                   }
                                             activeLinkAttributes:nil
                                                        parameter:nil
                                                   clickLinkBlock:^(CJLabelLinkModel *linkModel){
            [weakself jumpToZXSDProtocolController];
            
        }
                                                   longPressBlock:^(CJLabelLinkModel *linkModel){
            [weakself jumpToZXSDProtocolController];
        }];
        _protocolLabel.attributedText = attributedString;
        _protocolLabel.extendsLinkTouchArea = YES;
    }
    return _protocolLabel;
}


#pragma mark - timer -

- (void)startTimer{
    [self stopTimer];
    
    [self timerCntDown];
    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCntDown) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

- (void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timerCnt = 60;
}

- (void)timerCntDown{
    self.timerCnt --;
    
    if (self.timerCnt > 0) {
        self.smsCodeBtn.userInteractionEnabled = NO;
        [self.smsCodeBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
        [self.smsCodeBtn setTitle:[NSString stringWithFormat:@"%@ s",@(self.timerCnt)] forState:UIControlStateNormal];
    }else{
        [self stopTimer];

        self.smsCodeBtn.userInteractionEnabled = YES;
        [self.smsCodeBtn setTitleColor:kThemeColorMain forState:UIControlStateNormal];
        [self.smsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
}


@end
