//
//  ZXSDEntraceHolderController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDEntraceHolderController.h"
#import "ZXSDLoginService.h"
#import "ZXCerCreateViewController.h"

@interface ZXSDEntraceHolderController ()

@end

@implementation ZXSDEntraceHolderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHideNavigationBar = YES;
    self.window = [UIApplication sharedApplication].keyWindow;
    [self addUserInterfaceConfigure];
    //[self fetchConfigInfo];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [ZXSDLoginService judgeNextActionFrom:self withNavCtrl:self.navigationController];
//    });
    
    [self testBtns:@[@"continue",@"create"] action:^(UIButton * _Nonnull btn) {
        if (btn.tag == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZXSDLoginService judgeNextActionFrom:self withNavCtrl:self.navigationController];
            });
        }
        else if(btn.tag == 1){
            ZXCerCreateViewController *vc = [[ZXCerCreateViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];

}

- (void)addUserInterfaceConfigure {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *launchSlogan = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"launch_slogan")];
    [self.view addSubview:launchSlogan];
    [launchSlogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-75);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(60);
    }];
    
}


@end
