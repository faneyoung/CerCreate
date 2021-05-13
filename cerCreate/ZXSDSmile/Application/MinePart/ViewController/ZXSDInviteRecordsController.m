//
//  ZXSDInviteRecordsController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/26.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDInviteRecordsController.h"
#import "ZXSDInviteRecordsCell.h"

#define PageSize 15

@interface ZXSDInviteRecordsController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray<ZXSDInviteItem*> *records;

@end

@implementation ZXSDInviteRecordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.records = [NSMutableArray new];
    self.currentPage = 0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    
    [self addUserInterfaceConfigure];
    [self fetchRecords:YES];
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    [self.mainTable mas_updateConstraints:^(MASConstraintMaker *make) {
       if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (void)fetchRecords:(BOOL)refresh
{
    if (refresh) {
        self.currentPage = 0;
        [self.records removeAllObjects];
        [self showLoadingProgressHUDWithText:@"正在加载..."];
    }
    
    NSDictionary *parameters = @{
        @"offset": @(PageSize * _currentPage),
        @"limit": @(PageSize),
    };
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,USER_INVITELIST_URL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取邀请记录信息接口成功返回数据---%@",responseObject);
        if (refresh) {
            [self dismissLoadingProgressHUDImmediately];
            [self.mainTable.mj_header endRefreshing];
        }
        
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSArray *listArray = [responseObject objectForKey:@"resultList"];
            NSInteger totalCount = [[responseObject objectForKey:@"totalCount"] integerValue];
            
            NSArray *records = [NSArray yy_modelArrayWithClass:[ZXSDInviteItem class] json:listArray];
            
            
            [self.records addObjectsFromArray:records];
            [self.mainTable reloadData];
            
            
            if (self.records.count != 0) {
                if (self.records.count == totalCount || listArray.count == 0) {
                    [self.mainTable.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.mainTable.mj_footer endRefreshing];
                    self.currentPage ++;
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (refresh) {
            [self dismissLoadingProgressHUDImmediately];
            [self.mainTable.mj_header endRefreshing];
        }
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
        [self.mainTable.mj_header endRefreshing];
    }];
}

- (void)addUserInterfaceConfigure {
    
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"邀请记录";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [headerView addSubview:titleLabel];
    
    self.mainTable.tableHeaderView = headerView;
    self.mainTable.tableFooterView = [UIView new];
    
    self.mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchRecords:YES];
    }];
    self.mainTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchRecords:NO];
    }];
    

    [self.mainTable registerClass:[ZXSDInviteItemCell class] forCellReuseIdentifier:[ZXSDInviteItemCell identifier]];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXSDInviteItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDInviteItemCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZXSDInviteItem *model = [self.records objectAtIndex:indexPath.row];
    [cell setRenderData:model];

    [cell showBottomLine];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 44)];
    header.backgroundColor = UICOLOR_FROM_HEX(0xF8F8F8);
    
    UILabel *phoneLabel = [UILabel labelWithText:@"好友手机号" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(12)];
    
    UILabel *verifyLabel = [UILabel labelWithText:@"完成认证" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    verifyLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *wageLabel = [UILabel labelWithText:@"上传流水" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    wageLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *withdrawLabel = [UILabel labelWithText:@"首次提现" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    withdrawLabel.textAlignment = NSTextAlignmentCenter;
    
    [header addSubview:phoneLabel];
    [header addSubview:verifyLabel];
    [header addSubview:wageLabel];
    [header addSubview:withdrawLabel];
    
    CGFloat width = (SCREEN_WIDTH() - 40);
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(20);
        make.centerY.equalTo(header);
        make.width.mas_equalTo(width * 0.25);
    }];
    [verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_right);
        make.centerY.equalTo(header);
        make.width.mas_equalTo(width * 0.25);
    }];
    
    [wageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verifyLabel.mas_right);
        make.centerY.equalTo(header);
        make.width.mas_equalTo(width * 0.25);
    }];
    
    [withdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header).offset(-20);
        make.left.equalTo(wageLabel.mas_right);
        make.centerY.equalTo(header);
        make.width.mas_equalTo(width * 0.25);
    }];
    return header;
}

#pragma mark - Getter
- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [UITableView new];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.estimatedRowHeight = 90;
        _mainTable.backgroundColor = UIColor.whiteColor;

    }
    return _mainTable;
}

@end
