//
//  ZXSDQueryCompanyInfoController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDQueryCompanyInfoController.h"

#import "UITextField+help.h"

#import "ZXSDPersonalInfoCell.h"
#import "ZXSDRadioPickController.h"
#import "ZXSDMultipleChoicePickController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "BRDatePickerView.h"
#import "ZXSDCompanySearchResultView.h"
#import "ZXSDVerifyUserinfoController.h"
#import "ZXSDNecessaryCertResultController.h"
#import "EPNetworkManager+Mine.h"
#import "ZXSDCityModel.h"

#import "ZXCompanySearchViewController.h"


static const NSString *QUERY_COMPANY_INFO_URL = @"/rest/userInfo/job";

@interface ZXSDQueryCompanyInfoController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    TPKeyboardAvoidingTableView *_infoTableView;
    UIButton *_modifyButton;
    
    NSArray *_titleArray;
    NSArray *_paydayArray;
    NSArray *_jobArray;
}

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *payday;
@property (nonatomic, copy) NSString *employmentDate;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, copy) NSString *companyProvince;
@property (nonatomic, copy) NSString *companyCity;
@property (nonatomic, copy) NSString *companyAdress;

@property (nonatomic, copy) NSString *companyNameModify;
@property (nonatomic, copy) NSString *jobModify;
@property (nonatomic, copy) NSString *salaryModify;
@property (nonatomic, copy) NSString *paydayModify;
@property (nonatomic, copy) NSString *employmentDateModify;
@property (nonatomic, copy) NSString *companyPhoneModify;
@property (nonatomic, copy) NSString *companyProvinceModify;
@property (nonatomic, copy) NSString *companyCityModify;
@property (nonatomic, copy) NSString *companyAdressModify;

// 匹配到内部合作的公司
@property (nonatomic, assign) BOOL isComfirm;
@property (nonatomic, strong) ZXSDCompanyModel *pickedCompany;

@property (nonatomic, strong) ZXSDCompanySearchResultView *searchView;
@property (nonatomic, strong) NSArray<ZXSDCompanyModel*> *companys;

// 雇主信息审核中
@property (nonatomic, assign) BOOL isApproving;

@property (nonatomic, strong) NSMutableArray<NSString*> *validValues;
@property (nonatomic, retain) NSArray *jobList;

@end

@implementation ZXSDQueryCompanyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"雇主信息";
    
    self.isApproving = [[ZXSDCurrentUser currentUser].smileStatus isEqualToString:@"Submit"];
    // 禁止编辑
    BOOL enableEdit = [ZXSDCurrentUser currentUser].canEditJobInfo;
    if (self.isApproving) {
        enableEdit = NO;
    }
    
    [self fetchInnerCompanyList];
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
    [self requestJobMapWithLoading:NO];
    
    if (enableEdit) {
        [self prepareMoreDataConfigure];
    } else {
        self.view.userInteractionEnabled = NO;
    }
    
    _modifyButton.backgroundColor = enableEdit ? kThemeColorMain: UICOLOR_FROM_HEX(0xF0F0F0);
    [_modifyButton setTitleColor:enableEdit ?UICOLOR_FROM_HEX(0xFFFFFF) : UICOLOR_FROM_HEX(0xCCCCCC) forState:(UIControlStateNormal)];
    
    if (self.isApproving) {
        [_modifyButton setTitle:@"雇主审核中" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TrackEvent(kMine_employer_msg);
    
    [self refreshDataConfigure];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
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
    
    self.companyNameModify = @"";
    self.jobModify = @"";
    self.salaryModify = @"";
    self.paydayModify = @"";
    self.employmentDateModify = @"";
    self.companyPhoneModify = @"";
    self.companyProvinceModify = @"";
    self.companyCityModify = @"";
    self.companyAdressModify = @"";
    
}

- (void)refreshDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_COMPANY_INFO_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取用户公司信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.companyName = [[responseObject objectForKey:@"workUnit"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"workUnit"];
            
            NSString *job = [(NSDictionary*)responseObject stringObjectForKey:@"job"];
            NSString *jobCate = [(NSDictionary*)responseObject stringObjectForKey:@"jobCategory"];
            self.jobModify = self.job = [NSString stringWithFormat:@"%@-%@",GetStrDefault(jobCate, @""),GetStrDefault(job, @"")];
            
            
            self.salaryModify = self.salary = [[responseObject objectForKey:@"sixAveSalary"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"sixAveSalary"];
            self.paydayModify = self.payday = [[responseObject objectForKey:@"salaryDay"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"salaryDay"];
            self.employmentDateModify = self.employmentDate = [[responseObject objectForKey:@"hiredate"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"hiredate"];
            self.companyPhoneModify = self.companyPhone = [[responseObject objectForKey:@"workPhone"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"workPhone"];
            self.companyProvinceModify = self.companyProvince = [[responseObject objectForKey:@"workProvince"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"workProvince"];
            self.companyCityModify = self.companyCity = [[responseObject objectForKey:@"workCity"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"workCity"];
            self.companyAdressModify =self.companyAdress = [[responseObject objectForKey:@"workAddress"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"workAddress"];
            
        }

        
        if (self.isApproving) {
            [self filterCompanyInfos];
        } else {
            [self->_infoTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)filterCompanyInfos
{
    NSMutableArray *rows = [NSMutableArray new];
    self.validValues = [NSMutableArray arrayWithCapacity:_titleArray.count];
    
    if (CHECK_VALID_STRING(self.companyName)) {
        [rows addObject:@"公司名称"];
        [self.validValues addObject:self.companyName];
    }
    if (CHECK_VALID_STRING(self.job)) {
        [rows addObject:@"职业"];
        [self.validValues addObject:self.job];
    }
    if (CHECK_VALID_STRING(self.salary)) {
        [rows addObject:@"薪资(元)"];
        [self.validValues addObject:self.salary];
    }
    if (CHECK_VALID_STRING(self.payday)) {
        [rows addObject:@"发薪日"];
        [self.validValues addObject:self.payday];
    }
    if (CHECK_VALID_STRING(self.employmentDate)) {
        [rows addObject:@"入职时间"];
        [self.validValues addObject:self.employmentDate];
    }
    if (CHECK_VALID_STRING(self.companyPhone)) {
        [rows addObject:@"公司电话"];
        [self.validValues addObject:self.companyPhone];
    }
    if (CHECK_VALID_STRING(self.companyProvince) && CHECK_VALID_STRING(self.companyCity)) {
        [rows addObject:@"公司所在城市"];
        [self.validValues addObject:[NSString stringWithFormat:@"%@-%@",self.companyProvince,self.companyCity]];
    }
    if (CHECK_VALID_STRING(self.companyAdress)) {
        [rows addObject:@"公司详细地址"];
        [self.validValues addObject:self.companyAdress];
    }
    
    
    _titleArray = [NSArray arrayWithArray:rows];
    [self->_infoTableView reloadData];
}

- (void)prepareMoreDataConfigure
{
    [EPNetworkManager getOptionalConfigs:nil completion:^(ZXSDOptionalConfigs * _Nonnull model, NSError * _Nonnull error) {
        if (model.salaryDay.count > 0) {
            self->_paydayArray = model.salaryDay;
        }
        
        if (model.job.count > 0) {
            self->_jobArray = model.job;
        }
    }];
}

- (void)addUserInterfaceConfigure {
    _infoTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 84) style:UITableViewStylePlain];
    _infoTableView.backgroundColor = [UIColor whiteColor];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _infoTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    _infoTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self.view addSubview:_infoTableView];
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80)];
//    headerView.backgroundColor = [UIColor whiteColor];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
//    titleLabel.text = @"雇主信息";
//    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
//    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
//    [headerView addSubview:titleLabel];
//
//    _infoTableView.tableHeaderView = headerView;
    _infoTableView.tableFooterView = [UIView new];
    
    UIButton *modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat safaAreaBottom = iPhoneXSeries() ? 34 : 0;
    modifyButton.frame = CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 20 - 44 - safaAreaBottom, SCREEN_WIDTH() - 40, 44);
    modifyButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [modifyButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    modifyButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [modifyButton addTarget:self action:@selector(modifyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    modifyButton.layer.cornerRadius = 22.0;
    modifyButton.layer.masksToBounds = YES;
    [self.view addSubview:modifyButton];
    _modifyButton = modifyButton;
}

#pragma mark - Action

- (void)backButtonClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)modifyButtonClicked {
    
    NSString *companyName = self.companyNameModify;
    if (!IsValidString(companyName)) {
        companyName = self.companyName;
    }
    
    if ([self validateAllTextFieldsAreAllowed]) {
        if ([self validateAllTextFieldsIsModify]) {
            [self showLoadingProgressHUDWithText:@"提交中..."];
            AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];

            NSArray *jobComps = [self.jobModify componentsSeparatedByString:@"-"];

            NSMutableDictionary *tmps = @{}.mutableCopy;
            [tmps setSafeValue:companyName forKey:@"workUnit"];
            [tmps setSafeValue:self.salaryModify forKey:@"sixAveSalary"];
            [tmps setSafeValue:self.paydayModify forKey:@"salaryDay"];
            [tmps setSafeValue:self.employmentDateModify forKey:@"hiredate"];
            [tmps setSafeValue:self.companyProvinceModify forKey:@"workProvince"];
            [tmps setSafeValue:self.companyCityModify forKey:@"workCity"];
            [tmps setSafeValue:self.companyAdressModify forKey:@"workAddress"];
            [tmps setSafeValue:self.companyPhoneModify forKey:@"workPhone"];

            if (IsValidArray(jobComps)) {
                if (jobComps.count > 1) {
                    [tmps setSafeValue:jobComps.firstObject forKey:@"jobCategory"];
                }
                [tmps setSafeValue:jobComps.lastObject forKey:@"job"];
            }
            
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
                    
                    // 合作企业用户
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
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self dismissLoadingProgressHUD];
                [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"提交失败"];
            }];
        } else {
            
            [self showToastWithText:@"您还没有修改任何信息哦"];
        }
    }
}

//成功且是Smile+用户前往结果页
- (void)jumpToNecessaryCertResultController {
    ZXSDNecessaryCertResultController *viewController = [ZXSDNecessaryCertResultController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handlerTextFieldSelect:(UITextField *)textField  {
    switch (textField.tag) {
        case 1:
        /*{
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _jobArray;
            viewController.pickTitle = @"职业";
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.jobModify = returnString;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
        }*/
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
                self.jobModify = textField.text;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
        }
            break;
        case 3: //发薪日处理
        {
            // 公司名字修改后才可以修改发薪日
            if ([self.companyName isEqualToString:self.companyNameModify]) {
                return;
            }
            // 若选择的公司（模糊搜索列表选中的）为单一发薪日,则不可自选
            
            __block ZXSDCompanyModel *target = nil;
            [self.companys enumerateObjectsUsingBlock:^(ZXSDCompanyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.companyName isEqualToString:self.companyNameModify]) {
                    target = obj;
                    *stop = YES;
                }
            }];
            
            // 当前选择的公司有固定发薪日, 自动填充发薪日&&无法修改
            if (target && target.salaryDay.integerValue > 0) {
                textField.text = target.salaryDay;
                self.paydayModify = target.salaryDay;
                return;
            }
            
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _paydayArray;
            viewController.pickTitle = @"发薪日";
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.paydayModify = returnString;
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
                self.employmentDateModify = selectValue;
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
                self.companyProvinceModify = province;
                self.companyCityModify = city;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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

- (void)fetchInnerCompanyList{
    ZGLog(@"获取内部公司信息接口成功返回数据");

    [[EPNetworkManager defaultManager] getAPI:kPath_queryInnerCompany parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        self.companys = [NSArray yy_modelArrayWithClass:[ZXSDCompanyModel class] json:response.originalContent];
        
    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"companyInformationCell";
    ZXSDPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ZXSDPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    
    if (self.isApproving) {
        cell.textField.text = [self.validValues objectAtIndex:indexPath.row];
    } else {
        switch (indexPath.row) {
            case 0:
            {
                cell.canEdit = YES;
                cell.textField.placeholder = @"请输入您的单位名称";
                NSString *companyName = self.companyName;
                if (IsValidString(self.companyNameModify)) {
                    companyName = self.companyNameModify;
                }
                cell.textField.text =  companyName;
            }
                break;
            case 1:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择您的职业";
                cell.textField.text = self.job;
            }
                break;
            case 2:
            {
                cell.canEdit = YES;
                cell.textField.placeholder = @"请输入您每月工资到手金额";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text = self.salary;
            }
                break;
            case 3:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择您每月发薪资的时间";
                cell.textField.text = self.payday;
            }
                break;
            case 4:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择您的入职时间";
                cell.textField.text = self.employmentDate;
            }
                break;
            case 5:
            {
                cell.canEdit = YES;
                cell.textField.placeholder = @"请输入您单位座机(选填)";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text = self.companyPhone;
            }
                break;
            case 6:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择您公司所在城市";
                if (self.companyProvince.length > 0 && self.companyCity.length > 0) {
                    cell.textField.text = [NSString stringWithFormat:@"%@-%@",self.companyProvince,self.companyCity];
                }
            }
                break;
            case 7:
            {
                cell.canEdit = YES;
                cell.textField.placeholder = @"请输入您公司详细地址";
                cell.textField.text = self.companyAdress;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
            }
                break;
                
            default:
                break;
        }
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
    if (self.companys.count == 0 || textField.text.length == 0) {
        return;
    }
    
//    [self showSearchView:YES keyword:textField.text textField:textField];
    
    ZXCompanySearchViewController *searchVC = [[ZXCompanySearchViewController alloc] init];
    
    @weakify(self);
    searchVC.completionBlock = ^(NSString*  _Nonnull data) {
        @strongify(self);
        self.companyNameModify = data;
        textField.text = self.companyNameModify;
    };
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag != 0) {
        return;
    }
    self.searchView.hidden = YES;
    self.companyNameModify = textField.text;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 0) { // 公司名称
        if (toBeString.length > 50) {
            [self showToastWithText:@"公司名称不能超过50个字"];
            return NO;
        }
        [self showSearchView:YES keyword:toBeString textField:textField];
        return YES;
    }
    else if(textField.tag == 5){
        return [textField filter:kPureNumFilter toString:string range:range maxLenght:11];
    }
    

    return YES;
}


#pragma mark - Private
- (void)handlerTextFieldEndEdit:(UITextField *)textField {
    ZGLog(@"结束编辑:%@", textField.text);
    switch (textField.tag) {
        case 0:
        {
            self.companyNameModify = textField.text;
        }
            break;
        case 2:
        {
            self.salaryModify = textField.text;
        }
            break;
        case 5:
        {
            self.companyPhoneModify = textField.text;
        }
            break;
        case 7:
        {
            self.companyAdressModify = textField.text;
        }
            break;
            
        default:
            break;
    }
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
            self.companyNameModify = model.companyName;
            textField.text = self.companyNameModify;
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

- (BOOL)validateAllTextFieldsAreAllowed  {
    [self.view endEditing:YES];
    
    NSString *companyName = self.companyNameModify;
    if (!IsValidString(companyName)) {
        companyName = self.companyName;
    }

    
    if (!IsValidString(companyName)) {
        [self showToastWithText:@"请输入您的单位名称"];
        return NO;
    }
    
    if (companyName.length < 4) {
        [self showToastWithText:@"公司名称不能少于4个字"];
        return NO;
    }
    
    if (self.jobModify.length == 0) {
        [self showToastWithText:@"请选择您的职业"];
        return NO;
    }
    if (self.salaryModify.length == 0) {
        [self showToastWithText:@"请输入您近6个月的平均薪资"];
        return NO;
    }
    if (self.paydayModify.length == 0) {
        [self showToastWithText:@"请选择您每月发薪资的时间"];
        return NO;
    }
    if (self.employmentDateModify.length == 0) {
        [self showToastWithText:@"请选择您的入职时间"];
        return NO;
    }
    if (self.companyPhoneModify.length > 0) {
        if (![self.companyPhoneModify validateStringIsIntegerFormate] || self.companyPhoneModify.length > 12) {
            [self showToastWithText:@"请输入正确的单位座机号码"];
            return NO;
        }
        
        if ([[ZXSDCurrentUser currentUser].phone isEqualToString:self.companyPhoneModify]) {
            [EasyTextView showText:@"不能填写本人手机号"];
            return NO;
        }
        
    }
    
    if (self.companyProvinceModify.length == 0 || self.companyCityModify.length == 0) {
        [self showToastWithText:@"请选择您公司所在城市"];
        return NO;
    }
    
    if (self.companyAdressModify.length == 0) {
        [self showToastWithText:@"请输入您公司详细地址"];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateAllTextFieldsIsModify {
    if (self.companyPhone.length > 0) {
        if (self.companyPhoneModify.length > 0) {
            if ([self.companyName isEqualToString:self.companyNameModify] && [self.job isEqualToString:self.jobModify] && [self.salary isEqualToString:self.salaryModify] && [self.payday isEqualToString:self.paydayModify] && [self.employmentDate isEqualToString:self.employmentDateModify] && [self.companyPhone isEqualToString:self.companyPhoneModify] && [self.companyProvince isEqualToString:self.companyProvinceModify] && [self.companyCity isEqualToString:self.companyCityModify] && [self.companyAdress isEqualToString:self.companyAdressModify]) {
                return NO;
            } else {
                return YES;
            }
        } else {
            return YES;
        }
    } else {
        if (self.companyPhoneModify.length > 0) {
            return YES;
        } else {
            if ([self.companyName isEqualToString:self.companyNameModify] && [self.job isEqualToString:self.jobModify] && [self.salary isEqualToString:self.salaryModify] && [self.payday isEqualToString:self.paydayModify] && [self.employmentDate isEqualToString:self.employmentDateModify] && [self.companyProvince isEqualToString:self.companyProvinceModify] && [self.companyCity isEqualToString:self.companyCityModify] && [self.companyAdress isEqualToString:self.companyAdressModify]) {
                return NO;
            } else {
                return YES;
            }
        }
    }
}

#pragma mark - Getter
- (ZXSDCompanySearchResultView *)searchView
{
    if (!_searchView) {
        _searchView = [ZXSDCompanySearchResultView new];
    }
    return _searchView;
}

@end
