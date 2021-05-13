//
//  ZXSDNavigationController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDNavigationController.h"
#import "ZXSDBaseViewController.h"

@interface ZXSDNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation ZXSDNavigationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.navigationBar.translucent = NO;
    [self loadWhiteNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
}

- (void)dealloc
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    self.delegate = nil;
}

- (void)loadWhiteNavigationBar
{
    NSDictionary *textAttributes = @{
        NSForegroundColorAttributeName:COMMON_APP_NAVBARTITLE_COLOR,
        NSFontAttributeName:FONT_PINGFANG_X_Medium(16)};
    [self.navigationBar setTitleTextAttributes:textAttributes];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTintColor:UICOLOR_FROM_HEX(0x3C465A)];
    [self.navigationBar setShadowImage:[UIImage new]];
}

#pragma mark - Override

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Hijack the push method to disable the gesture
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
   
    //push出来的controller不显示tabbar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
    // 解决首页push新页面时，tabbar上移的问题
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    for (NSInteger i = 1; i < [viewControllers count]; i++) {
        UIViewController *wCon = [viewControllers objectAtIndex:i];
        wCon.hidesBottomBarWhenPushed = YES;
    }
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([navigationController.viewControllers count] == 1) {
        // Disable the interactive pop gesture in the rootViewController of navigationController
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        if ([viewController isKindOfClass:[ZXSDBaseViewController class]]) {
            ZXSDBaseViewController *bvc = (ZXSDBaseViewController *)viewController;
            if (!bvc.enableInteractivePopGesture) {
                navigationController.interactivePopGestureRecognizer.enabled = NO;
                return;
            }
        }
        // Enable the interactive pop gesture
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
