//
//  ZXMemberCreateViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/2/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMemberCreateViewController.h"
#import "CJLabel.h"
#import "UITableView+help.h"
#import "UIViewController+help.h"


//views
#import "ZXMemberCreateHeaderView.h"
#import "ZXMemberCreateOptionCell.h"
#import "ZXMemberCreateMemberCell.h"

//vc
#import "ZXMemberPayViewController.h"
#import "ZXSDAdvanceSalaryResultController.h"
#import "ZXSDIdentityCardVerifyController.h"
#import "ZXSDLivingDetectionController.h"


#import "EPNetworkManager.h"
#import "ZXMemberUserInfo.h"


typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeOption,
    SectionTypeMember,
    SectionTypeAll
};

@interface ZXMemberCreateViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *customNavView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLab;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZXMemberCreateHeaderView *headerView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, assign) BOOL showBlackStatusBar;
@property (nonatomic, strong) NSArray *memberUsers;




@end

@implementation ZXMemberCreateViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.showBlackStatusBar) {
        [self.backBtn setImage:UIImageNamed(@"icon_nav_back_black") forState:UIControlStateNormal];
        self.titleLab.textColor = TextColorTitle;
        return UIStatusBarStyleDefault;
    }
    else{
        [self.backBtn setImage:UIImageNamed(@"icon_nav_back_white") forState:UIControlStateNormal];
        self.titleLab.textColor = UIColor.whiteColor;
        return UIStatusBarStyleLightContent;

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableInteractivePopGesture = YES;
    self.isHideNavigationBar = YES;

    [self adaptScrollView:self.tableView];
    
    [self.tableView registerNibs:@[
    
        NSStringFromClass(ZXMemberCreateOptionCell.class),
        NSStringFromClass(ZXMemberCreateMemberCell.class),
    ]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.customNavView];
    [self requestUserInfo];
    [self requestMemberPayList];
}

#pragma mark - data handle -

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
        [self refreshTableHeaderAndFooterView];
    }];
}

- (void)requestMemberPayList{
    [EPNetworkManager.defaultManager getAPI:kPath_memberPayUserList parameters:nil decodeClass:ZXMemberUserInfo.class completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (IsValidArray(response.resultModel.data)) {
            
            __block NSMutableArray *tmps = @[].mutableCopy;
            [((NSArray*)response.resultModel.data) enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZXMemberUserInfo *user = [[ZXMemberUserInfo alloc] init];
                user.userName = TrimString(obj);
                user.payStatus = @"购买了季卡会员";
                [tmps addObject:user];
            }];
            self.memberUsers = tmps.copy;
            [self.tableView reloadData];
        }
        
    }];
}

- (void)requestCanBuyMember{
    
    LoadingManagerShow();
    [EPNetworkManager.defaultManager getAPI:kPath_canBuyMember parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
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
        
        ZXMemberPayViewController *payVC = [[ZXMemberPayViewController alloc] init];
        [self.navigationController pushViewController:payVC animated:YES];
    }];
}

- (void)refreshTableHeaderAndFooterView{
    
    [self.headerView updateViewWithModel:nil];
    
    ZXUserModel *userModel = [ZXSDCurrentUser currentUser].userModel;
    
    [self.confirmButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    NSString *confirmTitle = @"开通并预支";
    SEL sel = @selector(openMemberAction);
    if(userModel.isCustomer){
        confirmTitle = @"续费";
        sel = @selector(confirmRenewBtnClick);
    }

    [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - views -

- (void)setupSubViews{
    
    [self.view addSubview:self.customNavView];
    [self.customNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    
    UIView *footView = [self footerView];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.inset(kBottomSafeAreaHeight);
        make.height.mas_equalTo(76);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.mas_equalTo(footView.mas_top);
    }];
    
    UIView *hView = [[UIView alloc] init];
    hView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 194 + kNavigationBarHeight);
    [hView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    [self.headerView updateViewWithModel:nil];
    self.tableView.tableHeaderView = hView;
    
}

- (UIView*)customNavView{
    if (!_customNavView) {
        UIView *navView = [[UIView alloc] init];
        navView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.font = FONT_PINGFANG_X_Medium(16);
        lab.textColor = UIColor.whiteColor;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"成为薪朋友会员";
        [navView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(0);
            make.bottom.inset(10);
            make.height.mas_equalTo(24);
        }];
        self.titleLab = lab;
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:UIImageNamed(@"icon_nav_back_white") forState:UIControlStateNormal];
        [navView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.inset(0);
            make.centerY.mas_equalTo(lab);
            make.width.mas_equalTo(56);
            make.height.mas_equalTo(44);
        }];
        [backBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.backBtn = backBtn;
        
        _customNavView = navView;
    }
    
    return _customNavView;
}

- (ZXMemberCreateHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [ZXMemberCreateHeaderView instanceMemberHeadView];
        
    }
    return _headerView;
}

- (UIView*)footerView{
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 76);
    
    [footerView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.protocolLabel.mas_bottom).offset(25);
        make.bottom.inset(16);
        make.left.right.inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.confirmButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    NSString *confirmTitle = @"开通并预支";
    SEL sel = @selector(openMemberAction);
    if(self.memberInfoModel.haveCustomer){
        confirmTitle = @"续费";
        sel = @selector(confirmRenewBtnClick);
    }

    [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];

    
    return footerView;
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

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(20, 160, SCREEN_WIDTH() - 40, 44);
        [_confirmButton setBackgroundImage:kGradientImageYellow forState:(UIControlStateNormal)];
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0x976C38) forState:UIControlStateNormal];
        
        [_confirmButton setTitle:@"开通并预支" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

#pragma mark - action methods -
- (void)openMemberAction{
    [self requestCanBuyMember];
}

- (void)confirmRenewBtnClick{
    [self requestCanBuyMember];
}

- (BOOL)checkActionStatus{
    return [[ZXSDCurrentUser currentUser] checkAllAuthStatusWithBackVC:self];
}



#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypeOption) {
        ZXMemberCreateOptionCell *cell = [ZXMemberCreateOptionCell instanceCell:tableView];
        @weakify(self);
        cell.optionSelectedBlock = ^(int idx) {
            @strongify(self);
            [self.tableView reloadData];
        };
        cell.loanAmount = self.loanAmount;
        cell.interest = self.interest;
        [cell updateWithData:self.memberInfoModel];
        
        return cell;
    }
    else if(indexPath.section == SectionTypeMember){
        ZXMemberCreateMemberCell *cell = [ZXMemberCreateMemberCell instanceCell:tableView];
        
        
        [cell updateViewsWithData:self.memberUsers];
        return cell;
    }
    
    return [tableView defaultReuseCell];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"----------offsetY=%.2f",offsetY);

    if (offsetY <= -kNavigationBarNormalHeight) {
        self.customNavView.backgroundColor = [UIColor colorWithWhite:255 alpha:0];
        [self.backBtn setImage:UIImageNamed(@"icon_nav_back_black") forState:UIControlStateNormal];
        self.titleLab.textColor = TextColorTitle;

        self.showBlackStatusBar = YES;
        [self setNeedsStatusBarAppearanceUpdate];


        return;
    }
    CGFloat alpha = fabs(offsetY/kNavigationBarHeight);
    alpha = alpha > 1 ? 1 : alpha;
    alpha = alpha < 0 ? 0 : alpha;
//    NSLog(@"----------alpha=%.2f",alpha);

    self.customNavView.backgroundColor = UIColorHexAlpha(0xffffff, alpha);
//
////    self.titleLab.textColor = [UIColor colorWithWhite:255-alpha*255 alpha:1];

    self.showBlackStatusBar = alpha >= 0.8;
    [self setNeedsStatusBarAppearanceUpdate];


}


@end
