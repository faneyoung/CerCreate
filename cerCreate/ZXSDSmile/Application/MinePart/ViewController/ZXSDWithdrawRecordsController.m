//
//  ZXSDWithdrawRecordsController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDWithdrawRecordsController.h"
#import "ZXSDWithdrawRecordCell.h"
#import "ZXSDWithdrawItemModel.h"

static const NSString *WITHDRAW_RECORDS_URL = @"/rest/loan/teller/listWithdrawOrder";

@interface ZXSDWithdrawRecordsController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray<ZXSDWithdrawItemModel*> *records;
@property (nonatomic, strong) NSString *bankDesc;

@end

@implementation ZXSDWithdrawRecordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableInteractivePopGesture = YES;
    self.records = [NSMutableArray new];
    self.currentPage = 1;
    
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
        self.currentPage = 1;
        [self.records removeAllObjects];
        [self showLoadingProgressHUDWithText:@"正在加载..."];
    }
    
    NSDictionary *parameters = @{
        @"pageNum":@(_currentPage),
        @"pageSize":@(10)
    };
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,WITHDRAW_RECORDS_URL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取提现记录信息接口成功返回数据---%@",responseObject);
        
        if (refresh) {
            [self dismissLoadingProgressHUDImmediately];
            [self.mainTable.mj_header endRefreshing];
        }
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            self.bankDesc = [responseObject objectForKey:@"title"];
            NSArray *responseArray = [[responseObject objectForKey:@"pageVO"] objectForKey:@"resultList"];
            NSInteger totalCount = [[[responseObject objectForKey:@"pageVO"] objectForKey:@"totalCount"] integerValue];
            
            [self.records addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ZXSDWithdrawItemModel class] json:responseArray]];
            [self.mainTable reloadData];
            
            
            if (self.records.count != 0) {
                if (self.records.count == totalCount || responseArray.count == 0) {
                    [self.mainTable.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.mainTable.mj_footer endRefreshing];
                    self.currentPage ++;
                }
            } else {
                // 空白页面
                [self addEmptyNoticeView];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (refresh) {
            [self.mainTable.mj_header endRefreshing];
            [self dismissLoadingProgressHUDImmediately];
        }
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
        
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
    titleLabel.text = @"提现记录";
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
    

    [self.mainTable registerClass:[ZXSDWithdrawRecordCell class] forCellReuseIdentifier:[ZXSDWithdrawRecordCell identifier]];
}

- (void)addEmptyNoticeView {
    self.mainTable.hidden = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"提现记录";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [self.view addSubview:titleLabel];
    
    UIImageView *noticeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 67, CGRectGetMaxY(titleLabel.frame) + 100, 134, 100)];
    noticeImageView.image = UIIMAGE_FROM_NAME(@"smile_no_records");
    [self.view addSubview:noticeImageView];
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(noticeImageView.frame) + 20, SCREEN_WIDTH() - 40, 30)];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    emptyLabel.text = @"暂无记录";
    emptyLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    [self.view addSubview:emptyLabel];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXSDWithdrawRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDWithdrawRecordCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZXSDWithdrawItemModel *model = [self.records objectAtIndex:indexPath.row];
    [cell setRenderData:model];
    cell.bankLabel.text = self.bankDesc.length > 0 ? self.bankDesc:@"余额提现";

    [cell showBottomLine];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
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
