//
//  ZXSDNecessaryCertFourthStepController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/18.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDNecessaryCertFourthStepController.h"
#import "UITextField+help.h"

#import "ZXSDNecessaryCertResultController.h"
#import "ZXSDCertificationCenterController.h"
#import "ZXSDPersonalInfoCell.h"
#import "ZXSDRadioPickController.h"
#import "ZXSDMultipleChoicePickController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "BRDatePickerView.h"
#import "ZXSDVerifyProgressCell.h"
#import "ZXSDVerifyManager.h"
#import "ZXSDCompanySearchResultView.h"
#import "ZXSDVerifyUserinfoController.h"
#import "EPNetworkManager+Mine.h"
#import "ZXSDCityManager.h"

#import "ZXCompanySearchViewController.h"


static const NSString *QUERY_COMPANY_INFO_URL = @"/rest/userInfo/job";

@interface ZXSDNecessaryCertFourthStepController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    TPKeyboardAvoidingTableView *_infoTableView;
    
    NSArray *_titleArray;
    NSArray *_paydayArray;
    NSArray *_jobArray;
}

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) TPKeyboardAvoidingTableView *infoTableView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *payday;
@property (nonatomic, copy) NSString *employmentDate;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, copy) NSString *companyProvince;
@property (nonatomic, copy) NSString *companyCity;
@property (nonatomic, copy) NSString *companyAdress;

@property (nonatomic, strong) ZXSDCompanySearchResultView *searchView;
//@property (nonatomic, strong) NSArray<ZXSDCompanyModel*> *companys;

// 匹配到内部合作的公司
@property (nonatomic, assign) BOOL isComfirm;
@property (nonatomic, strong) ZXSDCompanyModel *pickedCompany;

@property (nonatomic, retain) NSArray *jobList;



@end

@implementation ZXSDNecessaryCertFourthStepController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份认证";
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
    [self refreshDataConfigure];
    [self requestJobMapWithLoading:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)backButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_REFRESH_HOME object:nil];

    if (self.backViewController) {
        [super backButtonClicked:sender];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)prepareDataConfigure {
    _titleArray = @[@"公司名称",@"职业", @"薪资(元)", @"发薪日", @"入职时间", @"公司电话", @"公司所在城市",@"公司详细地址"];
    _paydayArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    _jobArray = @[@"程序员", @"设计师", @"教师", @"服务员", @"司机", @"厨师", @"理发师", @"教练", @"文员", @"销售经理", @"客服专员", @"采购员", @"营业员", @"网店店长", @"维修工", @"快递员", @"律师", @"翻译", @"编辑", @"会计", @"医生", @"工程师", @"其他"];
    
    self.companyName = @"";
    self.job = @"";
    self.salary = @"";
    self.payday = @"";
    self.employmentDate = @"";
    self.companyPhone = @"";
    self.companyProvince = @"";
    self.companyCity = @"";
    self.companyAdress = @"";
    
}

- (void)refreshDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    [EPNetworkManager getOptionalConfigs:nil completion:^(ZXSDOptionalConfigs * _Nonnull model, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if (model.salaryDay.count > 0) {
            self->_paydayArray = model.salaryDay;
        }
        
        if (model.job.count > 0) {
            self->_jobArray = model.job;
        }
    }];
}

- (void)addUserInterfaceConfigure {

    /*
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 110)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH() - 40, 2)];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [headerView addSubview:lineView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"填写雇主信息";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [headerView addSubview:titleLabel];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH() - 70, 20, 50, 40)];
    stepLabel.text = @"4/4";
    stepLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    stepLabel.textAlignment = NSTextAlignmentRight;
    stepLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:stepLabel.text];
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:28.f],NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x00B050)} range:NSMakeRange(0, 1)];
    stepLabel.attributedText = attributedString;
    [headerView addSubview:stepLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH() - 40, 40)];
    contentLabel.text = @"填写您真实的雇主信息，可提升预支额度的通过率";
    contentLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    if (iPhone4() || iPhone5()) {
        contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:24.0];
    }
    [headerView addSubview:contentLabel];
    
    _infoTableView.tableHeaderView = headerView;
     

    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat safaAreaBottom = iPhoneXSeries() ? 34 : 0;
    confirmButton.frame = CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 20 - 44 - safaAreaBottom, SCREEN_WIDTH() - 40, 44);
    confirmButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.cornerRadius = 22.0;
    confirmButton.layer.masksToBounds = YES;
    [self.view addSubview:confirmButton];
    */
    
    UIView *bottomView = [self buildFooterView];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [_infoTableView registerClass:[ZXSDVerifyProgressCell class] forCellReuseIdentifier:[ZXSDVerifyProgressCell identifier]];
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (UIView *)buildFooterView
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.right.equalTo(footerView).offset(-20);
        make.top.equalTo(footerView).offset(10);
        make.height.mas_equalTo(44);
    }];
    self.footerView = footerView;
    
    return footerView;
}

#pragma mark - action methods -

- (void)confirmButtonClicked {
    if ([self validateAllTextFieldsAreAllowed]) {
        [self showLoadingProgressHUDWithText:@"提交中..."];
        AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
        
        
//        NSDictionary *parameters = @{
//        @"workUnit":self.companyName,
//        @"job":self.job,
//        @"sixAveSalary":self.salary,
//        @"salaryDay":self.payday,
//        @"hiredate":self.employmentDate,
//        @"workProvince":self.companyProvince,
//        @"workCity":self.companyCity,
//        @"workAddress":self.companyAdress
//        };
        
        NSArray *jobComps = [self.job componentsSeparatedByString:@"-"];

        NSMutableDictionary *tmps = @{}.mutableCopy;
        [tmps setSafeValue:self.companyName forKey:@"workUnit"];
        [tmps setSafeValue:self.salary forKey:@"sixAveSalary"];
        [tmps setSafeValue:self.payday forKey:@"salaryDay"];
        [tmps setSafeValue:self.employmentDate forKey:@"hiredate"];
        [tmps setSafeValue:self.companyProvince forKey:@"workProvince"];
        [tmps setSafeValue:self.companyCity forKey:@"workCity"];
        [tmps setSafeValue:self.companyAdress forKey:@"workAddress"];
        [tmps setSafeValue:self.companyPhone forKey:@"workPhone"];

        if (IsValidArray(jobComps)) {
            [tmps setSafeValue:jobComps.firstObject forKey:@"jobCategory"];
            [tmps setSafeValue:jobComps.lastObject forKey:@"job"];
        }
        
//        if (self.companyPhone.length > 0) {
//        parameters = @{
//            @"workUnit":self.companyName,
//            @"job":self.job,
//            @"sixAveSalary":self.salary,
//            @"salaryDay":self.payday,
//            @"hiredate":self.employmentDate,
//            @"workProvince":self.companyProvince,
//            @"workCity":self.companyCity,
//            @"workAddress":self.companyAdress,
//            @"workPhone":self.companyPhone
//        };
//        }
        [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_COMPANY_INFO_URL] parameters:tmps.copy progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ZGLog(@"提交用户公司信息接口成功返回数据---%@",responseObject);
            [self dismissLoadingProgressHUD];
            
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                self.isComfirm = [[responseObject objectForKey:@"isComfirm"] boolValue];
                self.pickedCompany = [ZXSDCompanyModel modelWithJSON:[responseObject objectForKey:@"company"]];
                
                
                // 匹配到合作公司
                if (self.isComfirm && self.pickedCompany) {
                    ZXSDVerifyUserinfoController *vc = [ZXSDVerifyUserinfoController new];
                    vc.company = self.pickedCompany;
                    [ZXSDCurrentUser currentUser].company = self.pickedCompany;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                
                if ([[responseObject objectForKey:@"isSmilePlus"] integerValue] == 1) {
                    [ZXSDCurrentUser currentUser].smilePlus = YES;
                    // 是否审核通过
                    BOOL isApproved = [[responseObject objectForKey:@"isApproved"] boolValue];
                    if (isApproved) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        [self jumpToNecessaryCertResultController];
                    }
                    
                } else {
                    [self jumpToCertificationCenterController];
                }
            }
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self dismissLoadingProgressHUD];
            [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"提交失败"];
        }];
    }
}

//成功且是Smile+用户前往结果页
- (void)jumpToNecessaryCertResultController {
    ZXSDNecessaryCertResultController *viewController = [ZXSDNecessaryCertResultController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

//失败或者不是Smile+用户前往任务中心
- (void)jumpToCertificationCenterController {
//    ZXSDCertificationCenterController *viewController = [ZXSDCertificationCenterController new];
//    [self.navigationController pushViewController:viewController animated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
    dispatch_queue_after_S(0.4, ^{
        [URLRouter routeToTaskCenterTab];
    });
}

- (BOOL)validateAllTextFieldsAreAllowed  {
    [self.view endEditing:YES];
    
    if (self.companyName.length == 0) {
        [self showToastWithText:@"请输入您的单位名称"];
        return NO;
    }
    
    if (self.companyName.length < 4) {
        [self showToastWithText:@"公司名称不能少于4个字"];
        return NO;
    }
    
    if (self.job.length == 0) {
        [self showToastWithText:@"请选择您的职业"];
        return NO;
    }
    if (self.salary.length == 0) {
        [self showToastWithText:@"请输入您近6个月的平均薪资"];
        return NO;
    }
    if (self.payday.length == 0) {
        [self showToastWithText:@"请选择您每月发薪资的时间"];
        return NO;
    }
    if (self.employmentDate.length == 0) {
        [self showToastWithText:@"请选择您的入职时间"];
        return NO;
    }
    if (self.companyPhone.length > 0) {
        if (![self.companyPhone validateStringIsIntegerFormate] || self.companyPhone.length > 12) {
            [self showToastWithText:@"请输入正确的单位座机号码"];
            return NO;
        }
    }
    
    if (self.companyProvince.length == 0 || self.companyCity.length == 0) {
        [self showToastWithText:@"请选择您公司所在城市"];
        return NO;
    }
    
    if (self.companyAdress.length == 0) {
        [self showToastWithText:@"请输入您公司详细地址"];
        return NO;
    }
    
    return YES;
}

#pragma mark - data handle -

- (void)requestJobMapWithLoading:(BOOL)show{
    if (show) {
        LoadingManagerShow();
    }
    [[EPNetworkManager defaultManager] getAPI:@"rest/anon/jobMap" parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        if (show) {
            LoadingManagerHidden();
        }
        
        if (error) {
            return;
        }
        
        self.jobList = [ZXSDCityModel jobArrayWithWithData:response.originalContent];
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return _titleArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZXSDVerifyProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDVerifyProgressCell identifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ZXSDVerifyActionModel *model = [ZXSDVerifyManager employerBindingAction];
        [cell hideBottomLine];
        [cell setRenderData:model];
        return cell;
    } else {
        static NSString *cellName = @"companyInformationCell";
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
                cell.textField.placeholder = @"请输入您的单位名称";
            }
                break;
            case 1:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择您的职业";
            }
                break;
            case 2:
            {
                cell.canEdit = YES;
                cell.textField.placeholder = @"请输入您每月工资到手金额";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            case 3:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择您每月发薪资的时间";
            }
                break;
            case 4:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择您的入职时间";
            }
                break;
            case 5:
            {
                cell.canEdit = YES;
                cell.textField.placeholder = @"请输入您单位座机(选填)";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            case 6:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择您公司所在城市";
            }
                break;
            case 7:
            {
                cell.canEdit = YES;
                cell.textField.placeholder = @"请输入您公司详细地址";
                cell.textField.keyboardType = UIKeyboardTypeDefault;
            }
                break;
                
            default:
                break;
        }
        
        [cell showBottomLine];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    return 60.f;
}

- (void)gotoCompanyChoosePageWithTextField:(UITextField*)textField{
    ZXCompanySearchViewController *searchVC = [[ZXCompanySearchViewController alloc] init];
    
    @weakify(self);
    searchVC.completionBlock = ^(NSString*  _Nonnull data) {
        @strongify(self);
        self.companyName = data;
        textField.text = self.companyName;
    };
    
    [self.navigationController pushViewController:searchVC animated:YES];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1 || textField.tag == 3 || textField.tag == 4 || textField.tag == 6) {
        [self.view endEditing:YES];
        [self handlerTextFieldSelect:textField];
        return NO;
    } else {
        [textField addTarget:self action:@selector(handlerTextFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];

        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag != 0) {
        return;
    }
//    if (self.companys.count == 0 || textField.text.length == 0) {
//        return;
//    }
    
//    [self showSearchView:YES keyword:textField.text textField:textField];
    
    [self gotoCompanyChoosePageWithTextField:textField];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag != 0) {
        return;
    }
    self.searchView.hidden = YES;
    self.companyName = textField.text;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 0) { // 公司名称
        if (toBeString.length > 50) {
            [self showToastWithText:@"公司名称不能超过50个字"];
            return NO;
        }
//        [self showSearchView:YES keyword:toBeString textField:textField];
        return YES;
    }
    else if(textField.tag == 2){
        return [textField filter:kPureNumFilter toString:string range:range maxLenght:5];
    }
    else if(textField.tag == 5){
        return [textField filter:kPureNumFilter toString:string range:range maxLenght:11];
    }

    

    return YES;
}


#pragma mark - 处理编辑事件
- (void)handlerTextFieldEndEdit:(UITextField *)textField {
    ZGLog(@"结束编辑:%@", textField.text);
    switch (textField.tag) {
        case 0:
        {
            self.companyName = textField.text;
        }
            break;
        case 2:
        {
            self.salary = textField.text;
        }
            break;
        case 5:
        {
            self.companyPhone = textField.text;
        }
            break;
        case 7:
        {
            self.companyAdress = textField.text;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 处理点击事件
- (void)handlerTextFieldSelect:(UITextField *)textField  {
    switch (textField.tag) {
        case 1:
        {
            if (!IsValidArray(self.jobList)) {
                [self requestJobMapWithLoading:YES];
                return;
            }
            ZXSDMultipleChoicePickController *viewController = [[ZXSDMultipleChoicePickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickTitle = @"职业";
            viewController.provinceArray = self.jobList;
            viewController.pickAchieveString = ^(NSString * _Nonnull province, NSString * _Nonnull city) {
                textField.text = [NSString stringWithFormat:@"%@-%@",province,city];
                self.job = textField.text;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
        }
            break;
        case 3:
        {
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _paydayArray;
            viewController.pickTitle = @"发薪日";
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.payday = returnString;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
            
        }
            break;
        case 4:
        {
            BRDatePickerView *datePickerView = [[BRDatePickerView alloc] init];
            datePickerView.pickerStyle.maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            datePickerView.pickerStyle.titleBarHeight = 50.0;
            datePickerView.pickerStyle.topCornerRadius = 16.0;
            datePickerView.pickerStyle.cancelTextColor = UICOLOR_FROM_HEX(0x333333);
            datePickerView.pickerStyle.titleTextColor = UICOLOR_FROM_HEX(0x181C1F);
            datePickerView.pickerStyle.titleTextFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
            datePickerView.pickerStyle.doneTextColor = UICOLOR_FROM_HEX(0x00B050);
            datePickerView.pickerStyle.hiddenTitleLine = YES;
            datePickerView.pickerMode = BRDatePickerModeYMD;
            datePickerView.title = @"入职时间";
            datePickerView.minDate = [NSDate br_setYear:1990 month:1 day:1];
            datePickerView.maxDate = [NSDate date];
            datePickerView.isAutoSelect = NO;
            datePickerView.showToday = YES;
            datePickerView.showUnitType = BRShowUnitTypeNone;
            datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
                selectValue = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                ZGLog(@"selectValue=%@", selectValue);
                textField.text = selectValue;
                self.employmentDate = selectValue;
            };
            
            [datePickerView show];
        }
            break;
        case 6:
        {
            ZXSDMultipleChoicePickController *viewController = [[ZXSDMultipleChoicePickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickTitle = @"公司所在城市";
            viewController.pickAchieveString = ^(NSString * _Nonnull province, NSString * _Nonnull city) {
                textField.text = [NSString stringWithFormat:@"%@-%@",province,city];
                self.companyProvince = province;
                self.companyCity = city;
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

#pragma mark - 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//- (void)showSearchView:(BOOL)show
//               keyword:(NSString *)keyword
//             textField:(UITextField *)textField
//{
//    if (!show || keyword.length == 0) {
//        _searchView.hidden = YES;
//        return;
//    }
//
//    if (!self.searchView.superview) {
//        [self.view addSubview:self.searchView];
//        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_infoTableView).with.offset(150);
//            make.left.right.equalTo(self.view);
//            make.height.mas_equalTo(self.companys.count * 45);
//        }];
//
//        @weakify(self);
//        self.searchView.didSelectModel = ^(ZXSDCompanyModel * _Nonnull model) {
//
//            @strongify(self);
//            self.companyName = model.companyName;
//            textField.text = self.companyName;
//            self.searchView.hidden = YES;
//        };
//    }
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"companyName CONTAINS %@",keyword];
//
//    NSArray *result = [self.companys filteredArrayUsingPredicate:predicate].mutableCopy;
//
//    if (result.count == 0) {
//        self.searchView.hidden = YES;
//        return;
//    }
//
//    NSInteger max = MIN(result.count, 4);
//    [self.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(max * 45);
//    }];
//
//    self.searchView.hidden = NO;
//    [self.searchView freshResultWithResults:result];
//}

#pragma mark - Getter

- (UIButton *)nextButton
{
    if (!_nextButton) {
           _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
           [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [_nextButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        
           [_nextButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
           
           [_nextButton setTitle:@"确定" forState:UIControlStateNormal];
           _nextButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
           _nextButton.layer.cornerRadius = 22.0;
           _nextButton.layer.masksToBounds = YES;
       }
       return _nextButton;
}

- (TPKeyboardAvoidingTableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [TPKeyboardAvoidingTableView new];
        _infoTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _infoTableView.backgroundColor = [UIColor whiteColor];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.showsVerticalScrollIndicator = NO;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTableView.estimatedRowHeight = 90;
        _infoTableView.tableFooterView = [UIView new];
    }
    return _infoTableView;
    
}

- (ZXSDCompanySearchResultView *)searchView
{
    if (!_searchView) {
        _searchView = [ZXSDCompanySearchResultView new];
    }
    return _searchView;
}

@end
