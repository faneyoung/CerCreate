//
//  ZXSDPersonalSettingsController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDPersonalSettingsController.h"
#import "ZXSDPersonalSettingsAlertController.h"
#import "ZXSDAboutSmileController.h"
#import <StoreKit/SKStoreReviewController.h>
#import <StoreKit/SKStoreProductViewController.h>

@interface ZXSDPersonalSettingsController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_settingsTableView;
}

@end

@implementation ZXSDPersonalSettingsController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableInteractivePopGesture = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    
    [self addUserInterfaceConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ZXAppTrackManager event:kSettingPage];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
}

- (void)addUserInterfaceConfigure {
    _settingsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80 + 60 * 2) style:UITableViewStylePlain];
    _settingsTableView.backgroundColor = [UIColor whiteColor];
    _settingsTableView.scrollEnabled = NO;
    _settingsTableView.delegate = self;
    _settingsTableView.dataSource = self;
    _settingsTableView.showsVerticalScrollIndicator = NO;
    _settingsTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _settingsTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    [self.view addSubview:_settingsTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"设置";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [headerView addSubview:titleLabel];
    
    _settingsTableView.tableHeaderView = headerView;
    _settingsTableView.tableFooterView = [UIView new];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat safaAreaBottom = iPhoneXSeries() ? 34 : 0;
    logoutButton.frame = CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 20 - 44 - safaAreaBottom, SCREEN_WIDTH() - 40, 44);
    logoutButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
    [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
    [logoutButton setTitleColor:UICOLOR_FROM_HEX(0x999999) forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.layer.cornerRadius = 22.0;
    logoutButton.layer.masksToBounds = YES;
    [self.view addSubview:logoutButton];
    
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.bottom.inset(kBottomSafeAreaHeight+20);
        make.height.mas_equalTo(44);
    }];
    
    [_settingsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.mas_equalTo(logoutButton.mas_top);
    }];
    
}

- (void)cancelButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"settingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    cell.textLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    if (indexPath.row == 0) {
        cell.textLabel.text = @"关于";
        
        UIImageView *indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile_mine_arrow"]];
        indicatorView.frame = CGRectMake(0, 0, 16, 16);
        cell.accessoryView = indicatorView;
    }
    else if(indexPath.row == 1) {
        cell.textLabel.text = @"版本号";
        
        NSString *flag = @"";
        NSString *buildVersionStr = @"";
#if TEST
        flag = @"-test";
        buildVersionStr = [NSString stringWithFormat:@"(build %@)",appBuildVersion()];
#elif UAT
        flag = @"-UAT";
        buildVersionStr = [NSString stringWithFormat:@"(build %@)",appBuildVersion()];

#elif RELEASE
        
#endif
        
        cell.detailTextLabel.text  = [NSString stringWithFormat:@"v%@ %@ %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],buildVersionStr,flag];
        cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
        cell.detailTextLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"去评价";
        
        UIImageView *indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile_mine_arrow"]];
        indicatorView.frame = CGRectMake(0, 0, 16, 16);
        cell.accessoryView = indicatorView;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ZXSDAboutSmileController *viewController = [ZXSDAboutSmileController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 2){
        
//        NSString *appstoreLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1517015114&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
//        if (SYSTEM_VERSION_GETATER_THAN(11.0)) {
//            appstoreLink = @"itms-apps://itunes.apple.com/app/id1517015114";
//        }
//
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appstoreLink]];
        
        [AppUtility showAppstoreEvaluationView];
    }
}

- (void)logoutButtonClicked {
    ZXSDPersonalSettingsAlertController *viewController = [ZXSDPersonalSettingsAlertController new];
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    viewController.confirmBlock = ^{
        [self logoutApplication];
    };
    [self presentViewController:viewController animated:NO completion:nil];
}

//退出登录
- (void)logoutApplication {

    // 清空用户数据
    [ZXSDCurrentUser clearUserInfo];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_USERLOGOUT object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [URLRouter routeToMainPageTab];
    });
}

#pragma mark - appstore -

static SKStoreProductViewController *storeProductViewController;
- (void)showAppstoreEvaluationView{
    [ZXLoadingManager showLoading:kLoadingTip];
    
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
        [ZXLoadingManager hideLoading];
    } else {
        // Fallback on earlier versions
        
        
        [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:kAppID} completionBlock:^(BOOL result, NSError * _Nullable error) {
            
            if (error)
                NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
            else
                [self presentViewController:storeProductViewController animated:YES completion:nil];
        }];
        [ZXLoadingManager hideLoading];
        
    }
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [storeProductViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
