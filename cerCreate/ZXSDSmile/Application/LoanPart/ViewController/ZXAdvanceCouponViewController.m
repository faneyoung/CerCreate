//
//  ZXAdvanceCouponViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAdvanceCouponViewController.h"
#import <MSWeakTimer.h>
#import "UIButton+Align.h"
#import "UITableView+help.h"

//views
#import "ZXBuyCouponInfoCell.h"
#import "ZXMemberPayCardCell.h"
#import "ZXMemberSmsCodeCell.h"

#import "ZXSDBankCardModel.h"

//vc
#import "ZXSDNecessaryCertThirdStepController.h"
#import "ZXResultNoteViewController.h"


#import "EPNetworkManager+Mine.h"
#import "ZXUserViewModel.h"
#import "ZXCouponRuleModel.h"
#import "ZXCouponSMSModel.h"


typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeCouponInfo,
    SectionTypeCard,
    SectionTypeCode,
    SectionTypeAll
};

@interface ZXAdvanceCouponViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *cardSelectView;
@property (nonatomic, strong) UIButton *cardOptionBtn;
@property (nonatomic, strong) UIButton *smsCodeBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NSString *smsCode;

@property (nonatomic, strong) NSArray *cardList;
@property (nonatomic, strong) NSString *selectedCardRefId;

@property (nonatomic, assign) int timerCnt;
@property (nonatomic, strong) MSWeakTimer *timer;

@property (nonatomic, strong) ZXCouponRuleModel *couponModel;
@property (nonatomic, strong) ZXCouponSMSModel *smsModel;


@end

@implementation ZXAdvanceCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预支神券购买";
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXBuyCouponInfoCell.class),
        NSStringFromClass(ZXMemberPayCardCell.class),
        NSStringFromClass(ZXMemberSmsCodeCell.class),
    ]];
    
    [self requestCouponDetail];
    [self requestAllCardList];
    
//    @weakify(self);
//    [self testBtnAction:^(UIButton * _Nonnull btn) {
//        @strongify(self);
//        [self payResultPageWithData:@{@"payStatus":@"Success",@"payMessage":@"系统处理中~"}];
//    }];

}

#pragma mark - views -
- (void)setupSubViews{
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = FONT_PINGFANG_X_Medium(14);
    [confirmBtn setBackgroundColor:TextColorDisable];
    ViewBorderRadius(confirmBtn, 22, 0.1, UIColor.whiteColor);
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.inset(30+kBottomSafeAreaHeight);
        make.left.right.inset(35);
        make.height.mas_equalTo(44);
    }];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmBtn = confirmBtn;
    [self updataConfirmBtnEnable:NO];

    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.mas_equalTo(confirmBtn.mas_top);
    }];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 158;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        
    }
    return _tableView;
}

#pragma mark - data handle -
- (void)requestCouponDetail{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"03" forKey:@"type"];
    
    LoadingManagerShow();
    [EPNetworkManager.defaultManager postAPI:kPath_queryCouponRule parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            [self handleRequestError:error];
            return;
        }

        if (response.resultModel.code != 0) {
            if ([self appErrorWithData:response.originalContent]) {
                if (IsValidString(response.resultModel.responseMsg)) {
                    [self showToastWithText:response.resultModel.responseMsg];
                }
            }
            return;
        }
        
        self.couponModel = [ZXCouponRuleModel instanceWithDictionary:response.resultModel.data];
        
        [self.tableView reloadData];
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

- (void)sendSMSCodeRequest{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }
    self.smsCodeBtn.userInteractionEnabled = NO;
    
    ZXSDBankCardItem *card = [self selectedCard];

    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.couponModel.faceValue forKey:@"amount"];
    [tmps setSafeValue:card.refId forKey:@"bankcardRefId"];
    [tmps setSafeValue:card.bankCode forKey:@"bankCode"];
    [tmps setSafeValue:card.bankName forKey:@"bankName"];
    [tmps setSafeValue:@"ADVANCECOUPON_FEE" forKey:@"sceneCode"];

    LoadingManagerShow();
    [EPNetworkManager.defaultManager postAPI:kPath_advanceCoupon parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        [self.view endEditing:YES];

        if (error) {
            [self handleRequestError:error];
            self.smsCodeBtn.userInteractionEnabled = YES;

            return;
        }
        
        if (response.resultModel.code != 0) {
            self.smsCodeBtn.userInteractionEnabled = YES;

            if ([self appErrorWithData:response.originalContent]) {
                if (IsValidString(response.resultModel.responseMsg)) {
                    [self showToastWithText:response.resultModel.responseMsg];
                }
            }
            return;
        }

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastWithText:@"验证码已成功发送"];
            [self startTimer];
        });
        
        self.smsModel = [ZXCouponSMSModel instanceWithData:response.resultModel.data];
    }];
}

- (void)requestCouponConfirmPay{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }
    
    ZXSDBankCardItem *card = [self selectedCard];
    if (!card) {
        [EasyTextView showText:@"请先选择一张银行卡"];
        return;
    }

    if (!IsValidString(self.smsCode)) {
        ToastShow(@"请输入验证码");
        return;

    }
    
    if (!self.smsModel) {
        ToastShow(@"请先发送验证码");
        return;
    }
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    
    [tmps setSafeValue:self.couponModel.faceValue forKey:@"amount"];
    [tmps setSafeValue:self.smsCode forKey:@"confirmCode"];

    [tmps setSafeValue:self.smsModel.bankcardRefId forKey:@"bankcardRefId"];
    [tmps setSafeValue:self.smsModel.accountId forKey:@"accountId"];
    [tmps setSafeValue:@(self.smsModel.isSkipCheckSms) forKey:@"isSkipCheckSms"];
    [tmps setSafeValue:self.smsModel.channelCode forKey:@"channelCode"];
    [tmps setSafeValue:self.smsModel.refId forKey:@"refId"];
    [tmps setSafeValue:self.smsModel.smsSendNo forKey:@"smsSendNo"];


    LoadingManagerShow();
    [EPNetworkManager.defaultManager postAPI:kPath_advanceCouponConfirm parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if (response.resultModel.code != 0) {
            if ([self appErrorWithData:response.originalContent]) {
                if (IsValidString(response.resultModel.responseMsg)) {
                    [self showToastWithText:response.resultModel.responseMsg];
                }
            }
            return;
        }
        
        [self payResultPageWithData:response.resultModel.data];
    }];

}

- (void)payResultPageWithData:(NSDictionary*)data{
    NSString *status = [data stringObjectForKey:@"payStatus"];
    NSString *payMsg = [data stringObjectForKey:@"payMessage"];

    ZXResultNoteViewController *resultVC = [[ZXResultNoteViewController alloc] init];
    ResultPageType pageType = 0;
    if ([status isEqualToString:@"Success"]) {
        pageType = ResultPageTypeCouponSuccess;
    }
    else if([status isEqualToString:@"Doing"]){
        pageType = ResultPageTypeCouponDoing;
    }
    else{
        pageType = ResultPageTypeCouponFail;
    }
    resultVC.resultPageType = pageType;
    
    resultVC.payMessage = payMsg;
    resultVC.resultPageType = pageType;
    [self.navigationController pushViewController:resultVC animated:YES];

}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SectionTypeCouponInfo) {
        return 1;
    }
    else if (section == SectionTypeCard){
        return self.cardList.count;
    }
    else if (section == SectionTypeCode){
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == SectionTypeCouponInfo) {
        ZXBuyCouponInfoCell *cell = [ZXBuyCouponInfoCell instanceCell:tableView];
        [cell updateWithData:self.couponModel];
        return cell;
    }
    else if (indexPath.section == SectionTypeCard){
        ZXMemberPayCardCell *cell = [ZXMemberPayCardCell instanceCell:tableView];
        [cell updateWithData:self.cardList[indexPath.row]];

        return cell;
    }
    else if (indexPath.section == SectionTypeCode){
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
    
    if (indexPath.section == SectionTypeCard) {

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
    if (section == SectionTypeCard) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == SectionTypeAll-1) {
        return CGFLOAT_MIN;
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
    
    if (!IsValidString(self.smsCode) ||
        self.smsCode.length < 6) {
        [self updataConfirmBtnEnable:NO];
        return;
    }
    
    
    [self requestCouponConfirmPay];

}


#pragma mark - help methods -
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
