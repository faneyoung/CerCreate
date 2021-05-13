//
//  ZXSDUploadDetailsResultController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/16.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDUploadDetailsResultController.h"
#import "ZXSDUploadBankDetailsController.h"
#import "ZXSDUploadWechatDetailsController.h"
#import "ZXSDCertificationCenterController.h"

@interface ZXSDUploadDetailsResultController ()

@end

@implementation ZXSDUploadDetailsResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUserInterfaceConfigure];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)backToTaskCenter{
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_queue_after_S(0.4, ^{
        [URLRouter routeToTaskCenterTab];
    });
}

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


- (void)backButtonClicked:(id)sender
{
    if (self.canGoBack) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_queue_after_S(0.4, ^{
        [URLRouter routeToTaskCenterTab];
    });
}

- (void)addUserInterfaceConfigure {
    UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 97, 60, 194, 145)];
    [self.view addSubview:resultImageView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(resultImageView.frame) + 20, SCREEN_WIDTH() - 40, 30)];
    contentLabel.textColor = UICOLOR_FROM_HEX(0x3C465A);
    contentLabel.font = FONT_PINGFANG_X(16);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:contentLabel];
    
    UILabel *descLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(16)];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.frame = CGRectMake(20, CGRectGetMaxY(contentLabel.frame), SCREEN_WIDTH() - 40, 20);
    [self.view addSubview:descLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(60, CGRectGetMaxY(descLabel.frame) + 40, SCREEN_WIDTH() - 120, 44);
    [cancelButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = FONT_PINGFANG_X(16);
    [cancelButton addTarget:self action:@selector(backToEvaluationVC) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 22.0;
    cancelButton.layer.masksToBounds = YES;
    [self.view addSubview:cancelButton];
    
    BOOL isWechat = [self.certType isEqualToString:@"consumeInfo"];
    if ([self.certStatus isEqualToString:@"Success"]) {
        resultImageView.image = UIIMAGE_FROM_NAME(@"smile_cert_success");
        contentLabel.text = isWechat ? @"微信账单明细上传成功" : @"工资明细上传成功";
    } else if ([self.certStatus isEqualToString:@"Submit"]) {
        resultImageView.image = UIIMAGE_FROM_NAME(@"smile_cert_doing");
        contentLabel.text = isWechat ? @"微信账单明细正在认证中 …" : @"工资明细正在认证中 …";
    } else {
        //Fail
        resultImageView.image = UIIMAGE_FROM_NAME(@"smile_cert_fail");
        contentLabel.text = @"上传失败";
        //isWechat ? @"微信账单明细上传失败" : @"工资明细上传失败";
        descLabel.text = self.failureDesc;
    }
    
    // 认证中或者失败, 都可以重新上传
    if ([self.certStatus isEqualToString:@"Submit"] || [self.certStatus isEqualToString:@"Fail"]) {
        
        UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        retryButton.frame = CGRectMake(60, CGRectGetMaxY(descLabel.frame) + 40, SCREEN_WIDTH() - 120, 44);
        [retryButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        [retryButton setTitle:@"重新上传" forState:UIControlStateNormal];
        [retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        retryButton.titleLabel.font = FONT_PINGFANG_X(16);
        if (isWechat) {
            [retryButton addTarget:self action:@selector(retryButtonClickedWithWechat) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [retryButton addTarget:self action:@selector(retryButtonClickedWithBank) forControlEvents:UIControlEventTouchUpInside];
        }
        retryButton.layer.cornerRadius = 22.0;
        retryButton.layer.masksToBounds = YES;
        [self.view addSubview:retryButton];
        
        cancelButton.frame = CGRectMake(60, CGRectGetMaxY(retryButton.frame) + 20, SCREEN_WIDTH() - 120, 44);
        [cancelButton setBackgroundImage:[UIImage resizableImageWithGradient:@[UICOLOR_FROM_HEX(0xF7F9FB),UICOLOR_FROM_HEX(0xEAEFF2)] direction:UIImageGradientDirectionHorizontal] forState:(UIControlStateNormal)];
        [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
        [cancelButton setTitleColor:UICOLOR_FROM_HEX(0x626F8A) forState:UIControlStateNormal];
    }
}

- (void)retryButtonClickedWithBank {
    
//    ZXSDUploadBankDetailsController *viewController = [ZXSDUploadBankDetailsController new];
//    viewController.certType = self.certType;
//    [self.navigationController pushViewController:viewController animated:YES];

    __block BOOL hasOldVC = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:ZXSDUploadBankDetailsController.class]) {
            [self.navigationController popToViewController:obj animated:YES];
            hasOldVC = YES;
            *stop = YES;
        }
    }];
    
    if (!hasOldVC) {
        [self.navigationController popViewControllerAnimated:NO];
        [URLRouter routerUrlWithPath:kRouter_salaryInfo extra:@{@"certType":self.certType}];
    }
}

- (void)retryButtonClickedWithWechat {

//    ZXSDUploadWechatDetailsController *viewController = [ZXSDUploadWechatDetailsController new];
//    viewController.certType = self.certType;
//    [self.navigationController pushViewController:viewController animated:YES];

    __block BOOL hasOldVC = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:ZXSDUploadWechatDetailsController.class]) {
            [self.navigationController popToViewController:obj animated:YES];
            hasOldVC = YES;
            *stop = YES;
        }
    }];
    
    if (!hasOldVC) {
        [self.navigationController popViewControllerAnimated:NO];
        [URLRouter routerUrlWithPath:kRouter_consumeInfo extra:@{@"certType":self.certType}];
    }
}

@end
