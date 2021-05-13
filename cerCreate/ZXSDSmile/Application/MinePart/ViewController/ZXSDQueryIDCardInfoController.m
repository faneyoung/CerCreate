//
//  ZXSDQueryIDCardInfoController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDQueryIDCardInfoController.h"

static const NSString *QUERY_IDCARD_INFO_URL = @"/rest/userInfo/personInfo";

@interface ZXSDQueryIDCardInfoController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_infoTableView;
    
    NSArray *_titleArray;
    NSString *_userName;
    NSString *_userCardNumber;
}

@end

@implementation ZXSDQueryIDCardInfoController

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
    self.title = @"身份信息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
    [self refreshDataConfigure];
}

- (void)prepareDataConfigure {
    _titleArray = @[@"姓名",@"身份证号"];
    _userName = @"";
    _userCardNumber = @"";
}

- (void)refreshDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_IDCARD_INFO_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取用户身份信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self->_userName = [[responseObject objectForKey:@"name"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"name"];
            self->_userCardNumber = [[responseObject objectForKey:@"idNo"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"idNo"];
        }

        [self->_infoTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)addUserInterfaceConfigure {
    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80 + 60 * 3) style:UITableViewStylePlain];
    _infoTableView.backgroundColor = [UIColor whiteColor];
    _infoTableView.scrollEnabled = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _infoTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    [self.view addSubview:_infoTableView];
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80)];
//    headerView.backgroundColor = [UIColor whiteColor];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
//    titleLabel.text = @"身份信息";
//    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
//    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
//    [headerView addSubview:titleLabel];
//
//    _infoTableView.tableHeaderView = headerView;
    _infoTableView.tableFooterView = [UIView new];
}

- (void)cancelButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"idInformationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    cell.textLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 20, SCREEN_WIDTH() - 96 - 20, 20)];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    contentLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    if (indexPath.row == 0) {
        contentLabel.text = _userName;
    } else {
        contentLabel.text = _userCardNumber;
    }
    [cell.contentView addSubview:contentLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
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
