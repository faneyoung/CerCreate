//
//  ZXSDMemberReviewController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDMemberReviewController.h"
#import "CJLabel.h"
#import "ZXSDAuthCodeAlertView.h"
#import "ZXSDAdvanceDetailCell.h"
#import "ZXSDAdvanceRuleCell.h"
#import "ZXSDAdvanceCardCell.h"
#import "ZXSDMemberAlertView.h"

#import "ZXSDAdvanceSalaryResultController.h"
#import "ZXSDInviteCompanyController.h"

#import "ZXMemberPayViewController.h"

#import "EPNetworkManager.h"
#import "ZXSDBankCardModel.h"
#import "ZXMemberInfoModel.h"


static const NSInteger ZXSD_MEMBER_FEE = 30;

//static const NSString *SUBMIT_LOAN_URL = @"/rest/loan/create";
static const NSString *SUBMIT_MEMBERSHIPFEE_URL = @"/rest/loan/teller/repayMembershipFee";
static const NSString *RECOMMEND_COMPANY_URL = @"/rest/recommend/company";

@interface ZXSDMemberReviewController ()<UITableViewDelegate,UITableViewDataSource,ZXSDAdvanceCardCellDelegate>
{
    
}

@property (nonatomic, assign) MemberReviewStatus status;
@property (nonatomic, assign) BOOL checked;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) CJLabel *protocolLabel;

@property (nonatomic, strong) ZXSDMemberAlertView *memberAlert;
@property (nonatomic, strong) ZXSDMemberAlertView *plusMemberAlert;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) ZXSDAuthCodeAlertView *authAlert;

@property (nonatomic, assign) BOOL haveRecommend;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *amoutBindForAuth;

@property (nonatomic, strong) ZXMemberInfoModel *memberInfoModel;

@end

@implementation ZXSDMemberReviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self preProcessStatus];
    _haveRecommend = NO;
    self.title = @"薪朋友会员";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_close") style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonClicked)];
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
}

- (void)preProcessStatus
{
    if (self.haveCustomer) {
        self.status = MemberReviewStatus3;
    } else {
        if (self.flag) {
            self.status = MemberReviewStatus1;
        } else {
            self.status = MemberReviewStatus2;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
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

- (void)prepareDataConfigure {
    
}

- (void)addUserInterfaceConfigure
{
    self.mainTable.tableHeaderView = [self buildHeader];
    
    UIView *bottomView = [self buildFooter];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (self.status != MemberReviewStatus3){
            make.height.mas_equalTo(120);
        } else {
            make.height.mas_equalTo(64);
        }
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [self.mainTable registerClass:[ZXSDAdvanceDetailCell class] forCellReuseIdentifier:@"detailCell"];
    [self.mainTable registerClass:[ZXSDAdvanceCardCell class] forCellReuseIdentifier:@"cardCell"];
    [self.mainTable registerClass:[ZXSDAdvanceRuleCell class] forCellReuseIdentifier:@"ruleCell"];
    
    
}

- (UIView *)buildHeader
{
    NSString *title = @"";
    NSString *desc = @"";
    NSMutableAttributedString *attr = nil;
    if (self.status == MemberReviewStatus1) {
        title = @"您还未开通创世薪朋友";
        desc = @"预支工资，是“薪朋友”的专属服务";
    } else if (self.status == MemberReviewStatus2) {
        title = @"恭喜获得雇主员工特权";
        desc = @"每月可获得一次 ¥500 的免费预支服务";
        attr = [[NSMutableAttributedString alloc] initWithString:desc];
        [attr addAttributes:@{NSFontAttributeName:FONT_SFUI_X_Regular(14)} range:NSMakeRange(8, 4)];
    } else {
        title = @"创世薪朋友";
        desc = [NSString stringWithFormat:@"有效期  %@-%@", self.customerValidDate, self.customerInvalidDate];
        attr = [[NSMutableAttributedString alloc] initWithString:desc];
        [attr addAttributes:@{NSFontAttributeName:FONT_SFUI_X_Regular(14)} range:NSMakeRange(5, desc.length - 5)];
        
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 128)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = title;
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = FONT_PINGFANG_X(28);
    [headerView addSubview:titleLabel];
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 10, SCREEN_WIDTH() - 40, 20)];
    promptLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    promptLabel.font = FONT_PINGFANG_X(14);
    [headerView addSubview:promptLabel];
    if (attr) {
        promptLabel.attributedText = attr;
    } else {
        promptLabel.text = desc;
    }
    
    return headerView;
}

- (UIView *)buildFooter
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    if (self.status != MemberReviewStatus3) {
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
    } else {
        [footerView addSubview:self.confirmButton];
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView).offset(20);
            make.right.equalTo(footerView).offset(-20);
            make.top.equalTo(footerView).offset(10);
            make.height.mas_equalTo(44);
        }];
    }
    
    if (self.status == MemberReviewStatus1) {
        [self.confirmButton setTitle:@"开通并预支" forState:(UIControlStateNormal)];
        [self.confirmButton addTarget:self action:@selector(openMemberAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.confirmButton setTitle:@"立即预支" forState:(UIControlStateNormal)];
        [self.confirmButton addTarget:self action:@selector(prepareLoanAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.footerView = footerView;
    return footerView;
}

- (void)checkProtocol:(UIButton *)sender
{
    _checked = !_checked;
    UIImage *image = _checked ?UIIMAGE_FROM_NAME(@"smile_loan_agreement_selected") :UIIMAGE_FROM_NAME(@"smile_loan_agreement_unselected");
    [sender setImage:image forState:UIControlStateNormal];
    
    if (self.status == MemberReviewStatus2) {
        [self protocolChanged:_checked];
    }
}


#pragma mark - Action
- (void)closeButtonClicked
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareLoanAction{
    self.amoutBindForAuth = self.loanAmount;
    if (!_checked && (self.status == MemberReviewStatus1)) {
        [self showToastWithText:@"请阅读并同意协议"];
        return;
    }
    [self submitLoanRequest];
}

- (void)openMemberAction{
    
    if (self.flag && !self.checked) {
        [EasyTextView showText:@"请先勾选协议"];
        return;
    }

    ZXMemberPayViewController *payVC = [[ZXMemberPayViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)jumpToZXSDProtocolController
{
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,ZXSD_CUSTOMER_URL];
    
    viewController.title = @"服务协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)jumpToAdvanceSalaryResultController {
    ZXSDAdvanceSalaryResultController *viewController = [ZXSDAdvanceSalaryResultController new];
    viewController.success = YES;
    viewController.loanAmount = self.loanAmount;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - data handle -

- (void)submitLoanRequest
{
    NSInteger principalValue = [self.loanAmount integerValue];
    
    NSMutableDictionary *parameters = @{}.mutableCopy;
    [parameters setSafeValue:_loanType forKey:@"code"];
    [parameters setSafeValue:_installPeriodLength forKey:@"installPeriodLength"];
    [parameters setSafeValue:self.installPeriodNum forKey:@"installPeriodNum"];
    [parameters setSafeValue:self.installPeriodUnit forKey:@"installPeriodUnit"];
    [parameters setSafeValue:@(principalValue) forKey:@"principal"];
    [parameters setSafeValue:self.bankCardItem.refId forKey:@"bankCardRefId"];
    
    
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:SUBMIT_LOAN_URL parameters:parameters.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            return;
        }
        
        [self jumpToAdvanceSalaryResultController];
    }];
    
}


- (void)showMemberAlert:(BOOL)isSmilePlus
{
    UIView *maskView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.navigationController.view addSubview:maskView];
    
    
    if (isSmilePlus) {
        [self.navigationController.view addSubview:self.plusMemberAlert];
        
        [_plusMemberAlert configWithType:1];
        [self.plusMemberAlert mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.navigationController.view);
            make.width.mas_equalTo(296);
            make.height.mas_equalTo(330);
        }];
        @weakify(self);
        self.plusMemberAlert.confirmAction = ^{
            @strongify(self);
            [maskView removeFromSuperview];
            [self.plusMemberAlert removeFromSuperview];
        };
        
    } else {
        [self.navigationController.view addSubview:self.memberAlert];
        
        [_memberAlert configWithType:0];
        [self.memberAlert mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.navigationController.view);
            make.width.mas_equalTo(296);
            make.height.mas_equalTo(314);
        }];
        
        @weakify(self);
        self.memberAlert.confirmAction = ^{
            @strongify(self);
            [maskView removeFromSuperview];
            [self.memberAlert removeFromSuperview];
        };
    }
}

- (void)recommendYourCompany
{
    /*
    if (self.haveRecommend) {
        [self showToastProgressHUDWithText:@"已推荐"];
        return;
    }
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,RECOMMEND_COMPANY_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"邀请我司接口成功返回数据---%@",responseObject);
        self.haveRecommend = YES;
        [self dismissLoadingProgressHUD];
        [self showToastProgressHUDWithText:@"已推荐成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        
    }];*/
    
    ZXSDInviteCompanyController *viewController = [ZXSDInviteCompanyController new];
    [self.navigationController pushViewController:viewController animated:YES];
    
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 已开通
    if (self.status == MemberReviewStatus1
        || self.status == MemberReviewStatus2 ) {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = nil;
    if (indexPath.section == 0) {
        cellIdentifier = @"detailCell";
    } else if (indexPath.section == 1){
        
        if (self.status == MemberReviewStatus1 || self.status == MemberReviewStatus2) {
            cellIdentifier = @"cardCell";
        } else {
            cellIdentifier = @"ruleCell";
        }
    } else {
        cellIdentifier = @"ruleCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cellIdentifier isEqualToString:@"cardCell"]) {
        ZXSDAdvanceCardCell * cardCell = (ZXSDAdvanceCardCell *)cell;
        cardCell.status = self.status;
        cardCell.delegate = self;
        [cardCell updateMemberDate:self.customerValidDate end:self.customerInvalidDate];
    }
    
    if ([cellIdentifier isEqualToString:@"ruleCell"]) {
        ZXSDAdvanceRuleCell * ruleCell = (ZXSDAdvanceRuleCell *)cell;
        ruleCell.status = self.status;
        ruleCell.showRules = ^(BOOL isSmilePlus) {
            [self showMemberAlert:isSmilePlus];
        };
        ruleCell.recommendCompany = ^{
            [self recommendYourCompany];
        };
    }
    
    if ([cellIdentifier isEqualToString:@"detailCell"]) {
        ZXSDAdvanceDetailCell * detailCell = (ZXSDAdvanceDetailCell *)cell;
        CGFloat total = [self.loanAmount integerValue] + [self.interest floatValue];
        NSString *totalResult = [NSString stringWithFormat:@"%.2f", total];
        [detailCell config:self.loanAmount interest:self.interest date:self.repaymentDate total:totalResult];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 150 + 40; // 预支明细
    } else if (indexPath.section == 1){
        if (self.status == MemberReviewStatus1 || self.status == MemberReviewStatus2) {
            return 368 + 40; // 预支卡片
        }
        return 265 + 40; // 预支规则
        
    } else {
        return 265 + 40; // 预支规则
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - ZXSDAdvanceCardCellDelegate

- (void)protocolChanged:(BOOL)checked
{
    [self.confirmButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    if (checked) {
        [self.confirmButton setTitle:@"开通并预支" forState:(UIControlStateNormal)];
        [self.confirmButton addTarget:self action:@selector(openMemberAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.confirmButton setTitle:@"立即预支" forState:(UIControlStateNormal)];
        [self.confirmButton addTarget:self action:@selector(prepareLoanAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showProtocol
{
    [self jumpToZXSDProtocolController];
}


#pragma mark - Getter

- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [UITableView new];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.backgroundColor = UIColor.whiteColor;
    }
    return _mainTable;
}



- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(20, 160, SCREEN_WIDTH() - 40, 44);
        [_confirmButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        
        [_confirmButton setTitle:@"开通并预支" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

- (CJLabel *)protocolLabel
{
    if (!_protocolLabel) {
        NSString *protocolString = @"阅读已同意《服务协议》";
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
                                                       withString:@"《服务协议》"
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

- (ZXSDMemberAlertView *)memberAlert
{
    if (!_memberAlert) {
        _memberAlert = [ZXSDMemberAlertView new];
    }
    return _memberAlert;
}

- (ZXSDMemberAlertView *)plusMemberAlert
{
    if (!_plusMemberAlert) {
        _plusMemberAlert = [ZXSDMemberAlertView new];
    }
    return _plusMemberAlert;
}

- (ZXSDAuthCodeAlertView *)authAlert
{
    if (!_authAlert) {
        _authAlert = [ZXSDAuthCodeAlertView new];
    }
    return _authAlert;
}

@end
