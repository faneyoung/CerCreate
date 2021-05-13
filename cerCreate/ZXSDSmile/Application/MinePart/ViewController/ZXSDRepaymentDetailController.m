//
//  ZXSDRepaymentDetailController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDRepaymentDetailController.h"
#import <IQKeyboardManager.h>

#import "UIButton+Align.h"

#import "ZXSDRepaymentAmountCell.h"
#import "ZXSDRepaymentBankCell.h"
#import "ZXSDExtendResultController.h"
#import "ZXSDChargeDetailAlertView.h"
#import "ZXSDRepaymentAuthCodeCell.h"

#import "ZXMemberPayCardCell.h"
#import "ZXMemberSmsCodeCell.h"

#import <MSWeakTimer.h>
#import "EPNetworkManager+Mine.h"
#import "ZXUserViewModel.h"

//vc
#import "ZXSDNecessaryCertThirdStepController.h"
#import "ZXResultNoteViewController.h"


static const NSString *REPAYMENT_DETAIL_URL = @"/rest/loan/teller/repayConfirm";
static const NSString *REPAYMENT_REQUEST_URL = @"/rest/loan/teller/repayRequest";

@interface ZXSDRepaymentDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) ZXSDChargeDetailAlertView *chargeAlert;
@property (nonatomic, strong) ZXSDRepaymentInfoModel *infoModel;

@property (nonatomic, strong) UIButton *cardOptionBtn;

@property (nonatomic, strong) NSArray *cardList;
@property (nonatomic, strong) NSString *selectedCardRefId;

@property (nonatomic, strong) UIButton *smsCodeBtn;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, strong) ZXSMSChannelModel *channelModel;

@property (nonatomic, assign) int timerCnt;
@property (nonatomic, strong) MSWeakTimer *timer;

@end

@implementation ZXSDRepaymentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"立刻还款";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self addUserInterfaceConfigure];
    [self prepareDataConfigure];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self requestAllCardList];
}

- (void)viewDidLayoutSubviews{
    [self.cardOptionBtn alignWithType:ButtonAlignImgTypeRight margin:3];
}


#pragma mark - data handle -

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

- (void)prepareDataConfigure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];


    NSMutableDictionary *loanInfoDic = @{}.mutableCopy;
    [loanInfoDic setSafeValue:self.loanRefId forKey:@"loanRefId"];
    [loanInfoDic setSafeValue:@(-1) forKey:@"periodNum"];
//    NSArray *loanInfos = @[@{
//                               @"loanRefId":self.loanRefId,
//                               @"periodNum":@(-1)
//    }];
//    [params setSafeValue:loanInfos forKey:@"loanInfo"];
    if (IsValidDictionary(loanInfoDic.copy)) {
        [params setSafeValue:@[loanInfoDic] forKey:@"loanInfo"];
    }
    
    [params setSafeValue:self.bankcardRefId forKey:@"bankcardRefId"];
    [params setSafeValue:@"protocol_dk" forKey:@"channel"];
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,REPAYMENT_DETAIL_URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"确认还款接口成功返回数据---%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.infoModel = [ZXSDRepaymentInfoModel modelWithJSON:responseObject];
            [self.mainTable reloadData];
        }
        [self dismissLoadingProgressHUDImmediately];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}


- (void)requestAllCardList{
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"05" forKey:@"businessScenario"];
    [EPNetworkManager getUserBankCards:tmps.copy completion:^(NSArray<ZXSDBankCardItem *> *records, NSError *error) {
        
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

- (void)sendSMSCodeRequest{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }

    self.smsCodeBtn.userInteractionEnabled = NO;
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:phone forKey:@"phone"];
    [tmps setSafeValue:@"OTP_REPAY" forKey:@"type"];
    [tmps setSafeValue:[NSString stringWithFormat:@"%.2f", self.infoModel.actualAmount] forKey:@"amount"];
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    [ZXUserViewModel sendSMSCodeRequestWithPms:tmps.copy type:SMSCodeTypeRefund completion:^(id  _Nonnull data, NSError * _Nullable error) {
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


- (void)sendSMSCodeChannelRequest:(ZXSDBankCardItem*)card{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }

    [ZXLoadingManager showLoading:kLoadingTip];
    [ZXUserViewModel sendSMSCodeWithCard:card phone:phone  business:@"05" completion:^(ZXSMSChannelModel *  _Nonnull data, NSError * _Nullable error) {
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


#pragma mark - views -

- (void)addUserInterfaceConfigure
{
    
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.height.mas_equalTo(44);
        make.bottom.inset(kBottomSafeAreaHeight+16);
    }];
    [self updataConfirmBtnEnable:NO];


    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top);
    }];
    
    
    [self.mainTable registerClass:[ZXSDRepaymentAmountCell class] forCellReuseIdentifier:@"amountCell"];
//    [self.mainTable registerClass:[ZXSDRepaymentBankCell class] forCellReuseIdentifier:@"bankCell"];
//    [self.mainTable registerClass:[ZXSDRepaymentAuthCodeCell class] forCellReuseIdentifier:@"codeCell"];
    
    [self.mainTable registerNib:[UINib nibWithNibName:NSStringFromClass(ZXMemberPayCardCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(ZXMemberPayCardCell.class)];
    [self.mainTable registerNib:[UINib nibWithNibName:NSStringFromClass(ZXMemberSmsCodeCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(ZXMemberSmsCodeCell.class)];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
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
        ZXSDRepaymentAmountCell * amountCell = [tableView dequeueReusableCellWithIdentifier:@"amountCell" forIndexPath:indexPath];
        [amountCell hideBottomLine];
        [amountCell setShowChargeAlert:^{
            [self showChargeAlert];
        }];
        
        [amountCell setRenderData:self.infoModel];
        return amountCell;
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
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 35.0;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        return CGFLOAT_MIN;
    }
    
    return 8;
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
            
            [tableView reloadData];
            [self checkConfirmBtnStatus];
        }
    }

}

- (UITableViewCell *)dep_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = nil;
    if (indexPath.row == 0) {
        cellIdentifier = @"amountCell";
    } else if (indexPath.row == 1){
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
    if (indexPath.row == 2) {
        [cell hideBottomLine];
    } else {
        [cell showBottomLine];
    }
   
    [cell setRenderData:self.infoModel];
    
    return cell;
}

- (CGFloat)dep_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - action methods -

- (void)sendCodeBtnClick:(UIButton*)sender{
    ZXSDBankCardItem *card = [self selectedCard];
    if (!card) {
        [EasyTextView showText:@"请先选择一张银行卡"];
        return;
    }
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
    ZXSDBankCardItem *card = [self selectedCard];
    if (card.isNeedValid) {
        [self sendSMSCodeChannelRequest:card];
    }
    else{
        [self sendSMSCodeRequest];
    }
    
    return;
    
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (!self.infoModel || phone.length <= 0) {
        return;
    }
    
    btn.userInteractionEnabled = NO;
    NSDictionary *dic = @{
        @"phone":phone,
        @"type":@"OTP_REPAY",
        @"amount":[NSString stringWithFormat:@"%.2f", self.infoModel.actualAmount]
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

- (void)confirmBtnClick{
//#warning --test--
//    ZXResultNoteViewController *resultVC = [[ZXResultNoteViewController alloc] init];
//    ResultPageType pageType = 0;
//    if ([@"Success" isEqualToString:@"Success"]) {
//        pageType = ResultPageTypeRefundSuccess;
//    }
//    else{
//        pageType = ResultPageTypeRefundFail;
//    }
//    resultVC.resultPageType = pageType;
//    [self.navigationController pushViewController:resultVC animated:YES];
//    return;
//#warning --test--

    if (!IsValidString(self.smsCode) ||
        self.smsCode.length < 6) {
        [self updataConfirmBtnEnable:NO];
        return;
    }
    
    ZXSDBankCardItem *card = [self selectedCard];
    if (card.isNeedValid) {
        
        [ZXLoadingManager showLoading:kLoadingTip];
        [ZXUserViewModel confirmChannelBankCardWithSMSCode:self.smsCode channel:self.channelModel completion:^(id  _Nonnull data, NSError * _Nullable error) {
            [ZXLoadingManager hideLoading];
            if (error) {
                [self handleRequestError:error];
                return;
            }
            
            [self doRepayment];
        }];
    }
    else{
        [self doRepayment];
    }

}

- (void)doRepayment
{
    if (self.loanRefId.length <=0 ||
        self.bankcardRefId.length <= 0) {
        return;
    }
    if (self.smsCode.length <= 0) {
        [self showToastWithText:@"请输入短信验证码"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSArray *loanInfos = @[@{
                               @"loanRefId":self.loanRefId,
                               @"periodNum":@(-1)
    }];
    [params setValue:loanInfos forKey:@"loanInfo"];
    [params setValue:self.bankcardRefId forKey:@"bankcardRefId"];
    [params setValue:@"protocol_dk" forKey:@"channel"];
    [params setValue:self.smsCode forKey:@"otpCode"];
    
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    [params setValue:phone forKey:@"phone"];
    
    ZXSDBankCardItem *card = [self selectedCard];
    [params setSafeValue:@(card.isNeedValid) forKey:@"isSkipCheckSms"];
    [params setSafeValue:card.refId forKey:@"bankcardRefId"];

    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,REPAYMENT_REQUEST_URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"立即还款接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];

//        NSString *payCode = [responseObject stringObjectForKey:@"payCode"];
//        if ([self shouldShowReBindAlertView:payCode]) {
//            return;
//        }

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *status = [responseObject objectForKey:@"payStatus"];
            NSString *msg = [(NSDictionary*)responseObject stringObjectForKey:@"payMessage"];

            
//            ZXSDExtendResultController *vc = [ZXSDExtendResultController new];
//            vc.statusResult = [status isEqualToString:@"Success"] ? ZXSDRepaymentSuccess:ZXSDRepaymentFailure;
//            vc.repaymentFailure = errStr;
//            [self.navigationController pushViewController:vc animated:YES];
            
            ZXResultNoteViewController *resultVC = [[ZXResultNoteViewController alloc] init];
            ResultPageType pageType = 0;
            if ([status isEqualToString:@"Success"]) {
                pageType = ResultPageTypeRefundSuccess;
                
            }
            else if([status isEqualToString:@"Doing"]){
                pageType = ResultPageTypeRefundDoing;
                resultVC.payMessage = msg;

            }
            else{
                pageType = ResultPageTypeRefundFail;
                resultVC.payMessage = msg;
            }
            
            NSString *payCode = [responseObject stringObjectForKey:@"payCode"];
            if ([payCode isEqualToString:@"3034"]) {
                pageType = ResultPageTypeRebind;
                
                resultVC.payMessage = msg;
            }
            
            resultVC.resultPageType = pageType;
            [self.navigationController pushViewController:resultVC animated:YES];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self dismissLoadingProgressHUDImmediately];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (BOOL)shouldShowReBindAlertView:(NSString*)code{
    
    if (![code isEqualToString:@"3034"]) {
        return NO;
    }
    
    @weakify(self);
    NSString *title = @"未与银行签约，请点击“确定”关闭此页面，并重新点击“立即还款”。";
    [self showAlertWithTitle:title message:@"" confirm:@"确定" cancel:@"" confirmBlock:^{
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } cancelBlock:nil];
    
    return YES;
}

- (void)showChargeAlert
{
    if (!self.infoModel) {
        return;
    }
    UIView *maskView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.navigationController.view addSubview:maskView];
    
    [self.navigationController.view addSubview:self.chargeAlert];
    
    NSArray *items = @[
        @{@"key":@"预支本金(元)", @"value":[NSString stringWithFormat:@"%.2f", self.infoModel.principal]},
        @{@"key":@"利息(元)", @"value":[NSString stringWithFormat:@"%.2f", self.infoModel.interest]},
        @{@"key":@"逾期费(元)", @"value":[NSString stringWithFormat:@"%.2f", self.infoModel.punishFee]},
    ];
    [_chargeAlert configWithData:items];
    [self.chargeAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigationController.view);
        make.width.mas_equalTo(296);
        make.height.mas_equalTo(315);
    }];
    
    @weakify(self);
    self.chargeAlert.confirmAction = ^{
        @strongify(self);
        [maskView removeFromSuperview];
        [self.chargeAlert removeFromSuperview];
    };
}

#pragma mark - Getter
- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [UITableView new];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.estimatedRowHeight = 90;
        _mainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mainTable.backgroundColor = UIColor.whiteColor;
    }
    return _mainTable;
}

- (ZXSDChargeDetailAlertView *)chargeAlert
{
    if (!_chargeAlert) {
        _chargeAlert = [ZXSDChargeDetailAlertView new];
    }
    return _chargeAlert;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_confirmBtn setTitle:@"确认还款" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = FONT_PINGFANG_X(14);
        ViewBorderRadius(_confirmBtn, 22, 0.01, UIColor.whiteColor);
    }
    return _confirmBtn;
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
    
    self.confirmBtn.userInteractionEnabled  = enable;

    if (!enable) {
        [self.confirmBtn setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundColor:TextColorDisable];
    }
    else{
        [self.confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundColor:kThemeColorMain];

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

- (void)showPayResultPageViewController:(NSDictionary*)data{
    
    //                NSMutableArray *tmps = self.navigationController.viewControllers.mutableCopy;
    //                [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                    if ([obj isKindOfClass:NSClassFromString(@"WLLoginViewController")]) {
    //                        [tmps removeObject:obj];
    //                    }
    //                }];
    //                self.navigationController.viewControllers = tmps.copy;
    
    NSString *status = [data stringObjectForKey:@"payStatus"];
//    ZXSDOpenMemberResultController *vc = [ZXSDOpenMemberResultController new];
//    vc.success = [status isEqualToString:@"Success"];
//    vc.errorStr = [data stringObjectForKey:@"payMessage"];
//    vc.customerValidDate = self.feeModel.customerValidDate;
//    vc.customerInvalidDate = self.feeModel.customerInvalidDate;
//
//    vc.installPeriodLength = self.feeModel.installPeriodLength;
//    vc.installPeriodNum = self.feeModel.installPeriodNum;
//    vc.installPeriodUnit = self.feeModel.installPeriodUnit;
//    vc.loanType = self.feeModel.loanType;
//    vc.loanAmount = self.feeModel.loanAmount;
//    [self.navigationController pushViewController:vc animated:YES];

    ZXResultNoteViewController *resultVC = [[ZXResultNoteViewController alloc] init];
    ResultPageType pageType = 0;
    if ([status isEqualToString:@"Success"]) {
        pageType = ResultPageTypeMemberFeeSuccess;
    }
    else{
        pageType = ResultPageTypeMemberFeeFail;
    }
    resultVC.resultPageType = pageType;
    [self.navigationController pushViewController:resultVC animated:YES];
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
