//
//  ZXSDOpenMemberResultController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDOpenMemberResultController.h"
#import "ZXSDAdvanceSalaryResultController.h"

//static const NSString * = @"/rest/loan/create";

@interface ZXSDOpenMemberResultController ()

@end

@implementation ZXSDOpenMemberResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    [self addUserInterfaceConfigure];
    if (self.success) {
        [self prepareLoan];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
}

- (void)addUserInterfaceConfigure
{
    UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 41, 58, 82, 82)];
    [self.view addSubview:resultImageView];
    
    UILabel *resultLab = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x00B050) font:FONT_PINGFANG_X(20)];
    [self.view addSubview:resultLab];
    [resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    
    UILabel *descLab = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(14)];
    [self.view addSubview:descLab];
    [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultLab.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    
    UIButton *confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    confirmButton.layer.cornerRadius = 22.0;
    confirmButton.layer.masksToBounds = YES;
    [self.view addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLab.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(44);
    }];
    
    
    if (self.success) {
        resultImageView.image = UIIMAGE_FROM_NAME(@"smile_memeber_success");
        resultLab.textColor = UICOLOR_FROM_HEX(0x00B050);
        resultLab.text = @"开通成功";
        descLab.text = [NSString stringWithFormat:@"有效期  %@ - %@", self.customerValidDate, self.customerInvalidDate];
        
        confirmButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
        [self configContent:confirmButton];
        confirmButton.userInteractionEnabled = NO;
        
    } else {
        resultImageView.image = UIIMAGE_FROM_NAME(@"smile_memeber_failure");
        resultLab.textColor = UICOLOR_FROM_HEX(0xFF4C00);
        resultLab.text = @"开通失败";
        if (self.errorStr.length > 0) {
            descLab.text = self.errorStr;
        } else {
            descLab.text = @"扣款失败 请稍后再尝试";
        }
        
        confirmButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton setTitle:@"返回到创世薪朋友" forState:(UIControlStateNormal)];
        [confirmButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)configContent:(UIButton *)confirmButton
{
    // loading
    UIImageView *loadingImageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_home_loading")];
    [confirmButton addSubview:loadingImageView];
    [loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.centerY.equalTo(confirmButton);
        make.centerX.equalTo(confirmButton).offset(-56);
    }];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    UILabel *status = [UILabel labelWithText:@"薪资预付中…" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(16)];
    [confirmButton addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(confirmButton);
        make.left.equalTo(loadingImageView.mas_right).offset(10);
    }];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareLoan
{
    NSInteger principalValue = [self.loanAmount integerValue];
    NSDictionary *parameters = @{
        @"code":self.loanType,
        @"installPeriodLength":self.installPeriodLength,
        @"installPeriodNum":self.installPeriodNum,
        @"installPeriodUnit":self.installPeriodUnit,
        @"principal":[NSNumber numberWithInteger:principalValue]};
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,SUBMIT_LOAN_URL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"提交预支薪资借款信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        [self jumpToAdvanceSalaryResultController];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
       
}

- (void)jumpToAdvanceSalaryResultController {
    ZXSDAdvanceSalaryResultController *viewController = [ZXSDAdvanceSalaryResultController new];
    viewController.success = YES;
    viewController.loanAmount = self.loanAmount;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
