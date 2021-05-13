//
//  ZXSDPublicClassMethod.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDPublicClassMethod.h"
#import <SDWebImage/SDWebImage.h>
#import "EPNetworkManager.h"

@implementation ZXSDPublicClassMethod

//显示提示框工具类方法
+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message andCancelTitle:(NSString *)cancelTitle {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    [ignoreAction setValue:kThemeColorMain forKey:@"titleTextColor"];
    [alert addAction:ignoreAction];
    [[ZXSDPublicClassMethod ZXSD_GetController] presentViewController:alert animated:YES completion:nil];
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)ZXSD_GetController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentViewController = [self ZXSD_GetCurrentViewControllerFrom:rootViewController];
    return currentViewController;
}

+ (UIViewController *)ZXSD_GetCurrentViewControllerFrom:(UIViewController *)rootViewController {
    UIViewController *currentViewController;
    
    if ([rootViewController presentedViewController]) {
        //视图是被presented出来的
        rootViewController = [rootViewController presentedViewController];
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        //根视图为UITabBarController
        currentViewController = [self ZXSD_GetCurrentViewControllerFrom:[(UITabBarController *)rootViewController selectedViewController]];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        //根视图为UINavigationController
        currentViewController = [self ZXSD_GetCurrentViewControllerFrom:[(UINavigationController *)rootViewController visibleViewController]];
    } else {
        //根视图为非导航类
        currentViewController = rootViewController;
    }
    return currentViewController;
}

//计算自适应文本尺寸的方法
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont*)font MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

//生成纯色图片
+ (UIImage *)initImageFromColor:(UIColor *)color Size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//生成渐变色图片
+ (UIImage *)gradientImageWithSize:(CGSize)size Colors:(NSArray *)colors andGradientType:(BOOL)isHorizontal {
    NSMutableArray *array = [NSMutableArray array];
    
    for(UIColor *color in colors) {
        [array addObject:(id)color.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)array, NULL);
    CGPoint start;
    CGPoint end;
    
    if (isHorizontal) {
        start = CGPointMake(0.0, 0.0);
        end = CGPointMake(size.width, 0.0);
    } else {
        start = CGPointMake(0.0, 0.0);
        end = CGPointMake(0.0, size.height);
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}

//模糊图片处理
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
    return blurImage;
}

//截取屏幕
+ (UIImage *)screenImageWithSize:(CGSize)imgSize {
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //获取app的appdelegate，便于取到当前的window用来截屏
    [app.window.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//截取清晰屏幕
+ (UIImage *)screenShotWithView:(UIView *)view andSize:(CGSize)size {
    UIView *temperView = [view snapshotViewAfterScreenUpdates:YES];
    [view addSubview:temperView];
    
    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [temperView removeFromSuperview];
    
    return image;
}

//present出来的viewController 截取屏幕
+ (UIImage *)presentVCScreenImageWithSize:(CGSize)imgSize andWindow:(UIWindow *)window {
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [window.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//改变图片尺寸
+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);  //size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

//裁剪图片
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//绘制虚线
+ (void)drawDashWith:(BOOL)isVertical andView:(UIView *)view {
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    [shapelayer setBounds:view.bounds];
    [shapelayer setPosition:CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2)];
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    shapelayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapelayer.lineWidth = 1.0;
    shapelayer.lineJoin = kCALineJoinRound;
    shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:4],[NSNumber numberWithInt:2], nil];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (isVertical) {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(view.frame));
    } else {
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(view.frame), 0);
    }
    shapelayer.path = path;
    CGPathRelease(path);
    [view.layer addSublayer:shapelayer];
}

//设置自定义域名的cookie
+ (void)setCookieWithName:(NSString *)name andValue:(NSString *)value andDomainUrl:(NSString *)domainUrl {
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:name forKey:NSHTTPCookieName];
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domainUrl forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"false" forKey:@"sessionOnly"];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

//删除所有cookie
+ (void)deleteAllCookiesInSharedHTTPCookieStorage {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

//获取网络请求管理类
+ (AFHTTPSessionManager *)getAFSessionManagerWithRequestType:(AFSerializerType)requestType andResponseType:(AFSerializerType)responseType {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (requestType == AFSerializerTypeJson) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if (requestType == AFSerializerTypeHttp) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    if (responseType == AFSerializerTypeJson) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    if (responseType == AFSerializerTypeHttp) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    NSString *encodedString = [NSString stringWithFormat:@"%@%@",MARS_HMAC_KEY,MARS_HMAC_SEND_MS];
    NSString *hmacSignature = [encodedString hmacSHA512StringWithKey:MARS_APP_SECRET];
    NSString *signature = [hmacSignature lowercaseString];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@%@",USER_AGENT,APP_VERSION()] forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:MARS_HMAC_KEY forHTTPHeaderField:@"HMAC-KEY"];
    [manager.requestSerializer setValue:MARS_HMAC_SEND_MS forHTTPHeaderField:@"HMAC-SEND-MS"];
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"HMAC-SIGNATURE"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:version forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"deviceType"];
    
    [manager.requestSerializer setValue:kSourceChannel forHTTPHeaderField:@"sourceChannel"];
    
    NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
    if(userSession.length > 0) {
        [manager.requestSerializer setValue:userSession forHTTPHeaderField:@"USER-SESSION"];
    }
    return manager;
}

//把NSDictionary转化成JsonString
+ (NSString *)jsonStringWithdictionary:(NSDictionary *)dictionary {
    if (dictionary == nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *returnData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted
                                                           error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return jsonString;
}

//把JsonString转化成NSDictionary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers
                                                                 error:&error];
    return dictionary;
}

//把JsonString转化成NSArray
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    return jsonArray;
}

//当前时间戳转化为时间字符串
+ (NSString *)timeStampWithNow {
    NSDate *detaildate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:detaildate];
}

//当前时间戳转化为特殊需求时间字符串(年月)
+ (NSString *)timeStampWithNowSpecialYearAndMonth {
    NSDate *detaildate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:detaildate];
}

//当前时间戳转化为特殊需求时间字符串(月日)
+ (NSString *)timeStampWithNowSpecialMonthAndDay {
    NSDate *detaildate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:detaildate];
}

//当前时间戳转化为特殊需求时间字符串(年)
+ (NSString *)timeStampWithNowSpecialYear {
    NSDate *detaildate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:detaildate];
}

//当前时间戳转化为特殊需求时间字符串(月)
+ (NSString *)timeStampWithNowSpecialMonth {
    NSDate *detaildate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:detaildate];
}

//任意时间戳转化为时间字符串
+ (NSString *)timeStampWithRandomTime:(NSNumber *)timeStamp {
    NSTimeInterval interval = [timeStamp doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:date];
}

//NSDate转化为指定时间字符串(年月)
+ (NSString *)dateConvertYearAndMonth:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:date];
}

//时间字符串转化为NSDate(年月)
+ (NSDate *)dateStringWithYMConvertDate:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter dateFromString:dateString];
}

//时间字符串转化为NSDate(年月日)
+ (NSDate *)dateStringWithYMDConvertDate:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter dateFromString:dateString];
}

//检测第三方输入带有的表情输入
+ (BOOL)stringContainsEmoji:(NSString *)string {
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}


+ (BOOL)isAllChineseInString:(NSString*)str {
    BOOL result = YES;
    for (int i= 0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (ch < 0x4E00 || ch > 0x9FA5) {
            return NO;
        }
    }
    return result;
}

//判断字串是否为空
+ (BOOL)emptyOrNull:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    return string == nil || (NSNull *)string == [NSNull null] || string.length == 0;
}

+ (void)prefetchImages:(NSArray<NSString *> *)urls completed:(void (^)(NSArray<UIImage *> * _Nullable images, BOOL allFinished))allCompleteBlock
{
    if (urls == nil || urls.count == 0) {
        allCompleteBlock(nil, NO);
        return;
    }
    
    NSMutableArray<NSURL *> *imageURLs = [NSMutableArray array];
    for (NSInteger i = 0; i < urls.count; i++) {
        NSURL *url = [NSURL URLWithString:urls[i]];
        if (url) {
            [imageURLs addObject:url];
        }
    }
    
    [SDWebImagePrefetcher sharedImagePrefetcher].delegateQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [SDWebImagePrefetcher sharedImagePrefetcher].maxConcurrentPrefetchCount = 4;
    
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageURLs progress:^(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls) {
        
    } completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
        if (noOfFinishedUrls == urls.count && noOfSkippedUrls == 0) {
            NSMutableArray<UIImage *> *images = [NSMutableArray array];
            for (NSInteger j = 0; j < noOfFinishedUrls; j++) {
                NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:urls[j]]];
                UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheKey];
                if (image) {
                    [images addObject:image];
                }
            }
            
            if (images.count == imageURLs.count && allCompleteBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    allCompleteBlock(images, YES);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    allCompleteBlock(images, NO);
                });
            }
        } else {
            if (allCompleteBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    allCompleteBlock(nil, NO);
                });
            }
        }
    }];
}

@end
