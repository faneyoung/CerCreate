//
//  ZXSDAdvanceSalaryResultController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAdvanceSalaryResultController.h"

//views
#import "CoverBackgroundView.h"
#import "ZXShareActionView.h"

#import "EPNetworkManager.h"
#import "ZXShareInfoModel.h"
#import "ZXShareManager.h"


@interface ZXSDAdvanceSalaryResultController ()

@property (nonatomic, strong) ZXShareInfoModel *shareInfo;

@end

@implementation ZXSDAdvanceSalaryResultController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
//    if (self.success) {
//        [self addUserInterfaceConfigureSuccess];
//    } else {
//        [self addUserInterfaceConfigure];
//    }
    
    [self requestShareInfo:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
}

#pragma mark - data handle -
- (void)requestShareInfo:(BOOL)loading{
    if (loading) {
        LoadingManagerShow();
    }
    
    [[EPNetworkManager defaultManager] getAPI:kShareInfoPath parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            if (loading) {
                [self handleRequestError:error];
            }
            return;
        }
        
        NSDictionary *result = response.originalContent;
        if (!IsValidDictionary(result)) {
            return;
        }
        
        self.shareInfo = [ZXShareInfoModel instanceWithDictionary:result];
        if (loading) {
            [self showShareActionView];
        }
        
    }];
}


#pragma mark - views -

- (void)addUserInterfaceConfigure {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH() - 40, 40)];
    titleLabel.text = @"预支的工资正在路上…";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x1A1A1A);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.0];
    [self.view addSubview:titleLabel];
    
    UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH() - 286)/2, CGRectGetMaxY(titleLabel.frame) + 40, 286, 202)];
    resultImageView.image = UIIMAGE_FROM_NAME(@"smile_loan_result");
    [self.view addSubview:resultImageView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(resultImageView.frame) + 20, SCREEN_WIDTH() - 40, 20)];
    contentLabel.text = @"请您耐心等待，去首页逛一逛？";
    contentLabel.textColor = UICOLOR_FROM_HEX(0x999999);
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:contentLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, CGRectGetMaxY(contentLabel.frame) + 50, SCREEN_WIDTH() - 40, 44);
    cancelButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [cancelButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 22.0;
    cancelButton.layer.masksToBounds = YES;
    [self.view addSubview:cancelButton];
}

- (void)addUserInterfaceConfigureSuccess {
    
    UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH() - 286)/2,  40, 286, 202)];
    resultImageView.image = UIIMAGE_FROM_NAME(@"smile_loan_success");
    [self.view addSubview:resultImageView];
    
    UILabel *status = [UILabel labelWithText:@"恭喜，预支成功" textColor:kThemeColorMain font:FONT_PINGFANG_X(20)];
    status.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *contentLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(14)];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(status.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
    }];
    contentLabel.text = [NSString stringWithFormat:@"¥%@ 已经成功到达您的工资卡上", self.loanAmount];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //cancelButton.frame = CGRectMake(20, CGRectGetMaxY(contentLabel.frame) + 40, SCREEN_WIDTH() - 40, 44);
    cancelButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [cancelButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 22.0;
    cancelButton.layer.masksToBounds = YES;
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    [AppUtility showAppstoreEvaluationView];
}

- (void)setupSubViews{
    
    UIImageView *resultImageView = [[UIImageView alloc] init];
    resultImageView.image = UIIMAGE_FROM_NAME(@"icon_success");
    [self.view addSubview:resultImageView];
    [resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(40);
        make.centerX.offset(0);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *status = [UILabel labelWithText:@"预支成功" textColor:kThemeColorMain font:FONT_PINGFANG_X(20)];
    status.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultImageView.mas_bottom).inset(21);
        make.centerX.offset(0);
        make.height.mas_equalTo(28);
    }];
    
    UILabel *contentLabel = [UILabel labelWithText:@"" textColor:TextColor999999 font:FONT_PINGFANG_X(14)];
    contentLabel.text = @"预支的工资正在路上…";
    [self.view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(status.mas_bottom).inset(12);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *btn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"炫耀一下" textColor:TextColorSubTitle];
    btn.backgroundColor = UIColor.whiteColor;
    [btn addTarget:self action:@selector(showoffClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).inset(20);
        make.left.right.inset(88);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(btn, 22, 1, UICOLOR_FROM_HEX(0x979797));

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = FONT_PINGFANG_X(14);
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 22.0;
    cancelButton.layer.masksToBounds = YES;
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).inset(14);
        make.left.right.inset(88);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(cancelButton, 22, 0.01, UIColor.whiteColor);
    
    
    [AppUtility showAppstoreEvaluationView];
}


#pragma mark - help methods -

- (void)showShareActionView{
    [ZXShareManager.sharedManager showImageShareViewWithInfo:self.shareInfo];
}


#pragma mark - action methods -

- (void)showoffClicked{
    
    if (!self.shareInfo) {
        [self requestShareInfo:YES];
    }
    else{
        [self showShareActionView];
    }
    
}

- (void)cancelButtonClicked {

    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_REFRESH_HOME object:nil];

}



@end
