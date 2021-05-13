//
//  ZXMessageViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMessageViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <JPUSHService.h>
#import "UITableView+help.h"
#import "AppDelegate.h"

//views
#import "ZXMessageOptionCell.h"
#import "ZXMessageItemCell.h"

//vc
#import "ZXSDBaseTabBarController.h"
#import "ZXMemberMessageViewController.h"
#import "ZXPromotionMessageViewController.h"
#import "ZXSDWebViewController.h"


#import "EPNetworkManager+message.h"
#import "ZXMessageList.h"
#import "ZXLocationManager.h"

#define kTableViewHeaderHeight      104

@interface ZXMessageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZXMessageOptionCell *headerview;

@property (nonatomic, strong) UIView *notiView;

@property (nonatomic, strong) ZXMessageStatusModel *statusModel;
@property (nonatomic, strong) NSMutableArray *messages;


@end

@implementation ZXMessageViewController

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllData) name:ZXSD_notification_newMessage object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllData) name:ZXSD_notification_userLogin object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    self.enableInteractivePopGesture = YES;
    
    self.tableView.centery = kTableViewHeaderHeight;
    self.tableView.placeholderView = [self.tableView defaultPlaceholdViewWithMsg:@"还没有任何消息哦~"];
    self.tableView.showPlaceholdWhenLoad = NO;
    @weakify(self);
    [self.tableView addHeaderRefreshingBlock:^{
        @strongify(self);
        [self reloadAllData];
    }];
    [self.tableView addFooterRefreshingBlock:^{
        @strongify(self);
        [self refreshMessageCount];
        [self loadMoreData];
    }];
    
    
    self.headerview.optionBtnBlock = ^(int type) {
        @strongify(self);
        if (type == 0) {
            ZXMemberMessageViewController *messageVC = [[ZXMemberMessageViewController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
        else if (type == 1){
            
            ZXPromotionMessageViewController *proVC = [[ZXPromotionMessageViewController alloc] init];
            proVC.locationDic = ZXLocationManager.sharedManger.locationDic;
            [self.navigationController pushViewController:proVC animated:YES];
        }
    };
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), kTableViewHeaderHeight);
    self.tableView.tableHeaderView = self.headerview;
    
    [self refreshMessageDataWithLoading:YES];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self userIsAllowPush:^(BOOL open) {
        
        [self shouldShowNotificationNoteView:!open];
        
    }];
    
    [self refreshAllData];
    
}

#pragma mark - views -
- (ZXMessageOptionCell *)headerview{
    
    if (!_headerview) {
        _headerview = [ZXMessageOptionCell instanceCell:self.tableView];
    }
    
    return _headerview;
}

- (void)setupSubViews{
//    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    clearBtn.frame = CGRectMake(0, 0, kNavigationBarHeight*2, kNavigationBarHeight);
//    clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [clearBtn setImage:UIImageNamed(@"icon_msg_clear") forState:UIControlStateNormal];
//    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
//    [self customNavBarView];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.inset(kBottomSafeAreaHeight);
    }];
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXMessageOptionCell.class),
        NSStringFromClass(ZXMessageItemCell.class),
    ]];
    
    
    
    
}

- (UIView *)notiView{
    if (!_notiView) {
        _notiView = [[UIView alloc] init];
        _notiView.backgroundColor = kThemeColorNote;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"X" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:UIColorFromHex(0xC8A028) forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FONT_PINGFANG_X(18);
        [cancelBtn setImage:UIImageNamed(@"") forState:UIControlStateNormal];
        [_notiView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.inset(0);
            make.width.mas_equalTo(49);
        }];
        [cancelBtn addTarget:self action:@selector(cancelNotiViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *openNotiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openNotiBtn.backgroundColor = UIColor.whiteColor;
        [openNotiBtn setTitle:@"立即开启" forState:UIControlStateNormal];
        
        [openNotiBtn setTitleColor:UIColorFromHex(0xC8A028) forState:UIControlStateNormal];
        openNotiBtn.titleLabel.font  =FONT_PINGFANG_X(12);
        ViewBorderRadius(openNotiBtn, 16, 0.01, UIColor.whiteColor);
        [openNotiBtn setImage:UIImageNamed(@"") forState:UIControlStateNormal];
        [_notiView addSubview:openNotiBtn];
        [openNotiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cancelBtn.mas_left).inset(0);
            make.height.mas_equalTo(32);
            make.width.mas_equalTo(80);
            make.centerY.offset(0);
        }];
        [openNotiBtn addTarget:self action:@selector(openNotiBtnViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *noteLab = [[UILabel alloc] init];
        noteLab.numberOfLines = 0;
        noteLab.font = FONT_PINGFANG_X(14);
        noteLab.textColor = kThemeColorYellow;
        noteLab.text = @"请开启通知开关，获取即时提醒，保障您的权益。";
        [_notiView addSubview:noteLab];
        [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.inset(16);
            make.left.inset(20);
            make.right.mas_equalTo(openNotiBtn.mas_left).inset(16);
        }];
        
        [self.view addSubview:_notiView];
        [_notiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(0);
            make.bottom.inset(kBottomSafeAreaHeight);
            make.height.mas_equalTo(72);
        }];

    }
    return _notiView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 165;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    
    return _tableView;
}

- (void)shouldShowNotificationNoteView:(BOOL)show{
    self.notiView.hidden = !show;
}

#pragma mark - data handle -

- (void)refreshAllData{
    [self.tableView startHeaderRefresh];
}

- (void)reloadAllData{
    [self refreshMessageCount];
    [self refreshMessageData];
}


- (void)refreshMessageCount{
    [[EPNetworkManager defaultManager] requestMessageStatus:^(NSError * _Nonnull error, ZXMessageStatusModel * _Nonnull statusModel) {
        
//        [[AppDelegate appDelegate].tabBarController shouldShowBadge:statusModel.hasNew];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshMessage object:nil userInfo:@{@"hasNew" : @(statusModel.hasNew)}];

        self.statusModel = statusModel;
        [self.headerview updateWithData:self.statusModel];
        self.tableView.tableHeaderView = self.headerview;
    }];
}

- (void)refreshMessageData{
    [self refreshMessageDataWithLoading:NO];
}

static const int kPageSize = 10;
- (void)refreshMessageDataWithLoading:(BOOL)show{
    NSMutableDictionary *pms = @{}.mutableCopy;
    [pms setSafeValue:@(0) forKey:@"offset"];
    [pms setSafeValue:@(kPageSize) forKey:@"limit"];
    [pms setSafeValue:@"message" forKey:@"type"];
    if (show) {
        [ZXLoadingManager showLoading:@"加载中..."];
    }
    [[EPNetworkManager defaultManager] getAPI:@"rest/notice/record/list" parameters:pms.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_safe_async_main(^{
            [ZXLoadingManager hideLoading];
            [self.tableView.mj_header endRefreshing];
        });
        
        if (error) {
            return;
        }
        
        ZXMessageList *messageList = [ZXMessageList instanceWithDictionary:response.originalContent];
        
        [self.messages removeAllObjects];
        
        [self.messages addObjectsFromArray:messageList.messages];
        
        dispatch_safe_async_main(^{
            [self.tableView reloadData];
        });
    }];
}

- (void)loadMoreData{
    
    NSMutableDictionary *pms = @{}.mutableCopy;
    [pms setSafeValue:@(self.messages.count) forKey:@"offset"];
    [pms setSafeValue:@(kPageSize) forKey:@"limit"];
    [pms setSafeValue:@"message" forKey:@"type"];
    [[EPNetworkManager defaultManager] getAPI:@"rest/notice/record/list" parameters:pms.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_safe_async_main(^{
            [self.tableView.mj_footer endRefreshing];
        });
        if (error) {
            return;
        }
        
        ZXMessageList *messageList = [ZXMessageList instanceWithDictionary:response.originalContent];
        if (IsValidArray(messageList.messages)) {
            [self.messages addObjectsFromArray:messageList.messages];
        }
        
        dispatch_safe_async_main(^{
            [self.tableView reloadData];

        });
        
        
    }];

}

#pragma mark - action methods -
- (void)clearBtnClick{
    
}

- (void)cancelNotiViewBtnClick{
    self.notiView.hidden = YES;
}

- (void)openNotiBtnViewBtnClick{
    self.notiView.hidden = YES;

    [JPUSHService openSettingsForNotification:^(BOOL success) {

    }];
}

#pragma mark - help methods -
- (NSMutableArray *)messages{
    if (!_messages) {
        _messages = [NSMutableArray arrayWithCapacity:1];
    }
    return _messages;
}

- (void)userIsAllowPush:(void (^)(BOOL))isOpenPushBlock {
    
    __block BOOL isAllow = NO;
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            isAllow = (settings.authorizationStatus == UNAuthorizationStatusAuthorized);
            
            dispatch_safe_async_main(^{
                isOpenPushBlock(isAllow);
            });
        }];
    }
    else{
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        BOOL isAllow = (settings.types != UIUserNotificationTypeNone);
        
        dispatch_safe_async_main(^{
            isOpenPushBlock(isAllow);
            
        });
        
    }
    
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXMessageItemCell *cell = [ZXMessageItemCell instanceCell:tableView];
    [cell updateWithData:self.messages[indexPath.row]];
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColor.whiteColor;
    headerView.clipsToBounds = YES;
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = TextColorTitle;
    titleLab.font = FONT_PINGFANG_X_Medium(20);
    titleLab.text = @"服务通知";
    [headerView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(20);
        make.bottom.inset(0);
        make.height.mas_equalTo(28);
    }];
    
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZXMessageItem *item = self.messages[indexPath.row];
    if (!IsValidString(item.url)) {
        return;
    }
    
//    ZXSDWebViewController *webVC = [[ZXSDWebViewController alloc] init];
//    webVC.requestURL = GetString(item.url);
//    [self.navigationController pushViewController:webVC animated:YES];
    [URLRouter routerUrlWithPath:GetString(item.url) extra:nil];
    
}




@end
