//
//  ZXSDPersonalCenterController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDPersonalCenterController.h"
#import "NSString+Helper.h"

#import "ZXSDPersonalCenterCell.h"
#import "ZXSDPersonalSettingsController.h"
#import "ZXSDAdvanceRecordsController.h"
#import "ZXSDQueryIDCardInfoController.h"
#import "ZXSDQueryDebitCardInfoController.h"
#import "ZXSDQueryCompanyInfoController.h"
#import "ZXSDCertificationCenterController.h"
#import "ZXSDIdentityCardVerifyController.h"
#import "ZXSDLivingDetectionController.h"
#import "ZXSDNecessaryCertThirdStepController.h"
#import "ZXSDNecessaryCertFourthStepController.h"
#import "ZXSDInviteCompanyController.h"
#import "ZXSDInviteFriendsController.h"
#import "ZXSDBankCardListController.h"

static const NSString *USER_CENTER_STATUS_URL = @"/rest/userIndex/certStatus";
static const NSString *USER_CENTER_FAQ_URL = @"";

@interface ZXSDPersonalCenterController ()<UITableViewDelegate,UITableViewDataSource> {
    UIScrollView *_mineScrollView;
    
    
    UIImageView *_userImnageView;
    
    NSMutableArray *_mineDataArray;
    
    BOOL _idCardDone;
    BOOL _idFaceDone;
    BOOL _bankCardDone;
    BOOL _jobInfoDone;
}
@property (nonatomic, strong) UIView *customNavBarView;

@property (nonatomic, strong) UIView *headerBackView;
@property (nonatomic, strong) UITableView *mineTableView;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *memberDateLabel;
@property (nonatomic, strong) UIImageView *memberIcon;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UILabel *paydayLab;

@property (nonatomic, assign) BOOL showBlackStatusBar;

@end

@implementation ZXSDPersonalCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isHideNavigationBar = YES;

    [self refreshDataConfigure];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ZXAppTrackManager event:kMinePage];
    
//    [self prepareDataConfigure];
//
//    [self freshHeader];
    [self refreshAllData];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.showBlackStatusBar) {
        return UIStatusBarStyleDarkContent;
    }
    else{
        return UIStatusBarStyleLightContent;

    }
}

#pragma mark - data handle -
- (void)refreshAllData{
    [self prepareDataConfigure];
    [self freshHeader];
    [self refreshDataConfigure];
}

- (void)prepareDataConfigure {
    
    NSArray *section0 = @[
        @{@"icon":@"mine_pay", @"title":@"预支记录"},
        @{@"icon":@"icon_mine_coupon", @"title":@"优惠券"},

    ];
    
    NSArray *section1 = @[
        @{@"icon":@"mine_idcard", @"title":@"身份信息"},
        @{@"icon":@"mine_banckcard", @"title":@"工资卡管理"},
        @{@"icon":@"mine_company", @"title":@"雇主信息"},
        @{@"icon":@"mine_manage", @"title":@"任务中心"}
    ];
    
    NSArray *section2 =  nil;
    BOOL showInviteCompany = ![[ZXSDCurrentUser currentUser].userRole isEqualToString:@"smile"];
    if (showInviteCompany) {
        section2 = @[
            @{@"icon":@"mine_friends", @"title":@"邀请好友"},
            @{@"icon":@"mine_invite", @"title":@"邀请我司"}
        ];
    } else {
        section2 = @[
            @{@"icon":@"mine_friends", @"title":@"邀请好友"}
        ];
    }
    
    NSArray *section3 = @[
        @{@"icon":@"mine_faq", @"title":@"帮助与客服"},
        @{@"icon":@"mine_contact_ceo", @"title":@"留言联系 CEO"}
    ];
    
    NSArray *totalConfigs = @[section0,section1,section2, section3];
    
    _mineDataArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < totalConfigs.count; i++) {
        NSArray *section = totalConfigs[i];
        NSMutableArray *sectionData = [NSMutableArray new];
        for (NSDictionary *item in section) {
            ZXPersonalCenterModel *model = [ZXPersonalCenterModel new];
            model.title = item[@"title"];
            model.icon = item[@"icon"];
            [sectionData addObject:model];
        }
        [_mineDataArray addObject:sectionData];
    }
}

- (void)refreshDataConfigure {

    [ZXLoadingManager showLoading:@"正在加载..." inView:self.view];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,USER_CENTER_STATUS_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ZXLoadingManager hideLoading];
        ZGLog(@"获取用户相关认证状态接口成功返回数据---%@",responseObject);

        [self->_mineScrollView.mj_header endRefreshing];

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"idCardDone"] integerValue] == 1) {
                self->_idCardDone = YES;
            } else {
                self->_idCardDone = NO;
            }

            if ([[responseObject objectForKey:@"idFaceDone"] integerValue] == 1) {
                self->_idFaceDone = YES;
            } else {
                self->_idFaceDone = NO;
            }
            
            if ([[responseObject objectForKey:@"bankCardDone"] integerValue] == 1) {
                self->_bankCardDone = YES;
            } else {
                self->_bankCardDone = NO;
            }

            if ([[responseObject objectForKey:@"jobInfoDone"] integerValue] == 1) {
                self->_jobInfoDone = YES;
                [ZXSDCurrentUser currentUser].isCertified = YES;
            } else {
                self->_jobInfoDone = NO;
            }

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        [self->_mineScrollView.mj_header endRefreshing];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)setupSubViews
{
    [self initHeader];
    
    if (@available(iOS 11.0, *)) {
        self.mineTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.mineTableView];
    [self.mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_mineTableView registerClass:[ZXSDPersonalCenterCell class] forCellReuseIdentifier:@"personalCenterCell"];
    
    UIView *customNavBarView = [[UIView alloc] init];
    customNavBarView.userInteractionEnabled = NO;
    customNavBarView.backgroundColor = [UIColor colorWithWhite:255 alpha:0];
    [self.view addSubview:customNavBarView];
    [customNavBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    UILabel *lab = [[UILabel alloc] init];
    lab.font = FONT_PINGFANG_X_Medium(16);
    lab.textColor = TextColorTitle;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"我的";
    [customNavBarView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(kNavigationBarNormalHeight);
    }];
    
    self.customNavBarView = customNavBarView;
}

- (void)initHeader
{
    UIImageView *headerBackView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_mine_header_back")];
    headerBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_WIDTH() * (400.0/750.0));
    headerBackView.userInteractionEnabled = YES;
    self.mineTableView.tableHeaderView = headerBackView;
    
    CGFloat offsetY = iPhoneXSeries()? 0 : 20;
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, offsetY + NAVIBAR_HEIGHT(), 48, 48)];
    avatarImageView.image = UIIMAGE_FROM_NAME(@"mine_avatar");
    [headerBackView addSubview:avatarImageView];
    self.avatarImageView = avatarImageView;
    
    [headerBackView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarImageView.mas_right).offset(20);
        make.centerY.equalTo(avatarImageView);
    }];
    [headerBackView addSubview:self.memberIcon];
    [self.memberIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.userNameLabel).offset(-2);
        make.width.height.mas_equalTo(16);
    }];
    
    [headerBackView addSubview:self.memberDateLabel];
    [self.memberDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel);
        make.bottom.equalTo(self.avatarImageView.mas_bottom).offset(-2);
        make.height.mas_equalTo(0);
    }];
    
    [headerBackView addSubview:self.paydayLab];
    [self.paydayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.memberDateLabel.mas_bottom).inset(5);
        make.left.mas_equalTo(self.memberDateLabel);
    }];
    
    [headerBackView addSubview:self.settingBtn];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBackView).offset(STATUSBAR_HEIGHT());
        make.right.equalTo(headerBackView).offset(-20);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(40);
    }];
    self.settingBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -20, -15, -20);
    
    self.headerBackView = headerBackView;
}

- (void)freshHeader
{
    NSString *userName = [ZXSDCurrentUser currentUser].phone;
    if (userName.length == 11) {
//        userName = [userName stringByReplacingOccurrencesOfString:[userName substringWithRange:NSMakeRange(3,4)] withString:@" **** "];
        
        NSString *subStr = [NSString stringWithFormat:@"%@ **** %@",[userName substringWithnumber:3 reverse:NO],[userName substringWithnumber:4 reverse:YES]];

        _userNameLabel.text = subStr;
    }
    
    NSString *memberDate = [ZXSDCurrentUser currentUser].customerValidity;
    if (memberDate.length > 0) {
        [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(20);
            make.top.equalTo(self.avatarImageView).offset(-3);
        }];
        
        [self.memberDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLabel);
            make.bottom.equalTo(self.avatarImageView.mas_bottom).offset(-2);
        }];
        
        self.memberIcon.image = UIIMAGE_FROM_NAME(@"smile_member_icon_green");
        self.memberDateLabel.text = memberDate;
        
    } else {
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(20);
            make.centerY.equalTo(self.avatarImageView);
        }];
        
        [self.memberDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLabel);
            make.bottom.equalTo(self.avatarImageView.mas_bottom).offset(-2);
            make.height.mas_equalTo(0);
        }];
        
        self.memberIcon.image = UIIMAGE_FROM_NAME(@"smile_member_icon_gray");
    }
    
    int payday = [ZXSDCurrentUser currentUser].payDay;
    
    NSString *paydayStr = payday>0 ? [@(payday) stringValue] : @"" ;

    if (IsValidString(paydayStr)) {
        self.paydayLab.text = [NSString stringWithFormat:@"发薪日：每月%@日",paydayStr];
    }
    else{
        self.paydayLab.text = @"";
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _mineDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_mineDataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXSDPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCenterCell" forIndexPath:indexPath];
    
    NSArray *rows = _mineDataArray[indexPath.section];
//    NSLog(@"----------rows=%ld,row=%ld",rows.count,indexPath.row);
//    ZXPersonalCenterModel *model = [rows objectAtIndex:indexPath.row];

    ZXPersonalCenterModel *model = nil;
    if (rows.count > indexPath.row) {
        model = [rows objectAtIndex:indexPath.row];
    }
    
    if (indexPath.row == rows.count - 1) {
        [cell hideBottomLine];
    } else {
        [cell showBottomLine];
    }
    
    if (model) {
        [cell reloadSubviewsWithModel:model];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColor.purpleColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _mineDataArray.count - 1) {
        return 0;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == _mineDataArray.count - 1) {
        return nil;
    }
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 8)];
    footer.backgroundColor = UICOLOR_FROM_HEX(0xF7F9FB);
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ZXPersonalCenterModel *model = [_mineDataArray[indexPath.section] objectAtIndex:indexPath.row];
    if ([model.title isEqualToString:@"帮助与客服"]) {
        [self jumpToFaqController];
    } else if ([model.title containsString:@"留言联系"]) {
        TrackEvent(kNote_ceo);
        
        [self jumpToFeedbackController];
    } else if ([model.title isEqualToString:@"邀请我司"]) {
        ZXSDInviteCompanyController *viewController = [ZXSDInviteCompanyController new];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([model.title isEqualToString:@"邀请好友"]) {
        ZXSDInviteFriendsController *viewController = [ZXSDInviteFriendsController new];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if([model.title isEqual:@"优惠券"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kCouponRedDotkey"];
        [URLRouter routerUrlWithPath:kRouter_couponList extra:nil];
        [self.mineTableView reloadData];
    }
    else {
        [self checkStatusAndJump:model];
    }
}

#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        return;
    }
    CGFloat alpha = fabs(offsetY/(200-kNavigationBarHeight));
    self.customNavBarView.backgroundColor = UIColorHexAlpha(0xffffff, alpha);

//    self.titleLab.textColor = [UIColor colorWithWhite:255-alpha*255 alpha:1];
    
    self.showBlackStatusBar = alpha >= 0.8;
    [self setNeedsStatusBarAppearanceUpdate];


}

#pragma mark - Action
//处理对应状态的跳转逻辑
- (void)checkStatusAndJump:(ZXPersonalCenterModel *)model
{
    if (!_bankCardDone) {
//        ZXSDNecessaryCertThirdStepController *vc = [ZXSDNecessaryCertThirdStepController new];
//        vc.backViewController = self;
//        [self.navigationController pushViewController:vc animated:YES];
        
        [URLRouter routerUrlWithPath:kRouter_bindCard extra:nil];
        
        return;
    }
    
    if (!_jobInfoDone) {
        ZXSDNecessaryCertFourthStepController *vc = [ZXSDNecessaryCertFourthStepController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }


//    if (!_idCardDone) {
//        ZXSDIdentityCardVerifyController *vc = [ZXSDIdentityCardVerifyController new];
//        vc.backViewController = self;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//    
//    if (!_idFaceDone) {
//        ZXSDLivingDetectionController *vc = [ZXSDLivingDetectionController new];
//        vc.backViewController = self;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    
    
    
    if ([model.title isEqualToString:@"预支记录"]) {
        ZXSDAdvanceRecordsController *viewController = [ZXSDAdvanceRecordsController new];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([model.title isEqualToString:@"身份信息"]) {
        TrackEvent(kMine_info);
        
        ZXSDQueryIDCardInfoController *viewController = [ZXSDQueryIDCardInfoController new];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([model.title isEqualToString:@"工资卡管理"]) {
        
        //ZXSDQueryDebitCardInfoController *viewController = [ZXSDQueryDebitCardInfoController new];
        ZXSDBankCardListController *viewController = [ZXSDBankCardListController new];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([model.title isEqualToString:@"雇主信息"]) {
        ZXSDQueryCompanyInfoController *viewController = [ZXSDQueryCompanyInfoController new];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([model.title isEqualToString:@"任务中心"]) {
        
        ZXSDCertificationCenterController *viewController = [ZXSDCertificationCenterController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }  else {
        ZGLog(@"用户中心点击异常!");
    }
    
}

- (void)jumpToSetting
{
    ZXSDPersonalSettingsController *viewController = [ZXSDPersonalSettingsController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

//跳转帮助与客服
- (void)jumpToFaqController {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/faq"];
    [self showWebWithURL:requestURL];
}

// 留言联系
- (void)jumpToFeedbackController {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/feedback"];
    [self showWebWithURL:requestURL];
}

- (void)showWebWithURL:(NSString *)url
{
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = url;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];

}


#pragma mark - Getter

- (UITableView *)mineTableView
{
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _mineTableView.scrollEnabled = YES;
        _mineTableView.delegate = self;
        _mineTableView.dataSource = self;
        _mineTableView.showsVerticalScrollIndicator = YES;
        _mineTableView.backgroundColor = [UIColor whiteColor];
        _mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mineTableView;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [UILabel new];
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.font = FONT_SFUI_X_Medium(16);
    }
    return _userNameLabel;
}

- (UILabel *)memberDateLabel
{
    if (!_memberDateLabel) {
        _memberDateLabel = [UILabel labelWithText:@"" textColor:UIColor.whiteColor font:FONT_PINGFANG_X(12)];
    }
    return _memberDateLabel;
}

- (UILabel *)paydayLab{
    if (!_paydayLab) {
        _paydayLab = [UILabel labelWithText:@"" textColor:UIColor.whiteColor font:FONT_PINGFANG_X(12)];
    }
    return _paydayLab;
}

- (UIImageView *)memberIcon
{
    if (!_memberIcon) {
        _memberIcon = [UIImageView new];
    }
    return _memberIcon;
}

- (UIButton *)settingBtn
{
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithNormalImage:UIIMAGE_FROM_NAME(@"mine_tool") highlightedImage:nil];
        [_settingBtn addTarget:self action:@selector(jumpToSetting) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _settingBtn;
}


@end
