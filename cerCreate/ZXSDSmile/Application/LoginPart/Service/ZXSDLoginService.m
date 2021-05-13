//
//  ZXSDLoginService.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/25.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDLoginService.h"
#import <WXApi.h>
#import <UMShare/UMShare.h>

#import "ZXSDSmileUUID.h"
#import "ZXSDSystemInformation.h"
#import "EPNetworkManager+Login.h"

#import "ZXSDNavigationController.h"
#import "ZXSDBaseTabBarController.h"
#import "ZXSDEntraceHolderController.h"
#import "ZXSDPhoneNumberLoginController.h"
#import "ZXSDChooseEmployerController.h"
#import "ZXSDVerifyUserinfoController.h"
#import "ZXSDVerifyBankCardController.h"
#import "ZXWechatBindPhoneViewController.h"

#import "ZXLocationManager.h"

#import "EPNetworkManager.h"


@interface ZXSDLoginService ()

@property (nonatomic, strong) UIViewController *basedController;
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@property (nonatomic, strong) UIView *otherLoginView;
@property (nonatomic, strong) UIButton *otherLoginBtn;
@property (nonatomic, strong) NSString *openid;

@end

@implementation ZXSDLoginService

+ (instancetype)sharedService
{
    static ZXSDLoginService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZXSDLoginService new];
    });
    return instance;
}

+ (void)startYJLogin:(UIViewController *)authController
{
    [ZXAppTrackManager event:kOnekeyLoginPage];
    
    [[ZXSDLoginService sharedService] clearProgressHUD];
    [ZXSDLoginService sharedService].basedController = authController;
    YJYZUIModel *model = [self configYJYZUIModel:authController];
    
    [YJYZSDK yjyzAuthLoginWithModel:model completion:^(NSDictionary * _Nullable resultDic, NSError * _Nullable error) {
        
        [[ZXSDLoginService sharedService] configNavigationBar];

        if (!error) {
            ZGLog(@"一键登录成功===%@", resultDic);
            [self bindUserInfoWithYJLogin:resultDic];
        } else {
            //手动关闭界面的时候使用
            //990602 调用finish函数关闭登录VC
            //990204 取消一键登录
            if (error.code != 990602 && error.code != 990204) {
                ZGLog(@"一键登录失败===%@", error.description);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[ZXSDLoginService sharedService] showToastWithText:@"请稍后重试"];
                    [YJYZSDKManager yjyzReLoginVCEnable];
                });
            }
        }
    }];
}

+ (void)startSMSLogin:(UIViewController *)fromController
{
     while (fromController.presentedViewController){
         fromController = fromController.presentedViewController;
     }
    
    [ZXSDLoginService sharedService].basedController = fromController;
    ZXSDPhoneNumberLoginController *vc = [[ZXSDPhoneNumberLoginController alloc] init];
    ZXSDNavigationController *nav = [[ZXSDNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [fromController presentViewController:nav animated:YES completion:^{
    }];
}

+ (void)startAutoLogin:(UIViewController *)fromController
{
    while (fromController.presentedViewController){
        fromController = fromController.presentedViewController;
    }

    [ZXSDLoginService sharedService].basedController = fromController;
    ZXSDEntraceHolderController *vc = [[ZXSDEntraceHolderController alloc] init];
    ZXSDNavigationController *nav = [[ZXSDNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [fromController presentViewController:nav animated:YES completion:^{
    }];
}

#pragma mark - Action

// 一键登录路径
+ (void)judgeNextAction
{
    UINavigationController *nav = YJYZSDKManager.yjyzAuthViewController.navigationController;
    
    [[ZXSDLoginService sharedService] showLoadingProgressHUDWithText:@"正在加载..."];
    [[ZXSDCurrentUser currentUser] queryUserEmployerInfo:^(BOOL selectedCompany, BOOL confrimedEmployee, BOOL bindBankCard, NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[ZXSDLoginService sharedService] dismissLoadingProgressHUD];
//#warning --test--
//        error = [NSError new];
//#warning --test--

        if (error) {
            NSString *message = error.localizedDescription;
            if (!CHECK_VALID_STRING(message)) {
                message = @"请稍后重试";
            }
            ToastShow(message);

            return;
        }
        
        if (!selectedCompany) {
            // 是否已经选择了其他企业
            NSString *userId = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
            NSString *key = [NSString stringWithFormat:@"%@_%@", USER_INITIAL_COMPANY_OTHER, userId];
            
            BOOL marked = [[ZXSDUserDefaultHelper readValueForKey:key] boolValue];
            if (marked) {
                [self gotoMainHome:nav];
            } else {
                ZXSDChooseEmployerController *vc = [ZXSDChooseEmployerController new];
                [nav pushViewController:vc animated:YES];
            }
            
            return;
        }
        
        BOOL queryMode = [ZXSDCurrentUser currentUser].businessModel == ZXSDCooperationModelEmployerQuery;
        
        if (queryMode) {
            if (!confrimedEmployee) {
                ZXSDVerifyUserinfoController *vc = [ZXSDVerifyUserinfoController new];
                vc.fromLogin = YES;
                [nav pushViewController:vc animated:YES];
                return;
            }
            
            if (!bindBankCard) {
                ZXSDVerifyBankCardController *vc = [ZXSDVerifyBankCardController new];
                vc.bindCard = YES;
                [vc setBindCardCompleted:^(BOOL success, NSError * _Nullable error) {
                    
                    if (success) {
                        [self gotoMainHome:nav];
                    }
                }];
                [nav pushViewController:vc animated:YES];
                return;
            }
            
            [self gotoMainHome:nav];
            
            
        } else {
            [self gotoMainHome:nav];
        }
    }];
}

// 验证码登录&&自动登录路径
+ (void)judgeNextActionFrom:(ZXSDBaseViewController *)controller
      withNavCtrl:(UINavigationController *)navController
{
    // 自动登录情况下特殊处理, 部分页面禁止返回
    BOOL autoLogin = NO;
    if (navController.viewControllers.count == 1) {
        
        UIViewController *top = navController.topViewController;
        if ([top isKindOfClass:[ZXSDEntraceHolderController class]]) {
            autoLogin = YES;
        }
    }
    
    [controller showLoadingProgressHUDWithText:@"正在加载..."];
    [[ZXSDCurrentUser currentUser] queryUserEmployerInfo:^(BOOL selectedCompany, BOOL confrimedEmployee, BOOL bindBankCard, NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [controller dismissLoadingProgressHUD];
        if (error) {
            [controller showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
            return;
        }
        
        
        if (!selectedCompany) {
            
            // 是否已经选择了其他企业
            NSString *userId = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
            NSString *key = [NSString stringWithFormat:@"%@_%@", USER_INITIAL_COMPANY_OTHER, userId];
            BOOL marked = [[ZXSDUserDefaultHelper readValueForKey:key] boolValue];
            if (marked) {
                [self gotoMainHome:navController];
            } else {
                ZXSDChooseEmployerController *vc = [ZXSDChooseEmployerController new];
                [navController pushViewController:vc animated:YES];
            }
            return;
        }
        
        BOOL queryMode = [ZXSDCurrentUser currentUser].businessModel == ZXSDCooperationModelEmployerQuery;
        
        if (queryMode) {
            if (!confrimedEmployee) {
                ZXSDVerifyUserinfoController *vc = [ZXSDVerifyUserinfoController new];
                vc.forbidBack = autoLogin;
                vc.fromLogin = YES;
                [navController pushViewController:vc animated:YES];
                return;
            }
            
            if (!bindBankCard) {
                ZXSDVerifyBankCardController *vc = [ZXSDVerifyBankCardController new];
                vc.bindCard = YES;
                vc.forbidBack = autoLogin;
                [vc setBindCardCompleted:^(BOOL success, NSError * _Nullable error) {
                    
                    if (success) {
                        [self gotoMainHome:navController];
                    }
                }];
                [navController pushViewController:vc animated:YES];
                return;
            }
            
            [self gotoMainHome:navController];
            
            
        } else {
            [self gotoMainHome:navController];
        }
    }];
}

+ (void)gotoMainHome:(UINavigationController *)navController
{
    /**
    * 1 YJYZSDK巨坑：使用yjyzAuthLoginWithModel调起的授权页, 必须使用yjyzManualCloseLoginVc关闭;
    *2 如果授权页使用其他方法关闭（比如[navController dismissViewControllerAnimated]），但是下次再使用yjyzAuthLoginWithModel调授权页无效果
    *
    */
    
    __block BOOL fromYJYZEntrace = NO;
    
    if ([navController isKindOfClass:NSClassFromString(@"UAAuthViewController")]) {
        fromYJYZEntrace = YES;
    }
    else{
        [navController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UAAuthViewController")] ||
                [obj isKindOfClass:NSClassFromString(@"EAccountAuthenticateViewController")]) {
                fromYJYZEntrace = YES;
                *stop = YES;
            }
        }];
    }
    
//    if ([[navController.viewControllers firstObject] isKindOfClass:NSClassFromString(@"UAAuthViewController")]) {
//        fromYJYZEntrace = YES;
//    }

    if (!fromYJYZEntrace) {
        [navController dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_REFRESH_HOME object:nil];
        }];



    } else {
        [YJYZSDK yjyzManualCloseLoginVc:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_REFRESH_HOME object:nil];
        }];
    }
    
    
    [ZXSDCurrentUser registerAliasForJPush];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[ZXLocationManager  sharedManger] requestLocationAuth];
//    });
}

+ (void)otherLoginBtnClicked:(UIButton*)btn{
    
    UINavigationController *nav = YJYZSDKManager.yjyzAuthViewController.navigationController;
    [[ZXSDLoginService sharedService] configNavigationBar];

    if ([btn.currentTitle isEqualToString:@"切换号码"]) {
        ZXSDPhoneNumberLoginController *vc = [ZXSDPhoneNumberLoginController new];
        vc.isCanBack = YES;
        [nav pushViewController:vc animated:YES];
    }
    else{
        ZXWechatBindPhoneViewController *bindVC = [[ZXWechatBindPhoneViewController alloc] init];
        bindVC.openid = [ZXSDLoginService sharedService].openid;
        [nav pushViewController:bindVC animated:YES];
    }
}

///微信登录
+ (void)wechatLoginBtnClick{
    //调起微信授权
    [ZXSDLoginService wxAuthComplete:^(NSDictionary *params, NSError *error) {
        
        if (error) {
           NSString *errMsg = [error.userInfo stringObjectForKey:@"message"];
            [EasyTextView showText:errMsg];
            return;
        }
        
        ///微信App登录
        [ZXSDLoginService weixinAppLoginWithDic:params];
        
    }];

}

#pragma mark - Tools

// 一键登录成功后获取用户信息
+ (void)bindUserInfoWithYJLogin:(NSDictionary *)dic
{
    NSString *operatorToken = [dic safty_objectForKey:@"operatorToken"];
    NSString *operatorType = [dic safty_objectForKey:@"operatorType"];
    NSString *token = [dic safty_objectForKey:@"token"];
    
    NSMutableDictionary * parameters = @{}.mutableCopy;
    [parameters setSafeValue:operatorToken forKey:@"opToken"];
    [parameters setSafeValue:operatorType forKey:@"operator"];
    [parameters setSafeValue:token forKey:@"token"];
    [parameters setSafeValue:@"ios" forKey:@"deviceplatform"];
    [parameters setSafeValue:[ZXSDLoginService sharedService].openid forKey:@"openid"];
    
    [[ZXSDLoginService sharedService] showLoadingProgressHUDWithText:@"登录中..."];
    __block NSURLSessionDataTask *task = nil;
    task = [EPNetworkManager doYJLoginWithParams:parameters completion:^(NSString *phone, NSError *error) {
        [[ZXSDLoginService sharedService] dismissLoadingProgressHUD];

        if (error) {
            NSString *message = error.localizedDescription;
            if (!CHECK_VALID_STRING(message)) {
                message = @"请稍后重试";
            }
            ToastShow(message);
            return;
        }
        [ZXAppTrackManager event:kOnekeyLogin];
        
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse*)task.response;
        NSDictionary *headersDic = httpURLResponse.allHeaderFields;
        NSString *userSession = [headersDic objectForKey:@"USER-SESSION"];
        
        [self saveSession:userSession phone:phone];
        [self uploadDeviceInfo];
        
        [self judgeNextAction];
        
    }];
}

// 上传设备信息
+ (void)uploadDeviceInfo
{
    NSString *uuid = [[ZXSDSmileUUID sharedInsance] getUUID];
    NSString *deviceType = [ZXSDSystemInformation deviceVersion];
    NSString *os = [ZXSDSystemInformation systemVersion];
    NSString *idfv = [ZXSDSystemInformation idfv];
    NSString *idfa = [ZXSDSystemInformation idfa];
    NSString *screen = [ZXSDSystemInformation screen];
    NSString *userAgent = [NSString stringWithFormat:@"%@%@",USER_AGENT,APP_VERSION()];
    
    NSString *operator = [[ZXSDGlobalObject sharedGlobal] operatorName];
    NSString *networkState = [[ZXSDGlobalObject sharedGlobal] networkState];
    
    if (!CHECK_VALID_STRING(operator)) {
        operator = @"";
    }
    if (!CHECK_VALID_STRING(networkState)) {
        networkState = @"";
    }
    
    NSDictionary *parameters = @{
        @"channel":@"Apple",
        @"deviceId":uuid,
        @"idfa":idfa,
        @"deviceType":deviceType,
        @"idfv":idfv,
        @"os":os,
        @"screen":screen,
        @"userAgent":userAgent,
        @"networkState":networkState,
        @"operator":operator
        
    };
    
    [EPNetworkManager uploadDeviceInformation:parameters completion:^(NSError * _Nonnull error) {
        if (error) {
            ZGLog(@"设备信息上传失败- %@",error);
        } else {
            ZGLog(@"设备信息上传成功");
        }
    }];
}

// 保存用户信息
+ (void)saveSession:(NSString *)userSession phone:(NSString *)phone
{
    [ZXSDUserDefaultHelper storeValueIntoUserDefault:userSession forKey:KEEPLOGINSTATUSSESSION];
    [ZXSDUserDefaultHelper storeValueIntoUserDefault:phone forKey:KEEPLOGINSTATUSUSERID];
    if (CHECK_VALID_STRING(userSession)) {
        [ZXSDPublicClassMethod setCookieWithName:KEEPLOGINSTATUSSESSION andValue:userSession andDomainUrl:DOMAINURL];
    }
    
    if (CHECK_VALID_STRING(phone)) {
        [ZXSDPublicClassMethod setCookieWithName:KEEPLOGINSTATUSUSERID andValue:phone andDomainUrl:DOMAINURL];
    }
    
    [ZXSDCurrentUser currentUser].phone = phone;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_notification_userLogin object:nil];
}

+ (YJYZUIModel *)configYJYZUIModel:(UIViewController *)authController
{
    YJYZUIModel *model = [[YJYZUIModel alloc] init];
    model.manualDismiss = @(YES);
    model.yjyzAnimateType = [NSNumber numberWithInt:0];
    model.authViewController = authController;
    model.yjyzSwitchHidden = @(YES);
    model.yjyzLogoHidden = @(YES);
    //model.yjyzHiddenLoading = @(YES);
    model.yjyzBackgroundColor = [UIColor whiteColor];
    model.yjyzNavBackgroundImage = [ZXSDPublicClassMethod initImageFromColor:UICOLOR_FROM_HEX(0xFFFFFF) Size:CGSizeMake(SCREEN_WIDTH(), NAVIBAR_HEIGHT())];
    model.yjyzNavLeftControlHidden = @(YES);
    model.yjyzNavBarTintColor = UICOLOR_FROM_HEX(0x666666);
    model.yjyzNavText = @"";
    
    
    //运营商品牌
    model.yjyzSloganTextFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
    model.yjyzSloganTextColor = UICOLOR_FROM_HEX(0x999999);
    model.yjyzSloganTextAlignment = @(NSTextAlignmentCenter);
    
    //手机号
    model.yjyzNumberColor = UICOLOR_FROM_HEX(0x666666);
    model.yjyzNumberFont = FONT_SFUI_X_Medium(20);
    model.yjyzNumberTextAlignment = @(NSTextAlignmentCenter);
    
    //登录按钮
    model.yjyzLoginBtnText = @"一键登录";
    model.yjyzLoginBtnTextColor = [UIColor whiteColor];
    model.yjyzLoginBtnCornerRadius = @(22);
    model.yjyzLoginBtnTextFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    model.yjyzLoginBtnBgImgArr = @[MAIN_BUTTON_BACKGROUND_IMAGE];
    
    //隐私协议
    model.yjyzPrivacyTextColor = UICOLOR_FROM_HEX(0x999999);
    model.yjyzCheckHidden = @(YES);
    model.yjyzCheckedImg = UIImageNamed(@"choose_employer_checked");
    model.yjyzUncheckedImg = UIImageNamed(@"choose_employer_uncheck");
    model.yjyzCheckDefaultState = @(YES);
    model.yjyzPrivacyAppName = @"";
    model.yjyzPrivacyTextFont = FONT_PINGFANG_X(12);
    model.yjyzPrivacyTextAlignment = @(NSTextAlignmentCenter);
    model.yjyzPrivacyAgreementColor = UICOLOR_FROM_HEX(0x4472C4);
    model.yjyzPrivacyProtocolMarkArr = @[@"《",@"》"];
    model.yjyzPrivacyFirstTextArr = @[@"薪朋友用户服务协议",[NSString stringWithFormat:@"%@%@",H5_URL,USER_SERVICE_URL],@"、"];
    model.yjyzPrivacySecondTextArr = @[@"薪朋友平台用户隐私政策",[NSString stringWithFormat:@"%@%@",H5_URL,PRIVACY_AGREEMENT_URL],@"、"];
    model.yjyzPrivacyThirdTextArr = @[@"个人综合信息授权书",[NSString stringWithFormat:@"%@%@",H5_URL,PERSONAL_INFO_AGREEMENT_URL],@"、"];

    model.yjyzPrivacyNormalTextFirst = @"登录即代表已同意";
    model.yjyzPrivacyNormalTextSecond = @"";
    model.yjyzPrivacyNormalTextThird = @"";
    model.isPrivacyOperatorsLast = @(YES);
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:19.f],NSForegroundColorAttributeName:COMMON_APP_NAVBARTITLE_COLOR};
    
    NSAttributedString *title1 = [[NSAttributedString alloc] initWithString:@" 薪朋友用户服务协议" attributes:attributes];
    NSAttributedString *title2 = [[NSAttributedString alloc] initWithString:@"薪朋友平台用户隐私政策" attributes:attributes];
    NSAttributedString *title3 = [[NSAttributedString alloc] initWithString:@"个人综合信息授权书" attributes:attributes];
    model.privacytitleArray = @[title1,title2,title3];
    
    
    //隐私协议Web
    model.yjyzPrivacyWebBackBtnImage = UIIMAGE_FROM_NAME(@"smile_back");
    
    //自定义控件
    [model setCustomViewBlock:^(UIView *customView) {
        
        UIImageView *logoImgView = [[UIImageView alloc] init];
        logoImgView.image = UIImageNamed(@"icon_oneLogin_logo");
        [customView addSubview:logoImgView];
        [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(8);
            make.centerX.offset(0);
            make.width.mas_equalTo(73);
            make.height.mas_equalTo(90);
        }];
        
        UIImageView *desImgView = [[UIImageView alloc] init];
        desImgView.image = UIImageNamed(@"icon_oneLogin_des");
        [customView addSubview:desImgView];
        [desImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(logoImgView.mas_bottom).inset(12);
            make.centerX.offset(0);
            make.width.mas_equalTo(102);
            make.height.mas_equalTo(32);
        }];

        
        
        //其它手机号登录按钮
        UIButton *otherLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherLoginBtn.frame = CGRectMake(20, 310, SCREEN_WIDTH()-2*20, 44);
        [otherLoginBtn setBackgroundImage:[UIImage resizableImageWithGradient:@[UIColorFromHex(0xF7F9FB),UIColorFromHex(0xEAEFF2)] direction:UIImageGradientDirectionHorizontal] forState:(UIControlStateNormal)];
        [otherLoginBtn setTitle:@"切换号码" forState:UIControlStateNormal];
        [otherLoginBtn setTitleColor:UIColorFromHex(0x626F8A) forState:UIControlStateNormal];
        otherLoginBtn.titleLabel.font = FONT_PINGFANG_X(16);
        otherLoginBtn.layer.cornerRadius = 22.0;
        otherLoginBtn.layer.masksToBounds = YES;
        [customView addSubview:otherLoginBtn];
        [otherLoginBtn addTarget:self action:@selector(otherLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [ZXSDLoginService sharedService].otherLoginBtn = otherLoginBtn;

        
        if ([WXApi isWXAppInstalled]) {
            UIView *otherLoginView = [[UIView alloc] init];
            otherLoginView.frame = CGRectMake(0, CGRectGetMaxY(otherLoginBtn.frame)+50, SCREEN_WIDTH(), 92);
            
            UILabel *otherLab = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:TextColorPlacehold font:FONT_PINGFANG_X(14)];
            otherLab.frame = CGRectMake((SCREEN_WIDTH() - 84)/2, 0, 84, 20);
            otherLab.text = @"其他登录方式";
            [otherLoginView addSubview:otherLab];
            
            UILabel *leftLine = [UILabel sepLab];
            leftLine.frame = CGRectMake(20, CGRectGetMidY(otherLab.frame), CGRectGetMinX(otherLab.frame)-2*20, 1);
            [otherLoginView addSubview:leftLine];
            
            UILabel *rightLine = [UILabel sepLab];
            rightLine.frame = CGRectMake(CGRectGetMaxX(otherLab.frame) + 20, CGRectGetMidY(leftLine.frame), CGRectGetWidth(leftLine.frame), 1);
            [otherLoginView addSubview:rightLine];
            
            UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            wechatBtn.frame = CGRectMake((SCREEN_WIDTH() - 40)/2, CGRectGetMaxY(otherLab.frame)+25, 40, 40);
            [wechatBtn setImage:UIImageNamed(@"icon_oneLogin_wechat") forState:UIControlStateNormal];
            [wechatBtn addTarget:self action:@selector(wechatLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [otherLoginView addSubview:wechatBtn];
            
            [customView addSubview:otherLoginView];

            [ZXSDLoginService sharedService].otherLoginView = otherLoginView;
        }
        
        
    }];
    
    
    YjyzVerifyCustomLayouts *layouts = nil;
    if (!model.portraitLayouts) {
        layouts = [[YjyzVerifyCustomLayouts alloc] init];
    } else {
        layouts = model.portraitLayouts;
    }
    
    //手机号码布局
    if (!layouts.yjyzPhoneLayout) {
        YjyzVerifyLayout *layout = [[YjyzVerifyLayout alloc] init];
        layout.yjyzLayoutTop = @(170);
        layout.yjyzLayoutCenterX = @(0);
//        layout.yjyzLayoutLeft = @(20);
        layout.yjyzLayoutHeight = @(30);
        
        layouts.yjyzPhoneLayout = layout;
    }
    
    //运营商品牌布局
    if (!layouts.yjyzSloganLayout) {
        YjyzVerifyLayout *layout = [[YjyzVerifyLayout alloc] init];
        layout.yjyzLayoutTop = @(210);
        layout.yjyzLayoutCenterX = @(0);
//        layout.yjyzLayoutLeft = @(20);
        //layout.yjyzLayoutWidth = @(SCREEN_WIDTH() - 40);
        layout.yjyzLayoutHeight = @(20);
        
        layouts.yjyzSloganLayout = layout;
    }
    
    //登录按钮布局
    if (!layouts.yjyzLoginLayout) {
        YjyzVerifyLayout *layout = [[YjyzVerifyLayout alloc] init];
        layout.yjyzLayoutTop = @(250);
        layout.yjyzLayoutCenterX = @(0);
        layout.yjyzLayoutWidth = @(SCREEN_WIDTH() - 40);
        layout.yjyzLayoutHeight = @(44);
        
        layouts.yjyzLoginLayout = layout;
    }
    
    //隐私条款
    if (!layouts.yjyzPrivacyLayout) {
        CGFloat height = 60;
        YjyzVerifyLayout *layout = [[YjyzVerifyLayout alloc] init];
        layout.yjyzLayoutHeight = @(height);
        layout.yjyzLayoutBottom = @(-16-kBottomSafeAreaHeight);
        layout.yjyzLayoutLeft = @(20);
        layout.yjyzLayoutWidth = @(SCREEN_WIDTH() - 40);
        
        layouts.yjyzPrivacyLayout = layout;
    }
    
    model.portraitLayouts = layouts;
    
    return model;
}

- (void)configNavigationBar
{
    UINavigationBar *navigationBar = YJYZSDKManager.yjyzAuthViewController.navigationController.navigationBar;
    NSDictionary *textAttributes = @{
        NSForegroundColorAttributeName:COMMON_APP_NAVBARTITLE_COLOR,
        NSFontAttributeName:FONT_PINGFANG_X_Medium(16)};
    [navigationBar setTitleTextAttributes:textAttributes];
    [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTintColor:UICOLOR_FROM_HEX(0x3C465A)];
    [navigationBar setShadowImage:[UIImage new]];
}

#pragma mark - Loading & Toast

- (void)showLoadingProgressHUDWithText:(NSString *)text {
//    [self.progressHUD showAnimated:YES];
//    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
//    self.progressHUD.label.text = text;
    LoadingManagerShowText(text);
}

- (void)dismissLoadingProgressHUDImmediately {
//    [self.progressHUD hideAnimated:YES];
    LoadingManagerHidden();
}

- (void)dismissLoadingProgressHUD {
//    [self.progressHUD hideAnimated:YES afterDelay:1.0];
    dispatch_queue_after_S(1.0, ^{
        LoadingManagerHidden();
    });
}

- (void)showToastWithText:(NSString *)text
{
    if (!IsValidString(text)) {
        return;
    }
    
    UIView *yjLoginView = YJYZSDKManager.yjyzAuthViewController.navigationController.topViewController.view;
    [ZXLoadingManager showLoading:text inView:yjLoginView];
}

- (void)clearProgressHUD
{
    [ZXLoadingManager hideLoading];
//    if (_progressHUD) {
//        _progressHUD = nil;
//    }
}

- (MBProgressHUD *)progressHUD
{
    UIView *yjLoginView = YJYZSDKManager.yjyzAuthViewController.navigationController.topViewController.view;
    
    //UIViewController *vc = YJYZSDKManager.yjyzAuthViewController.navigationController.topViewController;
    //ZGLog(@"YJYZSDKManager top vc..........%@", vc);
    
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:yjLoginView];
        _progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _progressHUD.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _progressHUD.contentColor = [UIColor whiteColor];
        [yjLoginView addSubview:_progressHUD];
    }
    return _progressHUD;
}

#pragma mark - wechat login -
+ (void)wxAuthComplete:(void(^)(NSDictionary*,NSError *))block{
    
    if (![WXApi isWXAppInstalled]) {
        return;
    }
    
    UMSocialPlatformType socialPlatformType = UMSocialPlatformType_WechatSession;
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:socialPlatformType currentViewController:nil completion:^(id result, NSError *error) {
        
//        NSLog(@"----------getUserInfoWithPlatform=%@",((UMSocialUserInfoResponse*)result).modelToJSONString);
        
        if (error) {
            block(nil, error);
            return;
        }
        
        UMSocialUserInfoResponse *resp = result;
        block(resp.originalResponse, nil);

    }];
    
}


#pragma mark - data handle -

+ (void)needBindPhoneUpdate{
    UIButton *btn = YJYZSDKManager.yjyzLoginView;
    [btn setTitle:@"本机号码一键绑定" forState:UIControlStateNormal];
    UIButton *otherLoginBtn = [ZXSDLoginService sharedService].otherLoginBtn;
    [otherLoginBtn setTitle:@"手机号验证码绑定" forState:UIControlStateNormal];
    
    [ZXSDLoginService sharedService].otherLoginView.hidden = YES;

}

+ (void)weixinAppLoginWithDic:(NSDictionary*)dic{
    if (!IsValidDictionary(dic)) {
        ToastShow(@"微信授权失败");
        return;
    }
    

    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:kPath_weixinAppLogin parameters:dic decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            NSString *message = error.localizedDescription;
            if (!IsValidString(message)) {
                message = @"请稍后重试";
            }
            ToastShow(message);
            return;
        }
        [ZXAppTrackManager event:kWeixinLogin];
        
        NSDictionary *resultDic = (NSDictionary*)response.originalContent;
        
        BOOL needBindPhone = [resultDic boolValueForKey:@"needBindPhone"];
        [ZXSDLoginService sharedService].openid = [dic stringObjectForKey:@"openid"];
        
        if (needBindPhone) {//绑定手机号
            
            [ZXSDLoginService needBindPhoneUpdate];
            
            return;
        }
        
        
        NSDictionary *account = [resultDic dictionaryObjectForKey:@"account"];
        NSString *phone = [account stringObjectForKey:@"phone"];
        
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse*)response.response;
        NSDictionary *headersDic = httpURLResponse.allHeaderFields;
        NSString *userSession = [headersDic objectForKey:@"USER-SESSION"];
        
        [ZXSDLoginService saveSession:userSession phone:phone];
        [ZXSDLoginService uploadDeviceInfo];
        
        [ZXSDLoginService judgeNextAction];
        
    }];
    
}

@end
