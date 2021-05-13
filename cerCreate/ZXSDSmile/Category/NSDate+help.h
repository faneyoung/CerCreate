//
//  NSDate+help.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSDate (help)
///是否是今天
- (BOOL)isToday;
///是否是昨天
- (BOOL)isYesterday;
///是否是当月
- (BOOL)isThisMonth;
///是否是今年
- (BOOL)isThisYear;
///返回一个 年-月-日
- (NSDate *)dateWithYMD;
- (NSString *)stringWithYMD;
- (NSString *)stringWithYMD:(NSString *)formatter;

///和现在的时间差
- (NSTimeInterval)deltaWithNow;
///和date的时间差
- (NSTimeInterval)deltaWithDate:(NSDate*)date;

+ (NSDateComponents*)deltaComponentsWithDate:(NSDate*)date;

///获取昨天
+ (NSDate*)yesterday;

///一个日期是否是当天
+ (NSString *)checkTheDate:(NSString *)string;
///从字符串中获取一个date
+ (NSDate*)dateWithString:(NSString*)string formatter:(NSString*)formatter;


-(NSString *)getDateDisplayString;

+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
