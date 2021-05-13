//
//  ZXSDBaseTabBarController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTabBarController.h"
#import "UITabBarController+Badge.h"
#import "AppDelegate.h"
#import "UITabBarController+Badge.h"

#import "ZXSDHomePageController.h"
//#import "ZXMessageViewController.h"
#import "ZXMallViewController.h"
#import "ZXTaskCenterViewController.h"
#import "ZXMineViewController.h"


#import "ZXSDCompanyModel.h"
#import "ZXSDGlobalObject.h"
#import "ZXSDAgreementAlertView.h"
#import "ZXSDVersionModel.h"

static const NSString *BASE_QUERY_COMPANYS_URL = @"/rest/company/status?status=3";
static const NSString *CHECK_IS_SMILE_PLUS_URL = @"/rest/userInfo/smilePlus";
static const NSString *CHECK_VERSION_URL = @"/rest/anon/verifyVersion";

@interface ZXSDBaseTabBarController ()<UITabBarControllerDelegate> {
}

@property (nonatomic, strong) ZXSDAgreementAlertView *updateAlertView;
@property (nonatomic, assign) BOOL skipCheck;

@property (nonatomic,assign) NSInteger  indexFlag;//记录上一次点击tabbar，使用时，记得先在init或viewDidLoad里 初始化 = 0

@end

@implementation ZXSDBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate appDelegate].tabBarController = self;

    self.delegate = self;
    _skipCheck = NO;
    
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }

    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.barTintColor = UIColor.whiteColor;//UICOLOR_FROM_HEX(0xFBFBFB);
//    self.tabBar.tintColor = UICOLOR_FROM_HEX(0x00B050);
//    self.tabBar.translucent = NO;

    ///设置tab项
    [self setupViewControllers];
    
//    [self fetchCompanys];
//    [self checkIsSmilePlusUser];
//    [self fetchShareQrInfo];
    
    [self checkVersionUpdate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_notification_newMessage object:nil];

}

#pragma mark - help methods -

- (void)selectTab:(NSInteger)index
{
    if (index < 0) {
        index = 0;
    }
    
    if (index > ZXTabBarTypeMine) {
        index = ZXTabBarTypeMine;
    }
    
    self.selectedIndex = index;
}

- (void)setupViewControllers{
    [UITabBar appearance].translucent = NO;
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.tabBar.layer.shadowRadius = 8;
    self.tabBar.layer.shadowColor = TextColorSubTitle.CGColor;
    self.tabBar.layer.shadowOpacity = 0.1;



    self.viewControllers = @[
        [self navWithClass:ZXSDHomePageController.class normalImgName:@"icon_tabBar_home" selectedImg:@"icon_tabBar_home_H" title:@"首页"],
        [self navWithClass:ZXMallViewController.class normalImgName:@"icon_tabBar_mall" selectedImg:@"icon_tabBar_mall_H" title:@"商城"],
        [self navWithClass:ZXTaskCenterViewController.class normalImgName:@"icon_tabBar_msg" selectedImg:@"icon_tabBar_msg_H" title:@"任务"],
        [self navWithClass:ZXMineViewController.class normalImgName:@"icon_tabBar_mine" selectedImg:@"icon_tabBar_mine_H" title:@"我的"],
    ];
}

#pragma mark - data handle -


- (void)fetchCompanys
{
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,BASE_QUERY_COMPANYS_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取内部公司信息接口成功返回数据---%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *list = [ZXSDCompanyModel parserDatasWithObj:responseObject];
//            [NSArray modelArrayWithClass:[ZXSDCompanyModel class] json:responseObject];
            [ZXSDGlobalObject sharedGlobal].innerCompanys = list;
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)checkVersionUpdate
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *params = @{
        @"deviceType":@"ios",
        @"versionCode":version
    };
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,CHECK_VERSION_URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取版本更新信息接口成功返回数据---%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            ZXSDVersionModel *model = [ZXSDVersionModel modelWithJSON:responseObject];
            [self showUpdateAlert:model];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)checkIsSmilePlusUser
{
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,CHECK_IS_SMILE_PLUS_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取是否为Smile+用户接口成功返回数据---%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"isSmilePlus"] integerValue] == 1) {
                [ZXSDCurrentUser currentUser].smilePlus = YES;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)fetchShareQrInfo
{
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,USER_QRCODE_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取分享海报接口成功返回数据---%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *shareQRURL = [responseObject objectForKey:@"qrCodeUrl"];
            [ZXSDCurrentUser currentUser].shareQRURL = shareQRURL;
            
            if (shareQRURL.length > 0) {
                [ZXSDPublicClassMethod prefetchImages:@[shareQRURL] completed:^(NSArray<UIImage *> * _Nullable images, BOOL allFinished) {
                    
                }];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)showUpdateAlert:(ZXSDVersionModel *)model
{
    if (!model.isUpdate) {
        return;
    }
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.frame];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:maskView];
    
    NSString *desc = model.updateDesc;
    if (desc.length <= 0) {
        desc = @"最新版来了，马上更新尝鲜吧！";
    }
    
    if (model.forceUpdate) {
        self.updateAlertView = [[ZXSDAgreementAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 260) alertTitle:@"版本更新" alertTitleLines:1 alertContent:desc hasJumpLink:NO cancelButtonTitle:@"" andConfirmButtonTitle:@"现在更新"];
    } else {
        self.updateAlertView = [[ZXSDAgreementAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 260) alertTitle:@"版本更新" alertTitleLines:1 alertContent:desc hasJumpLink:NO cancelButtonTitle:@"暂不更新" andConfirmButtonTitle:@"现在更新"];
    }
    self.updateAlertView.center = CGPointMake(self.view.center.x, self.view.center.y);
    self.updateAlertView.userInteractionEnabled = YES;
    
    @weakify(self);
    self.updateAlertView.confirmBlock = ^{
        @strongify(self);
        [maskView removeFromSuperview];
        [self.updateAlertView removeFromSuperview];
        
        NSString *appstoreUrl = @"itms-apps://itunes.apple.com/app/id1517015114";
        NSString *entUrl = GetString(model.downloadUrl);
        NSString *finalUrl = IsValidString(entUrl) ? entUrl : appstoreUrl;
        
        NSURL *appReviewUrl = [NSURL URLWithString:finalUrl];
        if ([[UIApplication sharedApplication] canOpenURL:appReviewUrl]) {
            [[UIApplication sharedApplication] openURL:appReviewUrl];
        }
        
    };
    self.updateAlertView.cancelBlock = ^{
        @strongify(self);
        [maskView removeFromSuperview];
        [self.updateAlertView removeFromSuperview];
        self.skipCheck = YES;
    };
    
    [self.view addSubview:self.updateAlertView];
}

#pragma mark - dep_ -

- (void)addUserInterfaceConfigure {
    ZXSDNavigationController *homeNav = [[ZXSDNavigationController alloc] initWithRootViewController:[ZXSDHomePageController new]];
    homeNav.tabBarItem = [self tabBarItemWithTag:1000 title:@"首页" defaultImage:@"icon_tabBar_home" selectedImage:@"icon_tabBar_home_H"];
    
    ZXSDNavigationController *userCenterNav = [[ZXSDNavigationController alloc] initWithRootViewController:[ZXMineViewController new]];
    userCenterNav.tabBarItem = [self tabBarItemWithTag:1001 title:@"我的" defaultImage:@"icon_tabBar_mine" selectedImage:@"icon_tabBar_mine_H"];
    
    self.viewControllers = @[homeNav, userCenterNav];
}



- (UITabBarItem *)tabBarItemWithTag:(NSInteger)tag
                              title:(NSString *)title
                       defaultImage:(NSString *)defaultImage
                      selectedImage:(NSString *)selectedImage
{
    UITabBarItem *item = [[UITabBarItem alloc]
                          initWithTitle:title
                          image:[[UIImage imageNamed:defaultImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    item.tag = tag;
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x626F8A)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:kThemeColorMain} forState:UIControlStateSelected];
    
    return item;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (!self.skipCheck) {
        [self checkVersionUpdate];
    }
}

#pragma mark - UIStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - help methods -

- (UINavigationController*)navWithClass:(Class)cls normalImgName:(NSString *)imgName selectedImg:(NSString *)selImgName title:(NSString *)title
{
    
    ZXSDNavigationController *nav = [[ZXSDNavigationController alloc] initWithRootViewController:[[cls alloc] init]];

    [self formatTabbarItem:nav.tabBarItem WithTitle:title imageName:imgName selectedImageName:selImgName];

    return nav;
}

- (void)formatTabbarItem:(UITabBarItem *)tabBarItem WithTitle:(NSString *)title imageName:(NSString *)imgName selectedImageName:(NSString *)selectedImgName{
    tabBarItem.title = title;
    tabBarItem.image = [[UIImage imageNamed:imgName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    tabBarItem.selectedImage = [[UIImage imageNamed:selectedImgName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TextColorSubTitle} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kThemeColorMain} forState:UIControlStateSelected];
    
//    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0,-1)];
    if ([title isEqualToString:@"消息"]) {
        tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
    }

}

- (void)shouldShowBadge:(BOOL)show{
    if (show) {
        [self showBadgeAtIndex:1];
    }
    else{
        [self hideBadgeAtIndex:1];
    }
}

#pragma mark - tabBar select -
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [self addShakeEffect];
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self selectedTabBarAnimation:(int)index];
    
    if([self.tabBarDelegate respondsToSelector:@selector(tabBar:willSelectIndex:currentIndex:)]){
        [self.tabBarDelegate tabBar:self willSelectIndex:(int)index currentIndex:(int)self.indexFlag];
    }
    
    //第二次点击刷新控制
    if (index == self.selectedIndex) {
        UINavigationController *nav = (UINavigationController*)self.viewControllers[index];
        [(ZXSDBaseViewController*)nav.viewControllers.firstObject refreshAllData];
    }

    
    
    //选中后并更新indexFlag
    if (index != self.indexFlag) {
        self.indexFlag = index;
    }
}

// 震动
- (void)addShakeEffect{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
            [generator prepare];
            [generator impactOccurred];
        }
    });
}

#pragma mark - animation -

- (void)selectedTabBarAnimation:(int)idx{
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *btn in self.tabBar.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {

            NSNumber *state = [btn valueForKeyPath:@"_selected"];
            if (state.intValue == 1) {
                if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                    [array addObject:btn];
                }
            }
        }
    }
    
    //放大效果，并回到原位
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.2,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 0.8;
    animation.calculationMode = kCAAnimationCubic;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [[array[0] layer] addAnimation:animation forKey:nil];

}

@end
