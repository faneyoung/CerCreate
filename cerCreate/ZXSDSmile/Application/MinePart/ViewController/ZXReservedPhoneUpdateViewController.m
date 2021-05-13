//
//  ZXReservedPhoneUpdateViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/20.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXReservedPhoneUpdateViewController.h"
#import "UITableView+help.h"
#import <MSWeakTimer.h>

//views
#import "ZXNormalBankCardCell.h"
#import "ZXNewPhoneNumCell.h"
#import "ZXMemberSmsCodeCell.h"

#import "EPNetworkManager.h"


typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeNote,
    SectionTypeCard,
    SectionTypePhone,
    SectionTypeSmsArea,
    SectionTypeAll
};

@interface ZXReservedPhoneUpdateViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSString *inputPhone;
@property (nonatomic, strong) UIButton *smsCodeBtn;
@property (nonatomic, strong) NSString *smsCode;
@property (nonatomic, assign) int timerCnt;
@property (nonatomic, strong) MSWeakTimer *timer;


@end

@implementation ZXReservedPhoneUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"银行卡验证";
    
    [self.tableView registerClasses:@[
        NSStringFromClass(ZXBaseCell.class)
    ]];
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXNormalBankCardCell.class),
        NSStringFromClass(ZXNewPhoneNumCell.class),
        NSStringFromClass(ZXMemberSmsCodeCell.class),
    ]];
    
}

#pragma mark - views -
- (void)setupSubViews{
   
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 90;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
#pragma mark - data handle -
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

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == SectionTypeNote) {
        ZXBaseCell *cell = [ZXBaseCell instanceCell:tableView];
        cell.contentView.backgroundColor = kThemeColorLine;
        [cell.contentView removeAllSubviews];
        
        UILabel *noteLab = [UILabel labelWithText:@"请输入银行发送给您的绑卡验证码，仅用于还款扣款。" textColor:TextColorgray font:FONT_PINGFANG_X(12)];
        noteLab.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:noteLab];
        [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(20);
            make.top.bottom.inset(16);
            make.height.mas_equalTo(17);
        }];
        return cell;
    }
    else if(indexPath.section == SectionTypeCard){
        ZXNormalBankCardCell *cell = [ZXNormalBankCardCell instanceCell:tableView];
        [cell updateWithData:self.card];
        cell.isMainCard = self.isMainCard;
        return cell;
    }
    else if(indexPath.section == SectionTypePhone){
        ZXNewPhoneNumCell *cell = [ZXNewPhoneNumCell instanceCell:tableView];
        cell.titleStr = @"新预留手机号";
        cell.placeholderStr = @"请输入新预留的手机号";
        
        @weakify(self);
        cell.inputBlock = ^(NSString * _Nonnull str) {
            @strongify(self);
            self.inputPhone = str;
            [self checkConfirmBtnStatus];
        };
        
        return cell;
        
    }
    else if(indexPath.section == SectionTypeSmsArea){
        ZXMemberSmsCodeCell *cell = [ZXMemberSmsCodeCell instanceCell:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

//        cell.hideTitle = YES;
//        cell.hideSepLine = YES;
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
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == SectionTypeCard) {
        return 8;
    }
    else if(section == SectionTypeSmsArea){
        return 85;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [tableView defaultHeaderFooterView];
    view.backgroundColor = kThemeColorLine;
    
    if (section == SectionTypeSmsArea) {
        view.backgroundColor = UIColor.whiteColor;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"下一步" forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_PINGFANG_X_Medium(16);
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn setBackgroundColor:TextColorDisable];
        btn.userInteractionEnabled = NO;
        [btn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(40);
            make.left.right.inset(20);
            make.height.mas_equalTo(44);
        }];
        ViewBorderRadius(btn, 22, 0.1, UIColor.whiteColor);
        self.confirmBtn = btn;
        
        return view;

    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    [self requestSMSCodeValid];
    
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
    if (!IsValidString(self.inputPhone)) {
        [self showToastWithText:@"请输入手机号"];
        return;
    }
    
    if (![self.inputPhone validateStringIsPhoneNumberFormate]) {
        [self showToastWithText:@"请输入正确的手机号"];
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
        [self.smsCodeBtn setTitle:[NSString stringWithFormat:@"已发送 %@s",@(self.timerCnt)] forState:UIControlStateNormal];
    }else{
        [self stopTimer];

        self.smsCodeBtn.userInteractionEnabled = YES;
        [self.smsCodeBtn setTitleColor:kThemeColorMain forState:UIControlStateNormal];
        [self.smsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
}

@end
