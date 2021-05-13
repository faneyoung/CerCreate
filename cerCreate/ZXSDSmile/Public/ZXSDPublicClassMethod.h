//
//  ZXSDPublicClassMethod.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AFSerializerType){
    AFSerializerTypeNone,
    AFSerializerTypeJson,
    AFSerializerTypeHttp,
};

@interface ZXSDPublicClassMethod : NSObject

//显示提示框工具类方法
+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message andCancelTitle:(NSString *)cancelTitle;

+ (UIViewController *)ZXSD_GetController;

+ (UIViewController *)ZXSD_GetCurrentViewControllerFrom:(UIViewController *)rootViewController;

//计算自适应文本尺寸的方法
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont*)font MaxSize:(CGSize)maxSize;

//生成纯色图片
+ (UIImage *)initImageFromColor:(UIColor *)color Size:(CGSize)size;

//生成渐变色图片(YES为水平,NO为竖直)
+ (UIImage *)gradientImageWithSize:(CGSize)size Colors:(NSArray *)colors andGradientType:(BOOL)isHorizontal;

//模糊图片处理
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

//截取屏幕
+ (UIImage *)screenImageWithSize:(CGSize )imgSize;

//截取清晰屏幕
+ (UIImage *)screenShotWithView:(UIView *)view andSize:(CGSize)size;

//present出来的viewController 截取屏幕
+ (UIImage *)presentVCScreenImageWithSize:(CGSize)imgSize andWindow:(UIWindow *)window;

//改变图片尺寸
+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size;

//裁剪图片
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//绘制虚线
+ (void)drawDashWith:(BOOL)isVertical andView:(UIView *)view;

//设置自定义域名的cookie
+ (void)setCookieWithName:(NSString *)name andValue:(NSString *)value andDomainUrl:(NSString *)domainUrl;

//删除所有cookie
+ (void)deleteAllCookiesInSharedHTTPCookieStorage;

//获取网络请求管理类
+ (AFHTTPSessionManager *)getAFSessionManagerWithRequestType:(AFSerializerType)requestType andResponseType:(AFSerializerType)responseType;

//把NSDictionary转化成JsonString
+ (NSString *)jsonStringWithdictionary:(NSDictionary *)dictionary;

//把JsonString转化成NSDictionary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//把JsonString转化成NSArray
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;

//当前时间戳转化为时间字符串
+ (NSString *)timeStampWithNow;

//当前时间戳转化为特殊需求时间字符串(年月)
+ (NSString *)timeStampWithNowSpecialYearAndMonth;

//当前时间戳转化为特殊需求时间字符串(月日)
+ (NSString *)timeStampWithNowSpecialMonthAndDay;

//当前时间戳转化为特殊需求时间字符串(年)
+ (NSString *)timeStampWithNowSpecialYear;

//当前时间戳转化为特殊需求时间字符串(月)
+ (NSString *)timeStampWithNowSpecialMonth;

//任意时间戳转化为时间字符串
+ (NSString *)timeStampWithRandomTime:(NSNumber *)timeStamp;

//NSDate转化为指定时间字符串(年月)
+ (NSString *)dateConvertYearAndMonth:(NSDate *)date;

//时间字符串转化为NSDate(年月)
+ (NSDate *)dateStringWithYMConvertDate:(NSString *)dateString;

//时间字符串转化为NSDate(年月日)
+ (NSDate *)dateStringWithYMDConvertDate:(NSString *)dateString;

//检测第三方输入带有的表情输入
+ (BOOL)stringContainsEmoji:(NSString *)string;

// 检测汉字输入
+ (BOOL)isAllChineseInString:(NSString*)str;

//判断字串是否为空
+ (BOOL)emptyOrNull:(NSString *)string;

// 预下载图片
+ (void)prefetchImages:(NSArray<NSString *> *)urls completed:(void (^)(NSArray<UIImage *> * _Nullable images, BOOL allFinished))allCompleteBlock;
@end

NS_ASSUME_NONNULL_END
