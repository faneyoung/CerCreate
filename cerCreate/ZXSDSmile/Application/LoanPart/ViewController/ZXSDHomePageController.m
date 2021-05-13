//
//  ZXSDHomePageController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomePageController.h"
#import "UIViewController+help.h"

#import "UITableView+help.h"
#import "AppDelegate+setting.h"

#import "ZXSDHomeHeaderView.h"
#import "CoverBackgroundView.h"

#import "ZXSDAdvanceSalaryInfoController.h"
#import "ZXSDAdvanceSalaryResultController.h"

#import "ZXSDCertificationCenterController.h"
#import "ZXSDRiskCheckResultController.h"
//#import "ZXSDMemberReviewController.h"
#import "ZXSDChooseEmployerController.h"
#import "ZXSDInviteFriendsController.h"
#import "ZXSDVerifyBankCardController.h"

//#import "ZXSDNecessaryCertThirdStepController.h"
#import "ZXSDNecessaryCertFourthStepController.h"
#import "ZXSDNecessaryCertResultController.h"

#import "EPNetworkManager+Home.h"
#import "ZXBannerModel.h"
#import "ZXMessageList.h"

//views
//#import "ZXHomeLoanNoteCell.h"
//#import "ZXSDHomeLoanCircularCell.h"
//#import "ZXSDHomeLoanBankCardCell.h"
#import "ZXSDHomeLoanProgressCell.h"
//#import "ZXSDHomePrivilegeCell.h"
//#import "ZXSDHomeCollegeCell.h"
//#import "ZXSDHomeQuestionCell.h"
//#import "ZXSDHomePartnerCell.h"
//#import "ZXSDHomeJoinedPeopleCell.h"
//#import "ZXHomeBannerCell.h"
//#import "ZXSDHomeLoanStageCell.h"

#import "ZXShortcutItemCell.h"
#import "ZXMainBannerCell.h"
#import "ZXHomeTipCell.h"
#import "ZXHomeWorkCell.h"
#import "ZXHomeRechargeCell.h"
#import "ZXSecondaryBannerCell.h"
#import "ZXHomeCollegeCell.h"
#import "ZXBrandStoryCell.h"
#import "ZXHomeCooperationCell.h"
#import "ZXMallGoodsFooterView.h"



#import "ZXSDIdentityCardVerifyController.h"
#import "ZXSDLivingDetectionController.h"
#import "ZXSDVerifyUserinfoController.h"
#import "ZXSDRepaymentDetailController.h"
#import "ZXWithdrawViewController.h"

#import "ZXResultNoteViewController.h"


// 上传身份证信息
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_IDCARD_UPLOAD = @"PREPARE_IDCARD_UPLOAD";

// 刷脸认证
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_PREPARE_FACE = @"PREPARE_FACE";

//绑定银行卡信息
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_PREPARE_BANKCARD = @"PREPARE_BANKCARD";

//填写工作信息
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO = @"PREPARE_JOB_INFO";

//任务中心
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_TASK_CENTER = @"TASK_CENTER";

//提交风控审核
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_CALL_RISK = @"CALL_RISK";

//风控审核中
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_RISK_DOING = @"RISK_DOING";

//风控审核拒绝
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_RISK_REJECT = @"RISK_REJECT";

//雇主审核中
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_EMPLOYER_APPROVING = @"EMPLOYER_APPROVING";

//雇主审核拒绝
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_EMPLOYER_REJECT = @"EMPLOYER_REJECT";

//预支中
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_DOING_ADVANCE = @"DOING_ADVANCE";

//能预支
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_CAN_ADVANCE = @"CAN_ADVANCE";

//不能预支
 ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_CAN_NOT_ADVANCED = @"CAN_NOT_ADVANCED";

// 立即还款(逾期)
ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_OVERDUE_REPAY = @"OVERDUE_REPAY";

// 立即还款
ZXSDHomeUserApplyStatus const ZXSDHomeUserApplyStatus_NORMAL_REPAY = @"NORMAL_REPAY";

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeShortcutItem,
    SectionTypeMainBanner,
    SectionTypeTips,
    SectionTypeLoan,
    SectionTypeWork,
    SectionTypeRecharge,
    SectionTypeBanner,
    SectionTypeCollege,
    SectionTypeBrandStroy,
    SectionTypePartner,
    SectionTypeAll
};

@interface ZXSDHomePageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ZXSDHomeHeaderView *headerView;

@property (nonatomic, strong) UITableView *mainTable;

@property (nonatomic, strong) UIView *couponAlertView;

@property (nonatomic, strong) ZXSDHomeLoanInfo *loanInfo;

@property (nonatomic, strong) ZXHomeBannerModel *topShortcutModel;///
@property (nonatomic, strong) ZXHomeBannerModel *bannerModel;///
@property (nonatomic, strong) ZXHomeBannerModel *moneyModel;///赚钱花
@property (nonatomic, strong) ZXHomeBannerModel *depositModel;///特色充值
@property (nonatomic, strong) ZXHomeBannerModel *secondaryBannerModel;///
@property (nonatomic, strong) ZXHomeBannerModel *smileCollegeModel;///薪朋友学院
@property (nonatomic, strong) ZXHomeBannerModel *brandStoryModel;///品牌故事
@property (nonatomic, strong) ZXHomeBannerModel *cooperateModel;///合作伙伴
@property (nonatomic, strong) ZXHomeBannerModel *storyModel;///用户故事

@property (nonatomic, strong) ZXNewUserRegistCouponModel *couponModel;

@property (nonatomic, strong) NSArray *banners;

@end

@implementation ZXSDHomePageController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllData) name:ZXSD_NOTIFICATION_REFRESH_HOME object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllData) name:ZXSD_notification_userLogin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageNoti:) name:kNotificationRefreshMessage object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHideNavigationBar = YES;
    [self adaptScrollView:self.mainTable];
        
//    [self testBtnAction:^(UIButton * _Nonnull btn) {
////                url = [url stringByReplacingCharactersInRange:range withString:@"http://192.168.21.187:3000"];
//
//        NSString *str = @"http://192.168.21.189:3000/app/pay-result";
//        [URLRouter routerUrlWithPath:str extra:nil];
//    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([ZXSDCurrentUser isLogin]) {
        [self requestHomePageInfo];
        [self requestBannerList];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [ZXAppTrackManager event:kHomePage];
    
    if ([ZXSDCurrentUser isLogin]) {
        [self requsetNewRegisterCoupon];
    }

}

#pragma mark - data handle -
- (void)refreshAllData{
    [self.mainTable.mj_header beginRefreshing];
    
}
///banner位
- (void)requestBannerList{
    @weakify(self);
    [EPNetworkManager requestBannerListCompletion:^(NSArray*  _Nonnull data, NSError * _Nonnull error) {
        @strongify(self);
        if (error) {
            return;
        }
        [self formatterBannerTypesWithData:data];
    }];
}

- (void)formatterBannerTypesWithData:(NSArray*)data{
    
    self.banners = data;

    [self.banners enumerateObjectsUsingBlock:^(ZXHomeBannerModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.type isEqualToString:@"mainMenu"]) {
            self.topShortcutModel = obj;
        }
        else if([obj.type isEqualToString:@"internalBanner"]){
            self.bannerModel = obj;
        }
        else if([obj.type isEqualToString:@"deposit"]){
            self.depositModel = obj;

        }
        else if([obj.type isEqualToString:@"moneyFlower"]){
            self.moneyModel = obj;

        }
        else if([obj.type isEqualToString:@"externalBanner"]){
            self.secondaryBannerModel = obj;
        }
        else if([obj.type isEqualToString:@"smileCollege"]){
            self.smileCollegeModel = obj;
        }
        else if([obj.type isEqualToString:@"brandStory"]){
            self.brandStoryModel = obj;
        }
        else if([obj.type isEqualToString:@"co"]){
            self.cooperateModel = obj;
        }
        else if([obj.type isEqualToString:@"userStroy"]){
            self.storyModel = obj;
        }
    }];
    
//#warning &&&& test -->>>>>
//    self.moneyModel = [ZXHomeBannerModel mockItemWithType:@""];
//#warning <<<<<<-- test &&&&

    
    [self.mainTable reloadData];
    
}


//首页数据 && 本地数据
- (void)requestHomePageInfo
{

    if (![ZXSDCurrentUser isLogin]) {
        return;
    }

    [EPNetworkManager getHomeLoanInfoWithParams:nil completion:^(ZXSDHomeLoanInfo * _Nonnull model, NSError * _Nonnull error) {

        [self.mainTable.mj_header endRefreshing];
        if (error) {
            [self handleRequestError:error];
            return;
        }
        if (model) {
            
//#warning --test--
//            model.actionModel.action = ZXSDHomeUserApplyStatus_CAN_ADVANCE;
//            model.actionModel.enable = @"1";
//            model.actionModel.title = @"立即预支";
//#warning --test--
            
            [[ZXSDCurrentUser currentUser] updateCurrentUser:model];
            self.loanInfo = model;
            
            [self.headerView configWithData:self.loanInfo];
            [self.mainTable reloadData];
            
            if (IsValidString(self.loanInfo.note)) {
                [self showInvalidSalaryInfoView];
            }
        }
    }];
}

- (void)requsetNewRegisterCoupon{
    [EPNetworkManager requestNewUserCouponCompletion:^(ZXNewUserRegistCouponModel*  _Nonnull data, NSError * _Nonnull error) {

        if (error) {
            return;
        }

        self.couponModel = data;

        if (self.couponModel.needAlert) {
            [self showCouponAlertView];
        }

    }];
}

- (void)requestUpdateMsgWithItem:(ZXMessageItem*)item nextBlock:(void(^)(void))nextBlock{
    if (!IsValidString(item.msgId)) {
        return ;
    }
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:item.msgId forKey:@"id"];
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:kPath_recordUpdate parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            [self handleRequestError:error];
            return;
        }

        if (nextBlock) {
            nextBlock();
        }
    }];
}

- (BOOL)shouldShowTips{
    
    if (!IsValidString(self.loanInfo.actionModel.tips)) {
        return NO;
    }
    
    if ([ZXSDCurrentUser currentUser].userHideNote) {
        return NO;
    }
    
    return YES;
}

/// 是否需要认证
- (NSString*)checkAuthStatus{
    
    NSString *sta = @"";

    NSString *status = self.loanInfo.actionModel.action;
    if ([status isEqualToString:ZXSDHomeUserApplyStatus_PREPARE_BANKCARD]) {
        return ZXSDHomeUserApplyStatus_PREPARE_BANKCARD;
    }
    else if([status isEqualToString:ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO]){
        return ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO;
    }
    else if([status isEqualToString:ZXSDHomeUserApplyStatus_IDCARD_UPLOAD]){
        return ZXSDHomeUserApplyStatus_IDCARD_UPLOAD;
    }
    else if([status isEqualToString:ZXSDHomeUserApplyStatus_PREPARE_FACE]){
        return ZXSDHomeUserApplyStatus_PREPARE_FACE;
    }
    else if([status isEqualToString:ZXSDHomeUserApplyStatus_TASK_CENTER]){
        return ZXSDHomeUserApplyStatus_PREPARE_FACE;
    }

    

    return sta;
}

- (BOOL)shouldHandleAuthStatus{
    NSString *sta = self.loanInfo.actionModel.action;

    BOOL check = NO;
    if ([sta isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_BANKCARD]) {
        [URLRouter routerUrlWithPath:kRouter_bindCard extra:nil];

        check = YES;
    } else if ([sta isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO]) {
        [URLRouter routerUrlWithPath:kRouter_bindEmployerInfo extra:nil];

        check = YES;
    }
    /*else if ([sta isEqualToString: ZXSDHomeUserApplyStatus_IDCARD_UPLOAD]) {
        [URLRouter routerUrlWithPath:kRouter_idCardUpload extra:@{@"backViewController":self}];
        check = YES;
    } else if ([sta isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_FACE]) {
        [URLRouter routerUrlWithPath:kRouter_liveFace extra:@{@"backViewController":self}];
        check = YES;
    }
    else if ([sta isEqualToString: ZXSDHomeUserApplyStatus_TASK_CENTER]) {
        [URLRouter routeToTaskCenterTab];
        check = YES;
    }*/
    
    return check;
}

#pragma mark - views -

- (UIView *)couponAlertView{
    
    _couponAlertView = [[UIView alloc] init];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:UIImageNamed(@"icon_home_coupon_alert")];
    [_couponAlertView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(24);
        make.centerX.offset(0);
        make.width.mas_equalTo(274);
        make.height.mas_equalTo(305);
        make.bottom.inset(0);
    }];
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.font = FONT_PINGFANG_X_Medium(48);
    priceLab.textColor = kThemeColorRed;
    priceLab.text = GetStrDefault(self.couponModel.faceValue, @"0");
    [_couponAlertView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView).inset(76);
        make.centerX.offset(0);
        make.height.mas_equalTo(67);
    }];
    
    UILabel *unitLab = [[UILabel alloc] init];
    unitLab.font = FONT_PINGFANG_X_Medium(16);
    unitLab.textColor = kThemeColorRed;
    unitLab.text = @"￥";
    [_couponAlertView addSubview:unitLab];
    [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(priceLab.mas_left);
        make.bottom.mas_equalTo(priceLab).offset(-10);
        make.height.mas_offset(22);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:UIImageNamed(@"icon_alert_close") forState:UIControlStateNormal];
    [_couponAlertView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.inset(0);
        make.width.mas_equalTo(124);
        make.height.mas_equalTo(24);
    }];
    [cancelBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_couponAlertView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(100);
        make.bottom.inset(0);
        make.centerX.offset(0);
        make.height.mas_equalTo(68);
    }];

    [nextBtn addTarget:self action:@selector(couponNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _couponAlertView;
}

- (void)showCouponAlertView{
    [CoverBackgroundView hide];
    CoverBackgroundView *cover = [CoverBackgroundView instanceWithTargetView:self.view contentView:self.couponAlertView mode:CoverViewShowModeCenter viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.centerY.offset(0);
    }];
    cover.backgroundColor = UIColorHexAlpha(0x000000, 0.7);
    cover.bgViewUserEnable = NO;

}


- (void)setupSubViews{
    
    self.headerView = [[ZXSDHomeHeaderView alloc] init];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kStatusBarHeight + 44);
    }];
    @weakify(self);
    [self.headerView setEmployerAction:^{
        @strongify(self);
        [self reviewEmployerAction];
    }];
    
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.inset(0);
    }];
    
    self.mainTable.backgroundColor = UIColor.whiteColor;
    self.mainTable.tableFooterView = [UIView new];
    self.mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestHomePageInfo];
        [self requestBannerList];
    }];
    
    [self.mainTable registerClasses:@[
        NSStringFromClass(ZXSDHomeLoanProgressCell.class),
    ]];
    
    [self.mainTable registerNibs:@[
        NSStringFromClass(ZXShortcutItemCell.class),
        NSStringFromClass(ZXMainBannerCell.class),
        NSStringFromClass(ZXHomeTipCell.class),
        NSStringFromClass(ZXHomeWorkCell.class),
        NSStringFromClass(ZXHomeRechargeCell.class),
        NSStringFromClass(ZXSecondaryBannerCell.class),
        NSStringFromClass(ZXHomeCollegeCell.class),
        NSStringFromClass(ZXBrandStoryCell.class),
        NSStringFromClass(ZXHomeCooperationCell.class),
    ]];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SectionTypeAll;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SectionTypeShortcutItem) {
        if (!IsValidArray(self.topShortcutModel.list)) {
            return 0;
        }
    }
    else if (section == SectionTypeMainBanner) {
        if (!IsValidArray(self.bannerModel.list)) {
            return 0;
        }
    }
    else if (section == SectionTypeTips) {
        if (!IsValidArray(self.loanInfo.notice)) {
            return 0;
        }
    }
    else if (section == SectionTypeLoan) {
        if (![ZXSDCurrentUser isLogin] ||
            !self.loanInfo) {
            return 0;
        }
    }
    else if(section == SectionTypeWork){
        if (!IsValidArray(self.moneyModel.list)) {
            return 0;
        }
    }
    else if(section == SectionTypeRecharge){
        if (!IsValidArray(self.depositModel.list)) {
            return 0;
        }
    }
    else if(section == SectionTypeCollege){
        if (!IsValidArray(self.smileCollegeModel.list)) {
            return 0;
        }
    }
    else if(section == SectionTypeBanner){
        if (!IsValidArray(self.secondaryBannerModel.list)) {
            return 0;
        }
    }
    else if(section == SectionTypeBrandStroy){
        if (!IsValidArray(self.brandStoryModel.list)) {
            return 0;
        }
    }
    else if(section == SectionTypePartner){
        if (!IsValidArray(self.cooperateModel.list)) {
            return 0;
        }
    }
    
    return 1;
}

- (void)handleCustomBanner:(ZXBannerModel*)banner{
    
    if ([self shouldHandleAuthStatus]) {
        return;
    }
    
    [URLRouter routerUrlWithPath:banner.url extra:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SectionTypeShortcutItem) {
        ZXShortcutItemCell *cell = [ZXShortcutItemCell instanceCell:tableView];
        
        ZXHomeBannerModel *shortcut = self.topShortcutModel;
        [cell updateWithData:shortcut.list];
        @weakify(self);
        cell.itemClickBlock = ^(ZXBannerModel*  _Nonnull data) {
            @strongify(self);
            [self handleCustomBanner:data];
        };
        
        return cell;
    }
    else if(indexPath.section == SectionTypeMainBanner){
        ZXMainBannerCell *cell = [ZXMainBannerCell instanceCell:tableView];
        ZXHomeBannerModel *banner = self.bannerModel;
        [cell updateWithData:banner.list];
        
        @weakify(self);
        cell.bannerClickedBlock = ^(int index) {
            @strongify(self);
            [self banners:banner.list selectedAtIndex:index];
        };
        return cell;
    }
    else if(indexPath.section == SectionTypeTips){
        ZXHomeTipCell *cell = [ZXHomeTipCell instanceCell:tableView];
        [cell updateWithData:self.loanInfo.notice];
        return cell;
    }
    else if(indexPath.section == SectionTypeLoan){
        ZXSDHomeLoanProgressCell *cell = [ZXSDHomeLoanProgressCell instanceCell:tableView];
//        [cell showBottomLine];
        [cell setLoanConfirmAction:^(NSString * _Nullable targetAmount) {
            NSString *status = self.loanInfo.actionModel.action;
            if (CHECK_VALID_STRING(targetAmount) && [status isEqualToString:ZXSDHomeUserApplyStatus_CAN_ADVANCE]) {
                [self doAdvanceSalaryAction:targetAmount];
            } else {
                [self prepayAction];
            }
        }];
        
        [cell setRenderData:self.loanInfo];
        
        return cell;
    }
    else if(indexPath.section == SectionTypeWork){
        ZXHomeWorkCell *cell = [ZXHomeWorkCell instanceCell:tableView];
        [cell updateWithData:self.moneyModel.list];
        return cell;
    }
    else if(indexPath.section == SectionTypeRecharge){
        ZXHomeRechargeCell *cell = [ZXHomeRechargeCell instanceCell:tableView];
        [cell updateWithData:self.depositModel];
        return cell;
    }
    else if(indexPath.section == SectionTypeBanner){
        
        ZXSecondaryBannerCell *cell = [ZXSecondaryBannerCell instanceCell:tableView];
        
        ZXHomeBannerModel *banner = self.secondaryBannerModel;
        [cell updateWithData:banner.list];
        
        @weakify(self);
        cell.bannerClickedBlock = ^(int index) {
            @strongify(self);
            [self banners:banner.list selectedAtIndex:index];
        };

        return cell;
    }
    else if(indexPath.section == SectionTypeCollege){
        ZXHomeCollegeCell *cell = [ZXHomeCollegeCell instanceCell:tableView];
        
        ZXHomeBannerModel *banner = self.smileCollegeModel;
        [cell updateWithData:banner.list];
        cell.bannerClickedBlock = ^(int index) {
            if (index <= banner.list.count - 1) {
                [URLRouter routerUrlWithBannerModel:banner.list[index] extra:@{@"bannerAnaly":@(YES)}];
            }
        };
        return cell;
    }
    else if(indexPath.section == SectionTypeBrandStroy){
        ZXBrandStoryCell *cell = [ZXBrandStoryCell instanceCell:tableView];
        [cell updateWithData:self.brandStoryModel];
        return cell;
    }
    else if(indexPath.section == SectionTypePartner){
        ZXHomeCooperationCell *cell = [ZXHomeCooperationCell instanceCell:tableView];
        
        ZXHomeBannerModel *banner = self.cooperateModel;
        [cell updateWithData:banner.list];

        return cell;
    }
    
    return [tableView defaultReuseCell];

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == SectionTypeAll-1) {//底部
        if (![ZXSDCurrentUser isLogin] ||
            !self.loanInfo) {
            return 0;
        }
        return 162;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ZXMallGoodsFooterView *footer = [[ZXMallGoodsFooterView alloc] init];
    footer.clipsToBounds = YES;
    footer.backgroundColor = UIColor.whiteColor;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - action methods -

- (void)msgBtnClick{

    [AppDelegate clearBadge];
    
    [URLRouter routerUrlWithPath:kURLRouter_messageMain extra:nil];
}

- (void)prepayAction
{
//#warning --test--
//    [URLRouter routerUrlWithPath:kRoute_buyCoupon extra:nil];
//    return;
//
//    self.loanInfo.actionModel.action = ZXSDHomeUserApplyStatus_RISK_REJECT;
//    self.loanInfo.extraInfo.currentLoanRefId = @"EpdpsO_CNjEDz4c";
//    self.loanInfo.extraInfo.bankCardRefId = @"oiuXKd";
//#warning --test--
//#warning --test--
//    self.loanInfo.actionModel.action = ZXSDHomeUserApplyStatus_IDCARD_UPLOAD;
//#warning --test--
//#warning --test--
//    self.loanInfo.actionModel.action = ZXSDHomeUserApplyStatus_PREPARE_BANKCARD;
//#warning --test--



    NSString *status = self.loanInfo.actionModel.action;
    
    NSString *trackItem = @"";
    if ([status isEqualToString: ZXSDHomeUserApplyStatus_IDCARD_UPLOAD]) {
        trackItem = kAuth_idCard;
        
        ZXSDIdentityCardVerifyController * vc = [ZXSDIdentityCardVerifyController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
            
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_FACE]) {
        trackItem = kAuth_face;

        ZXSDLivingDetectionController *vc = [ZXSDLivingDetectionController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_BANKCARD]) {
        trackItem = kAuth_bankCard;

        [self bindCardAction];
        
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO]) {
        trackItem = kAuth_jobInfo;

        ZXSDNecessaryCertFourthStepController *vc = [ZXSDNecessaryCertFourthStepController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_TASK_CENTER]) {
        trackItem = ktaskCenterList;

//        ZXSDCertificationCenterController *vc = [ZXSDCertificationCenterController new];
//        [self.navigationController pushViewController:vc animated:YES];
        [URLRouter routeToTaskCenterTab];
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_CALL_RISK]) {
        trackItem = kAdvance_uploadRisk;
        
        [self doRiskCheck];
        
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_RISK_DOING]) {
        trackItem = kAdvance_risk_underRevice;

        NSString *eventRefId = self.loanInfo.extraInfo.eventRefId;
        [self gotoRiskResult:eventRefId];
        
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_EMPLOYER_APPROVING]) {
        trackItem = kAdvance_employer_underRevice;

        [self handleEmployerApprovingAction];
        
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_EMPLOYER_REJECT]) {
        trackItem = kAdvance__employer_refused;

        ZXSDNecessaryCertResultController *vc = [ZXSDNecessaryCertResultController new];
        vc.reviewStatus = status;
        vc.failReason = self.loanInfo.extraInfo.failReason;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_DOING_ADVANCE]) {
        trackItem = kAdvance_advancing;

//        ZXSDAdvanceSalaryResultController *vc = [ZXSDAdvanceSalaryResultController new];
//        [self.navigationController pushViewController:vc animated:YES];
        ZXResultNoteViewController *resultVC = [[ZXResultNoteViewController alloc] init];
        resultVC.resultPageType = ResultPageTypeAdvancing;
        [self.navigationController pushViewController:resultVC animated:YES];
        
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_CAN_ADVANCE]) {
        trackItem = kAdvance_enable;
        
        [self doAdvanceSalaryAction:nil];
        
    } else if ([status isEqualToString:
        ZXSDHomeUserApplyStatus_OVERDUE_REPAY]) {
        trackItem = kAdvance_refund_overdue;

        if (CHECK_VALID_STRING(self.loanInfo.extraInfo.overduLoanRefId) && CHECK_VALID_STRING(self.loanInfo.extraInfo.bankCardRefId)) {
            
            ZXSDRepaymentDetailController *vc = [ZXSDRepaymentDetailController new];
            vc.loanRefId = self.loanInfo.extraInfo.overduLoanRefId;
            vc.bankcardRefId = self.loanInfo.extraInfo.bankCardRefId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([status isEqualToString:ZXSDHomeUserApplyStatus_NORMAL_REPAY]){
        trackItem = kAdvance_refund;

        if (!IsValidString(self.loanInfo.extraInfo.bankCardRefId) ||
            !IsValidString(self.loanInfo.extraInfo.currentLoanRefId)) {
            [URLRouter routerUrlWithPath:kRouter_advanceRecords extra:nil];
            return;
        }
        ZXSDRepaymentDetailController *vc = [ZXSDRepaymentDetailController new];
        vc.loanRefId = self.loanInfo.extraInfo.currentLoanRefId;
        vc.bankcardRefId = self.loanInfo.extraInfo.bankCardRefId;
        [self.navigationController pushViewController:vc animated:YES];


    }
    else if ([status isEqualToString: ZXSDHomeUserApplyStatus_CAN_NOT_ADVANCED]) {
        trackItem = kAdvance_disable;
    }
    else if([status isEqualToString:ZXSDHomeUserApplyStatus_RISK_REJECT]){
        ZXResultNoteViewController *noteVC = [[ZXResultNoteViewController alloc] init];
        noteVC.payMessage = @"非常抱歉，您的审核未通过\n请下个发薪日再试试";
        noteVC.resultPageType = ResultPageTypeRiskReject;
        [self.navigationController pushViewController:noteVC animated:YES];
        trackItem = kAdvance_risk_refused;
    }
    
    [ZXAppTrackManager event:trackItem];
    
}

- (void)doAdvanceSalaryAction:(NSString *)targetAmount
{

    ZXSDAdvanceSalaryInfoController *vc = [ZXSDAdvanceSalaryInfoController new];
    vc.targetAmount = targetAmount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showAllQuestions
{
    [ZXAppTrackManager event:kquestionList];
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    
    viewController.requestURL = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/faq"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)doRiskCheck
{
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    [EPNetworkManager doRiskCheckWithParams:nil completion:^(NSString * _Nonnull eventRefId, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        
        if (error) {
            [self handleRequestError:error];
            return;
        }
        if (eventRefId.length > 0) {
            [self gotoRiskResult:eventRefId];
        }
    }];
}

- (void)reviewEmployerAction
{
    //ZXSDEditEmployerCompanyController *vc = [ZXSDEditEmployerCompanyController new];
    
    ZXSDChooseEmployerController *vc = [ZXSDChooseEmployerController new];
    vc.isHome = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoRiskResult:(NSString *)eventRefId
{
    ZXSDRiskCheckResultController *viewController = [ZXSDRiskCheckResultController new];
    viewController.eventRefId = eventRefId;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
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
//        ZXSDNecessaryCertThirdStepController *vc = [ZXSDNecessaryCertThirdStepController new];
//        vc.backViewController = self;
//        [self.navigationController pushViewController:vc animated:YES];
        [URLRouter routerUrlWithPath:kRouter_bindCard extra:nil];
    }
}

- (void)handleEmployerApprovingAction
{
    if ([ZXSDCurrentUser currentUser].businessModel == ZXSDCooperationModelEmployerQuery) {
        ZXSDVerifyUserinfoController *vc = [ZXSDVerifyUserinfoController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        ZXSDNecessaryCertResultController *vc = [ZXSDNecessaryCertResultController new];
        vc.reviewStatus = ZXSDHomeUserApplyStatus_EMPLOYER_APPROVING;
        vc.failReason = self.loanInfo.extraInfo.failReason;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)showActivityDetail
{
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    
    viewController.requestURL = self.loanInfo.extraInfo.vaActivityUrl;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)shareActivity
{
    NSArray *activityItemsArray = @[self.loanInfo.extraInfo.vaActivityUrl];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems: activityItemsArray applicationActivities:nil];
    activityVC.modalInPopover = YES;
    activityVC.excludedActivityTypes = @[
                                             UIActivityTypePostToFacebook,
                                             UIActivityTypePostToTwitter,
                                             UIActivityTypePostToWeibo,
                                             UIActivityTypeMessage,
                                             UIActivityTypeMail,
                                             UIActivityTypePrint,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeAddToReadingList,
                                             UIActivityTypePostToFlickr,
                                             UIActivityTypePostToVimeo,
                                             UIActivityTypePostToTencentWeibo,
                                             UIActivityTypeAirDrop,
                                             UIActivityTypeOpenInIBooks
                                             ];
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError)
    {
        ZGLog(@"activityType == %@",activityType);
        if (completed == YES) {
            ZGLog(@"share completed");
        } else {
            ZGLog(@"share cancel");
        }
    };
    
    activityVC.completionWithItemsHandler = itemsBlock;
    
    [self presentViewController:activityVC animated:YES completion:^{
        
    }];
}

- (void)couponNextBtnClick{
    [CoverBackgroundView hide];
    [URLRouter routerUrlWithPath:self.couponModel.url extra:nil];

}

- (void)gotoInvitePage{
    NSString *status = self.loanInfo.actionModel.action;
    
    if ([status isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_BANKCARD]) {
        
        [self bindCardAction];
    }
    else if ([status isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO]) {
        TrackEvent(kAuth_jobInfo);

        ZXSDNecessaryCertFourthStepController *vc = [ZXSDNecessaryCertFourthStepController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        ZXSDInviteFriendsController *viewController = [[ZXSDInviteFriendsController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (void)gotoWithdrawalPage{
    
    NSString *status = self.loanInfo.actionModel.action;

    if ([status isEqualToString: ZXSDHomeUserApplyStatus_IDCARD_UPLOAD]) {
        TrackEvent(kAuth_idCard);

        ZXSDIdentityCardVerifyController * vc = [ZXSDIdentityCardVerifyController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([status isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_FACE]) {
        TrackEvent(kAuth_face);

        ZXSDLivingDetectionController *vc = [ZXSDLivingDetectionController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{

        ZXWithdrawViewController *vc = [[ZXWithdrawViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }

}

- (void)showInvalidSalaryInfoView{
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor  =UIColor.whiteColor;
    ViewBorderRadius(contentView, 8, 1, UIColor.whiteColor);
    
    UILabel *titleLab = [UILabel labelWithText:@"薪朋友提示您" textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(18)];
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(20);
        make.centerX.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    ZXMessageItem *item = [ZXMessageItem instanceWithData:self.loanInfo.note];
    UILabel *msgLab = [UILabel labelWithText:GetString(item.title) textColor:TextColorSubTitle font:FONT_PINGFANG_X(14)];
    msgLab.textAlignment = NSTextAlignmentCenter;
    msgLab.numberOfLines = 0;
    [contentView addSubview:msgLab];
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).inset(20);
        make.left.right.inset(20);
    }];

    UIButton *cancelBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"取消" textColor:TextColorTitle cornerRadius:22];
    cancelBtn.backgroundColor = TextColorDisable;
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(msgLab.mas_bottom).inset(20);
        make.left.inset(20);
        make.bottom.inset(20);
        make.height.mas_equalTo(44);

    }];
    [cancelBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
        [self requestUpdateMsgWithItem:item nextBlock:nil];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"确定" textColor:UIColor.whiteColor cornerRadius:22];
    nextBtn.backgroundColor = kThemeColorMain;
    [contentView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelBtn.mas_right).inset(16);
        make.bottom.inset(20);
        make.right.inset(20);
        make.width.mas_equalTo(cancelBtn);
        make.height.mas_equalTo(44);
    }];
    
    [nextBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
        [self requestUpdateMsgWithItem:item nextBlock:^{
            [URLRouter routeToTaskCenterTab];
        }];
    } forControlEvents:UIControlEventTouchUpInside];

    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:contentView mode:CoverViewShowModeCenter cancelPrevious:YES viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.centerY.offset(0);
    }];
    cover.bgViewUserEnable = NO;
}

#pragma mark - help methods -
- (void)banners:(NSArray*)banners selectedAtIndex:(int)index{
    ZXBannerModel *banner = banners[index];
    if ([banner.url isEqualToString:@"invite"]) {
        [self gotoInvitePage];
    }
    else if([banner.url isEqualToString:@"taskCenter"]){
        [URLRouter routeToTaskCenterTab];
    }
    else if([banner.url isEqualToString:@"withdrawal"]){
        [self gotoWithdrawalPage];
    }
    else{
        [URLRouter routerUrlWithBannerModel:banner extra:@{@"bannerAnaly":@(YES)}];
    }
}

#pragma mark - notification -
- (void)refreshMessageNoti:(NSNotification*)noti{
    NSDictionary *info = noti.userInfo;
    BOOL hasNew = [info boolValueForKey:@"hasNew"];
    
    self.headerView.hasNewMsg = hasNew;
    
}

#pragma mark - Getter

- (UIScrollView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTable.backgroundColor = UIColor.brownColor;
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.showsVerticalScrollIndicator = YES;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.backgroundColor = [UIColor whiteColor];
        _mainTable.estimatedRowHeight = 90;
        _mainTable.sectionHeaderHeight = CGFLOAT_MIN;
        _mainTable.sectionFooterHeight = CGFLOAT_MIN;
        _mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _mainTable;
}




@end

