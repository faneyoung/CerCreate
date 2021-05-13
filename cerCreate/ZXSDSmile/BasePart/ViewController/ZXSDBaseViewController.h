//
//  ZXSDBaseViewController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSObject+YYModel.h>

#import <EasyTextView.h>

// 左导航按钮返回类型
typedef enum : NSUInteger {
    ZXSDLeftBarButtonBackToRoot,
    ZXSDLeftBarButtonBackToPrevious,
    ZXSDLeftBarButtonCloseToNormal
} ZXSDLeftBarButtonBackType;

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDBaseViewController : UIViewController

///返回回调
@property (nonatomic, copy) void(^backCompletion)(void);
///返回回调-带参数
@property (nonatomic, copy) void(^completionBlock)(id data);
///route block
@property (nonatomic, copy) void(^routeBlock)(void);


/// 返回到指定的上级控制器
@property (nonatomic, weak) UIViewController *backViewController;

/// 是否隐藏导航栏
@property (nonatomic, assign) BOOL isHideNavigationBar;

/// nav底部分割线
@property (nonatomic, assign) BOOL showNavBottomSepLine;

/// 是否需要侧滑返回，默认YES
@property (nonatomic, assign) BOOL enableInteractivePopGesture;

///页面
@property (nonatomic, assign) BOOL disableUMPageLog;


- (void)setupSubViews;

/// 设置左导航按钮类型
- (UIBarButtonItem *)backBarButtonItem;
- (UIBarButtonItem *)closeBarButtonItem;

- (UIButton*)testBtnAction:(void(^)(UIButton*btn))block;
- (void)testBtns:(NSArray*)titles action:(void(^)(UIButton*btn))block;

- (void)showPdfBtnWithUrl:(nullable NSString*)url fileName:(nullable NSString*)file html:(nullable NSString*)html;

- (BOOL)appErrorWithData:(NSDictionary*)resp;

- (void)setLeftBarButtonItem:(ZXSDLeftBarButtonBackType)backType;

- (void)backButtonClicked:(nullable id)sender;
- (void)closeButtonClicked:(nullable id)sender;

- (void)ZXSDNavgationBarConfigure;


#pragma mark - Loading & Toast
- (void)showLoadingProgressHUDWithText:(NSString *)text;
- (void)dismissLoadingProgressHUDImmediately;
- (void)dismissLoadingProgressHUD;
- (void)showToastWithText:(NSString *)text;

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)msg confirm:(NSString*)confirm cancel:(NSString*)cancel confirmBlock:(void(^)(void))cBlock cancelBlock:(void(^)(void))block;

#pragma mark - Request Handler
///错误统一处理
- (BOOL)handleError:(NSError *)error response:(EPNetworkResponse*)resp;

- (void)showNetworkErrowAlertView:(NSURLSessionDataTask *)task andError:(NSError *)error andDefaultTitle:(NSString *)string;
- (void)handleRequestError:(NSError *)error;
/// 请求非200错误处理
/// @param block 回调
- (void)errowAlertViewWithResponse:(NSURLResponse *)response error:(NSError *)error title:(NSString *)string block:(void(^)(id data))block;
- (void)errowAlertViewWithTask:(NSURLSessionDataTask *)task error:(NSError *)error title:(NSString *)string block:(void(^)(id data))block;

- (UIViewController *)ZXSD_GetController;
- (UIViewController *)ZXSD_GetCurrentViewControllerFrom:(UIViewController *)rootViewController;
- (UIViewController *)ZXSD_GetControllerUnknown;
- (UIViewController *)ZXSD_GetViewControllerWithView:(UIView *)view;

- (void)refreshAllData;
///刷新当前nav栈中的viewcontrollers里的某些vc
- (void)refreshNavVCsWithName:(NSArray*)vcs;

@end

NS_ASSUME_NONNULL_END
