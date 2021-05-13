//
//  ZXSettingViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXSettingViewController.h"
#import "UITableView+help.h"

//vc
#import "ZXSDNecessaryCertFourthStepController.h"

//views
#import "ZXPersonalItemCell.h"
#import "ZXSDPersonalSettingsAlertController.h"

#import "ZXPersonalCenterModel.h"

@interface ZXSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *personalItems;

@end

@implementation ZXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.enableInteractivePopGesture = YES;
    
    [self.tableView registerNibs: @[
        NSStringFromClass(ZXPersonalItemCell.class),
    ]];
    
}

#pragma mark - views -

- (void)setupSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
    [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
    [logoutButton setTitleColor:UICOLOR_FROM_HEX(0x999999) forState:UIControlStateNormal];
    logoutButton.titleLabel.font = FONT_PINGFANG_X(16);
    [logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
    ViewBorderRadius(logoutButton, 22, 0.01, UIColor.whiteColor);
    
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.bottom.inset(kBottomSafeAreaHeight+20);
        make.height.mas_equalTo(44);
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
        _tableView.estimatedRowHeight = 56;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

#pragma mark - data handle -

- (NSArray *)personalItems{
    if (!_personalItems) {
        _personalItems = [ZXPersonalCenterModel personalSettingItems];
    }
    return _personalItems;
}

#pragma mark - action methods -

- (void)logoutButtonClicked {
//    ZXSDPersonalSettingsAlertController *viewController = [ZXSDPersonalSettingsAlertController new];
//    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    @weakify(self);
//    viewController.confirmBlock = ^{
//        @strongify(self);
//        [self dismissViewControllerAnimated:NO completion:nil];
//        dispatch_queue_after_S(0.3, ^{
//            [self logoutApplication];
//        });
//    };
//    [self presentViewController:viewController animated:NO completion:nil];
    
    @weakify(self);
    [AppUtility alertViewWithTitle:@"确定要退出吗？" des:nil cancel:nil confirm:^{
        @strongify(self);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZXSDUserDefaultHelper removeObjectForKey:KEEPLOGINSTATUSUSERID];
            [ZXSDUserDefaultHelper removeObjectForKey:KEEPLOGINSTATUSSESSION];
            [ZXSDPublicClassMethod deleteAllCookiesInSharedHTTPCookieStorage];

            [self.navigationController popToRootViewControllerAnimated:NO];
            // 清空用户数据
            [ZXSDCurrentUser clearUserInfo];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_USERLOGOUT object:nil];
            });

        });
        

    }];
    
    
    
    
}

//退出登录
- (void)logoutApplication {

    [self.navigationController popToRootViewControllerAnimated:NO];

    dispatch_queue_after_S(0.3, ^{
        // 清空用户数据
        [ZXSDCurrentUser clearUserInfo];

        [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_USERLOGOUT object:nil];

    });
    
}



#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.personalItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = self.personalItems[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXPersonalItemCell *cell = [ZXPersonalItemCell instanceCell:tableView];
    NSArray *rowItems = self.personalItems[indexPath.section];
    [cell updateWithData:rowItems[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [tableView defaultHeaderFooterView];
    view.backgroundColor = kThemeColorBg;
    return view;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *rowItems = self.personalItems[indexPath.section];
    ZXPersonalCenterModel *model = rowItems[indexPath.row];
    
//    if (model.needVerify) {
//        if (!self.statusModel.bankCardDone) {
//            [URLRouter routerUrlWithPath:kRouter_bindCard extra:nil];
//            return;
//        }
//
//        if (!self.statusModel.jobInfoDone) {
//            ZXSDNecessaryCertFourthStepController *vc = [ZXSDNecessaryCertFourthStepController new];
//            vc.backViewController = self;
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
//    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    if (indexPath.row == 0) {
        [params setSafeValue:self.backViewController forKey:@"backViewController"];
    }
    [URLRouter routerUrlWithPath:model.action extra:params.copy];
}

@end
