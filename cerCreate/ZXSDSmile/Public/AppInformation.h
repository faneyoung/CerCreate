//
//  AppInformation.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#ifndef AppInformation_h
#define AppInformation_h

//快速生成成员变量
#define __string(__param__) @property (nonatomic,copy) NSString *__param__;
#define __number(__param__) @property (nonatomic,retain) NSNumber *__param__;

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define ZGLog(format, ...) printf("\n%s [第%d行] %s\n",__FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define ZGLog(format, ...)
#endif

#ifdef DEBUG
    #define TICK NSDate *startTime = [NSDate date]
    #define TOCK DLog(@"Time: %f", -[startTime timeIntervalSinceNow])
#else
    #define TICK
    #define TOCK
#endif

#define WEAKOBJECT(o)  __weak typeof(o) weak##o = o
#define STRONGOBJCECT(o)  __strong typeof(o) strong##o = o

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define COMMON_APP_THEME_COLOR RGBCOLOR(58,163,58)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/**
 *  分割线的高度
 */
static inline CGFloat SEPARATE_SINGLE_LINE_WIDTH() {
    return 1 / [UIScreen mainScreen].scale;
}
/**
 @abstract 在debug模式下打印CGRECT.
 **/
static inline void ZGLOG_CGRECT(CGRect rect) {
    ZGLog(@"x = %lf,y = %lf,w = %lf,h = %lf",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}
/**
 @abstract 在debug模式下打印CGSIZE.
 **/
static inline void ZGLOG_CGSIZE(CGSize size) {
    ZGLog(@"w = %lf,h = %lf",size.width,size.height);
}
/**
 @abstract 在debug模式下打印CGPOINT.
 **/
static inline void ZGLOG_CGPOINT(CGPoint point) {
    ZGLog(@"x = %lf,y = %lf",point.x,point.y);
}
/**
 @abstract 根据URL去调用外部的APP.
 @param url url是一个外部链接的地址.
 **/
static inline void OPEN_OUTSIDE_URL_BASED_ON_STRING(NSString *url) {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
        ZGLog(@"CAN NOT OPEN THIS URL");
    }
}

static inline NSArray* SORTED_ARRAY_BY_KEY_AND_ASCENDING(NSArray *array,NSString *key,BOOL ascending) {
    return [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:key ascending:ascending selector:@selector(caseInsensitiveCompare:)]]];
}

static inline NSArray* GET_UNIQUE_OBJECTS_FROM_ARRAY(NSArray *array) {
    return [[NSSet setWithArray:array] allObjects];
}
/**
 @abstract 获取本机屏幕的宽度.
 **/
static inline CGFloat SCREEN_WIDTH() {
    return [UIScreen mainScreen].bounds.size.width;
}
/**
 @abstract 获取本机屏幕的高度.
 **/
static inline CGFloat SCREEN_HEIGHT() {
    return [UIScreen mainScreen].bounds.size.height;
}
/**
 @abstract 获取本机屏幕状态栏的高度.
 **/
static inline CGFloat STATUSBAR_HEIGHT() {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}
/**
 @abstract 获取本机屏幕的导航栏高度.
 **/
static inline CGFloat NAVIBAR_HEIGHT() {
    return STATUSBAR_HEIGHT() + 44;
}
/**
 @abstract 获取本机上的软件版本.
 **/
static inline NSString *APP_VERSION() {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
/**
 @abstract 判断本机是否为iPhone4或者iPhone4s.
 **/
static inline BOOL iPhone4() {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO;
}
/**
 @abstract 判断本机是否为iPhone5或者iPhone5s或者iPhone5c或者iPhoneSE.
 **/
static inline BOOL iPhone5() {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO;
}

//iPhone 6、iPhone 6s、iPhone 7、iPhone 8系列
static inline BOOL iPhone6() {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO;
}

/**
 @abstract 判断本机是否为iPhone8.
 **/
static inline BOOL iPhone8() {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO;
}
/**
 @abstract 判断本机是否为iPhone8Plus.
 **/
static inline BOOL iPhone8Plus() {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO;
}
/**
 @abstract 判断本机是否为iPhoneX或者iPhoneXS或者iPhone11Pro.
 **/
static inline BOOL iPhoneX() {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}
/**
 @abstract 判断本机是否为iPhoneXR或者iPhone11
 **/
static inline BOOL iPhoneXR() {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO;
}
/**
 @abstract 判断本机是否为iPhoneXS_Max或者iPhone11Pro_Max.
 **/
static inline BOOL iPhoneXS_Max() {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO;
}
/**
 iPhone12(12 pro):844
 iPhone12 mini/X,Xs,11pro: 812
 iPhone12 pro Max: 926
 @abstract 判断本机是否为iPhoneX系列屏幕.
 **/
static inline BOOL iPhoneXSeries() {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    return (height == 812 ||
            height == 844 ||
            height == 896 ||
            height == 926) ? YES : NO;
}
/**
 @abstract 根据Hex值来获取UICOLOR.
 **/
static inline UIColor *UICOLOR_FROM_HEX(NSInteger hex) {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}
static inline UIColor *UICOLOR_FROM_RGB(CGFloat r,CGFloat g,CGFloat b,CGFloat a) {
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a];
}
/**
 @abstract 获取本机的操作系统版本.
 **/
static inline NSString* DEVICE_SYSTEM_VERSION() {
    return [[UIDevice currentDevice] systemVersion];
}
/**
 @abstract 判断本机的版本是否为v版本.
 **/
static inline BOOL SYSTEM_VERION_EQUAL_TO(double v) {
    return DEVICE_SYSTEM_VERSION().doubleValue == v;
}
/**
 @abstract 判断本机的版本是否为v版本.
 **/
static inline BOOL SYSTEM_VERSION_GETATER_THAN(double v) {
    return DEVICE_SYSTEM_VERSION().doubleValue >v;
}
/**
 @abstract 判断本机的版本是否为v版本.
 **/
static inline BOOL SYSTEM_VERSION_GETATER_THAN_OR_EQUAL_TO(double v) {
    return DEVICE_SYSTEM_VERSION().doubleValue >= v;
}
/**
 @abstract 判断本机的版本是否为v版本.
 **/
static inline BOOL SYSTEM_VERSION_LESS_THAN(double v) {
    return DEVICE_SYSTEM_VERSION().doubleValue < v;
}
/**
 @abstract 判断本机的版本是否为v版本.
 **/
static inline BOOL SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(double v) {
    return __IPHONE_OS_VERSION_MAX_ALLOWED <= v;
}
/**
 @abstract 根据name来获取图片.
 **/
static inline UIImage *UIIMAGE_FROM_NAME(NSString *name) {
    return [UIImage imageNamed:name];
}
/**
 @abstract 根据path和type来获取图片.
 @param path 需要查找的文件路径.
 @param type 需要查找的文件类型.(PNG,JPG)
 **/
static inline UIImage *UIIMAGE_FROM_PATH_AND_TYPE(NSString *path,NSString *type) {
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:path ofType:type]];
}
/**
 @abstract 隐藏navigationController的navigationBar.
 **/
static inline void HIDE_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(UINavigationController *navigationController) {
    [navigationController setNavigationBarHidden:YES animated:YES];
}
/**
 @abstract 显示navigationController的navigationBar.
 **/
static inline void SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(UINavigationController *navigationController) {
    [navigationController setNavigationBarHidden:NO animated:YES];
}
/**
 @abstract 根据storyboardName来获取对应的storyboard.
 **/
static inline UIStoryboard* GET_STORYBOARD_BY_NAME(NSString *storyboardName) {
    return [UIStoryboard storyboardWithName:storyboardName bundle:nil];
}

static inline UIViewController* GET_CONTROLLER_FROM_STORYBOARD(NSString *controllerName,NSString *stroyboardName) {
    UIStoryboard *storyboard = GET_STORYBOARD_BY_NAME(stroyboardName);
    return [storyboard instantiateViewControllerWithIdentifier:controllerName];
}

/**
 @abstract 淡入淡出的界面切换效果,但是不能采用原生的动画效果.
 **/
static inline void CHANGE_ROOT_VIEW_CONTROLLER_WITH_ANIMATION() {
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.type = kCATransitionFromBottom;
    [[[[[UIApplication sharedApplication] delegate] window] layer] addAnimation:animation forKey:nil];
}

static inline void OPEN_OTHER_URL_SHEME(NSString *urlSheme) {
    NSURL *requestURL = [NSURL URLWithString:urlSheme];
    if ([[UIApplication sharedApplication] canOpenURL:requestURL]) {
        [[UIApplication sharedApplication] openURL:requestURL];
    }
}


#endif /* AppInformation_h */
