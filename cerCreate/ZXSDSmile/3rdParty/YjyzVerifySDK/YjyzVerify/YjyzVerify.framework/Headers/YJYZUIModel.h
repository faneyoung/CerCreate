//
//  YJYZUIModel.h
//  YjyzVerify
//
//  Created by yjyz on 2019/5/28.
//  Copyright © 2019 yjyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YjyzVerifyCheckPrivacyLayout : NSObject

//与隐私协议顶部 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutTop;
//与隐私协议中心 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutCenterY;
//与隐私协议右边距 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutRight;
//宽 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutWidth;
//高 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutHeight;

@end

@interface YjyzVerifyLayout : NSObject

//view 顶部距离 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutTop;
//view 底部距离 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutBottom;
//view 左边距离 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutLeft;
//view 右边距离 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutRight;
//宽度 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutWidth;
//高度 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutHeight;
//view x 中心距离 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutCenterX;
//view y 中心距离 (例:@(10))
@property (nonatomic,strong)NSNumber * yjyzLayoutCenterY;
@end

@interface YjyzVerifyCustomLayouts : NSObject

//logo
@property (nonatomic,strong)YjyzVerifyLayout * yjyzLogoLayout;

//手机号
@property (nonatomic,strong)YjyzVerifyLayout * yjyzPhoneLayout;

//其他方式登录
@property (nonatomic,strong)YjyzVerifyLayout * yjyzSwitchLayout;

//登录按钮
@property (nonatomic,strong)YjyzVerifyLayout * yjyzLoginLayout;

//check(相对隐私协议)复选框
@property (nonatomic,strong)YjyzVerifyCheckPrivacyLayout * yjyzCheckPrivacyLayout;

//隐私条款(切记,不可设置隐藏)
@property (nonatomic,strong)YjyzVerifyLayout * yjyzPrivacyLayout;

//运营商品牌(切记,不可设置隐藏)
@property (nonatomic,strong)YjyzVerifyLayout * yjyzSloganLayout;

//背景视图
@property (nonatomic,strong)YjyzVerifyLayout * yjyzBgViewLayout;

//左边按钮
@property (nonatomic,strong)YjyzVerifyLayout * yjyzLeftControlLayout;

@property (nonatomic,strong)YjyzVerifyLayout * yjyzRightControlLayout;

@end


#pragma mark - ******** UIModel属性 **********

//支持五种动画样式
typedef NS_ENUM(NSInteger, YJYZAnimateStyle) {
    YJYZAnimateStyleCoverVertical = 0,
    YJYZAnimateStyleFlipHorizontal,
    YJYZAnimateStyleCrossDissolve,
    YJYZAnimateStyleAlert,
    YJYZAnimateStylePush,
    YJYZAnimateStyleSheet,
    
    //无动画
    YJYZAnimateStyleNone
};

//支持的显示样式 = 动画样式 + 默认布局
typedef NS_ENUM(NSInteger, YJYZShowStyle) {
    YJYZShowStyleDefault = 0,
    YJYZShowStyleAlert,
    YJYZShowStylePush,
    YJYZShowStyleSheet,
};

@interface YJYZUIModel : NSObject

//当前控制器
@property (nonatomic, strong) UIViewController *authViewController;

//外部手动管理关闭界面 @(BOOL)
/*
 注意：设置为YES 时，点击(登录操作，切换其他用户操作) 回调成功或者失败时，一定要手动关闭登录页面
 */
@property (nonatomic,strong) NSNumber * manualDismiss;
//动画类型 0:默认 1:淡入淡出 2:翻转 3: Alert 4: Push 5:sheet
@property (nonatomic, strong) NSNumber *yjyzAnimateType;
//展示样式 = 动画类型 + 默认布局
@property (nonatomic, strong) NSNumber *yjyzShowType;

#pragma mark -  ******** 默认自定义动画页面(只针对于Alert/Sheet视图) **********
//弹窗控制器的背景色
@property (nonatomic, strong) UIColor *yjyzAnimateBgColor;
//左边按钮样式
@property (nonatomic, strong) UIImage *yjyzLeftControlImage;
//左边按钮是否显示
@property (nonatomic, strong) NSNumber *yjyzLeftControlHidden;
//左边按钮样式
@property (nonatomic, strong) UIImage *yjyzRightControlImage;
//右边按钮是否显示
@property (nonatomic, strong) NSNumber *yjyzRightControlHidden;
//背景视图是否展示
@property (nonatomic, strong) NSNumber *yjyzBgViewHidden;
//背景视图的圆角
@property (nonatomic, strong) NSNumber *yjyzBgViewCorner;
//背景视图颜色
@property (nonatomic, strong) UIColor *yjyzBgViewColor;
//背景视图展示图片
@property (nonatomic, strong) UIImage *yjyzBgViewImage;
//关闭按钮显示在左边还是右边 YES:左边 NO:右边
@property (nonatomic, strong) NSNumber *yjyzCloseType;
//左侧按钮自定义事件
@property (nonatomic, assign) SEL yjyzLeftTouchAction;
//右侧按钮自定义事件
@property (nonatomic, assign) SEL yjyzRightTouchAction;


#pragma mark - ******** 导航条设置 **********
//  导航栏背景色(default is white)
@property (nonatomic, strong) UIColor  *yjyzNavBarTintColor;
// 导航栏标题
@property (nonatomic, copy) NSString *yjyzNavText;
// 导航返回图标
@property (nonatomic, strong) UIImage *yjyzNavReturnImg;
// 隐藏导航栏尾部线条(默认显示,例:@(YES))
@property (nonatomic, strong) NSNumber *yjyzNavBottomLineHidden;
// 导航栏隐藏(例:@(YES))
@property (nonatomic, strong) NSNumber *yjyzNavBarHidden;
// 导航栏状态栏隐藏(例:@(YES))
@property (nonatomic, strong) NSNumber *yjyzNavStatusBarHidden;
// 导航栏透明(例:@(YES))
@property (nonatomic, strong) NSNumber *yjyzNavTranslucent;
// 导航栏返回按钮隐藏(例:@(YES))
@property (nonatomic, strong) NSNumber *yjyzNavBackBtnHidden;
// 导航栏左边按钮
@property (nonatomic, strong) UIBarButtonItem *yjyzNavLeftControl;
// 隐藏导航栏左边按钮
@property (nonatomic, strong) NSNumber *yjyzNavLeftControlHidden;
// 导航栏右边按钮
@property (nonatomic, strong) UIBarButtonItem *yjyzNavRightControl;
// 导航栏属性标题
@property (nonatomic, strong) NSAttributedString *yjyzNavAttributesText;
//  导航栏文字颜色
@property (nonatomic, strong) UIColor  *yjyzNavTintColor;
//  导航栏文字字体
@property (nonatomic, strong) UIFont  *yjyzNavTextFont;
//  导航栏背景图片
@property (nonatomic, strong) UIImage  *yjyzNavBackgroundImage;
//  导航栏配合背景图片设置，用来控制在不同状态下导航栏的显示(横竖屏是否显示) @(UIBarMetricsCompact)
@property (nonatomic, strong) NSNumber *yjyzNavBarMetrics;
//  导航栏导航栏底部分割线（图片)
@property (nonatomic, strong) UIImage  *yjyzNavShadowImage;
//  导航栏barStyle(例:@(UIBarStyleBlack))
@property (nonatomic, strong) NSNumber *yjyzNavBarStyle;
//  导航栏背景透明(例:@(YES))
@property (nonatomic, strong) NSNumber *yjyzNavBackgroundClear;


#pragma mark - ******** 授权页 **********
// 授权页背景颜色
@property (nonatomic, strong) UIColor *yjyzBackgroundColor;
// 授权背景图片
@property (nonatomic,strong) UIImage *yjyzBgImg;
//单击页面实现取消操作(例:@(NO))
@property (nonatomic,strong)NSNumber * yjyzCancelBySingleClick;

//UIModalPresentationOverCurrentContext style,半透明适用 (例:@(BOOL))
@property (nonatomic, strong) NSNumber *yjyzModalPresentationStyleOCC;
@property (nonatomic,weak)id<UIViewControllerTransitioningDelegate> presentAnimationDelegate;


#pragma mark - ******** 授权页logo **********
// Logo图片
@property (nonatomic, strong) UIImage *yjyzLogoImg;
// Logo是否隐藏(例:@(YES))
@property (nonatomic,strong)NSNumber * yjyzLogoHidden;
// Logos圆角(例:@(10))
@property (nonatomic, strong)NSNumber *yjyzLogoCornerRadius;


#pragma mark - ******** 号码设置 **********
// 手机号码字体颜色
@property (nonatomic, strong) UIColor *yjyzNumberColor;
// 字体
@property (nonatomic, strong) UIFont *yjyzNumberFont;
// 手机号对其方式(例:@(NSTextAlignmentCenter))
@property (nonatomic, strong) NSNumber *yjyzNumberTextAlignment;
// 手机号码背景颜色
@property (nonatomic, strong) UIColor *yjyzNumberBgColor;
//手机号码是否隐藏
@property (nonatomic, strong)  NSNumber *yjyzPhoneHidden;
//phone边框颜色
@property (nonatomic, strong) UIColor *yjyzPhoneBorderColor;
//phone边框宽度
@property (nonatomic, strong) NSNumber *yjyzPhoneBorderWidth;
//phone圆角
@property (nonatomic, strong) NSNumber *yjyzPhoneCorner;


#pragma mark - ******** 切换账号设置 **********
// 切换账号背景颜色
@property (nonatomic, copy) UIColor *yjyzSwitchBgColor;
// 切换账号字体颜色
@property (nonatomic, strong) UIColor *yjyzSwitchColor;
// 切换账号字体
@property (nonatomic, strong) UIFont *yjyzSwitchFont;
// 切换账号对其方式
@property (nonatomic, strong) NSNumber *yjyzSwitchTextHorizontalAlignment;
// 隐藏切换账号按钮, 默认为NO(例:@(YES))
@property (nonatomic, strong) NSNumber *yjyzSwitchHidden;
// 切换账号标题
@property (nonatomic, copy) NSString *yjyzSwitchText;

#pragma mark - ******** 复选框 **********
// 复选框选中时的图片
@property (nonatomic, strong) UIImage *yjyzCheckedImg;
// 复选框未选中时的图片
@property (nonatomic, strong) UIImage *yjyzUncheckedImg;
// 隐私条款check框默认状态，默认为YES(例:@(YES))
@property (nonatomic, strong) NSNumber *yjyzCheckDefaultState;
// 复选框尺寸 (例:[NSValue valueWithCGSize:CGSizeMake(30, 30)])
@property (nonatomic, strong) NSValue *yjyzCheckSize;
// 隐私条款check框是否隐藏，默认为YES(例:@(YES))
@property (nonatomic, strong) NSNumber *yjyzCheckHidden;

#pragma mark - ******** 隐私条款设置(切记,不可隐藏) **********
// 隐私条款基本文字颜色
@property (nonatomic, strong) UIColor *yjyzPrivacyTextColor;
// 隐私条款协议文字字体
@property (nonatomic, strong) UIFont *yjyzPrivacyTextFont;
// 隐私条款对其方式(例:@(NSTextAlignmentCenter))
@property (nonatomic, strong) NSNumber *yjyzPrivacyTextAlignment;
// 隐私条款协议文字颜色
@property (nonatomic, strong) UIColor *yjyzPrivacyAgreementColor;
// 隐私条款协议背景颜色
@property (nonatomic, strong) UIColor *yjyzPrivacyAgreementBgColor;
// 隐私条款应用名称
@property (nonatomic, copy) NSString *yjyzPrivacyAppName;
// 协议文本前后符号@[@"前置符号",@"后置符号"]
@property (nonatomic, strong) NSArray<NSString*> *yjyzPrivacyProtocolMarkArr;
// 开发者隐私条款协议名称（第一组协议）@[@"名字",@"url",@"分割符"]
@property (nonatomic, strong) NSArray<NSString*> *yjyzPrivacyFirstTextArr;
// 开发者隐私条款协议名称（第二组协议）@[@"名字",@"url",@"分割符"]
@property (nonatomic, strong) NSArray<NSString*> *yjyzPrivacySecondTextArr;
// 开发者隐私条款协议名称（第三组协议）@[@"名字",@"url",@"分割符"]
@property (nonatomic, strong) NSArray<NSString*> *yjyzPrivacyThirdTextArr;
// 隐私条款多行时行距 CGFloat (例:@(4.0))
@property (nonatomic,strong)NSNumber* yjyzPrivacyLineSpacing;
//开发者隐私条款协议默认名称(不建议修改)
@property (nonatomic, copy) NSString  *yjyzPrivacyDefaultText;
//隐私协议下划线样式
//NSUnderlineStyleSingle NSUnderlineStyleThick
@property (nonatomic, strong) NSNumber * yjyzPrivacyUnderlineStyle;
/** (登录即同意)*/
@property (nonatomic, copy) NSString *yjyzPrivacyNormalTextFirst;
/** (并授权)*/
@property (nonatomic, copy) NSString *yjyzPrivacyNormalTextSecond;
/** (获取本机号码)*/
@property (nonatomic, copy) NSString *yjyzPrivacyNormalTextThird;
//隐私条款是否隐藏
@property (nonatomic, strong)  NSNumber *yjyzPrivacyHidden;
//隐私协议WEB页面标题数组
//若设置了 privacyWebTitle 则不生效
//若采用 privacytitleArray 来设置WEB页面标题 请添加一个默认标题用于在默认运营商协议WEB页面中进行展示
@property (nonatomic, strong)  NSArray<NSMutableAttributedString *> *privacytitleArray;
//运营商协议在排序在后 默认为NO(例:@(YES))
@property (nonatomic, strong)  NSNumber *isPrivacyOperatorsLast;


#pragma mark - ******** 隐私条款 具体协议页面 **********
// 隐私条款WEB页面返回按钮图片
@property (nonatomic, strong)UIImage *yjyzPrivacyWebBackBtnImage;

// 隐私条款WEB页面标题
@property (nonatomic, strong)NSAttributedString *yjyzPrivacyWebTitle;

// 隐私条款导航style UIStatusBarStyle (例:@(UIStatusBarStyleDefault))
@property (nonatomic, strong)NSNumber *yjyzPrivacyWebNavBarStyle;

// 隐私条款页面返回按钮 (外界不用传入返回事件)
@property (nonatomic, strong)UIButton *yjyzPrivacyBackButton;

#pragma mark - ******** 登陆按钮设置 **********
// 登录按钮文本
@property (nonatomic, copy) NSString *yjyzLoginBtnText;
// 登录按钮文本颜色
@property (nonatomic, strong) UIColor *yjyzLoginBtnTextColor;
// 登录按钮背景颜色
@property (nonatomic, strong) UIColor *yjyzLoginBtnBgColor;
// 登录按钮边框宽度 (例:@(1.0))
@property (nonatomic, strong) NSNumber *yjyzLoginBtnBorderWidth;
// 登录按钮边框颜色
@property (nonatomic, strong) UIColor *yjyzLoginBtnBorderColor;
// 登录按钮圆角  (例:@(10))
@property (nonatomic, strong) NSNumber *yjyzLoginBtnCornerRadius;
// 登录按钮文字字体
@property (nonatomic, strong) UIFont *yjyzLoginBtnTextFont;
// 登录按钮背景图片数组 (例:@[激活状态的图片,失效状态的图片,高亮状态的图片])
@property (nonatomic, strong) NSArray<UIImage*> *yjyzLoginBtnBgImgArr;
//手机号码是否隐藏
@property (nonatomic, strong)  NSNumber *yjyzLoginBtnHidden;


#pragma mark - ******** 运营商品牌标签(切记,不可隐藏) **********
//运营商品牌文字字体
@property (nonatomic, strong) UIFont   *yjyzSloganTextFont;
//运营商品牌文字颜色
@property (nonatomic, strong) UIColor  *yjyzSloganTextColor;
//运营商品牌文字对齐方式 (例:@(NSTextAlignmentCenter))
@property (nonatomic,strong) NSNumber *yjyzSloganTextAlignment;
//运营商品牌背景颜色
@property (nonatomic, strong) UIColor  *yjyzSloganBgColor;
//运营商品牌文字(不建议修改)
@property (nonatomic, copy) NSString  *yjyzSloganText;
//slogan是否隐藏
@property (nonatomic, strong) NSNumber *yjyzSloganHidden;
//slogan边框颜色
@property (nonatomic, strong) UIColor *yjyzSloganBorderColor;
//slogan边框宽度
@property (nonatomic, strong) NSNumber *yjyzSloganBorderWidth;
//slogan圆角
@property (nonatomic, strong) NSNumber *yjyzSloganCorner;

#pragma mark - ******** yjyzLoading 视图 **********
// loading 是否隐藏 (例:@(NO))
@property (nonatomic,strong) NSNumber *yjyzHiddenLoading;
//Loading 大小 (例:[NSValue valueWithCGSize:CGSizeMake(60, 60)])
@property (nonatomic,strong) NSValue *yjyzLoadingSize;
//Loading 背景色
@property (nonatomic,strong) UIColor *yjyzLoadingBackgroundColor;
//style (例:@(UIActivityIndicatorViewStyleWhiteLarge))
@property (nonatomic,strong) NSNumber *yjyzLoadingIndicatorStyle;
//Loading 圆角 (例:@(5))
@property (nonatomic,strong) NSNumber *yjyzLoadingCornerRadius;
//Loading Indicator渲染色
@property (nonatomic,strong) UIColor *yjyzLoadingTintColor;

#pragma mark - ******** 自定义loading视图 **********
/*
 * 大小 ,背景色,style,圆角,Indicator渲染色 将失效
 * 注意特殊 login函数 的willHiddenLoading 回调 回收特殊loading
 */
@property (nonatomic,copy)void(^loadingView)(UIView * contentView);

#pragma mark - 自定义视图
//默认授权页面添加自定义控件和获取控件位置请再次block中执行
//默认全屏布局样式 customView = vc.view
@property (nonatomic,copy) void(^customViewBlock)(UIView *customView);

//自定义布局的时候，设置布局
@property (nonatomic,copy) void(^manualLayoutBlock)(UIView *containView);

//check按钮点击事件(设置后，将由app处理相关弹窗事件)
@property (nonatomic,copy) void(^hasNotSelectedCheckViewBlock)(UIView *checkView);

#pragma mark - ******** 布局 **********
//布局 竖布局
@property (nonatomic,strong) YjyzVerifyCustomLayouts *portraitLayouts;
//布局 横布局
@property (nonatomic,strong) YjyzVerifyCustomLayouts *landscapeLayouts;
//布局 手动自定义布局,不设置横竖布局
@property (nonatomic,strong) NSNumber *yjyzManualLayout;

#pragma mark - ******** 横竖屏支持 **********
//横竖屏 是否支持自动转屏 (例:@(NO))
@property (nonatomic,strong) NSNumber *yjyzShouldAutorotate;
//横竖屏 设备支持方向 (例:@(UIInterfaceOrientationMaskAll))
@property (nonatomic,strong) NSNumber *yjyzSupportedInterfaceOrientations;
//横竖屏 默认方向 (例:@(UIInterfaceOrientationPortrait))
@property (nonatomic,strong) NSNumber *yjyzPreferredInterfaceOrientationForPresentation;

@end


