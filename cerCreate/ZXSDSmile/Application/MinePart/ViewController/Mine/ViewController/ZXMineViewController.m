//
//  ZXMineViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/7.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMineViewController.h"
#import "UITableView+help.h"
#import "UIViewController+help.h"

//vc
#import "ZXSDNecessaryCertFourthStepController.h"
#import "ZXSDLivingDetectionController.h"
#import "ZXMemberCreateViewController.h"
#import "ZXSDIdentityCardVerifyController.h"


//views
#import "ZXMineHeaderView.h"
#import "ZXPersonalItemCell.h"
#import "ZXMineInfoCell.h"
#import "ZXMineMemberCell.h"



#import "ZXPersonalCenterModel.h"

#import "EPNetworkManager+Home.h"
#import "EPNetworkManager+Mine.h"
#import "ZXVerifyStatusModel.h"
#import "ZXSDBankCardModel.h"
#import "ZXUserViewModel.h"
#import "ZXSMSChannelModel.h"
#import "ZXMemberInfoModel.h"

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeInfo,
    SectionTypeMember,
    SectionTypeRecord,
    SectionTypeInvite,
    SectionTypeHelp,
    SectionTypeSetting,
    SectionTypeAll
};

@interface ZXMineViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *customNavBarView;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZXMineHeaderView *mineheaderView;

@property (nonatomic, strong) NSArray *personalItems;

@property (nonatomic, assign) BOOL showBlackStatusBar;

@property (nonatomic, strong) ZXVerifyStatusModel *statusModel;

/// false:否原生;  true:是H5
@property (nonatomic, assign) BOOL isH5Recommend;


@end

@implementation ZXMineViewController

#pragma mark - lifecycle -

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllData) name:ZXSD_notification_userLogin object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHideNavigationBar = YES;
    [self adaptScrollView:self.tableView];
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXMineInfoCell.class),
        NSStringFromClass(ZXMineMemberCell.class),
        NSStringFromClass(ZXPersonalItemCell.class),
    ]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshAllData];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

#pragma mark - data handle 0-

- (void)refreshAllData{
    
    if (![ZXSDCurrentUser isLogin]) {
//        self.personalItems = nil;
        [self.tableView reloadData];
        return;
    }
    
//    [self requestFourStepStatus];
    [self requestUserInfo];
    
}

- (void)requestWXInfo{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"WeChatApp" forKey:@"platform"];
    [[EPNetworkManager defaultManager] postAPI:kPath_queryWXInfo parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self.tableView reloadData];

            return;
        }
        
        if(response.resultModel.code != 0){
            [self.tableView reloadData];

            return;
        }
        
        NSDictionary *wxInfo = (NSDictionary*)response.resultModel.data;
        ZXUserModel *userModel = [ZXUserModel instanceWithData:wxInfo];;
        
        if (IsValidString(userModel.nickname)) {
            [ZXSDCurrentUser currentUser].userModel.nickname = userModel.nickname;
        }
        if (IsValidString(userModel.avatar)) {
            [ZXSDCurrentUser currentUser].userModel.avatar = userModel.avatar;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)requestUserInfo{
    [[EPNetworkManager defaultManager] getAPI:kPath_userInfo parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        if (!IsValidDictionary(response.resultModel.data)) {
            return;
        }
        
        NSDictionary *userInfo = (NSDictionary*)response.resultModel.data;
        
        ZXUserModel *userModel = [ZXUserModel instanceWithDictionary:userInfo];
        
        [ZXSDCurrentUser currentUser].userModel = userModel;
//        [self.tableView reloadData];
        
        [self requestWXInfo];
    }];
}




#pragma mark - views -
- (void)setupSubViews{
    self.showBlackStatusBar = YES;
    self.view.backgroundColor = kThemeColorBg;
    self.tableView.backgroundColor = kThemeColorBg;
    self.tableView.contentInset = UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(0);
        make.left.bottom.right.inset(0);
    }];

    UIView *customNavBarView = [[UIView alloc] init];
    customNavBarView.backgroundColor = [UIColor colorWithWhite:255 alpha:0];
    [self.view addSubview:customNavBarView];
    [customNavBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    UILabel *lab = [[UILabel alloc] init];
    lab.font = FONT_PINGFANG_X_Medium(16);
    lab.textColor = UIColor.clearColor;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"我的";
    [customNavBarView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(kNavigationBarNormalHeight);
    }];
    self.titleLab = lab;
    self.customNavBarView = customNavBarView;

    
//    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [settingBtn setImage:UIImageNamed(@"icon_mine_setting") forState:UIControlStateNormal];
//    [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:settingBtn];
//    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.inset(kStatusBarHeight);
//        make.right.inset(0);
//        make.width.mas_equalTo(62);
//        make.height.mas_equalTo(44);
//    }];
//    self.settingBtn = settingBtn;
    
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
    }
    return _tableView;
}

#pragma mark - data handle -

- (NSArray *)personalItems{
    if (!_personalItems) {
        _personalItems = [ZXPersonalCenterModel personalCenterItems];
    }
    
    return _personalItems;
}

- (void)requestFourStepStatus{
    
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] getAPI:kPath_verifyStatus parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            return;
        }
        
        self.statusModel = [ZXVerifyStatusModel instanceWithDictionary:response.originalContent];
    }];
}

#pragma mark - help methods -

//- (ZXMineHeaderView *)mineheaderView{
//    if (!_mineheaderView) {
//        ZXMineHeaderView *headerView = [ZXMineHeaderView instanceMineHeaderView];
//        _mineheaderView = headerView;
//
//    }
//
//    return _mineheaderView;
//}
- (void)userInfoActionwithType:(int)type
{
    if (type == 1) {
        return;
    }

    ZXUserModel *userModel = [ZXSDCurrentUser currentUser].userModel;
    
    if (!userModel) {
        return;
    }
    
    if ([self checkActionStatus]) {
        return;
    }
    
    if (type == 0) {
//        if (self.statusModel &&
//            [self.statusModel shouldBindCardOrBindEmployer]) {
//            return;
//        }
        

        [URLRouter routerUrlWithPath:kRouter_mineProfile extra:nil];

    }
    else if(type == 1){
        
    }
    else if(type == 2){
        
        NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
        NSMutableDictionary *inviteDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [inviteDic setSafeValue:userSession forKey:@"session"];
        NSString *coopUrl = WebPageUrlFormatter(kPath_reward, inviteDic.copy);
        [URLRouter routerUrlWithPath:coopUrl extra:nil];
        
    }
    else if(type == 3){

        [URLRouter routerUrlWithPath:kRouter_couponList extra:nil];

    }
    else if(type == 4){
//        if (self.statusModel && [self.statusModel shouldBindCardOrBindEmployer]) {
//            return;
//        }

        [URLRouter routerUrlWithPath:kRouter_cardManageList extra:nil];
    }
}

- (BOOL)checkActionStatus{
    
    return [[ZXSDCurrentUser currentUser] checkAllAuthStatusWithBackVC:self];
}



- (BOOL)isSmilePlusUser{

    BOOL res = [[ZXSDCurrentUser currentUser].userRole isEqualToString:@"smile"];

    return res;
}

- (BOOL)checkAuthStatusForMemberPay{
    
    ZXSDHomeLoanInfo *homeLoanInfo = [ZXSDCurrentUser currentUser].homeLoanInfo;
    
    NSString *action = homeLoanInfo.actionModel.action;
    
    if ([action isEqualToString:ZXSDHomeUserApplyStatus_PREPARE_BANKCARD]) {
        [URLRouter routerUrlWithPath:kRouter_bindCard extra:nil];
        return YES;
    }
    else if([action isEqualToString:ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO]){
        [URLRouter routerUrlWithPath:kRouter_bindEmployerInfo extra:nil];
        return YES;
    }
    else if ([action isEqualToString:ZXSDHomeUserApplyStatus_TASK_CENTER]) {
        [URLRouter routeToTaskCenterTab];
        return YES;
    }
    
    return NO;
}


#pragma mark - action methods -
- (void)settingBtnClick{

    [URLRouter routerUrlWithPath:kRouter_setting extra:@{@"backViewController":self}];
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ZXUserModel *userModel = [ZXSDCurrentUser currentUser].userModel;
    
    if(section == SectionTypeInfo){
        return 1;
    }
    else if(section == SectionTypeMember){
        if (!userModel.isCustomer &&
            [self isSmilePlusUser]) {
            return 0;
        }
        return 1;
    }
    else {
        NSArray *rows = self.personalItems[section-SectionTypeMember-1];
        return rows.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == SectionTypeInfo){
        ZXMineInfoCell *cell = [ZXMineInfoCell instanceCell:tableView];
        [cell updateWithData:nil];
        
        @weakify(self);
        cell.infoActionBlock = ^(int type) {
            @strongify(self);
            [self userInfoActionwithType:type];
        };
        
        return cell;
    }
    else if(indexPath.section == SectionTypeMember){
        ZXMineMemberCell *cell = [ZXMineMemberCell instanceCell:tableView];
        [cell updateWithData:nil];
        return cell;
    }

    ZXPersonalItemCell *cell = [ZXPersonalItemCell instanceCell:tableView];
    NSArray *rowItems = self.personalItems[indexPath.section-SectionTypeMember-1];
    [cell updateWithData:rowItems[indexPath.row]];
    
    [cell shouldHideBottomLine:(indexPath.row == rowItems.count-1)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == SectionTypeRecord ||
        section == SectionTypeInvite ||
        section == SectionTypeHelp ||
        section == SectionTypeSetting) {
        return 8;
    }
    
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [tableView defaultHeaderFooterView];
    footerView.backgroundColor = kThemeColorBg;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == SectionTypeInfo) {
        return;
    }
    else if(indexPath.section == SectionTypeMember){
        
        if ([self checkActionStatus]) {
            return;
        }
        
        [URLRouter routerUrlWithPath:kURLRouter_memberCenter extra:nil];

        return;
    }
    
    NSArray *rowItems = self.personalItems[indexPath.section-SectionTypeMember-1];
    ZXPersonalCenterModel *model = rowItems[indexPath.row];

    if (model.needVerify) {

        if ([self checkActionStatus]) {
            return;
        }
    }
    
//    ZXUserModel *userModel = [ZXSDCurrentUser currentUser].userModel;
//    if ([model.icon isEqualToString:@"mine_friends"]) {
//        if (!userModel.isH5Recommend) {
//            model.action = kRouter_inviteFriends;
//        }
//    }

    [URLRouter routerUrlWithPath:model.action extra:nil];
}

#pragma mark - UIScrollViewDelegate -
- (UIStatusBarStyle)preferredStatusBarStyle
{
//    if (self.showBlackStatusBar) {

        return UIStatusBarStyleDefault;
//    }
//    else{
//        return UIStatusBarStyleLightContent;
//
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"----------offsetY=%.2f",offsetY);

    if (offsetY <= 0) {
        self.customNavBarView.backgroundColor = [UIColor colorWithWhite:255 alpha:0];
        self.titleLab.textColor = [UIColor colorWithWhite:255 alpha:0];
        self.showBlackStatusBar = YES;
        [self setNeedsStatusBarAppearanceUpdate];

        return;
    }

    CGFloat alpha = fabs(offsetY/kNavigationBarHeight);
    alpha = alpha > 1 ? 1 : alpha;
    alpha = alpha < 0 ? 0 : alpha;
//    NSLog(@"----------alpha=%.2f",alpha);

    self.customNavBarView.backgroundColor = UIColorHexAlpha(0xffffff, alpha);

    
    self.titleLab.textColor = UIColorHexAlpha(0x000000, alpha);

    self.showBlackStatusBar = alpha >= 0.8;
    [self setNeedsStatusBarAppearanceUpdate];


}


@end
