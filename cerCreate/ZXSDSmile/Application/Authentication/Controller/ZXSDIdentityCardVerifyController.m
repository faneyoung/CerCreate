//
//  ZXSDIdentityCardVerifyController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDIdentityCardVerifyController.h"
#import <AVFoundation/AVFoundation.h>

#import "ZXSDLivingDetectionController.h"
#import "BRDatePickerView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZXSDVerifyManager.h"

#import "ZXSDVerifyProgressCell.h"
#import "ZXSDIDCardPhotoCell.h"
#import "ZXSDIDCardTipsCell.h"
#import "ZXSDBindIDCardInfoCell.h"

static const NSString *UPLOAD_ID_CARD_PHOTO_URL = @"/rest/idCard/ocr/verified?type=";
static const NSString *VERIFY_ID_CARD_CERT_URL = @"/rest/userInfo/identity";

@interface ZXSDIdentityCardVerifyController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) TPKeyboardAvoidingTableView *infoTableView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *idCardNumber;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, assign) NSInteger currentTag;//区分正反面

@property (nonatomic, assign) BOOL idCardFrontSuccess, idCardBackSuccess;

@end

@implementation ZXSDIdentityCardVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份认证";
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
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

- (void)addUserInterfaceConfigure
{
    [self.view addSubview:self.infoTableView];
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
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [self.infoTableView registerClass:[ZXSDVerifyProgressCell class] forCellReuseIdentifier:[ZXSDVerifyProgressCell identifier]];
    [self.infoTableView registerClass:[ZXSDIDCardPhotoCell class] forCellReuseIdentifier:[ZXSDIDCardPhotoCell identifier]];
    [self.infoTableView registerClass:[ZXSDIDCardTipsCell class] forCellReuseIdentifier:[ZXSDIDCardTipsCell identifier]];
    [self.infoTableView registerClass:[ZXSDBindIDCardInfoCell class] forCellReuseIdentifier:[ZXSDBindIDCardInfoCell identifier]];
}

- (void)prepareDataConfigure {
    self.titleArray = @[@"姓名",@"身份证号",@"有效期限"];
    
    self.userName = @"";
    self.idCardNumber = @"";
    self.startDate = @"";
    self.endDate = @"";
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.idCardBackSuccess || self.idCardFrontSuccess) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if (section == 2) {
        return 1;
    } else {
        if (self.idCardBackSuccess || self.idCardFrontSuccess) {
            return 3;
        }
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZXSDVerifyProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDVerifyProgressCell identifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ZXSDVerifyActionModel *model = [ZXSDVerifyManager IDCardVerifyAction];
            [cell setRenderData:model];
            return cell;
        } else {
            ZXSDIDCardPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDIDCardPhotoCell identifier] forIndexPath:indexPath];
            [cell setTakePhotoAction:^(NSInteger tag) {
                [self takePhotoAndUploadThePhoto:tag];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    } else if (indexPath.section == 2) {
        ZXSDIDCardTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDIDCardTipsCell identifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if (self.idCardBackSuccess || self.idCardFrontSuccess) {
            
            ZXSDBindIDCardInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDBindIDCardInfoCell identifier] forIndexPath:indexPath];
            [cell showBottomLine];
            [self configInfoCell:cell indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else {
            ZXSDIDCardTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDIDCardTipsCell identifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (void)configInfoCell:(ZXSDBindIDCardInfoCell *)cell  indexPath:(NSIndexPath *)indexPath
{
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.canChoice = NO;
            cell.textField.text = self.userName;
            cell.textField.font = FONT_PINGFANG_X(14);
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.returnKeyType = UIReturnKeyDone;
        }
            break;
        case 1:
        {
            cell.canChoice = NO;
            cell.textField.text = self.idCardNumber;
            cell.textField.font = FONT_SFUI_X_Regular(14);
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.returnKeyType = UIReturnKeyDone;
        }
            break;
        case 2:
        {
            cell.canChoice = YES;
            cell.startButton.tag = 1000;
            cell.endButton.tag = 1001;
            [cell.startButton setTitle:self.startDate forState:UIControlStateNormal];
            [cell.startButton addTarget:self action:@selector(selectValidateDateWithButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.endButton setTitle:self.endDate forState:UIControlStateNormal];
            [cell.endButton addTarget:self action:@selector(selectValidateDateWithButton:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        return indexPath.row == 0 ? 80:[ZXSDIDCardPhotoCell height];
    }
    else if (section == 2) {
        return 242;
    } else {
        if (self.idCardBackSuccess || self.idCardFrontSuccess) {
            return 52;
        }
        return 242;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    } else if (section == 1) {
        return (self.idCardBackSuccess || self.idCardFrontSuccess)?8:0;
    } else {
        return 0;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2 || (section == 1 && !(self.idCardBackSuccess || self.idCardFrontSuccess))) {
        return nil;
    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 8)];
    footer.backgroundColor = UICOLOR_FROM_HEX(0xF7F9FB);
    return footer;
}

#pragma mark - UITextFieldDelegate 返回键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //身份证号输入校验
    if (textField.tag == 1) {
        NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *smsCodeNumber = [beingString stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (smsCodeNumber.length > 18) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadIDCardWithImage:image];
    }];
}

#pragma mark - Action

- (void)nextVerifyAction
{
    [self.view endEditing:YES];
    
    if ([self validateAllTextFieldsAreAllowed]) {
        self.nextButton.userInteractionEnabled = NO;
        NSDictionary *dic = @{@"idNo":self.idCardNumber,@"name":self.userName,@"nationality":@"CN",@"idType":@"IDCard"};
        [self showLoadingProgressHUDWithText:@"正在加载..."];
        
        AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
        [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,VERIFY_ID_CARD_CERT_URL] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dismissLoadingProgressHUD];
            self.nextButton.userInteractionEnabled = YES;
            ZGLog(@"提交身份证信息接口成功返回数据---%@",responseObject);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self jumpToNecessaryCertSecondStepController];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self dismissLoadingProgressHUD];
            self.nextButton.userInteractionEnabled = YES;
            [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"提交失败"];
        }];
    }
}

//前往人脸识别页面
- (void)jumpToNecessaryCertSecondStepController
{
    ZXSDLivingDetectionController *viewController = [ZXSDLivingDetectionController new];
    if (self.backViewController) {
        viewController.backViewController = self.backViewController;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

//校验是否可以验证身份证
- (BOOL)validateAllTextFieldsAreAllowed {
    if (_idCardBackSuccess == NO) {
        [self showToastWithText:@"请先拍摄并上传身份证人像面"];
        return NO;
    }
    
    if (_idCardFrontSuccess == NO) {
        [self showToastWithText:@"请先拍摄并上传身份证国徽面"];
        return NO;
    }
    
    if (self.userName.length == 0) {
        [self showToastWithText:@"请输入您的姓名"];
        return NO;
    }
    
    if (self.idCardNumber.length == 0) {
        [self showToastWithText:@"请输入您的身份证号"];
        return NO;
    } else {
        self.idCardNumber = [self.idCardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (![self.idCardNumber validateStringIsIDCardFormate]) {
            [self showToastWithText:@"请输入正确的身份证号"];
            return NO;
        }
    }
    
    if (self.startDate.length == 0 || self.endDate.length == 0) {
        [self showToastWithText:@"请选择身份证的有效期限"];
        return NO;
    }
    
    return YES;
}

- (void)selectValidateDateWithButton:(UIButton *)btn {
    [self.view endEditing:YES];
    
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
    datePickerView.title = @"有效期限";
    datePickerView.minDate = [NSDate br_setYear:1990 month:1 day:1];
    datePickerView.maxDate = [NSDate br_setYear:2099 month:12 day:12];
    //[NSDate date];
    datePickerView.isAutoSelect = NO;
    datePickerView.showToday = YES;
    datePickerView.showUnitType = BRShowUnitTypeNone;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        selectValue = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        ZGLog(@"selectValue=%@", selectValue);
        [btn setTitle:selectValue forState:UIControlStateNormal];
        if (btn.tag == 1000) {
            self.startDate = selectValue;
        } else {
            self.endDate = selectValue;
        }
    };
    
    [datePickerView show];
}

/// 拍照按钮点击事件
- (void)takePhotoAndUploadThePhoto:(NSInteger)tag {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        // 无权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置" message:@"请在iPhone的“设置-隐私-相机”选项中，允许Smile访问你的相机。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAct];
        UIAlertAction *settingAct = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alertController addAction:settingAct];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoWithTag:tag];
                });
            }
        }];
    } else {
        [self takePhotoWithTag:tag];
    }
}

- (void)takePhotoWithTag:(NSInteger)tag
{
    _currentTag = tag;
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

//上传身份证到服务器
- (void)uploadIDCardWithImage:(UIImage *)image {
    [self showLoadingProgressHUDWithText:@"正在上传..."];
    
    NSString *type = self.currentTag == 1000 ? @"front": @"back";
    /*
    if (self.currentTag == 1000) {
        type = @"front";
        _backImageView.image = image;
        _backStatusLabel.text = @"上传中...";
        _backStatusLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    } else {
        type = @"back";
        _frontImageView.image = image;
        _frontStatuslabel.text = @"上传中...";
        _frontStatuslabel.textColor = UICOLOR_FROM_HEX(0x999999);
    }*/
    [self updateIDCardPhotoCell:image status:0];
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,UPLOAD_ID_CARD_PHOTO_URL,type] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:data name:@"file" fileName:@"File" mimeType:@"jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"上传身份证成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (self.currentTag == 1000) {
                self.userName = [[responseObject objectForKey:@"name"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"name"];
                self.idCardNumber = [[responseObject objectForKey:@"idNo"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"idNo"];
                self.idCardBackSuccess = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //self->_backStatusLabel.text = @"上传成功";
                    //[self updateInterfaceConfigure];
                    [self updateIDCardPhotoCell:nil status:1];
                });
            } else {
                self.startDate = [[responseObject objectForKey:@"startDate"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"startDate"];
                self.startDate = [self.startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                self.endDate = [[responseObject objectForKey:@"endDate"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"endDate"];
                self.endDate = [self.endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                self.idCardFrontSuccess = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //self->_frontStatuslabel.text = @"上传成功";
                    //[self updateInterfaceConfigure];
                    [self updateIDCardPhotoCell:nil status:1];
                });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /*
            if (self.currentTag == 1000) {
                self->_backStatusLabel.text = @"识别失败，请重新上传";
                self->_backStatusLabel.textColor = UICOLOR_FROM_HEX(0xF06428);
            } else {
                self->_frontStatuslabel.text = @"识别失败，请重新上传";
                self->_frontStatuslabel.textColor = UICOLOR_FROM_HEX(0xF06428);
            }*/
            [self updateIDCardPhotoCell:nil status:2];
        });
    }];
}

- (void)updateIDCardPhotoCell:(UIImage *)image status:(NSInteger)status
{
    ZXSDIDCardPhotoCell *cell = [self.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *statusText = @"上传中...";
    UIColor *textColor = UICOLOR_FROM_HEX(0x999999);
    if (status == 1) {
        statusText = @"上传成功";
    } else if (status == 2) {
        statusText = @"识别失败，请重新上传";
        textColor = UICOLOR_FROM_HEX(0xF06428);
    }
    
    if (self.currentTag == 1000) {
        if (image) {
            cell.backImageView.image = image;
        }
        
        cell.backStatusLabel.text = statusText;
        cell.backStatusLabel.textColor = textColor;
    } else {
        if (image) {
            cell.frontImageView.image = image;
        }
        cell.frontStatuslabel.text = statusText;
        cell.frontStatuslabel.textColor = textColor;
    }
    
    [self.infoTableView reloadData];
}

#pragma mark - Getter

- (UIButton *)nextButton
{
    if (!_nextButton) {
           _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nextButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
           [_nextButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
           [_nextButton addTarget:self action:@selector(nextVerifyAction) forControlEvents:(UIControlEventTouchUpInside)];
           
           [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
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
        _infoTableView.tableFooterView = [UIView new];
    }
    return _infoTableView;
    
}

@end
