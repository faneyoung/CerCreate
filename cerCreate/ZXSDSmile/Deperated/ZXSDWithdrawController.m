//
//  ZXSDWithdrawController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/21.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDWithdrawController.h"
#import "ZXSDWithdrawAmountCell.h"
#import "ZXSDWithdrawBankCell.h"
#import "ZXSDRepaymentAuthCodeCell.h"
#import "ZXSDBankCardModel.h"
#import "ZXSDWithdrawInfoModel.h"


@interface ZXSDWithdrawController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, strong) ZXSDBankCardModel *bankInfo;
@property (nonatomic, strong) ZXSDWithdrawInfoModel *infoModel;

@end

@implementation ZXSDWithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    
    [self addUserInterfaceConfigure];
    [self prepareDataConfigure];
}

- (void)backButtonClicked
{
    if (self.fromActivity) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
}

- (void)prepareDataConfigure
{
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_WITHDRAW_INFO] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取提现信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.infoModel = [ZXSDWithdrawInfoModel modelWithJSON:responseObject];
        }
        [self.mainTable reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}


- (void)addUserInterfaceConfigure
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"我要提现";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [headerView addSubview:titleLabel];
    
    self.mainTable.tableHeaderView = headerView;
    
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 120)];
    [footer addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer).offset(20);
        make.right.equalTo(footer).offset(-20);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(0);
    }];
    self.mainTable.tableFooterView = footer;
    
    [self.mainTable registerClass:[ZXSDWithdrawAmountCell class] forCellReuseIdentifier:@"amountCell"];
    [self.mainTable registerClass:[ZXSDWithdrawBankCell class] forCellReuseIdentifier:@"bankCell"];
    [self.mainTable registerClass:[ZXSDRepaymentAuthCodeCell class] forCellReuseIdentifier:@"codeCell"];
}



#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = nil;
    if (indexPath.row == 0) {
        cellIdentifier = @"amountCell";
    } else if (indexPath.row == 1){
        cellIdentifier = @"bankCell";
    } else {
        cellIdentifier = @"codeCell";
    }
    
    ZXSDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cellIdentifier isEqualToString:@"amountCell"]) {
        ZXSDWithdrawAmountCell * amountCell = (ZXSDWithdrawAmountCell *)cell;
        amountCell.amoutTF.text = self.infoModel.amount;
        [cell setRenderData:self.infoModel];
        
    } else if ([cellIdentifier isEqualToString:@"bankCell"]) {
        [cell setRenderData:self.infoModel];
        
    } else if ([cellIdentifier isEqualToString:@"codeCell"]) {
        ZXSDRepaymentAuthCodeCell * codeCell = (ZXSDRepaymentAuthCodeCell *)cell;
        @weakify(codeCell);
        [codeCell setSendCodeAction:^(UIButton * _Nonnull sender, ZXSDRepaymentAuthCodeCell * _Nonnull cell) {
            @strongify(codeCell);
            [self sendAuthCode:sender cell:codeCell];
        }];
        [codeCell setUpdateAuthCode:^(NSString * _Nonnull code) {
            self.smsCode = code;
        }];
    }
    if (indexPath.row == 1) {
        [cell showBottomLine];
    } else {
        [cell hideBottomLine];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}


#pragma mark - Action

- (void)doWithdrawAction
{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }
    
    if (self.smsCode.length <= 0) {
        [self showToastWithText:@"请输入短信验证码"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"CNY" forKey:@"currency"];
    [params setValue:phone forKey:@"phone"];
    [params setValue:self.infoModel.amount forKey:@"amount"];
    [params setValue:self.infoModel.fee forKey:@"fee"];
    [params setValue:self.smsCode forKey:@"otpCode"];
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,WITHDRAW_ACTION_URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"提现接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *status = [responseObject objectForKey:@"fundStatus"];
            NSString *errStr = [responseObject objectForKey:@"fundMsg"];
            if ([status isEqualToString:@"SUCCESS"]) {
                [self showToastWithText:@"提现已完成，请耐心等待到账"];
                
                [self performSelector:@selector(backButtonClicked) withObject:nil afterDelay:.5];
            } else {
                if ([status isEqualToString:@"DOING"]) {
                    [self showToastWithText:errStr.length > 0 ? errStr:@"提现处理中"];
                    [self performSelector:@selector(backButtonClicked) withObject:nil afterDelay:.5];
                } else {
                    [self showToastWithText:errStr.length > 0 ? errStr:@"提现失败"];
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)sendAuthCode:(UIButton *)btn
                cell:(ZXSDRepaymentAuthCodeCell *)cell
{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }
    
    btn.userInteractionEnabled = NO;
    NSDictionary *dic = @{
        @"phone":phone,
        @"type":@"OPT_WITHDRAWAL",
        @"amount":self.infoModel.amount
    };
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,SEND_AUTHCODE_URL] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissLoadingProgressHUD];
        btn.userInteractionEnabled = YES;
        ZGLog(@"发送验证码接口成功返回数据---%@",responseObject);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastWithText:@"验证码已成功发送"];
            [cell updateCountdownValue];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        btn.userInteractionEnabled = YES;
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"验证码获取失败"];
    }];
      
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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


- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(20, 160, SCREEN_WIDTH() - 40, 44);
        _confirmButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(doWithdrawAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_confirmButton setTitle:@"立即提现" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}


@end
