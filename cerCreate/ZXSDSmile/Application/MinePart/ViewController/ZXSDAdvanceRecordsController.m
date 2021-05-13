//
//  ZXSDAdvanceRecordsController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAdvanceRecordsController.h"
#import "ZXSDAdvanceRecordsCell.h"
#import "ZXSDExtendDetailController.h"
#import "ZXSDRepaymentDetailController.h"
#import "ZXSDExtendInfoAlertView.h"

static const NSString *ADVANCE_RECORDS_URL = @"/rest/loan/list";

static const NSString *RECORD_CONTRACT_URL = @"/rest/contract/loan";

static const NSInteger RECORDS_LIST_PAGE_SIZE = 10;

@interface ZXSDAdvanceRecordsController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_recordsTableView;
    
    NSMutableArray *_recordsListArray;
    
    NSInteger _currentPage;
}

@property (nonatomic, strong) ZXSDExtendInfoAlertView *tipsAlert;

@end

@implementation ZXSDAdvanceRecordsController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableInteractivePopGesture = YES;
    
    self.title = @"预支记录";
    self->_recordsListArray = [NSMutableArray arrayWithCapacity:10];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    
    [self addUserInterfaceConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TrackEvent(kAdvancedRecord);
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
    [self fetchAdvanceRecords:YES];
}

#pragma mark - data handle -

- (void)refreshAllData{
    [self fetchAdvanceRecords:YES];
}

- (void)fetchAdvanceRecords:(BOOL)refresh
{
    if (refresh) {
        [self->_recordsListArray removeAllObjects];
        _currentPage = 1;
        [self showLoadingProgressHUDWithText:@"正在加载..."];
    }
    
    NSDictionary *parameters = @{
        @"pageNum":@(_currentPage),
        @"pageSize":@(RECORDS_LIST_PAGE_SIZE)
    };
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    @weakify(self);
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,ADVANCE_RECORDS_URL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        ZGLog(@"获取预支记录信息接口成功返回数据---%@",responseObject);
        if (refresh) {
            [self dismissLoadingProgressHUDImmediately];
            [self->_recordsTableView.mj_header endRefreshing];
        }
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *responseArray = [responseObject objectForKey:@"resultList"];
            NSInteger totalCount = [[responseObject objectForKey:@"totalCount"] integerValue];
            
            NSArray *listArray = [NSArray yy_modelArrayWithClass:[ZXSDAdvanceRecordsModel class] json:responseArray];

            [self->_recordsListArray addObjectsFromArray:listArray];
            [self->_recordsTableView reloadData];
            
            if (self->_recordsListArray.count != 0) {
                
                self->_currentPage ++;
                if (self->_recordsListArray.count == totalCount) {
                    [self->_recordsTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self->_recordsTableView.mj_footer endRefreshing];
                }
                
            } else {
                //添加空白提示页面
                [self addEmptyNoticeView];
            }
                        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (refresh) {
            [self dismissLoadingProgressHUDImmediately];
            [self->_recordsTableView.mj_header endRefreshing];
        }
       
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)addUserInterfaceConfigure {
    _recordsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT()) style:UITableViewStylePlain];
    _recordsTableView.delegate = self;
    _recordsTableView.dataSource = self;
    _recordsTableView.showsVerticalScrollIndicator = NO;
    _recordsTableView.backgroundColor = [UIColor whiteColor];
    _recordsTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _recordsTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    _recordsTableView.estimatedRowHeight = 100;
    [self.view addSubview:_recordsTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 40)];
    headerView.backgroundColor = kThemeColorNote;
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
//    titleLabel.text = @"预支记录";
//    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
//    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
//    [headerView addSubview:titleLabel];
    
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    detailsLabel.textAlignment = NSTextAlignmentCenter;
    detailsLabel.text = @"发薪日自动从您的工资卡中抵扣";
    detailsLabel.textColor = UICOLOR_FROM_HEX(0xC8A028);
    detailsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    [headerView addSubview:detailsLabel];
    
    _recordsTableView.tableHeaderView = headerView;
    _recordsTableView.tableFooterView = [UIView new];
    
    _recordsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchAdvanceRecords:YES];
    }];
    _recordsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchAdvanceRecords:NO];
        
    }];
    
    
    [_recordsTableView registerClass:[ZXSDAdvanceRecordsCell class] forCellReuseIdentifier:@"advanceRecordsCell"];
    [_recordsTableView registerClass:[ZXSDAdvanceRecordExtendCell class] forCellReuseIdentifier:@"advanceExtendCell"];
}

//无记录时展示默认页面
- (void)addEmptyNoticeView {
    _recordsTableView.hidden = YES;
    
    UIImageView *noticeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 67, 160, 134, 100)];
    noticeImageView.image = UIIMAGE_FROM_NAME(@"smile_no_records");
    [self.view addSubview:noticeImageView];
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(noticeImageView.frame) + 20, SCREEN_WIDTH() - 40, 30)];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    emptyLabel.text = @"暂无记录";
    emptyLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    [self.view addSubview:emptyLabel];
}

- (void)cancelButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recordsListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXSDAdvanceRecordsModel *model = _recordsListArray[indexPath.row];
    
    NSString *identifier = @"advanceRecordsCell";
    if (model.canRepay) {
        identifier = @"advanceExtendCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!model.canRepay) {
        ZXSDAdvanceRecordsCell *recordCell = (ZXSDAdvanceRecordsCell*)cell;
        [recordCell reloadSubviewsWithModel:model];
        @weakify(self);
        recordCell.jumpToLoanContractBlock = ^{
            @strongify(self);
            [self jumpToLoanContractControllerWithUrl:model.loanID];
        };
    } else {
        @weakify(self);
        ZXSDAdvanceRecordExtendCell *extendCell = (ZXSDAdvanceRecordExtendCell*)cell;
        [extendCell reloadSubviewsWithModel:model];
        extendCell.jumpToLoanContractBlock = ^{
            @strongify(self);
            [self jumpToLoanContractControllerWithUrl:model.loanID];
        };
        
        [extendCell setExtendAction:^{
            @strongify(self);
            [self gotoExtendDetail:model];
        }];
        
        [extendCell setRepaymentAction:^{
            @strongify(self);
            [self gotoRepaymentDetail:model];
        }];
        
        [extendCell setExtendAlert:^{
            [self showExtendTipsAlert:model];
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

//跳转预支合同
- (void)jumpToLoanContractControllerWithUrl:(NSString *)loanID {
    NSDictionary *parameters = @{
        @"loanRefId":loanID};
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    LoadingManagerShow();
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,RECORD_CONTRACT_URL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"加载预支合同接口成功返回数据---%@",responseObject);
        LoadingManagerHidden();
        NSString *html = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            html = [responseObject objectForKey:@"htmlContent"];
        }
        if (html.length > 0) {
            ZXSDWebViewController *viewController = [ZXSDWebViewController new];
            viewController.title = @"合同";
            viewController.htmlStr = html;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LoadingManagerHidden();
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)gotoExtendDetail:(ZXSDAdvanceRecordsModel *)model
{
    ZXSDExtendDetailController *vc = [ZXSDExtendDetailController new];
    vc.loanRefId = model.loanID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoRepaymentDetail:(ZXSDAdvanceRecordsModel *)model
{
    TrackEvent(kAdvancedRecord_refund);
    
    ZXSDRepaymentDetailController *vc = [ZXSDRepaymentDetailController new];
    vc.loanRefId = model.loanID;
    vc.bankcardRefId = model.bankcardRefId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showExtendTipsAlert:(ZXSDAdvanceRecordsModel *)model
{
    [self.tipsAlert showInView:self.navigationController.view];
    [self.tipsAlert configDate:model.oldRepaymentDate freshDate:model.repaymentDate];
}

- (ZXSDExtendInfoAlertView *)tipsAlert
{
    if (!_tipsAlert) {
        _tipsAlert = [ZXSDExtendInfoAlertView new];
    }
    return _tipsAlert;
}

@end
