//
//  ZXMemberPayViewController.m
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMemberPayViewController.h"
#import <IQKeyboardManager.h>
#import "CJLabel.h"

#import "UITableView+help.h"
#import "UIButton+Align.h"
#import "UIImage+Additions.h"

#import "EPNetworkManager.h"

//vc
#import "ZXSDNecessaryCertThirdStepController.h"
#import "ZXResultNoteViewController.h"
#import "ZXCouponSelectionViewController.h"
#import "ZXSDRadioPickController.h"

//views
#import "ZXCreateMemberGradeCell.h"
#import "ZXMemberPayInfoCell.h"
#import "ZXMemberFeeCouponCell.h"
#import "ZXMemberPayCardCell.h"
#import "ZXMemberSmsCodeCell.h"

#import "EPNetworkManager+Mine.h"
#import "ZXUserViewModel.h"
#import <MSWeakTimer.h>
#import "ZXCouponCalculationModel.h"
#import "ZXMemberGradeInfo.h"
#import "ZXCreateMemberSmsModel.h"


typedef NS_ENUM(NSUInteger, ZXMemberPaymentSectionType) {
    ZXMemberPaymentSectionTypeMember,
    ZXMemberPaymentSectionTypeInfo,
    ZXMemberPaymentSectionTypeCoupon,
    ZXMemberPaymentSectionTypeCard,
    ZXMemberPaymentSectionTypeCode,
    ZXMemberPaymentSectionTypeAll
};

@interface ZXMemberPayViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *cardSelectView;
@property (nonatomic, strong) UIButton *cardOptionBtn;
@property (nonatomic, strong) UIButton *smsCodeBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NSString *smsCode;
@property (nonatomic, strong) UILabel *allPriceLab;
@property (nonatomic, strong) UILabel *realPriceLab;

@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) CJLabel *protocolLabel;


@property (nonatomic, assign) int timerCnt;
@property (nonatomic, strong) MSWeakTimer *timer;

@property (nonatomic, strong) NSArray *memberInfos;
@property (nonatomic, strong) ZXMemberGradeInfo *selectedMemeber;

@property (nonatomic, strong) NSArray *cardList;
@property (nonatomic, strong) NSString *selectedCardRefId;

@property (nonatomic, strong) ZXSMSChannelModel *channelModel;

@property (nonatomic, strong) NSArray *couponList;
@property (nonatomic, strong) ZXCouponListModel *selectedCoupon;///选中的优惠券
///优惠券的优惠信息
@property (nonatomic, strong) ZXCouponCalculationModel *calculationModel;
@property (nonatomic, strong) dispatch_group_t group;

@property (nonatomic, strong) ZXCreateMemberSmsModel *memberSmsModel;


@end

@implementation ZXMemberPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开通会员费";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.group = dispatch_group_create();
    [self requestGradeInfo];
    [self requestCouponList];
    [self requestAllCardList];
    
    dispatch_group_notify(self.group, dispatch_get_global_queue(0, 0), ^{
        if (self.selectedCoupon && self.selectedMemeber) {
            [self requestMemberFeeWithCoupon:self.selectedCoupon loading:YES];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews{
    [self.cardOptionBtn alignWithType:ButtonAlignImgTypeRight margin:3];
}

#pragma mark - views -
- (void)setupSubViews{
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.height.mas_equalTo(44+40);
        make.bottom.inset(kBottomSafeAreaHeight+16);

    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:UIImageNamed(@"smile_loan_agreement_unselected") forState:UIControlStateNormal];
    [btn setImage:UIImageNamed(@"smile_loan_agreement_selected") forState:UIControlStateSelected];

    btn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -20, -15);
    [btn addTarget:self action:@selector(checkProtocolBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(16);
        make.left.inset(20);
        make.width.height.mas_equalTo(17);
    }];
    btn.selected = YES;
    self.checkBtn = btn;

    [bottomView addSubview:self.protocolLabel];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_right).offset(16);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(btn);
    }];

    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = FONT_PINGFANG_X(14);
    [confirmBtn setBackgroundColor:TextColorDisable];
    ViewBorderRadius(confirmBtn, 22, 0.1, UIColor.whiteColor);
    [bottomView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.inset(0);
        make.right.inset(16);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(44);
    }];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmBtn = confirmBtn;
    [self updataConfirmBtnEnable:NO];
    
    UILabel *allLab = [[UILabel alloc] init];
    allLab.font = FONT_PINGFANG_X(12);
    allLab.textColor = TextColorSubTitle;
    allLab.text = [NSString stringWithFormat:@"总价 ￥%@",GetStrDefault(self.selectedMemeber.amount, @"0")];
    [bottomView addSubview:allLab];
    [allLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(20);
        make.centerY.mas_equalTo(confirmBtn);
    }];
    self.allPriceLab = allLab;
    
    UILabel *realPriceLab = [[UILabel alloc] init];
    realPriceLab.font = FONT_PINGFANG_X_Medium(13);
    realPriceLab.textColor = TextColorTitle;
    realPriceLab.text = [NSString stringWithFormat:@"实付 ￥%@",GetStrDefault(self.selectedMemeber.amount, @"0")];
    [bottomView addSubview:realPriceLab];
    [realPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(allLab.mas_right).inset(10);
        make.centerY.mas_equalTo(confirmBtn);
    }];
    self.realPriceLab = realPriceLab;

    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.mas_equalTo(bottomView.mas_top).inset(5);
    }];
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXCreateMemberGradeCell.class),
        NSStringFromClass(ZXMemberPayInfoCell.class),
        NSStringFromClass(ZXMemberFeeCouponCell.class),
        NSStringFromClass(ZXMemberPayCardCell.class),
        NSStringFromClass(ZXMemberSmsCodeCell.class),
    ]];
    
    
}


- (UITableView *)tableView{
    if (!_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }

    return _tableView;
}

- (UIView *)cardSelectView{
    if (!_cardSelectView) {
        _cardSelectView = [[UIView alloc] initWithFrame:CGRectZero];
        ViewBorderRadius(_cardSelectView, 5, 3, UIColor.redColor);
        
    }
    
    return _cardSelectView;
    
}


- (CJLabel *)protocolLabel
{
    if (!_protocolLabel) {
        NSString *protocolString = @"同意《薪朋友会员服务协议》";
        UIFont *currentFont = FONT_PINGFANG_X(12);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:protocolString];
        _protocolLabel = [[CJLabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT() - 40 - NAVIBAR_HEIGHT(), SCREEN_WIDTH() - 40, 20)];
        if (iPhoneXSeries()) {
            CGFloat safeAreaHeight = 34;
            _protocolLabel.frame = CGRectMake(20, SCREEN_HEIGHT() - 40 - safeAreaHeight - NAVIBAR_HEIGHT(), SCREEN_WIDTH() - 40, 20);
        }
        _protocolLabel.numberOfLines = 0;
        _protocolLabel.textAlignment = NSTextAlignmentCenter;
        
        attributedString = [CJLabel configureAttributedString:attributedString
                                                      atRange:NSMakeRange(0, attributedString.length)
                                                   attributes:@{
                                                       NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x999999),
                                                       NSFontAttributeName:currentFont,
                                                   }];
        
        
        attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                       withString:@"《薪朋友会员服务协议》"
                                                 sameStringEnable:NO
                                                   linkAttributes:@{
                                                       NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                       NSFontAttributeName:currentFont,
                                                   }
                                             activeLinkAttributes:nil
                                                        parameter:nil
                                                   clickLinkBlock:^(CJLabelLinkModel *linkModel){
            [URLRouter routerUrlWithPath:[self protocalUrlFormatter] extra:nil];
        }longPressBlock:^(CJLabelLinkModel *linkModel){
            [URLRouter routerUrlWithPath:[self protocalUrlFormatter] extra:nil];
        }];
        _protocolLabel.attributedText = attributedString;
        _protocolLabel.extendsLinkTouchArea = YES;
    }
    return _protocolLabel;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return ZXMemberPaymentSectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == ZXMemberPaymentSectionTypeMember) {
        return 1;
    }
    else if (section == ZXMemberPaymentSectionTypeInfo) {
        return 2;
    }
    else if (section == ZXMemberPaymentSectionTypeCoupon){
        return IsValidArray(self.couponList) ? 1 : 0;
    }
    else if (section == ZXMemberPaymentSectionTypeCard){
        return self.cardList.count;
    }
    else if (section == ZXMemberPaymentSectionTypeCode){
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == ZXMemberPaymentSectionTypeMember) {
        ZXCreateMemberGradeCell *cell = [ZXCreateMemberGradeCell instanceCell:tableView];
        [cell updateWithData:self.memberInfos];
        
        @weakify(self);
        cell.itemDidSelectedBlock = ^(NSIndexPath * _Nonnull idxPath) {
            @strongify(self);
            if (!IsValidArray(self.memberInfos)) {
                return;
            }

            [self.memberInfos enumerateObjectsUsingBlock:^(ZXMemberGradeInfo*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idxPath.item == idx) {
                    obj.selected = YES;
                    self.selectedMemeber = obj;
                }
                else{
                    obj.selected = NO;
                }
            }];
            [self.tableView reloadData];
            
            if (self.selectedCoupon) {
                [self requestMemberFeeWithCoupon:self.selectedCoupon loading:YES];
            }
            else{
                [self updateBottomView];
            }
        };
        
        return cell;
    }
    else if (indexPath.section == ZXMemberPaymentSectionTypeInfo) {
        if (indexPath.row == 0) {
            ZXMemberPayInfoCell *cell = [ZXMemberPayInfoCell instanceCell:tableView];
            cell.type = 1;
            [cell updateWithData:self.selectedMemeber];
            return cell;
        }
        else if (indexPath.row == 1){
            ZXMemberPayInfoCell *cell = [ZXMemberPayInfoCell instanceCell:tableView];
            
            [cell updateWithData:self.selectedMemeber];

            return cell;

        }
    }
    else if (indexPath.section == ZXMemberPaymentSectionTypeCoupon){
        ZXMemberFeeCouponCell *cell = [ZXMemberFeeCouponCell instanceCell:tableView];
        
        if (self.calculationModel) {
            [cell updateWithData:self.selectedCoupon cal:self.calculationModel];
        }
        else{
            [cell updateWithData:self.couponList];
        }
        return cell;
    }
    else if (indexPath.section == ZXMemberPaymentSectionTypeCard){
        ZXMemberPayCardCell *cell = [ZXMemberPayCardCell instanceCell:tableView];
        [cell updateWithData:self.cardList[indexPath.row]];

        return cell;
    }
    else if (indexPath.section == ZXMemberPaymentSectionTypeCode){
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self disableSelection]) {
        return;
    }
    
    if (indexPath.section == ZXMemberPaymentSectionTypeInfo) {
        if (indexPath.row == 0) {
//            if (!IsValidArray(self.memberInfos)) {
//                return;
//            }
//
//            [self showMemberInfosView];

        }
        
    }
    else if (indexPath.section == ZXMemberPaymentSectionTypeCoupon) {
        if (!IsValidArray(self.couponList)) {
            return;
        }

        __block BOOL hasSel = NO;
        [self.couponList enumerateObjectsUsingBlock:^(ZXCouponListModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.couponSelected) {
                hasSel = YES;
                *stop = YES;
            }
        }];

        if (!hasSel) {
            ((ZXCouponListModel*)self.couponList.firstObject).couponSelected = YES;
        }
        
        ZXCouponSelectionViewController *selectionVC = [[ZXCouponSelectionViewController alloc] init];
        selectionVC.couponList = self.couponList;
        @weakify(self);
        selectionVC.completionBlock = ^(ZXCouponListModel * _Nonnull data) {
            @strongify(self);
            if (data) {
                [self requestMemberFeeWithCoupon:data loading:YES];
            }
            else{
                self.selectedCoupon = nil;
                self.calculationModel = nil;
                [self updateBottomView];
                [self.tableView reloadData];
            }
        };
        [self.navigationController pushViewController:selectionVC animated:YES];
    }
    else if (indexPath.section == ZXMemberPaymentSectionTypeCard) {

        ZXSDBankCardItem *selItem = self.cardList[indexPath.row];
        if (!selItem.selected) {
            selItem.selected = !selItem.selected;
            
            [self.cardList enumerateObjectsUsingBlock:^(ZXSDBankCardItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj.refId isEqualToString:selItem.refId]) {
                    obj.selected = !selItem.selected;
                }
            }];
            
            [self.tableView reloadData];
            [self checkConfirmBtnStatus];
            
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == ZXMemberPaymentSectionTypeCard) {
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
        if ([self disableSelection]) {
            return;
        }
        [self showAddNewCardVC];

    }];
    
    self.cardOptionBtn = btn;
    [headerView layoutIfNeeded];
    [btn alignWithType:ButtonAlignImgTypeRight margin:3];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == ZXMemberPaymentSectionTypeMember) {
        return CGFLOAT_MIN;
    }
    
    if (section == ZXMemberPaymentSectionTypeAll-1) {
        return CGFLOAT_MIN;
    }
    
    if (section == ZXMemberPaymentSectionTypeCoupon) {
        if (!IsValidArray(self.couponList)) {
            return CGFLOAT_MIN;
        }
    }
    
    return 8;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [tableView defaultHeaderFooterView];
}

#pragma mark - action methods -

- (void)sendCodeBtnClick:(UIButton*)sender{
    ZXSDBankCardItem *card = [self selectedCard];
    if (!card) {
        [EasyTextView showText:@"请先选择一张银行卡"];
        return;
    }
    
    [self sendSMSCodeRequest];
    
}

- (void)confirmBtnClick{
    
//#warning --test--
//    [self createMembershipRequest];
//    return;
//#warning --test--

    
    if (!self.checkBtn.selected) {
        ToastShow(@"请同意并勾选协议");
        return;
    }

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
    
    if (!IsValidString(self.memberSmsModel.refId)) {
        [self updataConfirmBtnEnable:NO];
        ToastShow(@"请重新发送验证码");
        return;
    }

    [self createMembershipRequest];
}

- (void)checkProtocolBtnClicked:(UIButton*)btn{
    btn.selected = !btn.selected;
    
}


#pragma mark - data handle -

- (void)requestGradeInfo{
    dispatch_group_enter(self.group);
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_queryCustomerGrade parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();
        if (error) {
            dispatch_group_leave(self.group);

            [self handleRequestError:error];
            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            dispatch_group_leave(self.group);

            return;
        }
        
        self.memberInfos = [ZXMemberGradeInfo modelsWithData:response.resultModel.data];
        ZXMemberGradeInfo *selectedInfo = self.memberInfos.firstObject;
        selectedInfo.selected = YES;
        self.selectedMemeber = selectedInfo;
        [self.tableView reloadData];
        [self updateBottomView];
        dispatch_group_leave(self.group);

    }];
}

- (void)requestAllCardList{
    [self showLoadingProgressHUDWithText:kLoadingTip];
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"03" forKey:@"businessScenario"];
    
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

        [self.tableView reloadData];
        [self checkConfirmBtnStatus];
    }];
}

- (void)requestCouponList{
    dispatch_group_enter(self.group);
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"01" forKey:@"status"];
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:kCouponListPath parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();

//#warning --test--
//        self.couponList = [ZXCouponListModel testModels];
//        if (!IsValidString(self.selectedCardRefId)) {
//            ZXCouponListModel *model = self.couponList.firstObject;
//            model.couponSelected = YES;
//            [self requestMemberFeeWithCoupon:model];
//        }
//        else{
//            [self.tableView reloadData];
//            [self updateBottomView];
//        }
//        return;
//#warning --test--
        
        
        if (error) {
            dispatch_group_leave(self.group);

            [self.tableView reloadData];
            [self updateBottomView];

            return;
        }
        
        if (response.resultModel.code != 0) {
            dispatch_group_leave(self.group);

            [self.tableView reloadData];
            [self updateBottomView];

            return;
        }
        
        self.couponList = [ZXCouponListModel modelsWithData:response.resultModel.data];
        
        if (IsValidArray(self.couponList) &&
            !self.selectedCoupon) {
            ZXCouponListModel *model = self.couponList.firstObject;
            model.couponSelected = YES;
            self.selectedCoupon = model;
            dispatch_group_leave(self.group);
        }

        [self.tableView reloadData];
        [self updateBottomView];
    }];
}

- (void)sendSMSCodeChannelRequest:(ZXSDBankCardItem*)card{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }

    [ZXLoadingManager showLoading:kLoadingTip];
    [ZXUserViewModel sendSMSCodeWithCard:card phone:phone business:@"03" completion:^(ZXSMSChannelModel *  _Nonnull data, NSError * _Nullable error) {
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
        
    self.smsCodeBtn.userInteractionEnabled = NO;
    NSMutableDictionary *tmps = @{}.mutableCopy;
    
    ZXSDBankCardItem *card = [self selectedCard];
    [tmps setSafeValue:card.refId forKey:@"bankcardRefId"];

    [tmps setSafeValue:self.selectedMemeber.amount forKey:@"amount"];
    [tmps setSafeValue:self.selectedMemeber.level forKey:@"level"];
    if (IsValidString(self.selectedMemeber.activeName)) {
        [tmps setSafeValue:self.selectedMemeber.activeName forKey:@"activeName"];
    }
    [tmps setSafeValue:self.selectedCoupon.couponRefId forKey:@"couponRefId"];

    
    LoadingManagerShow();
    [ZXUserViewModel createMemberSMSCodeRequestWithPms:tmps.copy completion:^(EPNetworkResponse*  _Nonnull data, NSError * _Nullable error) {
        LoadingManagerHidden();
        [self.view endEditing:YES];

        if (error) {
            [self handleRequestError:error];
            self.smsCodeBtn.userInteractionEnabled = YES;

            return;
        }
        
        if (data.resultModel.code != 0) {
            self.smsCodeBtn.userInteractionEnabled = YES;

            if ([self appErrorWithData:data.originalContent]) {
                if (IsValidString(data.resultModel.responseMsg)) {
                    [self showToastWithText:data.resultModel.responseMsg];
                }
                
                return;
            }
            return;
        }
        
        self.memberSmsModel = [ZXCreateMemberSmsModel instanceWithDictionary:data.resultModel.data];
        
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

- (void)createMembershipRequest{
    
//#warning --test--
//    EPNetworkResponse *respons = [[EPNetworkResponse alloc] init];
//    [respons setValue:@{@"payStatus":@"Doing",@"payMessage":@"处理成功"} forKey:@"originalContent"];
//    [self showPayResultPageViewController:respons.originalContent];
//
//return;
//#warning --test--
    if (!IsValidString(self.smsCode) ||
        !IsValidString(self.memberSmsModel.refId)||
        !IsValidString(self.memberSmsModel.smsSendNo)) {
        return;
    }

    NSMutableDictionary *pms = @{}.mutableCopy;
    [pms setSafeValue:self.smsCode forKey:@"confirmCode"];
    [pms setSafeValue:self.memberSmsModel.refId forKey:@"refId"];
    [pms setSafeValue:self.memberSmsModel.smsSendNo forKey:@"smsSendNo"];
    
    LoadingManagerShow();
    @weakify(self);
    [ZXUserViewModel createMembershipRequestWithPms:pms.copy completion:^(EPNetworkResponse*  _Nonnull data, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();
        
        [self.view endEditing:YES];
        
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if (data.resultModel.code != 0) {
            if ([self appErrorWithData:data.originalContent]) {
                if (IsValidString(data.resultModel.responseMsg)) {
                    [self showToastWithText:data.resultModel.responseMsg];
                }
                
                return;
            }
            return;
        }
        
        TrackEvent(kPayMemberFee);
        
        dispatch_safe_async_main(^{
            [self showPayResultPageViewController:data.resultModel.data];
        });
        
    }];
    
}

- (void)requestMemberFeeWithCoupon:(ZXCouponListModel*)coupon loading:(BOOL)show{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    
    [tmps setSafeValue:self.selectedMemeber.amount forKey:@"amount"];
    [tmps setSafeValue:coupon.couponRefId forKey:@"couponRefId"];
    
//#warning --test--
//    [tmps setSafeValue:@"30" forKey:@"amount"];
//#warning --test--

    
    @weakify(self);
    if (show) {
        LoadingManagerShow();
    }
    [[EPNetworkManager defaultManager] postAPI:kMemberFeeCouponPath parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        @strongify(self);
        if (error) {
            [self handleRequestError:error];
            self.calculationModel = nil;
            self.selectedCoupon = nil;
            [self.tableView reloadData];
            [self updateBottomView];
            return;
        }
        
        if (response.resultModel.code != 0) {
            [EasyTextView showText:response.resultModel.responseMsg];
            return;
        }
        
        self.calculationModel = [ZXCouponCalculationModel instanceWithDictionary:response.resultModel.data];
        
        self.selectedCoupon = coupon;
        [self.tableView reloadData];
        [self updateBottomView];
        
    }];
    
}

- (void)requestMemberFeeWithCoupon:(ZXCouponListModel*)coupon{
    [self requestMemberFeeWithCoupon:coupon loading:NO];
}


- (BOOL)disableSelection{
    
    if (IsValidString(self.memberSmsModel.refId) && !self.memberSmsModel.canSendCode) {
        return YES;
    }

    return NO;
}

#pragma mark - help methods -

- (void)updateBottomView{
    NSString *allpricStr = [NSString stringWithFormat:@"总价 ￥%@",GetStrDefault(self.selectedMemeber.amount, @"0")];
    NSString *realPrice = GetStrDefault(self.selectedMemeber.amount, @"0");
    
    if (IsValidArray(self.couponList)) {
        if (self.selectedCoupon) {
            allpricStr = [NSString stringWithFormat:@"总价 ￥%@ 优惠 ￥%@",GetStrDefault(self.calculationModel.totalAmount, @"0"),GetStrDefault(self.calculationModel.deductionAmount, @"0")];
            
            realPrice = GetStrDefault(self.calculationModel.payAmount, @"0");
        }
        else{
            allpricStr = [allpricStr stringByAppendingFormat:@" 优惠 ￥0"];
        }
    }
    
    self.allPriceLab.text = allpricStr;
    
    self.realPriceLab.text = [NSString stringWithFormat:@"实付：￥%@",realPrice];

}

- (void)checkConfirmBtnStatus{
    
    if (!IsValidString(self.smsCode) ||
        self.smsCode.length < 6) {
        [self updataConfirmBtnEnable:NO];
        return;
    }
    
    if(!self.selectedMemeber){
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
        [self.confirmBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else{
        [self.confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

        [self.confirmBtn setBackgroundImage:[UIImage  imageWithGradient:@[UIColorFromHex(0x00C35A),UIColorFromHex(0x00D663),] size:CGSizeMake(104, 44) direction:UIImageGradientDirectionRightSlanted] forState:UIControlStateNormal];

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
    
    NSString *status = [data stringObjectForKey:@"payStatus"];
    NSString *payMsg = [data stringObjectForKey:@"payMessage"];

    ZXResultNoteViewController *resultVC = [[ZXResultNoteViewController alloc] init];
    ResultPageType pageType = 0;
    if ([status isEqualToString:@"Success"]) {
        pageType = ResultPageTypeMemberFeeSuccess;
    }
    else if([status isEqualToString:@"Doing"]){
        pageType = ResultPageTypeMemberFeeDoing;
    }
    else{
        pageType = ResultPageTypeMemberFeeFail;
    }
    
    resultVC.payMessage = payMsg;
    resultVC.resultPageType = pageType;
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (void)showMemberInfosView{
    if (!IsValidArray(self.memberInfos)) {
        return;
    }
    

   __block NSMutableArray *titles = @[].mutableCopy;
    [self.memberInfos enumerateObjectsUsingBlock:^(ZXMemberGradeInfo*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:[NSString stringWithFormat:@"%@/%@",obj.amount,obj.describe]];
    }];
    
    
    ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.pickArray = titles.copy;
    viewController.pickTitle = @"会员套餐";
    viewController.pickAchieveString = ^(NSString *returnString) {
        if (!IsValidString(returnString)) {
            return;
        }
        
        NSString *amount = [returnString componentsSeparatedByString:@"/"].firstObject;
        [self.memberInfos enumerateObjectsUsingBlock:^(ZXMemberGradeInfo*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.amount isEqualToString:amount]) {
                self.selectedMemeber = obj;
                [self.tableView reloadData];
                *stop = YES;
            }
        }];
        if (self.selectedCoupon) {
            [self requestMemberFeeWithCoupon:self.selectedCoupon loading:YES];
        }
        else{
            [self updateBottomView];
        }
        
    };
    [self presentViewController:viewController animated:NO completion:^{
        [viewController beginAnimation];
    }];

}

- (NSString*)protocalUrlFormatter{
    NSString *protocolUrl = nil;
    if (self.selectedMemeber) {
        protocolUrl = [NSString stringWithFormat:@"%@/%@?level=%@",H5_URL,ZXSD_CUSTOMER_URL,self.selectedMemeber.modelToJSONString];
    }
    return protocolUrl.URLByCheckCharacter.absoluteString;
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
        
        self.memberSmsModel.canSendCode = YES;
    }
}



@end
