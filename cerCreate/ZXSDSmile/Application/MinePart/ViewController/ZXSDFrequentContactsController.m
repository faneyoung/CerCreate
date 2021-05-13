//
//  ZXSDFrequentContactsController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDFrequentContactsController.h"
#import "ZXSDContactsInfoCell.h"
#import "ZXSDRadioPickController.h"
#import "TPKeyboardAvoidingTableView.h"
#import <ContactsUI/ContactsUI.h>
#import "EPNetworkManager+Mine.h"

static const NSString *QUERY_FREQUENT_CONTACTS_URL = @"/rest/userInfo/contact";

@interface ZXSDFrequentContactsController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CNContactPickerDelegate> {
    TPKeyboardAvoidingTableView *_contactTableView;
    
    NSArray *_channelSectionArray;
    NSArray *_channelContentArray;
    
    NSArray *_socialTypeArray;
    NSArray *_relativeTypeArray;
    
    NSInteger indexTag;//通讯录点击标记Tag
}

@property (nonatomic, copy) NSString *relativeName;
@property (nonatomic, copy) NSString *relativeType;
@property (nonatomic, copy) NSString *relativePhone;
@property (nonatomic, copy) NSString *socialName;
@property (nonatomic, copy) NSString *socialType;
@property (nonatomic, copy) NSString *socialPhone;

@property (nonatomic, copy) NSString *relativeNameModify;
@property (nonatomic, copy) NSString *relativeTypeModify;
@property (nonatomic, copy) NSString *relativePhoneModify;
@property (nonatomic, copy) NSString *socialNameModify;
@property (nonatomic, copy) NSString *socialTypeModify;
@property (nonatomic, copy) NSString *socialPhoneModify;

@property (nonatomic, strong) NSArray<NSString*> *filterNames;

@end

@implementation ZXSDFrequentContactsController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常用联系人";
    self.filterNames = @[@"爸爸",@"妈妈",@"老妈",@"老婆",@"老爸",
                         @"媳妇",@"老公",@"姐姐",@"老爹",@"老娘",
                         @"母亲",@"父亲",@"大哥",@"亲爱的",@"母后",
                         @"父皇",@"老妈子",@"小宝贝",@"配偶",
                         @"宝贝", @"宝宝"];
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
    [self prepareMoreDataConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDataConfigure];
}

- (void)prepareDataConfigure {
    _channelSectionArray = @[@"联系人1",@"联系人2"];
    _channelContentArray = @[@"姓名",@"与我的关系",@"联系人电话"];
    
    _relativeTypeArray = @[@"父母",@"配偶",@"兄弟姐妹"];
    _socialTypeArray = @[@"同学", @"同事", @"朋友"];
    
    self.relativeName = @"";
    self.relativeType = @"";
    self.relativePhone = @"";
    self.socialName = @"";
    self.socialType = @"";
    self.socialPhone = @"";
    
    self.relativeNameModify = @"";
    self.relativeTypeModify = @"";
    self.relativePhoneModify = @"";
    self.socialNameModify = @"";
    self.socialTypeModify = @"";
    self.socialPhoneModify = @"";
}

- (void)prepareMoreDataConfigure {
    
    [EPNetworkManager getOptionalConfigs:nil completion:^(ZXSDOptionalConfigs *model, NSError *error) {
        
        if (model.relativeType.count > 0) {
            self->_relativeTypeArray = model.relativeType;
        }
        
        if (model.socialType.count > 0) {
            self->_socialTypeArray = model.socialType;
        }
    }];
}

- (void)refreshDataConfigure {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_FREQUENT_CONTACTS_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        ZGLog(@"获取常用联系人信息接口成功返回数据---%@",((NSDictionary*)responseObject).modelToJSONString);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.relativeNameModify = self.relativeName = [[responseObject objectForKey:@"relativeName"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"relativeName"];
            self.relativeTypeModify = self.relativeType = [[responseObject objectForKey:@"relativeType"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"relativeType"];
            self.relativePhoneModify = self.relativePhone = [[responseObject objectForKey:@"relativePhone"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"relativePhone"];
            self.socialNameModify = self.socialName = [[responseObject objectForKey:@"socialName"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"socialName"];
            self.socialTypeModify = self.socialType = [[responseObject objectForKey:@"socialType"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"socialType"];
            self.socialPhoneModify = self.socialPhone = [[responseObject objectForKey:@"socialPhone"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"socialPhone"];
        }
        
        [self->_contactTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)addUserInterfaceConfigure {
    _contactTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT()) style:UITableViewStylePlain];
    _contactTableView.delegate = self;
    _contactTableView.dataSource = self;
    _contactTableView.showsVerticalScrollIndicator = NO;
    _contactTableView.backgroundColor = [UIColor whiteColor];
    _contactTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _contactTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    _contactTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_contactTableView];
    
    _contactTableView.tableFooterView = [UIView new];
    
    CGFloat safaAreaBottom = iPhoneXSeries() ? 34 : 0;
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(20, SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 20 - 44 - safaAreaBottom, SCREEN_WIDTH() - 40, 44);
    confirmButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.cornerRadius = 22.0;
    confirmButton.layer.masksToBounds = YES;
    [self.view addSubview:confirmButton];
}

- (void)confirmButtonClicked {
    if ([self validateAllTextFieldsAreAllowed]) {
        if ([self validateAllTextFieldsIsModify]) {
            [self showLoadingProgressHUDWithText:@"提交中..."];
            AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
            NSDictionary *parameters = @{@"relativeName":self.relativeNameModify,@"relativeType":self.relativeTypeModify,@"relativePhone":self.relativePhoneModify,@"socialName":self.socialNameModify,@"socialType":self.socialTypeModify,@"socialPhone":self.socialPhoneModify};
            [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_FREQUENT_CONTACTS_URL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                ZGLog(@"提交常用联系人信息接口成功返回数据---%@",responseObject);
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
    NSString *userPhone = [ZXSDCurrentUser currentUser].phone;
    
    if (self.relativeNameModify.length == 0) {
        [self showToastWithText:@"请输入联系人姓名"];
        return NO;
    }
    if (self.relativeNameModify.length < 2 || [self checkContainsSpecialValue:self.relativeNameModify] /*|| ![ZXSDPublicClassMethod isAllChineseInString:self.relativeNameModify]*/) {
        [self showToastWithText:@"请输入联系人1的真实中文姓名"];
        return NO;
    }
    
    if (self.relativeTypeModify.length == 0) {
        [self showToastWithText:@"请选择亲属关系"];
        return NO;
    }
    
    if (self.relativePhoneModify.length == 0) {
        [self showToastWithText:@"请输入手机号"];
        return NO;
    } else {
        self.relativePhoneModify = [self.relativePhoneModify stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (![self.relativePhoneModify validateStringIsPhoneNumberFormate]) {
            [self showToastWithText:@"请输入联系人1正确的手机号"];
            return NO;
        }
        if ([self.relativePhoneModify isEqualToString:userPhone]) {
            [self showToastWithText:@"不能填写本人手机号"];
            return NO;
        }
    }
    
    if (self.socialNameModify.length == 0) {
        [self showToastWithText:@"请输入联系人姓名"];
        return NO;
    }
    if (self.socialNameModify.length < 2 || [self checkContainsSpecialValue:self.socialNameModify] /*|| ![ZXSDPublicClassMethod isAllChineseInString:self.socialNameModify]*/) {
        [self showToastWithText:@"请输入联系人2的真实中文姓名"];
        return NO;
    }
    
    if (self.socialTypeModify.length == 0) {
        [self showToastWithText:@"请选择社会关系"];
        return NO;
    }
    
    if (self.socialPhoneModify.length == 0) {
        [self showToastWithText:@"请输入手机号"];
        return NO;
    } else {
        self.socialPhoneModify = [self.socialPhoneModify stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (![self.socialPhoneModify validateStringIsPhoneNumberFormate]) {
            [self showToastWithText:@"请输入联系人2正确的手机号"];
            return NO;
        }
        if ([self.socialPhoneModify isEqualToString:userPhone]) {
            [self showToastWithText:@"不能填写本人手机号"];
            return NO;
        }
    }
    
    if ([self.relativeNameModify isEqualToString:self.socialNameModify]) {
        [self showToastWithText:@"联系人不能是同一个人"];
        return NO;
    }
    
    if([self.relativePhoneModify isEqualToString:self.socialPhoneModify]){
        [self showToastWithText:@"联系人电话不能是同一个号码"];
        return NO;
    }
    
    return YES;
}

- (BOOL)checkContainsSpecialValue:(NSString *)target
{
    NSInteger index = [self.filterNames indexOfObjectPassingTest:^BOOL(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:target]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    return index != NSNotFound;
}

- (BOOL)validateAllTextFieldsIsModify {
    if ([self.relativeName isEqualToString:self.relativeNameModify] && [self.relativeType isEqualToString:self.relativeTypeModify] && [self.relativePhone isEqualToString:self.relativePhoneModify] && [self.socialName isEqualToString:self.socialNameModify] && [self.socialType isEqualToString:self.socialTypeModify] && [self.socialPhone isEqualToString:self.socialPhoneModify]) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _channelSectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _channelContentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"contactInfoCell";
    ZXSDContactsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ZXSDContactsInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _channelContentArray[indexPath.row];
    cell.textField.delegate = self;
    
    if (indexPath.section == 0) {
        cell.textField.tag = indexPath.row + 100;
        if (indexPath.row == 0) {
            cell.canEdit = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.text = self.relativeNameModify ?: self.relativeName;
        } else if (indexPath.row == 1) {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择亲属关系";
            cell.textField.text = self.relativeTypeModify?: self.relativeType;
        } else {
            cell.canEdit = YES;
            cell.canContract = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.text = self.relativePhoneModify ?: self.relativePhone;
            cell.contractButton.tag = indexPath.row + 1000;
            [cell.contractButton addTarget:self action:@selector(contractButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        cell.textField.tag = indexPath.row + 200;
        if (indexPath.row == 0) {
            cell.canEdit = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.text = self.socialNameModify ?: self.socialName;
        } else if (indexPath.row == 1) {
            cell.canEdit = NO;
            cell.textField.placeholder = @"请选择社会关系";
            cell.textField.text = self.socialTypeModify ?: self.socialType;
        } else {
            cell.canEdit = YES;
            cell.canContract = YES;
            cell.textField.placeholder = @"请输入";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.text = self.socialPhoneModify ?: self.socialPhone;
            cell.contractButton.tag = indexPath.row + 2000;
            [cell.contractButton addTarget:self action:@selector(contractButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionBackView = [[UIView alloc] init];
    sectionBackView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH() - 40, SEPARATE_SINGLE_LINE_WIDTH())];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xDDDDDD);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    if (section == 0) {
        sectionBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 48);
        titleLabel.frame = CGRectMake(20, 20, SCREEN_WIDTH()/2, 28);
    } else {
        [sectionBackView addSubview:lineView];
        sectionBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 68);
        titleLabel.frame = CGRectMake(20, 40, SCREEN_WIDTH()/2, 28);
    }
    titleLabel.text = _channelSectionArray[section];
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
    
    if (textField.tag == 100 ||
        textField.tag == 200) {
        //过滤非汉字字符
        textField.text = [self filterCharactor:textField.text withRegex:kChineseFilter];
        
        if (textField.text.length >= kMaxNameLength) {
            textField.text = [textField.text substringToIndex:kMaxNameLength];
        }
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 102 || textField.tag == 202) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        //字母和数字判断
        if (![string isEqualToString:filtered]) {
            return NO;
        }
        
        
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger newLength = textField.text.length + string.length - range.length;
        return newLength <= 11;

    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 101 || textField.tag == 201) {
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
        case 100:
        {
            self.relativeNameModify = textField.text;
        }
            break;
        case 102:
        {
            self.relativePhoneModify = textField.text;
        }
            break;
        case 200:
        {
            self.socialNameModify = textField.text;
        }
            break;
        case 202:
        {
            self.socialPhoneModify = textField.text;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 处理点击事件
- (void)handlerTextFieldSelect:(UITextField *)textField  {
    switch (textField.tag) {
        case 101:
        {
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _relativeTypeArray;
            viewController.pickTitle = @"亲属关系";
            viewController.selectedValue = self.relativeTypeModify;
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.relativeTypeModify = returnString;
            };
            [self presentViewController:viewController animated:NO completion:^{
                [viewController beginAnimation];
            }];
        }
            break;
        case 201:
        {
            ZXSDRadioPickController *viewController = [[ZXSDRadioPickController alloc] init];
            viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            viewController.pickArray = _socialTypeArray;
            viewController.pickTitle = @"社会关系";
            viewController.selectedValue = self.socialTypeModify;
            viewController.pickAchieveString = ^(NSString *returnString) {
                textField.text = returnString;
                self.socialTypeModify = returnString;
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

#pragma mark - 点击通讯录 -- 调用系统通讯录
- (void)contractButtonClicked:(UIButton *)btn {
    ZGLog(@"点击系统通讯录===%@",@(btn.tag));
    indexTag = btn.tag;
    //获取通讯录权限，调用系统通讯录
    [self CheckAddressBookAuthorization:^(bool isAuthorized) {
        if (isAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self callAddressBook];
            });
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置" message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许Smile访问您的通讯录。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
          
- (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block {
    CNContactStore * contactStore = [[CNContactStore alloc]init];
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
            if (error) {
                ZGLog(@"Error: %@", error);
            } else if (!granted) {
                block(NO);
            } else {
                block(YES);
            }
        }];
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
        block(YES);
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置" message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许Smile访问您的通讯录。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
          
- (void)callAddressBook {
    CNContactPickerViewController *contactPickerController = [[CNContactPickerViewController alloc] init];
    contactPickerController.delegate = self;
    contactPickerController.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    contactPickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:contactPickerController animated:YES completion:nil];
}
      
#pragma mark -- CNContactPickerDelegate  进入系统通讯录页面 --
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    
    NSString *fullName = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName, contactProperty.contact.givenName];
    fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    UITextField *textField;
    UITextField *nameTextField;
    if (indexTag == 1002) {
        textField = (UITextField *)[self.view viewWithTag:102];
        nameTextField = (UITextField *)[self.view viewWithTag:100];
        
    } else {
        textField = (UITextField *)[self.view viewWithTag:202];
        nameTextField = (UITextField *)[self.view viewWithTag:200];
    }
    [[self ZXSD_GetController] dismissViewControllerAnimated:YES completion:^{
        NSString *phone = phoneNumber.stringValue;
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        textField.text = phone;
        nameTextField.text = fullName;
        
        if (self->indexTag == 1002) {
            self.relativePhoneModify = phone;
            self.relativeNameModify = fullName;
        } else {
            self.socialPhoneModify = phone;
            self.socialNameModify = fullName;
        }
    }];
}

#pragma mark - help methods -
//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}


@end
