//
//  ZXSDDebitCardBankListController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDDebitCardBankListController.h"
#import "ZXSDDebitCardBankListCell.h"
#import "BMChineseSort.h"
#import "DSectionIndexItemView.h"
#import "DSectionIndexView.h"

static const NSString *DEBIT_CARD_LIST_URL = @"/rest/bankCard/config";

@interface ZXSDDebitCardBankListController ()<DSectionIndexViewDelegate,DSectionIndexViewDataSource,UITableViewDelegate,UITableViewDataSource> {
    UITableView *_bankTableView;
}

@property (nonatomic, strong) NSMutableArray *groupTitlesArray;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *bankGroupsArray;
@property (nonatomic, strong) DSectionIndexView *sectionIndexView;

@end

@implementation ZXSDDebitCardBankListController

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
    
    self.title = @"选择银行";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    
    [self addUserInterfaceConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self ZXSDNavgationBarConfigure];
    [self prepareDataConfigure];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.sectionIndexView.frame = CGRectMake(SCREEN_WIDTH() - 40, (SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 360)/2, 40, 360);
    [self.sectionIndexView setBackgroundViewFrame];
}

- (void)addUserInterfaceConfigure {
    _bankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT()) style:UITableViewStylePlain];
    _bankTableView.delegate = self;
    _bankTableView.dataSource = self;
    _bankTableView.showsVerticalScrollIndicator = NO;
    _bankTableView.backgroundColor = [UIColor whiteColor];
    _bankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bankTableView.sectionIndexColor = UICOLOR_FROM_HEX(0x333333);
    _bankTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_bankTableView];
    
    _sectionIndexView = [[DSectionIndexView alloc] init];
    _sectionIndexView.backgroundColor = [UIColor clearColor];
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.isShowCallout = NO;
    [self.view addSubview:self.sectionIndexView];
    
    [_bankTableView registerNib:[UINib nibWithNibName:@"ZXSDDebitCardBankListCell" bundle:nil] forCellReuseIdentifier:@"debitCardBankListCell"];
}

- (void)prepareDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,DEBIT_CARD_LIST_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取银行列表信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        NSMutableArray *listArray = [ZXSDDebitCardBankListModel parsingDataWithJson:responseObject];
        [self dealWithDataConfigure:listArray];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"获取银行列表信息失败"];
    }];
}

- (void)dealWithDataConfigure:(NSMutableArray *)bankListArray {
    if (bankListArray.count != 0) {
        BMChineseSortSetting.share.sortMode = 2;
        [BMChineseSort sortAndGroup:bankListArray key:@"bankName" finish:^(bool isSuccess, NSMutableArray *unGroupedArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
            if (isSuccess) {
                self.groupTitlesArray = [NSMutableArray arrayWithArray:sectionTitleArr];
                self.bankGroupsArray = [NSMutableArray arrayWithArray:sortedObjArr];
                [self->_bankTableView reloadData];
                [self.sectionIndexView reloadItemViews];
            }
        }];
    }
}

- (void)cancelButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groupTitlesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bankGroupsArray[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 24)];
    sectionBackView.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 2, 100, 20)];
    titleLabel.text = [self.groupTitlesArray objectAtIndex:section];
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    [sectionBackView addSubview:titleLabel];
    
    return sectionBackView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXSDDebitCardBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"debitCardBankListCell" forIndexPath:indexPath];
    ZXSDDebitCardBankListModel *model = self.bankGroupsArray[indexPath.section][indexPath.row];
    [cell reloadSubviewsWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZXSDDebitCardBankListModel *model = self.bankGroupsArray[indexPath.section][indexPath.row];
    if (self.selectResultBlock) {
        self.selectResultBlock(model.bankName, model.bankPic, model.bankCode);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView {
    return _bankTableView.numberOfSections;
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section {
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    itemView.titleLabel.text = [self.groupTitlesArray objectAtIndex:section];
    itemView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
    itemView.titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    itemView.titleLabel.highlightedTextColor = UICOLOR_FROM_HEX(0x666666);
    return itemView;
}

- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView titleForSection:(NSInteger)section {
    return [self.groupTitlesArray objectAtIndex:section];
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section {
    [_bankTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
