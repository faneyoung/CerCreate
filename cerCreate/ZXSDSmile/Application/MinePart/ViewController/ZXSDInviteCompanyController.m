//
//  ZXSDInviteCompanyController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/7.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDInviteCompanyController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZXSDRadioPickController.h"
#import "ZXSDPersonalInfoCell.h"
#import "EPNetworkManager+Mine.h"

static const NSString *QUERY_RECOMMEND_INFO_URL = @"/rest/recommend/init";
static const NSString *POST_RECOMMEND_INFO_URL = @"/rest/recommend/new/company";

@interface ZXSDInviteCompanyController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *companyNameModify;
@property (nonatomic, copy) NSString *jobModify;
@property (nonatomic, copy) NSString *contactModify;
@property (nonatomic, copy) NSString *phoneModify;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *jobArray;


@property (nonatomic, strong) TPKeyboardAvoidingTableView *infoTableView;
@property (nonatomic, strong) UIButton *modifyButton;



@end

@implementation ZXSDInviteCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.title = @"邀请我司";
    
    [self prepareDataConfigure];
    [self prepareMoreDataConfigure];
    [self addUserInterfaceConfigure];
    [self refreshDataConfigure];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    TrackEvent(kInvite_me);
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
}

- (void)prepareDataConfigure {
    self.titleArray = @[@"公司名称",@"联系人", @"职务", @"联系方式"];
    
    self.jobArray = @[@"总经理/厂长", @"副总经理/副厂长", @"人力资源总监", @"财务总监", @"行政总监", @"销售总监", @"运营总监", @"技术总监", @"项目总监", @"总经理助理"];
    
    self.companyName = @"";
    self.job = @"";
    self.contact = @"";
    self.phone = @"";
    
    self.companyNameModify = @"";
    self.jobModify = @"";
    self.contactModify = @"";
    self.phoneModify = @"";
}

- (void)refreshDataConfigure
{
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_RECOMMEND_INFO_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取邀请我司信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.companyNameModify = self.companyName = [[responseObject objectForKey:@"companyName"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"companyName"];
            
            self.jobModify = self.job = [[responseObject objectForKey:@"leaderPost"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"leaderPost"];
            self.contact = self.contactModify = [[responseObject objectForKey:@"leaderName"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"leaderName"];
            self.phone = self.phoneModify = [[responseObject objectForKey:@"leaderPhone"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"leaderPhone"];
        }

        [self->_infoTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)addUserInterfaceConfigure
{
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(360);
    }];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 40)];
    headerView.backgroundColor = [UIColor whiteColor];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH() - 40, 40)];
//    titleLabel.text = ;
//    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
//    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
//    [headerView addSubview:titleLabel];
    
    UILabel *descLab = [UILabel labelWithText:@"我的公司不是薪朋友的合作企业" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(14)];
    [headerView addSubview:descLab];
    [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(9);
        make.left.inset(20);
    }];
    
    self.infoTableView.tableHeaderView = headerView;
    self.infoTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.modifyButton];
    [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.infoTableView.mas_bottom).offset(40);
    }];
    
    [self.infoTableView registerClass:[ZXSDPersonalInfoCell class] forCellReuseIdentifier:@"infoCell"];

}

- (void)cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyButtonClicked
{
    if (![self validateAllTextFieldsAreAllowed]) {
        return;
    }
    
    if (![self validateAllTextFieldsIsModify]) {
        [self showToastWithText:@"您还没有修改任何信息哦"];
        return;
    }
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    NSDictionary *parameters = @{@"companyName":self.companyNameModify,
          @"leaderName":self.contactModify,
          @"leaderPost":self.jobModify,
          @"leaderPhone":self.phoneModify
    };
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,POST_RECOMMEND_INFO_URL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"提交用户公司信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"提交失败"];
    }];
    
}

- (void)prepareMoreDataConfigure {
    
    [EPNetworkManager getOptionalConfigs:nil completion:^(ZXSDOptionalConfigs *model, NSError *error) {
        
        if (model.leaderPost.count > 0) {
            self.jobArray = model.leaderPost;
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"infoCell";
    ZXSDPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ZXSDPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.canEdit = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.text = self.companyName;
        }
            break;
        case 1:
        {
            cell.canEdit = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.text = self.contact;
        }
            break;
        case 2:
        {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择";
            cell.textField.text = self.job;
        }
            break;
        case 3:
        {
            cell.canEdit = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.text = self.phone;
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
        }
            break;
        
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 2) {
        [self.view endEditing:YES];
        [self handlerTextFieldSelect:textField];
        return NO;
    } else {
        [textField addTarget:self action:@selector(handlerTextFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
        return YES;
    }
}

#pragma mark - 处理编辑事件
- (void)handlerTextFieldEndEdit:(UITextField *)textField {
    ZGLog(@"结束编辑:%@", textField.text);
    switch (textField.tag) {
        case 0:
        {
            self.companyNameModify = textField.text;
        }
            break;
        case 1:
        {
            self.contactModify = textField.text;
        }
            break;
            
        case 3:
        {
            self.phoneModify = textField.text;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 处理点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)handlerTextFieldSelect:(UITextField *)textField  {
    switch (textField.tag) {
        case 2:
        {
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _jobArray;
            viewController.pickTitle = @"职务";
            viewController.selectedValue = self.job;
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.jobModify = returnString;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
        }
            break;
       
        default:
            break;
    }
}

- (BOOL)validateAllTextFieldsAreAllowed
{
    [self.view endEditing:YES];

    if (self.companyNameModify.length == 0) {
        [self showToastWithText:@"请输入您的单位名称"];
        return NO;
    }
    
    if (self.contactModify.length == 0) {
        [self showToastWithText:@"请输入联系人"];
        return NO;
    }
    
    if (self.jobModify.length == 0) {
        [self showToastWithText:@"请选择您的职务"];
        return NO;
    }
    
    if (self.phoneModify.length == 0) {
        [self showToastWithText:@"请输入您的联系方式"];
        return NO;
    }
    
    if ([self.phoneModify isEqualToString:[ZXSDCurrentUser currentUser].phone]) {
        [EasyTextView showText:@"不能填写本人手机号"];
        return NO;
    }
    
    if (![self.phoneModify validateStringIsPhoneNumberFormate]) {
        [self showToastWithText:@"请输入正确的电话号码"];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateAllTextFieldsIsModify
{
    if ([self.companyName isEqualToString:self.companyNameModify]
        && [self.job isEqualToString:self.jobModify]
        && [self.contact isEqualToString:self.contactModify]
        && [self.phone isEqualToString:self.phoneModify]) {
        return NO;
    } else {
        return YES;
    }
}
    

#pragma mark - Getter

- (TPKeyboardAvoidingTableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [TPKeyboardAvoidingTableView new];
        _infoTableView.backgroundColor = [UIColor whiteColor];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.showsVerticalScrollIndicator = NO;
        _infoTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _infoTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    }
    return _infoTableView;
}

- (UIButton *)modifyButton
{
    if (!_modifyButton) {
        _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _modifyButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
        [_modifyButton setTitle:@"提交" forState:UIControlStateNormal];
        [_modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _modifyButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
        [_modifyButton addTarget:self action:@selector(modifyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _modifyButton.layer.cornerRadius = 22.0;
        _modifyButton.layer.masksToBounds = YES;
    }
    return _modifyButton;
}

@end
