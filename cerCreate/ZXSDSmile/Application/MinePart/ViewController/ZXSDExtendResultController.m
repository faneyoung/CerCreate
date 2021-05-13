//
//  ZXSDExtendResultController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDExtendResultController.h"
#import "ZXSDAdvanceRecordsController.h"

@interface ZXSDExtendResultController ()

@end

@implementation ZXSDExtendResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUserInterfaceConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    HIDE_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
}

- (void)addUserInterfaceConfigure
{
    UIImageView *resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 41, NAVIBAR_HEIGHT() + 80, 82, 82)];
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
    
    switch (self.statusResult) {
        case ZXSDExtendSuccess:
            {
                resultImageView.image = UIIMAGE_FROM_NAME(@"smile_memeber_success");
                resultLab.textColor = UICOLOR_FROM_HEX(0x00B050);
                resultLab.text = @"展期成功";
                descLab.text = [NSString stringWithFormat:@"本次还款展期至 %@", self.extendValidDate];
            }
            break;
            
         case ZXSDExtendFailure:
            {
                resultImageView.image = UIIMAGE_FROM_NAME(@"smile_memeber_failure");
                resultLab.textColor = UICOLOR_FROM_HEX(0xFF4C00);
                resultLab.text = @"展期失败";
                if (self.extendFailure.length) {
                    descLab.text = self.extendFailure;
                } else {
                    descLab.text = @"抱歉，请稍后再尝试";
                }
            }
            break;
            
        case ZXSDRepaymentSuccess:
            {
                resultImageView.image = UIIMAGE_FROM_NAME(@"smile_memeber_success");
                resultLab.textColor = UICOLOR_FROM_HEX(0x00B050);
                resultLab.text = @"还款成功";
                descLab.text = @"恭喜您，已还清本次预支";
                
            }
            break;
            
         case ZXSDRepaymentFailure:
         {
             resultImageView.image = UIIMAGE_FROM_NAME(@"smile_memeber_failure");
             resultLab.textColor = UICOLOR_FROM_HEX(0xFF4C00);
             resultLab.text = @"还款失败";
             if (self.repaymentFailure.length > 0) {
                 descLab.text = self.repaymentFailure;
             } else {
                 descLab.text = @"抱歉，请稍后重试";
             }
             
         }
         break;
            
        default:
            break;
    }
    
    
    confirmButton.backgroundColor = UICOLOR_FROM_HEX(0x00B050);
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"返回到预支记录" forState:(UIControlStateNormal)];
    [confirmButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)goBack
{
    ZXSDAdvanceRecordsController *records = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZXSDAdvanceRecordsController class]]) {
            records = (ZXSDAdvanceRecordsController *)vc;
            break;
        }
    }
    
    if (records) {
        [self.navigationController popToViewController:records animated:NO];
    } else {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}


@end
