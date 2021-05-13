//
//  ZXSDOpenClassIIBankAccountController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDOpenClassIIBankAccountController.h"
#import "ZXSDAdvanceSalaryResultController.h"

static const NSString *GET_BANK_ACCOUNT_INFO_URL = @"/rest/userbank2/init";
static const NSString *SUBMIT_OPEN_BANK_ACCOUNT_URL = @"/rest/userbank2/openClassTwoAcct";
//static const NSString *SUBMIT_LOAN_URL = @"/rest/loan/create";
static const NSString *PERSON_IDCARD_AGREEMENT_URL = @"";

@interface ZXSDOpenClassIIBankAccountController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_infoTableView;
    
    NSArray *_channelNameArray;
    NSArray *_titleArray;
    
    NSString *_userName;
    NSString *_idCardNumber;
    NSString *_bankLogoUrl;
    NSString *_bankName;
    NSString *_debitCardNumber;
    NSString *_phoneNumber;
}

@end

@implementation ZXSDOpenClassIIBankAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self ZXSDNavgationBarConfigure];
    [self refreshDataConfigure];
}

- (void)prepareDataConfigure {
    _channelNameArray = @[@"基本信息",@"联系方式"];
    _titleArray = @[@"姓名",@"身份证号",@"银行卡号",@""];
    
    _userName = @"";
    _idCardNumber = @"";
    _debitCardNumber = @"";
    _bankName = @"";
    _bankLogoUrl = @"";
    _phoneNumber = @"";
}

- (void)refreshDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,GET_BANK_ACCOUNT_INFO_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取银行二类户信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self->_userName = [[responseObject objectForKey:@"name"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"name"];
            self->_idCardNumber = [[responseObject objectForKey:@"idCard"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"idCard"];
            self->_debitCardNumber = [[responseObject objectForKey:@"cardNo"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"cardNo"];
            self->_bankName = [[responseObject objectForKey:@"bankName"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"bankName"];
            self->_bankLogoUrl = [[responseObject objectForKey:@"bankPicUrl"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"bankPicUrl"];
            self->_phoneNumber = [[responseObject objectForKey:@"bankPhoneNo"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"bankPhoneNo"];
        }
        
        [self->_infoTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}


- (void)addUserInterfaceConfigure {
    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 104) style:UITableViewStylePlain];
    _infoTableView.backgroundColor = [UIColor whiteColor];
    _infoTableView.scrollEnabled = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _infoTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    [self.view addSubview:_infoTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 110)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"亲，还有最后一步";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [headerView addSubview:titleLabel];
    
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH() - 40, 20)];
    detailsLabel.text = @"预支薪资，需开通上海银行二类户";
    detailsLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    detailsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    [headerView addSubview:detailsLabel];
    
    _infoTableView.tableHeaderView = headerView;
    _infoTableView.tableFooterView = [UIView new];
    
    CGFloat safaAreaBottom = iPhoneXSeries() ? 34 : 0;
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 64 - 44 - safaAreaBottom, SCREEN_WIDTH() - 40, 44);
    submitButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [submitButton setTitle:@"确定开通" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.cornerRadius = 22.0;
    submitButton.layer.masksToBounds = YES;
    [self.view addSubview:submitButton];
    
    UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 20 - 20 - safaAreaBottom, SCREEN_WIDTH() - 40, 20)];
    agreeLabel.text = @"我已阅读并同意《个人身份证协议》";
    agreeLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    agreeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    agreeLabel.textAlignment = NSTextAlignmentCenter;
    agreeLabel.userInteractionEnabled = YES;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:agreeLabel.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UICOLOR_FROM_HEX(0x4472C4) range:NSMakeRange(attributedString.length - 9, 9)];
    agreeLabel.attributedText = attributedString;
    [self.view addSubview:agreeLabel];
    
    UITapGestureRecognizer *agreeLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPersonIDCardAgreementController)];
    [agreeLabel addGestureRecognizer:agreeLabelTap];
}

- (void)cancelButtonClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//跳转个人身份证协议
- (void)jumpToPersonIDCardAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
//    viewController.requestURL = [NSString stringWithFormat:@"%@%@",MAIN_URL,PERSON_IDCARD_AGREEMENT_URL];
    viewController.requestURL = @"http://sc-xmhf-web.ktest.cashbus.com/static/userAgreement.html";
    viewController.title = @"个人身份证协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

//先开通银行二类户
- (void)submitButtonClicked {
    NSDictionary *needDic = @{@"name":_userName,@"idCard":_idCardNumber,@"cardNo":_debitCardNumber,@"bankPhoneNo":_phoneNumber};;
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,SUBMIT_OPEN_BANK_ACCOUNT_URL] parameters:needDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"提交银行二类户开户接口成功返回数据---%@",responseObject);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self submitAdvanceSalaryLoan];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

//提交预支薪资借款
- (void)submitAdvanceSalaryLoan {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,SUBMIT_LOAN_URL] parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"提交预支薪资借款信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        [self jumpToAdvanceSalaryResultController];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

//等待审核状态页面
- (void)jumpToAdvanceSalaryResultController {
    ZXSDAdvanceSalaryResultController *viewController = [ZXSDAdvanceSalaryResultController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _channelNameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _titleArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"idInformationCell";
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
    [cell.contentView addSubview:contentLabel];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = _titleArray[indexPath.row];
            contentLabel.text = _userName;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = _titleArray[indexPath.row];
            contentLabel.text = _idCardNumber;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = _titleArray[indexPath.row];
            contentLabel.text = _debitCardNumber;
        } else {
            cell.textLabel.text = _bankName;
            if (_bankLogoUrl.length > 0) {
                NSString *encodedString = [_bankLogoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:UIIMAGE_FROM_NAME(@"smile_bank_default")];
            }
        }
    } else {
        cell.textLabel.text = @"银行预留手机号";
        contentLabel.text = _phoneNumber;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 68)];
    sectionBackView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH()/2, 28)];
    titleLabel.text = _channelNameArray[section];
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20.0];
    [sectionBackView addSubview:titleLabel];
    
    return sectionBackView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 68.f;
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
