//
//  ZXSDImprovePersonalInfoController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/18.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDImprovePersonalInfoController.h"
#import "ZXSDPersonalInfoCell.h"
#import "ZXSDRadioPickController.h"
#import "ZXSDMultipleChoicePickController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "EPNetworkManager+Mine.h"

static const NSString *QUERY_BASIC_INFO_URL = @"/rest/userInfo/basicInfo";
static const NSInteger wechatTag = 10;

@interface ZXSDImprovePersonalInfoController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    TPKeyboardAvoidingTableView *_infoTableView;
    
    NSArray *_channelNameArray;
    NSArray *_titleArray;
    NSArray *_educationPickerArray;
    NSArray *_marriagePickerArray;
    NSArray *_kidsPickerArray;
    NSArray *_dwellDatePickerArray;
    
}

@property (nonatomic, copy) NSString *education;
@property (nonatomic, copy) NSString *maritalStatus;
@property (nonatomic, copy) NSString *childrenNumber;
@property (nonatomic, copy) NSString *dwellProvince;
@property (nonatomic, copy) NSString *dwellCity;
@property (nonatomic, copy) NSString *dwellDuration;
@property (nonatomic, copy) NSString *dwellAddress;
@property (nonatomic, copy) NSString *wechat;

@property (nonatomic, copy) NSString *educationModify;
@property (nonatomic, copy) NSString *maritalStatusModify;
@property (nonatomic, copy) NSString *childrenNumberModify;
@property (nonatomic, copy) NSString *dwellProvinceModify;
@property (nonatomic, copy) NSString *dwellCityModify;
@property (nonatomic, copy) NSString *dwellDurationModify;
@property (nonatomic, copy) NSString *dwellAddressModify;
@property (nonatomic, copy) NSString *wechatModify;

@end

@implementation ZXSDImprovePersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善个人信息";
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
    [self prepareMoreDataConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDataConfigure];
}

- (void)prepareDataConfigure {
    _channelNameArray = @[@"必填信息",@"其它信息"];
    _titleArray = @[@"学历",@"婚姻",@"儿女数量",@"常住城市",@"常住地址",@"常住时常"];
    _educationPickerArray = @[@"小学", @"初中", @"高中/职高/技校", @"大专", @"本科", @"硕士", @"博士"];
    _marriagePickerArray = @[@"未婚", @"已婚", @"离异", @"丧偶"];
    _kidsPickerArray = @[@"0",@"1",@"2",@"3"];
    _dwellDatePickerArray = @[@"三个月",@"六个月",@"一年",@"两年",@"两年以上"];
    
    self.education = @"";
    self.maritalStatus = @"";
    self.childrenNumber = @"";
    self.dwellProvince = @"";
    self.dwellCity = @"";
    self.dwellAddress = @"";
    self.dwellDuration = @"";
    self.wechat = @"";
    
    self.educationModify = @"";
    self.maritalStatusModify = @"";
    self.childrenNumberModify = @"";
    self.dwellProvinceModify = @"";
    self.dwellCityModify = @"";
    self.dwellAddressModify = @"";
    self.dwellDurationModify = @"";
    self.wechatModify= @"";
}

- (void)refreshDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_BASIC_INFO_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取个人基本信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.educationModify = self.education = [[responseObject objectForKey:@"education"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"education"];
            self.maritalStatusModify = self.maritalStatus = [[responseObject objectForKey:@"maritalStatus"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"maritalStatus"];
            self.childrenNumberModify = self.childrenNumber = [[responseObject objectForKey:@"childrenNum"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"childrenNum"];
            self.dwellDurationModify = self.dwellDuration = [[responseObject objectForKey:@"dwellDuration"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"dwellDuration"];
            self.wechatModify = self.wechat = [[responseObject objectForKey:@"wechat"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"wechat"];
            self.dwellProvinceModify = self.dwellProvince = [[responseObject objectForKey:@"dwellProvince"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"dwellProvince"];
            self.dwellCityModify = self.dwellCity = [[responseObject objectForKey:@"dwellCity"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"dwellCity"];
            self.dwellAddressModify = self.dwellAddress = [[responseObject objectForKey:@"dwellAddress"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"dwellAddress"];
        }
        
        [self->_infoTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)prepareMoreDataConfigure {
    
    [EPNetworkManager getOptionalConfigs:nil completion:^(ZXSDOptionalConfigs *model, NSError *error) {
        
        if (model.dwellDuration.count > 0) {
            self->_dwellDatePickerArray = model.dwellDuration;
        }
        
        if (model.childrenNum.count > 0) {
            self->_kidsPickerArray = model.childrenNum;
        }
        
        if (model.education.count > 0) {
            self->_educationPickerArray = model.education;
        }
        
        if (model.maritalStatus.count > 0) {
            self->_marriagePickerArray = model.maritalStatus;
        }
    }];
}

- (void)addUserInterfaceConfigure {
    _infoTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 84) style:UITableViewStylePlain];
    _infoTableView.backgroundColor = [UIColor whiteColor];
    _infoTableView.scrollEnabled = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _infoTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    [self.view addSubview:_infoTableView];
    
    _infoTableView.tableFooterView = [UIView new];
    
    CGFloat safaAreaBottom = iPhoneXSeries() ? 34 : 0;
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 64 - safaAreaBottom, SCREEN_WIDTH() - 40, 44);
    submitButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [submitButton setTitle:@"确认" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.cornerRadius = 22.0;
    submitButton.layer.masksToBounds = YES;
    [self.view addSubview:submitButton];
}


- (void)submitButtonClicked {
    if ([self validateAllTextFieldsAreAllowed]) {
        if ([self validateAllTextFieldsIsModify]) {
            [self showLoadingProgressHUDWithText:@"提交中..."];
            AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
            NSDictionary *parameters = @{@"education":self.educationModify,@"maritalStatus":self.maritalStatusModify,@"childrenNum":self.childrenNumberModify,@"dwellProvince":self.dwellProvinceModify,@"dwellCity":self.dwellCityModify,@"dwellDuration":self.dwellDurationModify,@"dwellAddress":self.dwellAddressModify};
            if (self.wechatModify.length > 0) {
                parameters = @{@"education":self.educationModify,@"maritalStatus":self.maritalStatusModify,@"childrenNum":self.childrenNumberModify,@"dwellProvince":self.dwellProvinceModify,@"dwellCity":self.dwellCityModify,@"dwellDuration":self.dwellDurationModify,@"dwellAddress":self.dwellAddressModify,@"wechat":self.wechatModify};
            }
            [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_BASIC_INFO_URL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                ZGLog(@"提交完善个人信息接口成功返回数据---%@",responseObject);
                [self dismissLoadingProgressHUD];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self dismissLoadingProgressHUD];
                [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"提交失败"];
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (BOOL)validateAllTextFieldsAreAllowed  {
    [self.view endEditing:YES];
    
    if (self.educationModify.length == 0) {
        [self showToastWithText:@"请选择您的学历"];
        return NO;
    }
    if (self.maritalStatusModify.length == 0) {
        [self showToastWithText:@"请选择您的婚姻状态"];
        return NO;
    }
    if (self.childrenNumberModify.length == 0) {
        [self showToastWithText:@"请选择您的子女数量"];
        return NO;
    }
    if (self.dwellProvinceModify.length == 0 || self.dwellCityModify.length == 0) {
        [self showToastWithText:@"请选择您的常住省市"];
        return NO;
    }
    if (self.dwellAddressModify.length == 0) {
        [self showToastWithText:@"请输入您常住的详细地址"];
        return NO;
    }
    if (self.dwellDurationModify.length == 0) {
        [self showToastWithText:@"请选择您的居住时长"];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateAllTextFieldsIsModify {
    if (self.wechat.length > 0) {
        if (self.wechatModify.length > 0) {
            if ([self.education isEqualToString:self.educationModify] && [self.maritalStatus isEqualToString:self.maritalStatusModify] && [self.childrenNumber isEqualToString:self.childrenNumberModify] && [self.dwellDuration isEqualToString:self.dwellDurationModify] &&  [self.dwellProvince isEqualToString:self.dwellProvinceModify] && [self.dwellCity isEqualToString:self.dwellCityModify] && [self.dwellAddress isEqualToString:self.dwellAddressModify] && [self.wechat isEqualToString:self.wechatModify]) {
                return NO;
            } else {
                return YES;
            }
        } else {
            return YES;
        }
    } else {
        if (self.wechatModify.length > 0) {
            return YES;
        } else {
            if ([self.education isEqualToString:self.educationModify] && [self.maritalStatus isEqualToString:self.maritalStatusModify] && [self.childrenNumber isEqualToString:self.childrenNumberModify] && [self.dwellDuration isEqualToString:self.dwellDurationModify] && [self.dwellProvince isEqualToString:self.dwellProvinceModify] && [self.dwellCity isEqualToString:self.dwellCityModify] && [self.dwellAddress isEqualToString:self.dwellAddressModify]) {
                return NO;
            } else {
                return YES;
            }
        }
    }
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
    static NSString *cellName = @"companyInformationCell";
    ZXSDPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ZXSDPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    cell.textField.delegate = self;
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.textField.tag = indexPath.row;
        
        switch (indexPath.row) {
            case 0:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择学历";
                cell.textField.text = self.education;
            }
                break;
            case 1:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择婚姻状态";
                cell.textField.text = self.maritalStatus;
            }
                break;
            case 2:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择子女个数";
                cell.textField.text = self.childrenNumber;
            }
                break;
            case 3:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择您的常住省市";
                if (self.dwellProvince.length > 0 && self.dwellCity.length > 0) {
                    cell.textField.text = [NSString stringWithFormat:@"%@-%@",self.dwellProvince,self.dwellCity];
                }
            }
                break;
            case 4:
            {
                cell.canEdit = YES;
                cell.textField.placeholder = @"请输入您常住的详细地址";
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.text = self.dwellAddress;
            }
                break;
            case 5:
            {
                cell.canEdit = NO;
                cell.textField.placeholder = @"请选择居住时长";
                cell.textField.text = self.dwellDuration;
            }
                break;
                
            default:
                break;
        }
    } else {
        cell.titleLabel.text = @"个人微信号";
        cell.canEdit = YES;
        cell.textField.placeholder = @"请输入您的微信号(选填)";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.text = self.wechat;
        cell.textField.tag = wechatTag;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionBackView = [[UIView alloc] init];
    sectionBackView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    if (section == 0) {
        sectionBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 48);
        titleLabel.frame = CGRectMake(20, 20, SCREEN_WIDTH()/2, 28);
    } else {
        sectionBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 68);
        titleLabel.frame = CGRectMake(20, 40, SCREEN_WIDTH()/2, 28);
    }
    titleLabel.text = _channelNameArray[section];
    titleLabel.textColor = UICOLOR_FROM_HEX(0x3C465A);
    titleLabel.font = FONT_PINGFANG_X_Medium(16);
    
    [sectionBackView addSubview:titleLabel];
    
    return sectionBackView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 48.f;
    } else {
        return 68.f;
    }
}

#pragma mark - UITextFieldDelegate 返回键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 5) {
        [self.view endEditing:YES];
        [self handlerTextFieldSelect:textField];
        return NO;
    } else {
        [textField addTarget:self action:@selector(handlerTextFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag != wechatTag) {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 50) {
        
        [self showToastWithText:@"微信号不能超过50个字"];
        return NO;
    }

    return YES;
}

#pragma mark - 处理编辑事件
- (void)handlerTextFieldEndEdit:(UITextField *)textField {
    ZGLog(@"结束编辑:%@", textField.text);
    switch (textField.tag) {
        case 4:
        {
            self.dwellAddressModify = textField.text;
        }
            break;
        case wechatTag:
        {
            self.wechatModify = textField.text;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 处理点击事件
- (void)handlerTextFieldSelect:(UITextField *)textField  {
    switch (textField.tag) {
        case 0:
        {
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _educationPickerArray;
            viewController.pickTitle = @"学历";
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.educationModify = returnString;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
        }
            break;
        case 1:
        {
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _marriagePickerArray;
            viewController.pickTitle = @"婚姻";
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.maritalStatusModify = returnString;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
            
        }
            break;
        case 2:
        {
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _kidsPickerArray;
            viewController.pickTitle = @"儿女数量";
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.childrenNumberModify = returnString;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
        }
            break;
        case 3:
        {
            ZXSDMultipleChoicePickController *viewController = [[ZXSDMultipleChoicePickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickTitle = @"常住城市";
            viewController.pickAchieveString = ^(NSString * _Nonnull province, NSString * _Nonnull city) {
                textField.text = [NSString stringWithFormat:@"%@-%@",province,city];
                self.dwellProvinceModify = province;
                self.dwellCityModify = city;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
        }
            break;
        case 5:
        {
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _dwellDatePickerArray;
            viewController.pickTitle = @"居住时长";
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.dwellDurationModify = returnString;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
