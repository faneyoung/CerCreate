//
//  ZXSDRiskCheckResultController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDRiskCheckResultController.h"
#import "ZXSDAdvanceSalaryInfoController.h"

static const NSString *RISK_RESULTQEURY_URL = @"/rest/loan/queryRiskStatus";

@interface ZXSDRiskCheckResultController ()

@property (nonatomic, strong) UIView *checkingView;
@property (nonatomic, assign) ZXSDRiskResultType riskResultType;

// 风控拒绝原因
@property (nonatomic, copy) NSString *failTips;

@end

@implementation ZXSDRiskCheckResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableInteractivePopGesture = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    
    [self showCheckingView];
    [self queryRiskResult];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
}

- (void)queryRiskResult
{
    if (self.eventRefId.length == 0) {
        return;
    }
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,RISK_RESULTQEURY_URL]
      parameters:@{@"eventRefId":self.eventRefId}
        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"风控结果接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];
        NSString *result = @"";
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            result = [responseObject objectForKey:@"riskStatus"];
            self.failTips = [responseObject objectForKey:@"tips"];
            
            [self transferRiskResult:result];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)showCheckingView
{
    [self.view addSubview:self.checkingView];
    [self.checkingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //smile_cert_doing
    UIImageView *resultImageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"icon_wage_authenticating")];
    [self.checkingView addSubview:resultImageView];
    [resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkingView).with.offset(20);
        make.width.mas_equalTo(248);
        make.height.mas_equalTo(139);
        make.centerX.equalTo(self.checkingView);
    }];
    
    UILabel *resultLabel = [UILabel labelWithText:@"已提交审核，请耐心等待... " textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(16)];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.numberOfLines = 2;
    
    [self.checkingView addSubview:resultLabel];
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultImageView.mas_bottom).with.offset(20);
        //make.left.equalTo(self.checkingView).with.offset(30);
//        make.centerX.equalTo(self.checkingView);
        make.left.right.inset(40);
    }];
    
//    // loading
//    UIImageView *loadingImageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_home_loading")];
//    [self.checkingView addSubview:loadingImageView];
//    [loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(resultLabel.mas_bottom).with.offset(40);
//        make.width.height.mas_equalTo(16);
//        make.centerX.equalTo(self.checkingView);
//    }];
//
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 1.5;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = MAXFLOAT;
//    [loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = kThemeColorLine;
    [confirmButton setTitleColor:kThemeColorMain forState:UIControlStateNormal];
    confirmButton.titleLabel.font = FONT_PINGFANG_X(15);
    [confirmButton setTitle:@"返回首页" forState:UIControlStateNormal];
    ViewBorderRadius(confirmButton, 22, 0.01, UIColor.whiteColor);
    [self.checkingView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(resultLabel.mas_bottom).inset(20);
        make.left.right.inset(60);
        make.height.mas_equalTo(44);
    }];
    
    @weakify(self);
    [confirmButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self cancelButtonClicked];
    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showRiskResult:(ZXSDRiskResultType)type
{
    //248*139
    self.checkingView.hidden = YES;
    
    UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 97, 60, 194, 145)];
    
    NSString *imageName = @"icon_wage_authenticating";
    if (type == ZXSDRiskResultTypeReject) {
        imageName = @"smile_cert_fail";
    }
    else if(type == ZXSDRiskResultTypeAccept){
        imageName = @"icon_success";
        resultImageView.frame = CGRectMake((SCREEN_WIDTH()-120)/2, 60, 248, 120);
    }
    else{
        resultImageView.frame = CGRectMake((SCREEN_WIDTH()-248)/2, 60, 248, 139);
    }

    resultImageView.image = UIIMAGE_FROM_NAME(imageName);
    [self.view addSubview:resultImageView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(resultImageView.frame) + 20, SCREEN_WIDTH() - 40, 50)];
    contentLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 2;
    [self.view addSubview:contentLabel];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(60, CGRectGetMaxY(contentLabel.frame) + 40, SCREEN_WIDTH() - 120, 44);
    confirmButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.cornerRadius = 22.0;
    confirmButton.layer.masksToBounds = YES;
    [self.view addSubview:confirmButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(60, CGRectGetMaxY(confirmButton.frame) + 20, SCREEN_WIDTH() - 120, 44);
    cancelButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
    [cancelButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UICOLOR_FROM_HEX(0x999999) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 22.0;
    cancelButton.layer.masksToBounds = YES;
    [self.view addSubview:cancelButton];
    
    if (type == ZXSDRiskResultTypeReject) {
        NSString *tips = self.failTips;
        if (!CHECK_VALID_STRING(tips)) {
            tips = @"本次审核评分不足，您可以在 7 天之后重新提交";
        }
        contentLabel.text = tips;
        [confirmButton setTitle:@"返回首页" forState:UIControlStateNormal];
        cancelButton.hidden = YES;
    } else {
        contentLabel.text = @"恭喜您，审核通过";
        [confirmButton setTitle:@"立即预支" forState:UIControlStateNormal];
        cancelButton.hidden = NO;
    }
    
}

- (void)confirmButtonClicked
{
    if (self.riskResultType == ZXSDRiskResultTypeReject) {
        [self cancelButtonClicked];
    } else {
        // 立即预支
        ZXSDAdvanceSalaryInfoController *viewController = [ZXSDAdvanceSalaryInfoController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)cancelButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)transferRiskResult:(NSString *)result
{
    ZXSDRiskResultType type = ZXSDRiskResultTypeUndo;
    if ([result isEqualToString:@"Submit"]) {
        type = ZXSDRiskResultTypeDoing;
    } else if ([result isEqualToString:@"Reject"]) {
        type = ZXSDRiskResultTypeReject;
    } else if ([result isEqualToString:@"Accept"]) {
        type = ZXSDRiskResultTypeAccept;
    }
    self.riskResultType = type;
    if (type == ZXSDRiskResultTypeUndo) {
        [self cancelButtonClicked];
    } else if (type == ZXSDRiskResultTypeDoing) {
        // nothing
    } else {
        [self showRiskResult:type];
    }
}


- (UIView *)checkingView
{
    if (!_checkingView) {
        _checkingView = [UIView new];
        _checkingView.backgroundColor = [UIColor whiteColor];
    }
    return _checkingView;
}


@end
