//
//  ZXSDEditEmployerCompanyController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDEditEmployerCompanyController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "UITextField+ExtendRange.h"
#import "ZXSDPersonalInfoCell.h"
#import "ZXSDCompanySearchResultView.h"

static const NSString *EMPLOYER_QUERY_COMPANYNAME_URL = @"/rest/userInfo/companyInfo";
static const NSString *EMPLOYER_UPDATE_COMPANYNAME_URL = @"/rest/userInfo/companyInfo";

@interface ZXSDEditEmployerCompanyController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    TPKeyboardAvoidingTableView *_infoTableView;
    
    NSArray *_titleArray;
}

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, strong) ZXSDCompanySearchResultView *searchView;
@property (nonatomic, strong) NSArray<ZXSDCompanyModel*> *companys;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation ZXSDEditEmployerCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.companys = [ZXSDGlobalObject sharedGlobal].innerCompanys;
    
    [self addUserInterfaceConfigure];
    [self prepareDataConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
}

- (void)cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareDataConfigure {
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,EMPLOYER_QUERY_COMPANYNAME_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取雇主公司信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.companyName = [responseObject objectForKey:@"workUnit"];
            [self->_infoTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)addUserInterfaceConfigure {
    _infoTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 124) style:UITableViewStylePlain];
    _infoTableView.backgroundColor = [UIColor whiteColor];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _infoTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    [self.view addSubview:_infoTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80)];
    headerView.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"雇主信息";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [headerView addSubview:titleLabel];
    

    _infoTableView.tableHeaderView = headerView;
    _infoTableView.tableFooterView = [UIView new];
    
    CGFloat safaAreaBottom = iPhoneXSeries() ? 34 : 0;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 64 - 44 - safaAreaBottom, SCREEN_WIDTH() - 40, 44);
    submitButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [submitButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.cornerRadius = 22.0;
    submitButton.layer.masksToBounds = YES;
    [self.view addSubview:submitButton];
    self.submitButton = submitButton;
    
}

- (void)saveButtonClicked
{
    [self.view endEditing:YES];
    if (self.companyName.length == 0) {
        return;
    }
    
    
    [self showLoadingProgressHUDWithText:@"保存中..."];
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,EMPLOYER_UPDATE_COMPANYNAME_URL] parameters:@{@"workUnit":self.companyName} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"修改雇主公司信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];
        [self cancelButtonClicked];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"companyInformationCell";
    ZXSDPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ZXSDPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.titleLabel.text = @"公司名称";
    cell.textField.delegate = self;
    cell.textField.placeholder = @"请输入";
    cell.canEdit = YES;
    cell.textField.text = self.companyName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

#pragma mark - UITextFieldDelegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.companys.count == 0 || textField.text.length == 0) {
        return;
    }
    
    [self showSearchView:YES keyword:textField.text textField:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.searchView.hidden = YES;
    self.companyName = textField.text;
    [self updateButtonAppearance];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 50) {
        
        [self showToastWithText:@"公司名称不能超过50个字"];
        return NO;
    }
    
    [self showSearchView:YES keyword:toBeString textField:textField];

    return YES;
}

- (void)showSearchView:(BOOL)show
               keyword:(NSString *)keyword
             textField:(UITextField *)textField
{
    if (!show || keyword.length == 0) {
        _searchView.hidden = YES;
        return;
    }
    
    if (!self.searchView.superview) {
        [self.view addSubview:self.searchView];
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_infoTableView).with.offset(150);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(self.companys.count * 45);
        }];
        
        @weakify(self);
        self.searchView.didSelectModel = ^(ZXSDCompanyModel * _Nonnull model) {
            
            @strongify(self);
            self.companyName = model.companyName;
            textField.text = self.companyName;
            self.searchView.hidden = YES;
        };
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"companyName CONTAINS %@",keyword];
    
    NSArray *result = [self.companys filteredArrayUsingPredicate:predicate].mutableCopy;
    
    if (result.count == 0) {
        self.searchView.hidden = YES;
        return;
    }
    
    NSInteger max = MIN(result.count, 4);
    [self.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(max * 45);
    }];
    
    self.searchView.hidden = NO;
    [self.searchView freshResultWithResults:result];
}

- (void)updateButtonAppearance
{
    BOOL enabled = self.companyName.length > 0;
    _submitButton.backgroundColor = enabled ? kThemeColorMain: UICOLOR_FROM_HEX(0xF0F0F0);
    [_submitButton setTitleColor:enabled ?UICOLOR_FROM_HEX(0xFFFFFF) : UICOLOR_FROM_HEX(0xCCCCCC) forState:(UIControlStateNormal)];
    _submitButton.layer.shadowOpacity = enabled ? 1: 0;
    _submitButton.userInteractionEnabled = enabled;
}

- (ZXSDCompanySearchResultView *)searchView
{
    if (!_searchView) {
        _searchView = [ZXSDCompanySearchResultView new];
    }
    return _searchView;
}


@end
