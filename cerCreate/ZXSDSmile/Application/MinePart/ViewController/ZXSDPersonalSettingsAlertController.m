//
//  ZXSDPersonalSettingsAlertController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDPersonalSettingsAlertController.h"

@interface ZXSDPersonalSettingsAlertController ()

@end

@implementation ZXSDPersonalSettingsAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self addUserInterfaceConfigure];
}

- (void)addUserInterfaceConfigure {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 152)];
    backView.center = CGPointMake(self.view.center.x, self.view.center.y);
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 12.0;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];

    CGFloat currentWidth = backView.frame.size.width;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, currentWidth - 30, 28)];
    titleLabel.text = @"您确定要退出吗？";
    titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, 88, (currentWidth - 56)/2, 44);
    cancelButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UICOLOR_FROM_HEX(0x666666) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    [cancelButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 22.0;
    cancelButton.layer.masksToBounds = YES;
    [backView addSubview:cancelButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(currentWidth/2 + 8, 88, (currentWidth - 56)/2, 44);
    confirmButton.backgroundColor = kThemeColorMain;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.cornerRadius = 22.0;
    confirmButton.layer.masksToBounds = YES;
    [backView addSubview:confirmButton];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)confirmButtonClicked {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
