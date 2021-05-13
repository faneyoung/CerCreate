//
//  ZXSDNecessaryCertResultController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/18.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDNecessaryCertResultController.h"
#import "ZXSDCertificationCenterController.h"
#import "ZXSDQueryCompanyInfoController.h"

@interface ZXSDNecessaryCertResultController ()

@end

@implementation ZXSDNecessaryCertResultController

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
    
    [self addUserInterfaceConfigure];
}


- (void)addUserInterfaceConfigure {
    UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 55, 58, 110, 110)];
    resultImageView.image = UIIMAGE_FROM_NAME(@"smile_plus_user");
    [self.view addSubview:resultImageView];
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(resultImageView.frame) + 20, SCREEN_WIDTH() - 120, 50)];
    resultLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    resultLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.numberOfLines = 0;
    [self.view addSubview:resultLabel];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(60, CGRectGetMaxY(resultLabel.frame) + 40, SCREEN_WIDTH() - 120, 44);
    //confirmButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [confirmButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.cornerRadius = 22.0;
    confirmButton.layer.masksToBounds = YES;
    [self.view addSubview:confirmButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(60, CGRectGetMaxY(confirmButton.frame) + 20, SCREEN_WIDTH() - 120, 44);
    cancelButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
    [cancelButton setTitle:@"回到首页" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UICOLOR_FROM_HEX(0x999999) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 22.0;
    cancelButton.layer.masksToBounds = YES;
    [self.view addSubview:cancelButton];
    
    if ([self.reviewStatus isEqualToString:ZXSDHomeUserApplyStatus_EMPLOYER_REJECT]) {
        NSString *reason = self.failReason.length > 0 ? self.failReason:@"雇主员工中无法找到您，请输入您的真实雇主信息";
        resultLabel.text = reason;
        [confirmButton setTitle:@"修改雇主信息" forState:UIControlStateNormal];
    } else {
        resultLabel.text = @"您是 薪朋友 合作雇主的员工，正在等待雇主审核…";
        [confirmButton setTitle:@"继续其它认证" forState:UIControlStateNormal];
    }
    
}

- (void)confirmButtonClicked {
    if ([self.reviewStatus isEqualToString: ZXSDHomeUserApplyStatus_EMPLOYER_REJECT]) {
        ZXSDQueryCompanyInfoController *viewController = [ZXSDQueryCompanyInfoController new];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
//        ZXSDCertificationCenterController *viewController = [ZXSDCertificationCenterController new];
//        [self.navigationController pushViewController:viewController animated:YES];

        [self.navigationController popToRootViewControllerAnimated:NO];
        dispatch_queue_after_S(0.4, ^{
            [URLRouter routeToTaskCenterTab];
        });

    }
}

- (void)cancelButtonClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
