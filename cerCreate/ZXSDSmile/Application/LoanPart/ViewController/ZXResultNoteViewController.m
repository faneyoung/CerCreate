//
//  ZXResultNoteViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXResultNoteViewController.h"
#import "UIButton+Addition.h"

#import "ZXSDAdvanceRecordsController.h"

@interface ZXResultNoteViewController ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *navBackBtn;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *desTitleLab;
@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *checkBtn;


@end

@implementation ZXResultNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self configurationSubview];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


#pragma mark - views -
- (UIButton *)navBackBtn{
    if (!_navBackBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:UIImageNamed(@"icon_nav_back_black") forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(kStatusBarHeight);
            make.left.inset(0);
            make.width.mas_equalTo(54);
            make.height.mas_equalTo(44);
        }];
        _navBackBtn = btn;
    }
    return _navBackBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        UIView *customBavBarView = [[UIView alloc] init];
        customBavBarView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:customBavBarView];
        [customBavBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(kStatusBarHeight);
            make.left.right.inset(0);
            make.height.mas_equalTo(kNavigationBarNormalHeight);
        }];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = FONT_PINGFANG_X_Medium(16);
        titleLab.textColor = TextColorTitle;
        [customBavBarView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.inset(7);
            make.centerX.offset(0);
            make.height.mas_equalTo(30);
        }];
        _titleLab = titleLab;
    }
    return _titleLab;
}

- (void)setupSubViews{
    
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = UIImageNamed(@"icon_success");
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(96+kStatusBarHeight);
        make.centerX.offset(0);
        make.width.height.mas_equalTo(120);
    }];
    self.imgView = imgView;
    
    UILabel *desTitleLab = [[UILabel alloc] init];
    desTitleLab.font = FONT_PINGFANG_X(20);
    desTitleLab.textColor = kThemeColorMain;
    desTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:desTitleLab];
    [desTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).inset(16);
        make.left.right.inset(20);
//        make.height.mas_equalTo(28);
    }];
    self.desTitleLab = desTitleLab;

    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.numberOfLines = 3;
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.font = FONT_PINGFANG_X(14);
    contentLab.textColor = TextColorSubTitle;
    [self.view addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(desTitleLab.mas_bottom).inset(6);
        make.left.right.inset(20);
    }];
    self.contentLab = contentLab;

    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.titleLabel.font = FONT_PINGFANG_X_Medium(14);
    ViewBorderRadius(checkBtn, 22, 0.01, UIColor.whiteColor);
    [checkBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    checkBtn.backgroundColor = UIColorFromHex(0xD8A655);
    [checkBtn setTitle:@"查看神券" forState:UIControlStateNormal];
    [self.view addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentLab.mas_bottom).inset(20);
        make.left.right.inset(50);
        make.height.mas_equalTo(0);
    }];
    [checkBtn addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.checkBtn = checkBtn;

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = FONT_PINGFANG_X_Medium(14);
    ViewBorderRadius(btn, 22, 0.01, UIColor.whiteColor);
    [btn setBackgroundImage:GradientImageThemeMain() forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(checkBtn.mas_bottom).inset(12);
        make.left.right.inset(50);
        make.height.mas_equalTo(44);
    }];
    [btn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn = btn;

    self.navBackBtn.hidden = YES;
    [self.navBackBtn addTarget:self action:@selector(backToEvaluationVC) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - data -
- (void)configurationSubview{

    NSString *imgName = @"icon_success";
    NSString *desTitleStr = @"";
    NSString *contentStr = @"";
    NSString *confirmBtnTitle = @"完成";
    UIColor *titleColor = kThemeColorMain;
    
    CGFloat checkBtnHeight = 0;
    
    switch (self.resultPageType) {
        case ResultPageTypeRefundSuccess:{
            contentStr = @"还款成功";
        }
            break;
        case ResultPageTypeRefundDoing:{
            desTitleStr = @"付款处理中";
            contentStr = self.payMessage;
        }
            break;
        case ResultPageTypeRefundFail:{
            desTitleStr = @"还款失败";
            contentStr = self.payMessage;
            imgName = @"icon_failed_red";
            titleColor = kThemeColorRed;
        }
            break;
        case ResultPageTypeMemberFeeSuccess:{
            desTitleStr = @"付款成功";
            contentStr = self.payMessage;

        }
            break;
        case ResultPageTypeMemberFeeDoing:{
            desTitleStr = @"付款处理中";
            contentStr = self.payMessage;
        }
            break;
        case ResultPageTypeMemberFeeFail:{
            imgName = @"icon_failed_red";
            desTitleStr = @"开通失败";
            contentStr = self.payMessage;
            titleColor = kThemeColorRed;

        }
            break;
        case ResultPageTypeAddCard:{
            contentStr =@"工资卡添加成功";
            
        }
            break;
        case ResultPageTypeAdvancing:{
            contentStr =@"预支的工资正在路上...";
            confirmBtnTitle = @"返回首页";
        }
            break;
        case ResultPageTypeRebind:{
            imgName = @"icon_failed_red";
            contentStr =self.payMessage;
            confirmBtnTitle = @"确定";
        }
            break;
        case ResultPageTypePhoneUpdate:{
            contentStr =@"绑定的手机号修改成功";
            confirmBtnTitle = @"确定";
        }
            break;
        case ResultPageTypeTaskScoreUpload:{
            contentStr =self.payMessage;
            confirmBtnTitle = @"确定";
            [self.confirmBtn updateTarget:self action:@selector(backToEvaluationVC) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case ResultPageTypeCouponSuccess:{
            desTitleStr = @"付款成功";
            contentStr = self.payMessage;
            confirmBtnTitle = @"再次预支";
            checkBtnHeight = 44;
            
        }
            break;
        case ResultPageTypeCouponDoing:{
            desTitleStr = @"付款已提交";
            contentStr = self.payMessage;

        }
            break;
        case ResultPageTypeCouponFail:{
            desTitleStr = @"付款失败";
            contentStr = self.payMessage;
            titleColor = kThemeColorRed;
        }
            break;
        case ResultPageTypeRiskReject:{
            contentStr = self.payMessage;
            imgName = @"icon_failed_red";
            
            confirmBtnTitle = @"返回首页";

            [self.confirmBtn setBackgroundImage:nil forState:UIControlStateNormal];
            self.confirmBtn.backgroundColor = kThemeColorLine;
            [self.confirmBtn setTitleColor:kThemeColorMain forState:UIControlStateNormal];

        }
            break;
        case ResultPageTypeWageAuthing:{//银行流水认证中
            contentStr = self.payMessage;
            confirmBtnTitle = @"返回";
            imgName = @"icon_wage_authenticating";
            
            [self.confirmBtn setBackgroundImage:nil forState:UIControlStateNormal];
            self.confirmBtn.backgroundColor = kThemeColorLine;
            [self.confirmBtn setTitleColor:kThemeColorMain forState:UIControlStateNormal];
            [self.confirmBtn updateTarget:self action:@selector(backToEvaluationVC) forControlEvents:UIControlEventTouchUpInside];
            
            [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(496/2);
                make.height.mas_equalTo(278/2);
            }];
            
            self.navBackBtn.hidden = NO;
        }
            break;

        default:
            break;
    }
    
    self.imgView.image = UIImageNamed(imgName);
    self.desTitleLab.text = desTitleStr;
    self.desTitleLab.textColor = titleColor;
    
    self.contentLab.text = contentStr;
    
    [self.confirmBtn setTitle:confirmBtnTitle forState:UIControlStateNormal];
    
    [self.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(checkBtnHeight);
    }];
    
    
    [self.view layoutIfNeeded];

}

- (void)setCustomTitle:(NSString *)customTitle{
    _customTitle = customTitle;
    
    self.titleLab.text = customTitle;
}

- (void)setPayMessage:(NSString *)payMessage{
    _payMessage = payMessage;
    self.contentLab.text = payMessage;
}

- (void)setConfirmBgImage:(UIImage *)confirmBgImage{
    _confirmBgImage = confirmBgImage;
    [self.confirmBtn setBackgroundImage:confirmBgImage forState:UIControlStateNormal];
}

#pragma mark - action -

- (void)backToEvaluationVC{
    
    __block ZXSDBaseViewController *evaluateVC = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof ZXSDBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"ZXAmountEvaluationViewController" )]) {
            evaluateVC = obj;
            *stop = YES;
        }
    }];
    
    if (evaluateVC) {
        [self.navigationController popToViewController:evaluateVC animated:YES];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
        
}

- (void)backButtonClicked:(id)sender{
    
    if(self.resultPageType == ResultPageTypeCouponSuccess){
        [self.navigationController popToRootViewControllerAnimated:NO];
        [URLRouter routerUrlWithPath:kRouter_advancePage extra:nil];
        return;
    }
    
    if ([self.backViewController isKindOfClass:NSClassFromString(@"ZXWithdrawViewController")]) {
        [super backButtonClicked:sender];
        return;
    }
    
   __block ZXSDAdvanceRecordsController *records = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc isKindOfClass:[ZXSDAdvanceRecordsController class]]) {
            records = (ZXSDAdvanceRecordsController *)vc;
            *stop = YES;
        }
    }];
    
    if (records) {
        [self.navigationController popToViewController:records animated:NO];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }

    if (self.resultPageType == ResultPageTypePhoneUpdate) {
        dispatch_queue_after_S(0.5, ^{
            // 清空用户数据
            [ZXSDCurrentUser clearUserInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_USERLOGOUT object:nil];
        });
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_REFRESH_HOME object:nil];

    }
    
    
}

- (void)checkButtonClicked:(UIButton*)btn{
    
    if ([btn.currentTitle isEqualToString:@"查看神券"]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [URLRouter routerUrlWithPath:kRouter_couponList extra:nil];
    }
    
}



@end
