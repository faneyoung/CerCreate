//
//  ZXSDQueryDebitCardInfoController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDQueryDebitCardInfoController.h"

static const NSString *QUERY_DEBIT_CARD_INFO_URL = @"/rest/bankCard/all";

@interface ZXSDQueryDebitCardInfoController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_infoTableView;
    
    NSArray *_titleArray;
    NSString *_bankLogoUrl;
    NSString *_bankName;
    NSString *_debitCardNumber;
    NSString *_phoneNumber;
}

@end

@implementation ZXSDQueryDebitCardInfoController

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
    _titleArray = @[@"银行卡号",@"",@"银行预留手机号"];
    _bankName = @"";
    _debitCardNumber = @"";
    _phoneNumber = @"";
}

- (void)refreshDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_DEBIT_CARD_INFO_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取用户银行卡信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSDictionary *resultDic = [responseObject firstObject];
            self->_bankName = [[resultDic objectForKey:@"bankName"] isKindOfClass:[NSNull class]] ? @"" : [resultDic objectForKey:@"bankName"];
            self->_bankLogoUrl = [[resultDic objectForKey:@"bankIcon"] isKindOfClass:[NSNull class]] ? @"" : [resultDic objectForKey:@"bankIcon"];
            self->_debitCardNumber = [[resultDic objectForKey:@"number"] isKindOfClass:[NSNull class]] ? @"" : [resultDic objectForKey:@"number"];
            self->_phoneNumber = [[resultDic objectForKey:@"reservePhone"] isKindOfClass:[NSNull class]] ? @"" : [resultDic objectForKey:@"reservePhone"];
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"银行卡信息";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [headerView addSubview:titleLabel];
    
    _infoTableView.tableHeaderView = headerView;
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
    static NSString *cellName = @"debitCardInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    cell.textLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, 20, SCREEN_WIDTH() - 138 - 20, 20)];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    contentLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    if (indexPath.row == 0) {
        cell.textLabel.text = _titleArray[indexPath.row];
        contentLabel.text = _debitCardNumber;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = _titleArray[indexPath.row];
        contentLabel.text = _phoneNumber;
    } else {
        cell.textLabel.text = _bankName;
        if (_bankLogoUrl.length > 0) {
            [cell.imageView sd_setImageWithURL:_bankLogoUrl.URLByCheckCharacter placeholderImage:UIIMAGE_FROM_NAME(@"smile_bank_default")];
        }
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
