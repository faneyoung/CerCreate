//
//  ZXSDMandatoryRequirementController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/8.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDMandatoryRequirementController.h"
#import "ZXSDAgreementAlertView.h"
#import "ZXSDNavigationController.h"

@interface ZXSDMandatoryRequirementController () {
    NSString *_promptString;
    NSString *_requirementStirng;
    
    ZXSDAgreementAlertView *_promptView;
    ZXSDAgreementAlertView *_requirementView;
    ZXSDAgreementAlertView *_logoutView;
}

@end

@implementation ZXSDMandatoryRequirementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHideNavigationBar = YES;
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
}

- (void)prepareDataConfigure {
    _promptString = @"欢迎使用薪朋友 App，在您使用前请仔细阅读《薪朋友用户服务协议》、《薪朋友平台用户隐私政策》、《个人综合信息授权书》，我们将严格遵守您同意的各项条款使用您的信息，以便为您更好的服务。点击“同意”意味着您自觉遵守以上协议，我们将严格保护您的个人信息，确保信息的安全。";
    _requirementStirng = @"我们将严格保护您的个人信息，仅用于为您提供服务或提升服务体验，\n若您不同意本隐私政策，很遗憾我们将无法为您提供服务。";
}

- (void)addUserInterfaceConfigure {
    self.view.backgroundColor = [UIColor whiteColor];
    /*
    UIImageView *launchBG = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"launch_background")];
    launchBG.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:launchBG];
    [launchBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(launchBG.mas_width).with.multipliedBy(551.0/414.0);

    }];
    
    
    UIImageView *launchPerson = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"launch_person")];
    [self.view addSubview:launchPerson];
    [launchPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(124);
        make.left.equalTo(self.view).offset(32.5);
        make.centerX.equalTo(self.view);
        make.height.equalTo(launchPerson.mas_width).with.multipliedBy(33.0/31.0);
    }];
    
    UIImageView *launchSlogan = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"launch_slogan")];
    [self.view addSubview:launchSlogan];
    [launchSlogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-89);
        make.top.greaterThanOrEqualTo(launchPerson.mas_bottom).offset(35);
        make.left.equalTo(self.view).offset(40);
        make.width.mas_equalTo(257);
        make.height.mas_equalTo(89);
    }];*/
    
    
    UIImageView *launchSlogan = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"launch_slogan")];
    [self.view addSubview:launchSlogan];
    [launchSlogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-75);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(60);
    }];
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.frame];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:maskView];
    
    [self addUserInterfaceConfigureWithPrompt];
}


//加载隐私协议页面
- (void)addUserInterfaceConfigureWithPrompt {
    if (!_promptView) {
        _promptView = [[ZXSDAgreementAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) alertTitle:@"温馨提示" alertTitleLines:1 alertContent:_promptString hasJumpLink:YES cancelButtonTitle:@"不同意" andConfirmButtonTitle:@"同意"];
    }
    _promptView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _promptView.userInteractionEnabled = YES;
    _promptView.hidden = NO;
    
    @weakify(self);
    _promptView.confirmBlock = ^{
        @strongify(self);
        [self jumpToUserLoginController];
    };
    _promptView.userAgreementBlock = ^{
        @strongify(self);
        [self jumpToUserAgreementController];
    };
    _promptView.privacyAgreementBlock = ^{
        @strongify(self);
        [self jumpToPrivacyAgreementController];
    };
    _promptView.personalPrivacyBlock = ^{
        @strongify(self);
        [self jumpToPersernalPrivacyAgreementController];
    };
    _promptView.cancelBlock = ^{
        @strongify(self);
        [self adduserInterfaceConfigureWithRequirement];
    };
    
    
    
    [self.view addSubview:_promptView];
}

//查看用户协议
- (void)jumpToUserAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,USER_SERVICE_URL];
    
    viewController.title = @"薪朋友用户服务协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

//查看隐私协议
- (void)jumpToPrivacyAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,PRIVACY_AGREEMENT_URL];
    
    viewController.title = @"薪朋友平台用户隐私政策";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)jumpToPersernalPrivacyAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,PERSONAL_INFO_AGREEMENT_URL];
    
    viewController.title = @"个人综合信息授权书";
    [self.navigationController pushViewController:viewController animated:YES];
}

//同意相关协议,直接跳转登录页
- (void)jumpToUserLoginController {
    if (self.jumpAgreementBlock) {
        self.jumpAgreementBlock();
    }
}

//不同意协议，强制引导一次
- (void)adduserInterfaceConfigureWithRequirement {
    _promptView.hidden = YES;
    
    if (!_requirementView) {
        _requirementView = [[ZXSDAgreementAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) alertTitle:@"您需要同意本隐私权政策才能继续使用薪朋友" alertTitleLines:2 alertContent:_requirementStirng hasJumpLink:NO cancelButtonTitle:@"仍不同意" andConfirmButtonTitle:@"查看协议"];
    }
    _requirementView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _requirementView.userInteractionEnabled = YES;
    _requirementView.hidden = NO;
    WEAKOBJECT(self);
    _requirementView.confirmBlock = ^{
        [weakself showPromptView];
    };
    _requirementView.cancelBlock = ^{
        [weakself showLogoutView];
    };
    [self.view addSubview:_requirementView];
}

//引导成功，返回同意协议
- (void)showPromptView {
    _requirementView.hidden = YES;
    _promptView.hidden = NO;
}

//引导失败，显示退出应用
- (void)showLogoutView {
    _requirementView.hidden = YES;
    
    if (!_logoutView) {
        _logoutView = [[ZXSDAgreementAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 150) alertTitle:@"您要不要再想想 ?" alertTitleLines:1 alertContent:@"" hasJumpLink:NO cancelButtonTitle:@"退出应用" andConfirmButtonTitle:@"再次查看"];
    }
    _logoutView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _logoutView.userInteractionEnabled = YES;
    _logoutView.hidden = NO;
    WEAKOBJECT(self);
    _logoutView.confirmBlock = ^{
        [weakself showPromptViewAgain];
    };
    _logoutView.cancelBlock = ^{
        [weakself exitApplication];
    };
    [self.view addSubview:_logoutView];
}

//再次引导成功，返回同意协议
- (void)showPromptViewAgain {
    _logoutView.hidden = YES;
    _promptView.hidden = NO;
}

//再次引导失败，退出应用
- (void)exitApplication {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    //运行一个不存在的方法,退出界面更加圆滑
//    [self performSelector:@selector(notExistCall)];
//    abort();
//#pragma clang diagnostic pop
    exit(0);
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
