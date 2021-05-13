//
//  NSString+Helper.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHECK_VALID_STRING(__aString)               (__aString && [__aString isKindOfClass:[NSString class]] && [__aString length])

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Helper)

/**
 @abstract 判断NSString是否为银行卡号.
 **/
- (BOOL)validateStringIsBankCardFormate;
/**
 @return 判断NSString是否为银行卡号和信用卡号.
 */
- (BOOL)validateStringIsAllBankCardFormate;
/**
 @abstract 判断NSString是否为整数格式.
 **/
- (BOOL)validateStringIsIntegerFormate;
/**
 @abstract 判断NSString是否为小数格式.
 **/
- (BOOL)validateStringIsDoubleFormate;
/**
 @abstract 判断NSString是否为纯数字.
 **/
- (BOOL)validateStringIsOnlyNumberFormate;
/**
 @abstract 判断NSString是否为邮箱格式.
 **/
- (BOOL)validateStringIsEmailFormate;
/**
 @abstract 判断NSString是否为身份证格式.
 **/
- (BOOL)validateStringIsIDCardFormate;
/**
 @abstract 判断NSString是否为手机号码格式.
 **/
- (BOOL)validateStringIsPhoneNumberFormate;
/**
 @abstract 判断NSString是否为车牌号码格式.
 **/
- (BOOL)validateStringIsCarNumberFormate;
/**
 @abstract 判断NSString是否为URL格式.
 **/
- (BOOL)validateStringIsURLFormate;
/**
 @abstract 判断NSString是否为中文格式.
 **/
- (BOOL)validateStringIsChineseFormate;
/**
 @abstract 判断NSString是否为姓名格式
 **/
- (BOOL)validateStringIsNameFormate;
/**
 @abstract 对NSString进行MD5加密
**/
- (NSString *)MD5;
/**
 @abstract 对NSString进行HmacSHA512加密
**/
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;


/// 手机号中间4位脱敏处理
- (NSString*)phoneNumSensitiveProcessing;

- (NSAttributedString *)attributeStrWithKeyword:(NSString *)keyword textColor:(UIColor *)textColor font:(UIFont*)font defaultColor:(UIColor *)color alignment:(NSTextAlignment)alignment;

- (NSURL *)URLByCheckCharacter;

/**
 字符串截取
 */

/// 子串
/// @param num 要截取几位
/// @param reverse 从后往前还是从前往后，默认从前往后
- (NSString*)substringWithnumber:(int)num reverse:(BOOL)reverse;


#pragma mark - 时间格式化 -
- (NSString *)timeString:(NSTimeInterval)time format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
