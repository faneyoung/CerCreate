//
//  ZXWithdrawViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/7.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXWithdrawViewController.h"
#import <IQKeyboardManager.h>
#import <MSWeakTimer.h>

#import "UITableView+help.h"
#import "UIButton+Align.h"

//vc
#import "ZXSDNecessaryCertThirdStepController.h"

//views
#import "ZXWithdrawAmountCell.h"
#import "ZXMemberPayCardCell.h"
#import "ZXMemberSmsCodeCell.h"


#import "ZXUserViewModel.h"
#import "ZXSMSChannelModel.h"

#import "EPNetworkManager+Mine.h"
#import "EPNetworkManager.h"
#import "ZXSDWithdrawInfoModel.h"

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeAmount,
    SectionTypeCard,
    SectionTypeSms,
    SectionTypeAll
};

@interface ZXWithdrawViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cardOptionBtn;

@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, strong) UIButton *smsCodeBtn;
@property (nonatomic, strong) ZXSMSChannelModel *channelModel;

@property (nonatomic, assign) int timerCnt;
@property (nonatomic, strong) MSWeakTimer *timer;

@property (nonatomic, strong) NSArray *cardList;
@property (nonatomic, strong) NSString *selectedCardRefId;

@property (nonatomic, strong) ZXSDBankCardItem *selectedCard;

@property (nonatomic, strong) ZXSDWithdrawInfoModel *infoModel;

@end

@implementation ZXWithdrawViewController

#pragma mark - lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我要提现";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXWithdrawAmountCell.class),
        NSStringFromClass(ZXMemberPayCardCell.class),
        NSStringFromClass(ZXMemberSmsCodeCell.class),
    ]];

    [self requestWithdrawDetail];
    [self requestAllCardList];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


#pragma mark - views -
- (void)setupSubViews{
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
    [confirmBtn setTitle:@"立即提现" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = FONT_PINGFANG_X_Medium(16);
    [confirmBtn setBackgroundColor:TextColorDisable];
    ViewBorderRadius(confirmBtn, 22, 0.1, UIColor.whiteColor);
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.height.mas_equalTo(44);
        make.bottom.inset(kBottomSafeAreaHeight+16);
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
        _tableView.estimatedRowHeight = 105;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

#pragma mark - help methods -

- (void)checkConfirmBtnStatus{
    [self updataConfirmBtnEnable:IsValidString(self.smsCode) && [self selectedCard]];
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
    
    vc.backViewController = self;
    
    @weakify(self);
    vc.completionBlock = ^(NSString*  _Nonnull data) {
        @strongify(self);
        self.selectedCardRefId = data;
        [self requestAllCardList];
    };

    [self.navigationController pushViewController:vc animated:YES];

}

//
//- (void)gotoCardListVC{
//    ZXCardListViewController *viewController = [[ZXCardListViewController alloc] init];
//    viewController.card = self.selectedCard;
//    @weakify(self);
//    viewController.completionBlock = ^(ZXSDBankCardItem*  _Nonnull data) {
//        @strongify(self);
//        self.selectedCard = data;
//        [self.tableView reloadData];
//    };
//    [self.navigationController pushViewController:viewController animated:YES];
//}


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

- (void)requestAllCardList{
    [self showLoadingProgressHUDWithText:kLoadingTip];
    @weakify(self);
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"04" forKey:@"businessScenario"];
    [EPNetworkManager getUserBankCards:tmps.copy completion:^(NSArray<ZXSDBankCardItem *> *records, NSError *error) {
        @strongify(self);
        
        [self dismissLoadingProgressHUDImmediately];
        
        if (error) {
//            [self handleRequestError:error];
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
    }];

}
- (void)requestWithdrawDetail
{
//#warning --test--
//    self.infoModel = [[ZXSDWithdrawInfoModel alloc] init];
//    self.infoModel.amount = @"1000";
//    self.infoModel.fee = @"20";
//    self.infoModel.bankName = @"工商银行";
//    self.infoModel.bankIcon = @"http:\/\/cashbus-hrhx-app.oss-cn-beijing.aliyuncs.com\/prod\/bank\/ICBC@3x.png";
//    self.infoModel.number = @"";
//    self.infoModel.currency = @"";
//#warning --test--

    
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] getAPI:QUERY_WITHDRAW_INFO parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        if (error) {
            return;
        }
        
        self.infoModel = [ZXSDWithdrawInfoModel modelWithJSON:response.originalContent];
        [self.tableView reloadData];
        
    }];
}

- (void)doWithdrawAction
{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (!IsValidString(phone)) {
        return;
    }
    
    if (!IsValidStrLen(self.smsCode, 6)) {
        [self showToastWithText:@"请输入短信验证码"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:7];
    [params setSafeValue:@"CNY" forKey:@"currency"];
    [params setSafeValue:phone forKey:@"phone"];
    [params setSafeValue:@(self.infoModel.amount) forKey:@"amount"];
    [params setSafeValue:@(self.infoModel.fee) forKey:@"fee"];
    [params setSafeValue:self.smsCode forKey:@"otpCode"];
    
    ZXSDBankCardItem *card = [self selectedCard];
    [params setSafeValue:card.refId forKey:@"bankcardRefId"];
    [params setSafeValue:@(card.isNeedValid) forKey:@"isSkipCheckSms"];

    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:WITHDRAW_ACTION_URL parameters:params.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        NSDictionary *responseObject = response.originalContent;
        
        NSString *status = [responseObject stringObjectForKey:@"fundStatus"];
        NSString *errStr = [responseObject stringObjectForKey:@"fundMsg"];
        if ([status isEqualToString:@"SUCCESS"]) {
            [self showToastWithText:@"提现已完成，请耐心等待到账"];
            
            [self performSelector:@selector(backButtonClicked) withObject:nil afterDelay:.5];
        }
       else if ([status isEqualToString:@"DOING"]) {
            [self showToastWithText:IsValidString(errStr) ? errStr : @"提现处理中"];
            [self performSelector:@selector(backButtonClicked) withObject:nil afterDelay:.5];
        }
        else {
            [self showToastWithText:IsValidString(errStr) ? errStr : @"提现失败"];
        }
    }];
    
}

- (void)sendSMSCodeRequest:(UIButton *)btn{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (!IsValidString(phone)) {
        return;
    }
    
    btn.userInteractionEnabled = NO;
    
    NSDictionary *dic = @{
        @"phone":phone,
        @"type":@"OPT_WITHDRAWAL",
        @"amount":@(self.infoModel.amount)
    };
    
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:kPathSendVerifyCode parameters:dic decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();

        if (error) {
            [self handleRequestError:error];
            btn.userInteractionEnabled = YES;
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
    [ZXUserViewModel sendSMSCodeWithCard:card phone:phone business:@"04" completion:^(ZXSMSChannelModel *  _Nonnull data, NSError * _Nullable error) {
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

#pragma mark - action methods -
- (void)backButtonClicked{
    if (self.fromActivity) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

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
        [self sendSMSCodeRequest:sender];
    }
}

- (void)confirmBtnClick{
    
    if (!IsValidStrLen(self.smsCode, 6)) {
        [self updataConfirmBtnEnable:NO];
        return;
    }
    
    ZXSDBankCardItem *card = [self selectedCard];
    if (!card) {
        [EasyTextView showText:@"请先选择一张银行卡"];
        return;
    }

    if (card.isNeedValid) {
        
        LoadingManagerShow();
        [ZXUserViewModel confirmChannelBankCardWithSMSCode:self.smsCode channel:self.channelModel completion:^(id  _Nonnull data, NSError * _Nullable error) {
            
            LoadingManagerHidden();
            
            if (error) {
                [self handleRequestError:error];
                return;
            }
            
            [self doWithdrawAction];
        }];
    }
    else{
        [self doWithdrawAction];
    }
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


#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SectionTypeAmount) {

    }
    else if(section == SectionTypeCard){
        return self.cardList.count;
    }
    else if(section == SectionTypeSms){

    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypeAmount) {
        ZXWithdrawAmountCell *cell = [ZXWithdrawAmountCell instanceCell:tableView];
        [cell updateWithData:self.infoModel];
        return cell;
    }
    else if (indexPath.section == SectionTypeCard){
        ZXMemberPayCardCell *cell = [ZXMemberPayCardCell instanceCell:tableView];
        
        [cell updateWithData:self.cardList[indexPath.row]];

        return cell;
    }
    else if (indexPath.section == SectionTypeSms){
        ZXMemberSmsCodeCell *cell = [ZXMemberSmsCodeCell instanceCell:tableView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == SectionTypeCard) {
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
    titleLab.text = @"到账银行卡";
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
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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


@end
