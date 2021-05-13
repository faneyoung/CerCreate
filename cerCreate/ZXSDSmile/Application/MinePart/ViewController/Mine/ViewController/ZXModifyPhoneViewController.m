//
//  ZXModifyPhoneViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXModifyPhoneViewController.h"
#import <IQKeyboardManager.h>
#import <MSWeakTimer.h>
#import "UIViewController+help.h"

//vc
#import "ZXSDLivingDetectionController.h"

#import "UITableView+help.h"

//views
#import "CJLabel.h"
#import "ZXNewPhoneNumCell.h"
#import "ZXMemberSmsCodeCell.h"
#import "ZXPhoneUpdateInputCell.h"

#import "EPNetworkManager.h"

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeInfo,
    SectionTypeNew,
    SectionTypeAll,
};

@interface ZXModifyPhoneViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *checkBtn;

@property (nonatomic, strong) NSString *inputPhone;

@property (nonatomic, strong) UIButton *smsCodeBtn;
@property (nonatomic, strong) NSString *smsCode;
@property (nonatomic, assign) int timerCnt;
@property (nonatomic, strong) MSWeakTimer *timer;

@property (nonatomic, strong) NSString *oldPhoneNum;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *idcardNum;
@property (nonatomic, strong) NSDictionary *smsDic;


@end

@implementation ZXModifyPhoneViewController

//- (instancetype)init
//{
//    self = [[UIStoryboard storyboardWithName:@"ZXModifyPhoneViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ZXModifyPhoneViewController"];
//    if (self) {
//        
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.title = @"修改绑定的手机号";
    
    [self adaptScrollView:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXPhoneUpdateInputCell.class),

        NSStringFromClass(ZXNewPhoneNumCell.class),
        NSStringFromClass(ZXMemberSmsCodeCell.class),
        
    ]];
    
    
    self.checkBtn.selected = YES;

}

#pragma mark - data handle -

- (void)changePhoneSmsCodeRequest{
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.oldPhoneNum forKey:@"oldPhone"];
    [tmps setSafeValue:self.name forKey:@"name"];
    [tmps setSafeValue:self.idcardNum forKey:@"idCardNo"];
    [tmps setSafeValue:self.inputPhone forKey:@"newPhone"];

    LoadingManagerShow();
    [EPNetworkManager.defaultManager postAPI:kPath_changePhoneSendSMSCode parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();

        if (error) {
            [self handleRequestError:error];
            self.smsCodeBtn.userInteractionEnabled = YES;
            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            NSString *respMsg = [response.originalContent stringObjectForKey:@"responseMsg"];
            if (IsValidString(respMsg)) {
                [self showToastWithText:respMsg];
            }
            return;
        }
        
        self.smsDic = response.resultModel.data;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastWithText:@"验证码已成功发送"];
            [self startTimer];
        });

    }];
}

- (void)requestChangePhoneSmsValid{
    
    NSString *userRefId = [self.smsDic stringObjectForKey:@"userRefId"];

    if (!IsValidString(userRefId)) {
        ToastShow(@"请先发送验证码");
        return;
    }
    
    NSMutableDictionary *tmps = [[NSMutableDictionary alloc] initWithDictionary:self.smsDic];
    [tmps setSafeValue:self.inputPhone forKey:@"newPhone"];
    [tmps setSafeValue:self.smsCode forKey:@"code"];
    [tmps setSafeValue:userRefId forKey:@"userRefId"];
    
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] postAPI:kPath_changePhoneValidSMSCode parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            
            NSString *respMsg = [response.originalContent stringObjectForKey:@"responseMsg"];
            if (IsValidString(respMsg)) {
                [self showToastWithText:respMsg];
            }
            
            return;
        }
        
        dispatch_safe_async_main(^{
            [self gotoLivingDetectionVC];
        });

        
    }];

}

- (void)sendSMSCodeRequest{
    NSString *phone = [ZXSDCurrentUser currentUser].phone;
    if (phone.length <= 0) {
        return;
    }
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.inputPhone forKey:@"newPhone"];

    LoadingManagerShow();
    [[EPNetworkManager defaultManager] getAPI:kPath_phoneUpdateSendSmsCode parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        LoadingManagerHidden();

        if (error) {
            [self handleRequestError:error];
            self.smsCodeBtn.userInteractionEnabled = YES;

            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            
            NSString *respMsg = [response.originalContent stringObjectForKey:@"responseMsg"];
            if (IsValidString(respMsg)) {
                [self showToastWithText:respMsg];
            }
            
            return;
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastWithText:@"验证码已成功发送"];
            [self startTimer];
        });
    }];

}

- (void)requestSMSCodeValid{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.inputPhone forKey:@"newPhone"];
    [tmps setSafeValue:self.smsCode forKey:@"code"];
    
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] postAPI:kPath_phoneUpdateCodeValidSms parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            
            NSString *respMsg = [response.originalContent stringObjectForKey:@"responseMsg"];
            if (IsValidString(respMsg)) {
                [self showToastWithText:respMsg];
            }
            
            return;
        }
        
        NSMutableDictionary *tmps = @{}.mutableCopy;
        [tmps setSafeValue:self.backViewController forKey:@"backViewController"];
        [tmps setSafeValue:self.inputPhone forKey:@"phone"];
        [URLRouter routerUrlWithPath:kRouter_modifyPhoneInfo extra:tmps.copy];

    }];
}

#pragma mark - help methods -
//前往人脸识别页面
- (void)gotoLivingDetectionVC
{
    ZXSDLivingDetectionController *viewController = [[ZXSDLivingDetectionController alloc] init];
    viewController.phone = self.inputPhone;
    viewController.userRefId = [self.smsDic stringObjectForKey:@"userRefId"];
    viewController.detectType = LivingDetectionTypeChangePhone;
    if (self.backViewController) {
        viewController.backViewController = self.backViewController;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - action -
- (void)backButtonClicked:(nullable id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextBtnClicked{
    
    if (![self.inputPhone validateStringIsPhoneNumberFormate] ||
        self.smsCode.length < 6) {
        return;
    }
    
//#warning --test--
//    NSMutableDictionary *tmps = @{}.mutableCopy;
//    [tmps setSafeValue:self.backViewController forKey:@"backViewController"];
//    [tmps setSafeValue:self.inputPhone forKey:@"phone"];
//    [URLRouter routerUrlWithPath:kRouter_modifyPhoneInfo extra:tmps.copy];
//
//    return;
//#warning --test--

    if (self.pageType == ModifyPhonePageTypeSingleChange) {
        [self requestChangePhoneSmsValid];
        return;
    }
    [self requestSMSCodeValid];
    
}



#pragma mark - views -

- (void)setupSubViews{
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(1);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLine.mas_bottom).inset(0);
        make.left.bottom.right.inset(0);
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.pageType == ModifyPhonePageTypeDefault) {
        
        if (section == SectionTypeInfo) {
            return 0;
        }
        else if(section == SectionTypeNew){
            return 2;

        }
        
        return 0;
    }

    if(section == SectionTypeInfo){
        if (self.pageType == ModifyPhonePageTypeSingleChange) {
            return 3;
        }
    }
    else if(section == SectionTypeNew){
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == SectionTypeInfo) {
        ZXPhoneUpdateInputCell *cell = [ZXPhoneUpdateInputCell instanceCell:tableView];
        cell.type = indexPath.row;
        @weakify(self);
        cell.inputBlock = ^(NSString * _Nonnull str, PhoneUpdateType type) {
            @strongify(self);
            if (type == PhoneUpdateTypePhone) {
                self.oldPhoneNum = str;
            }
            else if(type == PhoneUpdateTypeName){
                self.name = str;
            }
            else if(type == PhoneUpdateTypeIdcard){
                self.idcardNum = str;
            }
            
            [self checkConfirmBtnStatus];
            
        };

        return cell;
    }
    
    if (indexPath.row == 0) {
        ZXNewPhoneNumCell *cell = [ZXNewPhoneNumCell instanceCell:tableView];
        @weakify(self);
        cell.inputBlock = ^(NSString * _Nonnull str) {
            @strongify(self);
            self.inputPhone = str;
            [self checkConfirmBtnStatus];
        };
        return cell;
    }
    else if(indexPath.row == 1){
        ZXMemberSmsCodeCell *cell = [ZXMemberSmsCodeCell instanceCell:tableView];

        [cell.sendCodeBtn addTarget:self action:@selector(sendCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.smsCodeBtn = cell.sendCodeBtn;
        
        @weakify(self);
        cell.codeBlock = ^(NSString * _Nonnull code) {
            @strongify(self);
            
            self.smsCode = code;
            [self checkConfirmBtnStatus];
        };
        
        return cell;
    }
    
    return [tableView defaultReuseCell];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.pageType == ModifyPhonePageTypeSingleChange) {
        return CGFLOAT_MIN;
    }
    else if (self.pageType == ModifyPhonePageTypeDefault) {
        
        if (section == SectionTypeInfo) {
            return CGFLOAT_MIN;
        }
        
        return 40;

    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(self.pageType == ModifyPhonePageTypeDefault){
        if (section == SectionTypeInfo) {
            return 0.001;
        }
        else if(section == SectionTypeNew){
            return 260;
        }
    }
    else if (self.pageType == ModifyPhonePageTypeSingleChange) {
        
        if (section == SectionTypeInfo) {
            return 8;
        }
        
        return 260;
    }
    

    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.pageType == ModifyPhonePageTypeSingleChange) {
        return [[UIView alloc] init];
    }
    
    if (section == SectionTypeInfo) {
        return [[UIView alloc] init];
    }

    UIView *headerView = [tableView defaultHeaderFooterView];
    headerView.backgroundColor = UIColorFromHex(0xFFF4D4);

    UILabel *lab = [[UILabel alloc] init];
    lab.font = FONT_PINGFANG_X(12);
    lab.textColor = UIColorFromHex(0xC8A028);
    lab.text = @"请输入新的手机号，并发送短信验证码";
    [headerView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [tableView defaultHeaderFooterView];
    footView.backgroundColor = UIColor.whiteColor;
    
    if (self.pageType == ModifyPhonePageTypeSingleChange) {
        
        if (section == SectionTypeInfo) {
            footView.backgroundColor = kThemeColorBg;
            return footView;
        }
        
    }

    
    UIView *protocol = [self protocolLabWith:footView];
    [protocol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(40);
        make.left.inset(51);
        make.right.inset(20);
        make.height.mas_equalTo(36);
    }];
    
    [footView addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(40);
        make.left.inset(8);
        make.width.mas_equalTo(41);
        make.height.mas_equalTo(17);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_PINGFANG_X_Medium(16);
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn setBackgroundColor:TextColorDisable];
    btn.userInteractionEnabled = NO;
    [btn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(protocol.mas_bottom).inset(40);
        make.left.right.inset(20);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(btn, 22, 0.1, UIColor.whiteColor);
    self.confirmBtn = btn;
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - help 1 -

- (UIButton *)checkBtn{
    if (!_checkBtn) {
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBtn setImage:UIImageNamed(@"choose_employer_uncheck") forState:UIControlStateNormal];
        [checkBtn setImage:UIImageNamed(@"choose_employer_checked") forState:UIControlStateSelected];
        @weakify(self);
        [checkBtn bk_addEventHandler:^(UIButton* sender) {
            @strongify(self);
            sender.selected = !sender.selected;
            [self checkConfirmBtnStatus];
        } forControlEvents:UIControlEventTouchUpInside];
        
        _checkBtn = checkBtn;
    }
    
    return _checkBtn;
}

- (UIView*)protocolLabWith:(UIView*)targetView{
    NSString *protocolString = @"阅读并同意《用户服务协议》、《隐私保护指引》未注册时将自动注册账";
    UIFont *currentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:protocolString];
    CJLabel *protocolLabel = [[CJLabel alloc] initWithFrame:CGRectZero];
    protocolLabel.numberOfLines = 0;
    [targetView addSubview:protocolLabel];
    
    @weakify(self);
    attributedString = [CJLabel configureAttributedString:attributedString atRange:NSMakeRange(0, attributedString.length) attributes:@{ NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x999999),NSFontAttributeName:currentFont,}];
    attributedString = [CJLabel configureLinkAttributedString:attributedString withString:@"《用户服务协议》" sameStringEnable:NO linkAttributes:@{NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),NSFontAttributeName:currentFont,} activeLinkAttributes:nil parameter:nil clickLinkBlock:^(CJLabelLinkModel *linkModel){
        @strongify(self);
        [self jumpToZXSDProtocolController];
    }longPressBlock:^(CJLabelLinkModel *linkModel){
        @strongify(self);
        [self jumpToZXSDProtocolController];
    }];
    
    attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                   withString:@"《隐私保护指引》"
                                             sameStringEnable:NO
                                               linkAttributes:@{
                                                   NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                   NSFontAttributeName:currentFont,
                                               }
                                         activeLinkAttributes:nil
                                                    parameter:nil
                                               clickLinkBlock:^(CJLabelLinkModel *linkModel){
        @strongify(self);

        [self jumpToPrivacyAgreementController];
    }longPressBlock:^(CJLabelLinkModel *linkModel){
        @strongify(self);
        [self jumpToPrivacyAgreementController];
    }];
    protocolLabel.attributedText = attributedString;
    protocolLabel.extendsLinkTouchArea = YES;

    return protocolLabel;
}

#pragma mark - protocol -
//跳转至众薪速达协议
- (void)jumpToZXSDProtocolController {
     NSString *requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,USER_SERVICE_URL];
    
    [URLRouter routerUrlWithPath:requestURL extra:nil];
}

//跳转至隐私保护指引
- (void)jumpToPrivacyAgreementController {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,PRIVACY_AGREEMENT_URL];
    [URLRouter routerUrlWithPath:requestURL extra:nil];
}





#pragma mark - sms -
- (void)checkConfirmBtnStatus{
    
    if (![self.inputPhone validateStringIsPhoneNumberFormate]) {
        [self updateConfirmBtnEnable:NO];
        return;
    }
    
    if (!IsValidStrLen(self.smsCode, 6)) {
        [self updateConfirmBtnEnable:NO];
        return;
    }
    
    if (!self.checkBtn.selected) {
        [self updateConfirmBtnEnable:NO];
        return;
    }
    
    if (self.pageType == ModifyPhonePageTypeSingleChange) {
        if (![self.oldPhoneNum validateStringIsPhoneNumberFormate]) {
            [self updateConfirmBtnEnable:NO];
            return;
        }
        
        if (!IsValidString(self.name)) {
            [self updateConfirmBtnEnable:NO];
            return;
        }
        
        if (!IsValidString(self.idcardNum)) {
            [self updateConfirmBtnEnable:NO];
            return;
        }
    }
    
    [self updateConfirmBtnEnable:YES];
    
}

- (void)updateConfirmBtnEnable:(BOOL)enable{
    
    self.confirmBtn.userInteractionEnabled  = enable;

    if (!enable) {
        [self.confirmBtn setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundColor:TextColorDisable];
        [self.confirmBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else{
        [self.confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

        [self.confirmBtn setBackgroundImage:[UIImage  imageWithGradient:@[UIColorFromHex(0x00C35A),UIColorFromHex(0x00D663),] size:CGSizeMake(SCREEN_WIDTH()-2*20, 44) direction:UIImageGradientDirectionRightSlanted] forState:UIControlStateNormal];

    }
    

}


#pragma mark - timer -
- (void)sendCodeBtnClick:(UIButton*)sender{

    if (self.pageType == ModifyPhonePageTypeSingleChange) {
        [self changePhoneSmsCodeRequest];
        return;
    }
    [self sendSMSCodeRequest];

}

- (void)startTimer{
    [self stopTimer];
    
    [self timerCntDown];
    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCntDown) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

- (void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timerCnt = 60;
}

- (void)timerCntDown{
    self.timerCnt --;
    
    if (self.timerCnt > 0) {
        self.smsCodeBtn.userInteractionEnabled = NO;
        [self.smsCodeBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
        [self.smsCodeBtn setTitle:[NSString stringWithFormat:@"%@ s",@(self.timerCnt)] forState:UIControlStateNormal];
    }else{
        [self stopTimer];

        self.smsCodeBtn.userInteractionEnabled = YES;
        [self.smsCodeBtn setTitleColor:kThemeColorMain forState:UIControlStateNormal];
        [self.smsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
}


@end
