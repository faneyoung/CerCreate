//
//  ZXSDAdvanceSalaryInfoController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAdvanceSalaryInfoController.h"
#import <IQKeyboardManager.h>
#import <MSWeakTimer.h>

#import "UITableView+help.h"
#import "UIButton+Align.h"
#import "CJLabel.h"


#import "ZXSDAdvanceSalaryInfoCell.h"
#import "ZXSDRadioPickController.h"
//#import "ZXSDOpenClassIIBankAccountController.h"
#import "ZXSDAdvanceSalaryResultController.h"
#import "ZXSDMemberReviewController.h"
#import "ZXMemberCreateViewController.h"

#import "ZXSDIdentityCardVerifyController.h"
#import "ZXSDLivingDetectionController.h"
#import "ZXSDVerifyBankCardController.h"
#import "ZXSDNecessaryCertThirdStepController.h"
#import "ZXCardListViewController.h"

//views
#import "ZXMemberPayCardCell.h"
#import "ZXMemberSmsCodeCell.h"


#import "ZXSDHomeLoanInfo.h"
#import "ZXSMSChannelModel.h"
#import "ZXUserViewModel.h"
#import "EPNetworkManager+Mine.h"
#import "ZXMemberInfoModel.h"


typedef NS_ENUM(NSUInteger, AdvanceSalarySectionType) {
    AdvanceSalarySectionTypeInfo,
    AdvanceSalarySectionTypeCard,
    AdvanceSalarySectionTypeSMScode,
    AdvanceSalarySectionTypeAll
};

@interface ZXSDAdvanceSalaryInfoController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
//    UITableView *_loanTableView;
    UILabel *_detailsLabel;
    UIButton *_submitButton;
    
    NSArray *_titleArray;
    NSMutableArray *_loanAmountArray;
    
    NSString *_loanDetails;
    NSString *_loanAmont;
    NSString *_loanType;
    NSString *_repaymentDate;
    NSString *_repaymentType;
    NSString *_interest;

    NSNumber *_installPeriodLength;
    NSNumber *_installPeriodNum;
    NSString *_installPeriodUnit;
    
    
    BOOL _isNeedOpenBankAccount;
}

@property (nonatomic, strong) UITableView *loanTableView;

@property (nonatomic, assign) BOOL haveCustomer;

// 配置信息
@property (nonatomic, strong) NSArray<ZXSDHomeCreditItem*> *configInfos;

// VA模式是否需要验证
@property (nonatomic, assign) BOOL isNeedVerify;
@property (nonatomic, copy) NSString *action;

//是否需要开通会员
@property (nonatomic, assign) BOOL isNeedCustomer;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cooperationModel;
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *customerInvalidDate;
@property (nonatomic, copy) NSString *customerValidDate;
@property (nonatomic, strong) CJLabel *protocolLabel;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *agreeButton;

@property (nonatomic, strong) UIButton *cardOptionBtn;
@property (nonatomic, strong) UIButton *smsCodeBtn;
@property (nonatomic, strong) NSString *smsCode;

@property (nonatomic, assign) int timerCnt;
@property (nonatomic, strong) MSWeakTimer *timer;

@property (nonatomic, strong) NSArray *cardList;
@property (nonatomic, strong) ZXSDBankCardItem *selectedCard;

@property (nonatomic, strong) ZXSMSChannelModel *channelModel;
@property (nonatomic, strong) ZXMemberInfoModel *memberInfoModel;

@end

@implementation ZXSDAdvanceSalaryInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.enableInteractivePopGesture = YES;
    
    _isNeedOpenBankAccount = NO;
    self.title = @"预支工资";
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDataConfigure];
    [self requestAllCardList];

}

#pragma mark - data handle 0 -
///default data
- (void)prepareDataConfigure {
    _titleArray = @[@"金额 ( ¥ )",@"扣款日",@"扣款方式",@"利息 ( ¥ )"];
    _loanAmountArray = [[NSMutableArray alloc] init];
    
    
    _loanDetails = @"";
    _loanAmont = self.targetAmount.length > 0 ? self.targetAmount:@"";
    _loanType = @"";
    _repaymentDate = @"";
    _repaymentType = @"";
    _interest = @"0";
}

- (void)refreshDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,GET_ADVANCE_SALARY_INFO_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取预支薪资信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self->_loanDetails  = [[responseObject objectForKey:@"rateDesc"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"rateDesc"];
            self->_repaymentDate = [[responseObject objectForKey:@"payDate"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"payDate"];
            self->_repaymentType  = [[responseObject objectForKey:@"repayType"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"repayType"];
            self->_loanType = [[responseObject objectForKey:@"loanCode"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"loanCode"];
            self->_installPeriodLength = [responseObject objectForKey:@"installPeriodLength"];
            self->_installPeriodNum = [responseObject objectForKey:@"installPeriodNum"];
            self->_installPeriodUnit = [responseObject objectForKey:@"installPeriodUnit"];
            
            if ([[responseObject objectForKey:@"haveBank2Number"] integerValue] == 1) {
                //self->_isNeedOpenBankAccount = YES;
            } else {
                //self->_isNeedOpenBankAccount = NO;
            }
            self.haveCustomer = [[responseObject objectForKey:@"haveCustomer"] boolValue];
            self.isNeedVerify = [[responseObject objectForKey:@"isNeedVerify"] boolValue];
            self.isSuccess = [[responseObject objectForKey:@"isSuccess"] boolValue];
            self.isNeedCustomer = [[responseObject objectForKey:@"isNeedCustomer"] boolValue];
            
            self.customerValidDate = [responseObject objectForKey:@"customerValidDate"];
            self.customerInvalidDate = [responseObject objectForKey:@"customerInvalidDate"];
            
            self.action = [responseObject objectForKey:@"action"];
            self.message = [responseObject objectForKey:@"message"];
            self.cooperationModel = [responseObject objectForKey:@"cooperationModel"];
            self.remark = [responseObject objectForKey:@"remark"];
            
            self.configInfos = [NSArray yy_modelArrayWithClass:[ZXSDHomeCreditItem class] json:[responseObject objectForKey:@"creditLimitList"]];
            
            [self->_loanAmountArray removeAllObjects];
            for (ZXSDHomeCreditItem *model in self.configInfos) {
                
                if (model.eable) {
                    [self->_loanAmountArray addObject:@(model.unit).stringValue];
                }
            }
            
            if (!IsValidString(self.targetAmount) && self->_loanAmountArray.count > 0) {
               self->_loanAmont = self.targetAmount = self->_loanAmountArray.firstObject;
            }
            
            self.memberInfoModel = [ZXMemberInfoModel instanceWithDictionary:responseObject];
        }
        
        self->_detailsLabel.text = self->_loanDetails;
        self.tipsLabel.text = self.remark;
        [self.loanTableView reloadData];
        
        [self requestAllCardList];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"获取信息失败"];
    }];
}


// 申请预支
- (void)submitLoanRequest
{

    NSInteger principalValue = [_loanAmont integerValue];
    
    NSMutableDictionary *parameters = @{}.mutableCopy;
    [parameters setSafeValue:_loanType forKey:@"code"];
    [parameters setSafeValue:_installPeriodLength forKey:@"installPeriodLength"];
    [parameters setSafeValue:_installPeriodNum forKey:@"installPeriodNum"];
    [parameters setSafeValue:_installPeriodUnit forKey:@"installPeriodUnit"];
    [parameters setSafeValue:@(principalValue) forKey:@"principal"];
    [parameters setSafeValue:self.selectedCard.refId forKey:@"bankCardRefId"];
    [parameters setSafeValue:self.memberInfoModel.advanceCouponRefId forKey:@"couponRefId"];

    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:SUBMIT_LOAN_URL parameters:parameters.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            return;
        }
        
        [self jumpToAdvanceSalaryResultController];
    }];
}

#pragma mark - views -

- (void)addUserInterfaceConfigure {
    _loanTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 84) style:UITableViewStylePlain];
    _loanTableView.backgroundColor = [UIColor whiteColor];
    _loanTableView.delegate = self;
    _loanTableView.dataSource = self;
    _loanTableView.showsVerticalScrollIndicator = NO;
    _loanTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _loanTableView.separatorColor = kThemeColorLine;
    _loanTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _loanTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_loanTableView];
    /*
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 110)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"预支工资";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [headerView addSubview:titleLabel];
    
    _detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH() - 40, 20)];
    _detailsLabel.text = _loanDetails;
    _detailsLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    _detailsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    [headerView addSubview:_detailsLabel];*/
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH() - 40, SEPARATE_SINGLE_LINE_WIDTH())];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xDDDDDD);
    [footerView addSubview:lineView];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame = CGRectMake(20, 22, 16, 16);
    [agreeButton setImage:[UIImage imageNamed:@"smile_loan_agreement_unselected"] forState:UIControlStateNormal];
    [agreeButton setImage:[UIImage imageNamed:@"smile_loan_agreement_selected"] forState:UIControlStateSelected];
    [agreeButton addTarget:self action:@selector(agreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    agreeButton.selected = NO;
    agreeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
    [footerView addSubview:agreeButton];
    
    [footerView addSubview:self.protocolLabel];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreeButton.mas_right).offset(15);
        make.centerY.equalTo(agreeButton);
        make.height.mas_equalTo(20);
    }];
    self.agreeButton = agreeButton;
    
    [footerView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreeButton);
        make.top.equalTo(agreeButton.mas_bottom).offset(10);
    }];
    
    
    //_loanTableView.tableHeaderView = headerView;
    _loanTableView.tableFooterView = footerView;
    
    CGFloat safaAreaBottom = iPhoneXSeries() ? 34 : 0;
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 20 - 44 - safaAreaBottom, SCREEN_WIDTH() - 40, 44);
    [_submitButton setBackgroundImage:[UIImage imageWithColor:UICOLOR_FROM_HEX(0xF5F5F5)] forState:(UIControlStateNormal)];
    [_submitButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateSelected)];
    
    [_submitButton setTitle:@"确认预支" forState:UIControlStateNormal];
    [_submitButton setTitleColor:UICOLOR_FROM_HEX(0xCCCCCC) forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.cornerRadius = 22.0;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.userInteractionEnabled = NO;
    [self.view addSubview:_submitButton];
    
    [_loanTableView registerNibs:@[
        NSStringFromClass(ZXMemberPayCardCell.class),
        NSStringFromClass(ZXMemberSmsCodeCell.class),
    ]];
    
}

#pragma mark - Action

- (void)cancelButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)checkConfirmBtnStatus{
    
    BOOL enable = NO;
    if (self.agreeButton.selected) {
        if (IsValidArray(self.cardList)) {

            if (self.selectedCard.isNeedValid) {
                if (self.smsCode.length == 6) {
                    enable = YES;
                }
            }
            else{
                enable = YES;
            }
        }
        else{
            enable = YES;
        }
    }
    
    _submitButton.selected = enable;
    _submitButton.userInteractionEnabled = enable;

    [_submitButton setTitleColor:enable ? [UIColor whiteColor] : UICOLOR_FROM_HEX(0xCCCCCC) forState:UIControlStateNormal];
    
}

- (void)agreeButtonClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    [self checkConfirmBtnStatus];
}

- (void)submitButtonClicked:(UIButton *)btn {
    
//#warning --test--
//    [self jumpToAdvanceSalaryResultController];
//    return;
//    _loanAmont = @"100";
//    _loanType = @"23";
//    _installPeriodUnit = @"dsufid";
//#warning --test--

    
    if ([ZXSDPublicClassMethod emptyOrNull:_loanAmont]) {
        [self showToastWithText:@"请选择预支薪资金额"];
        return;
    }
    
    __block ZXSDHomeCreditItem *model = nil;
    [self.configInfos indexOfObjectPassingTest:^BOOL(ZXSDHomeCreditItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_loanAmont integerValue] == obj.unit) {
            *stop = YES;
            model = obj;
            return YES;
        }
        return NO;
    }];
    
//#warning --test--
//    model = [[ZXSDHomeCreditItem alloc] init];
//    self.cardList = @[];
//    self.isSuccess = @"fdslj";
//#warning --test--

    
    if ([ZXSDPublicClassMethod emptyOrNull:_loanType] || [ZXSDPublicClassMethod emptyOrNull:_installPeriodUnit] || !model) {
        [self showToastWithText:@"系统错误,请退出本页面后重试!"];
        return;
    }
    
    if (!self.isSuccess) {
        NSString *message = CHECK_VALID_STRING(self.message)?self.message:@"服务异常，请稍后重试";
        [self showToastWithText:message];
        return;
    }
    
    if (self.isNeedVerify) {
        [self handleVerifyAction];
        return;
    }
    
    if (IsValidArray(self.cardList)) {
        ZXSDBankCardItem *card = self.selectedCard;
        if (card.isNeedValid) {
            
            LoadingManagerShow();
            [ZXUserViewModel confirmChannelBankCardWithSMSCode:self.smsCode channel:self.channelModel completion:^(id  _Nonnull data, NSError * _Nullable error) {
                LoadingManagerHidden();
                if (error) {
                    [self handleRequestError:error];
                    return;
                }
                
                [self continueOriginAdvanceWithModel:model];
            }];

            return;
        }
    }
    
    [self continueOriginAdvanceWithModel:model];
    
}

- (void)continueOriginAdvanceWithModel:(ZXSDHomeCreditItem *)model{
//#warning --test--
//    self.haveCustomer  =nil;
//    self.isNeedCustomer = YES;
//#warning --test--

    
    //需要开会员 & 不是会员 & 本笔借款需要开通会员
    if (self.isNeedCustomer && !self.haveCustomer && model.customerOpen) {
        
        ZXMemberCreateViewController *memberVC = [[ZXMemberCreateViewController alloc] init];
        memberVC.memberInfoModel = self.memberInfoModel;
        memberVC.loanAmount = _loanAmont;
        memberVC.interest = _interest;
        [self.navigationController pushViewController:memberVC animated:YES];
    }
    else{
        [self submitLoanRequest];
    }

    return;
    
    
    
    BOOL flag = model.customerOpen;
    //[[self.customerConfig objectForKey:_loanAmont] boolValue];
    
    ZXSDMemberReviewController *vc = [ZXSDMemberReviewController new];
    vc.flag = flag;
    vc.haveCustomer = self.haveCustomer;
    vc.loanAmount = _loanAmont;
    vc.interest = _interest;
    vc.customerInvalidDate = self.customerInvalidDate;
    vc.customerValidDate = self.customerValidDate;
    if (_repaymentDate.length >= 11) {
        vc.repaymentDate = [_repaymentDate substringToIndex:10];
    } else {
        vc.repaymentDate = _repaymentDate;
    }
    
    vc.loanType = _loanType;
    vc.installPeriodLength = _installPeriodLength;
    vc.installPeriodNum = _installPeriodNum;
    vc.installPeriodUnit = _installPeriodUnit;
    vc.bankCardItem = self.selectedCard;
    
    [self.navigationController pushViewController:vc animated:YES];

}

//等待审核状态页面
- (void)jumpToAdvanceSalaryResultController {
    ZXSDAdvanceSalaryResultController *viewController = [ZXSDAdvanceSalaryResultController new];
    viewController.success = YES;
    viewController.loanAmount = _loanAmont;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - help methods -

//跳转预支薪资协议
- (void)jumpToAdvanceSalaryAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];

    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,EXTEND_AGREEMENT_URL];
    viewController.title = @"预支薪资协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)jumpToChargeAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];

    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,ADVANCE_SALARY_AGREEMENT_URL];
    viewController.title = @"委托扣款协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handleVerifyAction
{
    NSString *status = self.action;
    
    if ([status isEqualToString: ZXSDHomeUserApplyStatus_IDCARD_UPLOAD]) {
        ZXSDIdentityCardVerifyController * vc = [ZXSDIdentityCardVerifyController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
            
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_FACE]) {
        
        ZXSDLivingDetectionController *vc = [ZXSDLivingDetectionController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_BANKCARD]) {
        
        [self bindCardAction];
    }
}

- (void)bindCardAction
{
    if ([ZXSDCurrentUser currentUser].businessModel == ZXSDCooperationModelEmployerQuery) {
        ZXSDVerifyBankCardController *vc = [ZXSDVerifyBankCardController new];
        vc.bindCard = YES;
        vc.backViewController = self;
        @weakify(vc);
        [vc setBindCardCompleted:^(BOOL success, NSError * _Nullable error) {
            @strongify(vc);
            [vc.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXSDNecessaryCertThirdStepController *vc = [ZXSDNecessaryCertThirdStepController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)gotoCardListVC{
    ZXCardListViewController *viewController = [[ZXCardListViewController alloc] init];
    viewController.card = self.selectedCard;
    @weakify(self);
    viewController.completionBlock = ^(ZXSDBankCardItem*  _Nonnull data) {
        @strongify(self);
        self.selectedCard = data;
        [self.loanTableView reloadData];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AdvanceSalarySectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == AdvanceSalarySectionTypeInfo) {
        return _titleArray.count;
    }
    else if(section == AdvanceSalarySectionTypeCard){
        return 1;
    }
    else if(section == AdvanceSalarySectionTypeSMScode){
        return self.selectedCard.isNeedValid ? 1 : 0;
    }
    
//    if (IsValidArray(self.cardList)) {
//        ZXSDBankCardItem *card = self.cardList.firstObject;
//        if (card.isNeedValid) {
//            return _titleArray.count + 1;
//        }
//    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (indexPath.section == AdvanceSalarySectionTypeInfo) {
        static NSString *cellName = @"advanceSalaryInfoCell";
        ZXSDAdvanceSalaryInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[ZXSDAdvanceSalaryInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        
        if (_titleArray.count-1 >= indexPath.row) {
            cell.titleLabel.text = _titleArray[indexPath.row];
            cell.textField.delegate = self;
            cell.textField.tag = indexPath.row;
        }
        
        switch (indexPath.row) {
            case 0:
            {
                cell.canChoice = YES;
                cell.textField.placeholder = @"请选择";
                cell.textField.text = _loanAmont;
                cell.textField.font = FONT_SFUI_X_Regular(14);
            }
                break;
            case 1:
            {
                cell.canChoice = NO;
                cell.textField.text = _repaymentDate;
                cell.textField.font = FONT_SFUI_X_Regular(14);
            }
                break;
            case 2:
            {
                cell.canChoice = NO;
                cell.textField.text = _repaymentType;
            }
                break;
            case 3:
            {
                cell.canChoice = NO;
                cell.textField.text = _interest;
                cell.textField.font = FONT_SFUI_X_Regular(14);
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
    else if(indexPath.section == AdvanceSalarySectionTypeCard){
        
        ZXMemberPayCardCell *cell = [ZXMemberPayCardCell instanceCell:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

        ZXSDBankCardItem *item = self.selectedCard;
        if (!item) {
            if (IsValidArray(self.cardList)) {
                item = self.cardList[indexPath.row];
            }
        }
        [cell updateWithData:item];

        return cell;
    }
    else if(indexPath.section == AdvanceSalarySectionTypeSMScode){
        ZXMemberSmsCodeCell *cell = [ZXMemberSmsCodeCell instanceCell:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

//        cell.hideTitle = YES;
        cell.hideSepLine = YES;
        [cell.sendCodeBtn addTarget:self action:@selector(sendCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.smsCodeBtn = cell.sendCodeBtn;
        
        @weakify(self);
        cell.codeBlock = ^(NSString * _Nonnull code) {
            @strongify(self);
            
            self.smsCode = code;
            [self checkConfirmBtnStatus];
        };
        
        return cell;
    }
    
    
    return [tableView defaultReuseCell];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == AdvanceSalarySectionTypeInfo) {
        return 60.f;
    }
    else{
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == AdvanceSalarySectionTypeCard) {
        return 35.0;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColor.whiteColor;
    headerView.clipsToBounds = YES;

    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = FONT_PINGFANG_X(14);
    titleLab.textColor = TextColorTitle;
    titleLab.text = @"收款方式";
    [headerView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(20);
        make.centerY.offset(0);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = NO;
    [btn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_PINGFANG_X(14);
    [btn setTitle:@"选择银行卡" forState:UIControlStateNormal];
    [btn setImage:UIImageNamed(@"smile_mine_arrow") forState:UIControlStateNormal];
    [headerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.inset(0);
        make.right.inset(20);
    }];

    @weakify(self);
    [headerView bk_whenTapped:^{
        @strongify(self);
        [self gotoCardListVC];

    }];
    
    self.cardOptionBtn = btn;
    [headerView layoutIfNeeded];
    [btn alignWithType:ButtonAlignImgTypeRight margin:3];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == AdvanceSalarySectionTypeInfo) {
        return 8;
    }
    return CGFLOAT_MIN;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [tableView defaultHeaderFooterView];
    footerView.backgroundColor = kThemeColorLine;
    
    return footerView;
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


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    
    if (textField.tag == 0 && self.configInfos) {
        [self handlerTextFieldSelect:textField];
    }
    return NO;
}

#pragma mark - 处理点击事件
- (void)handlerTextFieldSelect:(UITextField *)textField  {
    if (textField.tag == 0) {
        if (_loanAmountArray.count < 1) {
            return;
        }
        ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        viewController.pickArray = _loanAmountArray;
        viewController.pickTitle = @"金额(元)";
        viewController.isSelectNumber = YES;
        viewController.selectedValue = self->_loanAmont;
        viewController.pickAchieveString = ^(NSString *returnString) {
            textField.text = returnString;
            self->_loanAmont = returnString;
            
            __block ZXSDHomeCreditItem *model = nil;
            [self.configInfos indexOfObjectPassingTest:^BOOL(ZXSDHomeCreditItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([returnString integerValue] == obj.unit) {
                    *stop = YES;
                    model = obj;
                    return YES;
                }
                return NO;
            }];
            
            self->_interest = model.fee;
            
            [self.loanTableView reloadData];
        };
        [self presentViewController:viewController animated:NO completion:^{
            [viewController beginAnimation];
        }];
    }
}

#pragma mark - 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Getter
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
    }
    return _tipsLabel;
}

- (CJLabel *)protocolLabel
{
    if (!_protocolLabel) {
        
        NSString *phone = [ZXSDCurrentUser currentUser].phone;
        // special logic for review
        BOOL limited = [phone isEqualToString:@"18917890367"];
        
        NSString *protocolString = limited ? @"同意《委托扣款协议》": @"同意《预支薪资协议》和《委托扣款协议》";
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
        if (!limited) {
            attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                           withString:@"《预支薪资协议》"
                                                     sameStringEnable:NO
                                                       linkAttributes:@{
                                                           NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                           NSFontAttributeName:currentFont,
                                                       }
                                                 activeLinkAttributes:nil
                                                            parameter:nil
                                                       clickLinkBlock:^(CJLabelLinkModel *linkModel){
                [weakself jumpToAdvanceSalaryAgreementController];
            }longPressBlock:^(CJLabelLinkModel *linkModel){
                [weakself jumpToAdvanceSalaryAgreementController];
            }];
        }
        
        
        attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                       withString:@"《委托扣款协议》"
                                                 sameStringEnable:NO
                                                   linkAttributes:@{
                                                       NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                       NSFontAttributeName:currentFont,
                                                   }
                                             activeLinkAttributes:nil
                                                        parameter:nil
                                                   clickLinkBlock:^(CJLabelLinkModel *linkModel){
            [weakself jumpToChargeAgreementController];
        }longPressBlock:^(CJLabelLinkModel *linkModel){
            [weakself jumpToChargeAgreementController];
        }];
        _protocolLabel.attributedText = attributedString;
        _protocolLabel.extendsLinkTouchArea = YES;
    }
    return _protocolLabel;
}

#pragma mark - data handle 1 -

- (void)requestAllCardList{
    [self showLoadingProgressHUDWithText:kLoadingTip];
    @weakify(self);
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"01" forKey:@"businessScenario"];
    [EPNetworkManager getUserBankCards:tmps.copy completion:^(NSArray<ZXSDBankCardItem *> *records, NSError *error) {
        @strongify(self);
        
        [self dismissLoadingProgressHUDImmediately];
        
        if (error) {
//            [self handleRequestError:error];
            return;
        }
        
        if (!self.selectedCard) {
            ZXSDBankCardItem *card = records.firstObject;
            card.selected = YES;
            self.selectedCard = card;
        }
//#warning --test--
//        ZXSDBankCardItem *card = records.firstObject;
//        card.isNeedValid = YES;
//#warning --test--

        
        self.cardList = records;
        
        [self.loanTableView reloadData];
    }];

}

- (void)sendSMSCodeChannelRequest:(ZXSDBankCardItem*)card{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }

    [ZXLoadingManager showLoading:kLoadingTip];
    [ZXUserViewModel sendSMSCodeWithCard:card phone:phone business:@"01" completion:^(ZXSMSChannelModel *  _Nonnull data, NSError * _Nullable error) {
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


#pragma mark - timer -
- (void)sendCodeBtnClick:(UIButton*)sender{
    ZXSDBankCardItem *card = self.selectedCard;
    if (!card) {
        [EasyTextView showText:@"银行卡无效"];
        return;
    }
    
    if (card.isNeedValid) {
        [self sendSMSCodeChannelRequest:card];
    }
    
}

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
