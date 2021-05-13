//
//  ZXMacros.h
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#ifndef ZXMacros_h
#define ZXMacros_h
#import "ZXSDUIDefines.h"

//static NSString * const kSourceChannel = @"enterprise";
static NSString * const kSourceChannel = @"appstore";

//constant define
static NSString * const kAppID = @"1517015114";
static NSString * const kAPPScheme = @"zxsd";
static NSString * const kAPPBaseURL = @"zxsd://zxsd.com";

static NSString *const kIDCardNumFilter = @"1234567890xX";
static NSString *const kPureNumFilter = @"1234567890";
static NSString *const kPhoneNumFilter = @"1234567890 ";
static NSString *const kChineseFilter = @"[^\u4e00-\u9fa5\\·\\.]";
                                        

static int kMaxNameLength = 10;

#define APPName    ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]?:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])

#define APPIconPath   [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject]
#define APPIcon    [UIImage imageNamed:APPIconPath]

#pragma mark - singleton -
#define SingletonInterface(cls_name, method_name)\
+ (cls_name*)method_name;


#define SingletonImp(cls_name, method_name)\
+ (cls_name *)method_name {\
static cls_name *method_name;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
method_name = [[cls_name alloc] init];\
});\
return method_name;\
}

#pragma mark - UIKit -

#define ViewBorderRadius(View,Radius,borderWidth,Color);\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(borderWidth)];\
[View.layer setBorderColor:[(Color ? Color : [UIColor whiteColor]) CGColor]]

#define kStatusBarHeight statusBarHeight()
#define kNavigationBarNormalHeight (44)
#define kNavigationBarHeight (navgationBarHeight())
#define kBottomSafeAreaHeight (homeSafeAreaHeiht())
#define kTabBarNormalHeight (49)
#define kTabBarHeight (tabBarHeiht())


static inline NSString* appBundleID(){
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

static inline NSString* appVersion(){
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

static inline NSString* appBuildVersion(){
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

static inline UIEdgeInsets kSafeAreaInsets() {
    static dispatch_once_t onceToken;
    static UIEdgeInsets safeAreaInsets;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow?:[UIApplication sharedApplication].windows.lastObject;
            safeAreaInsets = window.safeAreaInsets;
        }else{
            safeAreaInsets = UIEdgeInsetsZero;
        }
    });
    return safeAreaInsets;
}

static inline CGFloat statusBarHeight(){
    if (kSafeAreaInsets().top > 0) {
        return kSafeAreaInsets().top;
    }
    
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

static inline CGFloat navgationBarHeight(){
    return statusBarHeight() + kNavigationBarNormalHeight;
}

static inline CGFloat homeSafeAreaHeiht(){
    return kSafeAreaInsets().bottom;
}

static inline CGFloat tabBarHeiht(){
    return homeSafeAreaHeiht()+kTabBarNormalHeight;
}

//Foundation

static inline BOOL IsValidString(id str){
    if (![str isKindOfClass:NSString.class]) {
        return NO;
    }
    if (((NSString*)str).length < 1) {
        return NO;
    }
    return YES;
}

static inline BOOL IsValidStrLen(id str,int lenght){
    if (!IsValidString(str)) {
        return NO;
    }
    if (((NSString*)str).length < lenght) {
        return NO;
    }
    return YES;
}


static inline BOOL IsValidArray(id arr){
    if (![arr isKindOfClass:NSArray.class]) {
        return NO;
    }
    if (((NSArray*)arr).count < 1) {
        return NO;
    }
    return YES;
}

static inline BOOL IsValidDictionary(id dic){
    if (![dic isKindOfClass:NSDictionary.class]) {
        return NO;
    }
    
    if (((NSDictionary*)dic).count < 1) {
        return NO;
    }
    
    return YES;
}


static inline NSString * GetString(id str){
    if (!str || [str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if (![str isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", str];
    }
    return str;
}

static inline NSString * GetStrDefault(id str,NSString *defaultValue){
    if (!str || [str isKindOfClass:[NSNull class]]) {
        return defaultValue;
    }
    if (![str isKindOfClass:[NSString class]]) {
        
        NSString *tmp = [NSString stringWithFormat:@"%@", str];
        if(!IsValidString(tmp)){
            return defaultValue;
        }
        else{
            return tmp;
        }
    }
    return str;
    
}



static inline UIImage* UIImageNamed(id str){
    if (!IsValidString(str)) {
        return nil;
    }
    
    return [UIImage imageNamed:str];
}




#pragma mark - thread -

#define dispatch_safe_async_main(block)\
if ([NSThread isMainThread])\
{\
block();\
}\
else\
{\
dispatch_async(dispatch_get_main_queue(), block);\
}


static inline UIImage *GradientImageHoriz(NSArray*colors){
    if (!IsValidArray(colors)) {
        return [UIImage imageWithColor:UIColor.whiteColor];
    }
    
    if (colors.count < 2) {
        return [UIImage imageWithColor:colors.firstObject];
    }
    
    return [UIImage resizableImageWithGradient:colors direction:UIImageGradientDirectionHorizontal];
}

static inline UIImage *GradientImageVertical(NSArray*colors){
    if (!IsValidArray(colors)) {
        return [UIImage imageWithColor:UIColor.whiteColor];
    }
    
    if (colors.count < 2) {
        return [UIImage imageWithColor:colors.firstObject];
    }
    
    return [UIImage resizableImageWithGradient:colors direction:UIImageGradientDirectionVertical];
}

static inline UIImage *GradientImageThemeMain(){
    return GradientImageHoriz(@[UIColorFromHex(0x00B050),UIColorFromHex(0x00C35A)]);
}

static inline UIImage *GradientImageThemeBlue(){
    return GradientImageHoriz(@[UIColorFromHex(0x3C74CE),UIColorFromHex(0x5886E2)]);
}


#pragma mark - string & url formatter -

static inline NSString *TrimString(NSString *str){
    if (!IsValidString(str)) {
        return @"";
    }
    
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

static inline NSString * EncodeString(NSString * uncodeString) {
    
    NSURL *url = [NSURL URLWithString:uncodeString];
    if (!url) {
        NSString *encodedURLString =
        [uncodeString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:encodedURLString];
    }
    return url.absoluteString;
}

static inline NSString * QueryStrEncoding(id url, NSDictionary *parameters) {
    if (!parameters) {
        if ([url isKindOfClass:NSURL.class]) {
            return ((NSURL*)url).absoluteString;
        }
        return url;
    }
    NSString *path = @"";
    if ([url isKindOfClass:NSString.class]) {
        path = url;
    }
    else if ([url isKindOfClass:NSURL.class]){
        path = ((NSURL*)url).absoluteString;;
    }
    else{
        return @"";
    }
    
    NSArray *urlComponents = [path componentsSeparatedByString:@"?"];
    NSString *baseUrl = urlComponents.firstObject;
    NSArray *baseQuerys = @[];
    if (urlComponents.count > 1) {
        baseQuerys = [urlComponents.lastObject componentsSeparatedByString:@"&"];
    }
    
   __block NSMutableArray *mutablePairs = [NSMutableArray arrayWithCapacity:parameters.count];
    
    __block BOOL hasPreItem = NO;
    [baseQuerys enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj1, BOOL * _Nonnull stop1) {
            NSString *tmpStr = [NSString stringWithFormat:@"%@=",key];
            if ([obj hasPrefix:tmpStr]) {
                hasPreItem = YES;
                *stop1 = YES;
            }
        }];
        
        if (!hasPreItem) {
            [mutablePairs addObject:obj];
        }
    }];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *tmpStr = [NSString stringWithFormat:@"%@=%@",GetStrDefault(key, @""),GetStrDefault(obj, @"")];
        [mutablePairs addObject: tmpStr];
    }];

    return EncodeString([NSString stringWithFormat:@"%@?%@",baseUrl,[mutablePairs componentsJoinedByString:@"&"]]);
}

static inline NSString *WebPageUrlFormatter(NSString *path,NSDictionary *params){
    if (!IsValidString(path)) {
        return nil;
    }
    
    NSString *aUrl = path;
    if (![path hasPrefix:@"http"]) {
        aUrl = [NSString stringWithFormat:@"%@/%@", H5_WEB,path];
    }
    
    if (!params) {
        return aUrl;
    }
    

    
    return QueryStrEncoding(aUrl, params);
}


#endif /* ZXMacros_h */
