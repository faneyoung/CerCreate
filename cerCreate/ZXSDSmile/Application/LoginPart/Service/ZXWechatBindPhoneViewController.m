//
//  ZXWechatBindPhoneViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/21.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXWechatBindPhoneViewController.h"
#import <IQKeyboardManager.h>
#import <MSWeakTimer.h>
#import "UITableView+help.h"
#import "UIButton+ExpandClickArea.h"

//views
#import "ZXNewPhoneNumCell.h"
#import "ZXMemberSmsCodeCell.h"

#import "ZXSDLoginService.h"

#import "EPNetworkManager.h"

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypePhone,
    SectionTypeSMS,
    SectionTypeAll
};

@interface ZXWechatBindPhoneViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSString *inputPhone;

@property (nonatomic, strong) UIButton *smsCodeBtn;
@property (nonatomic, strong) NSString *smsCode;
@property (nonatomic, assign) int timerCnt;
@property (nonatomic, strong) MSWeakTimer *timer;

@property (nonatomic, strong) NSString *otpCodeToken;

@end

@implementation ZXWechatBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定手机号";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self.tableView registerNibs: @[
        NSStringFromClass(ZXNewPhoneNumCell.class),
        NSStringFromClass(ZXMemberSmsCodeCell.class),
    ]];
    
}

#pragma mark - views -
- (void)setupSubViews{
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
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
        _tableView.estimatedRowHeight = 88;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypePhone) {
        ZXNewPhoneNumCell *cell = [ZXNewPhoneNumCell instanceCell:tableView];
        cell.titleStr = @"手机号";
        cell.placeholderStr = @"请输入手机号";
        cell.showCountry = YES;
        
        @weakify(self);
        cell.inputBlock = ^(NSString * _Nonnull str) {
            @strongify(self);
            self.inputPhone = str;
            [self checkConfirmBtnStatus];
        };
        return cell;
    }
    else if(indexPath.section == SectionTypeSMS){
        ZXMemberSmsCodeCell *cell = [ZXMemberSmsCodeCell instanceCell:tableView];
        cell.title = @"短信验证码";
        cell.sendCodeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
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

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == SectionTypeSMS) {
        return 260;
    }
    
    return CGFLOAT_MIN;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [tableView defaultHeaderFooterView];
    footView.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"立即绑定" forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_PINGFANG_X_Medium(16);
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn setBackgroundColor:TextColorDisable];
    btn.userInteractionEnabled = NO;
    [btn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(40);
        make.left.right.inset(20);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(btn, 22, 0.1, UIColor.whiteColor);
    self.confirmBtn = btn;
    
    return footView;
}

#pragma mark - data handle -
- (void)sendSMSCodeRequest{

    if (!IsValidString(self.inputPhone)) {
        return;
    }
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.inputPhone forKey:@"phone"];

    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:kPath_sendSMSCode parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
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
        
        NSDictionary *resultDic = (NSDictionary*)response.originalContent;
        
        self.otpCodeToken = [resultDic stringObjectForKey:@"otpCodeToken"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastWithText:@"验证码已成功发送"];
            [self startTimer];
        });
    }];

}

- (void)requestSMSCodeValid{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.otpCodeToken forKey:@"otpCodeToken"];
    [tmps setSafeValue:self.openid forKey:@"openid"];

    [tmps setSafeValue:self.inputPhone forKey:@"phone"];
    [tmps setSafeValue:self.smsCode forKey:@"otpCode"];

    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] postAPI:kPath_smsValidLogin parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
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
        

        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse*)response.response;
        NSDictionary *headersDic = httpURLResponse.allHeaderFields;
        NSString *userSession = [headersDic objectForKey:@"USER-SESSION"];
        
        [ZXSDLoginService saveSession:userSession phone:self.inputPhone];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZXSDLoginService uploadDeviceInfo];
            [ZXSDLoginService judgeNextActionFrom:self withNavCtrl:self.navigationController];
        });

        
    }];
}

#pragma mark - sms -
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

    
    [self requestSMSCodeValid];
    
}

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
