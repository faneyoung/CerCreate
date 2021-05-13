//
//  NSDate+help.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "NSDate+help.h"

@implementation NSDate (help)
//时间显示内容
-(NSString *)getDateDisplayString{
//    NSLog(@"-时间戳---%lld_----",miliSeconds);

//    NSTimeInterval tempMilli = miliSeconds;
//    NSTimeInterval seconds = tempMilli/1000.0;
//    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:self];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
//    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    } else {
//        if (nowCmps.day==myCmps.day) {
//            dateFmt.AMSymbol = @"上午";
//            dateFmt.PMSymbol = @"下午";
//            dateFmt.dateFormat = @"aaa hh:mm";
//
//        } else if((nowCmps.day-myCmps.day)==1) {
//            dateFmt.dateFormat = @"昨天";
//        } else {
//            if ((nowCmps.day-myCmps.day) <=7) {
//                switch (comp.weekday) {
//                    case 1:
//                        dateFmt.dateFormat = @"星期日";
//                        break;
//                    case 2:
//                        dateFmt.dateFormat = @"星期一";
//                        break;
//                    case 3:
//                        dateFmt.dateFormat = @"星期二";
//                        break;
//                    case 4:
//                        dateFmt.dateFormat = @"星期三";
//                        break;
//                    case 5:
//                        dateFmt.dateFormat = @"星期四";
//                        break;
//                    case 6:
//                        dateFmt.dateFormat = @"星期五";
//                        break;
//                    case 7:
//                        dateFmt.dateFormat = @"星期六";
//                        break;
//                    default:
//                        break;
//                }
//            }else {
//                dateFmt.dateFormat = @"MM-dd hh:mm";
//            }
//        }else{
            dateFmt.dateFormat = @"yyyy.MM.dd HH:mm";
//        }
    }
    return [dateFmt stringFromDate:self];
}

+ (NSDate*)yesterday{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];

    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    return yesterday;
}

+ (NSDate*)dateWithString:(NSString*)string formatter:(NSString*)formatter{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:formatter];
    NSDate *date = [format dateFromString:string];
    return date;
}

+ (NSString *)checkTheDate:(NSString *)string{
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    NSString *strDiff = nil;
    
    if(isToday) {
        strDiff= [NSString stringWithFormat:@"今天"];
    }
    return strDiff;
}
/**
 NSCalendar其他判断方法
 
 - (BOOL)isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2//判断两个日期是否是同一天
 
 - (BOOL)isDateInToday:(NSDate *)date; //判断一个日期是否是今天
 
 - (BOOL)isDateInYesterday:(NSDate *)date; //判断一个日期是否是昨天
 
 - (BOOL)isDateInTomorrow:(NSDate *)date;//判断一个日期是否是明天
 
 - (BOOL)isDateInWeekend:(NSDate *)date ; //判断一个日期是否是在本周
 */

- (BOOL)isToday

{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    // 1.获得当前时间的年月日
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return
    
    (selfCmps.year == nowCmps.year) &&
    
    (selfCmps.month == nowCmps.month) &&
    
    (selfCmps.day == nowCmps.day);
    
}

- (BOOL)isYesterday
{
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}

- (BOOL)isThisYear

{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (BOOL)isThisMonth{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitMonth;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.month == selfCmps.month;
}


- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfStr = [fmt stringFromDate:self];
    
    return [fmt dateFromString:selfStr];
}

- (NSString *)stringWithYMD{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfStr = [fmt stringFromDate:self];
    return selfStr;
}

- (NSString *)stringWithYMD:(NSString *)formatter{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = formatter;
    
    NSString *selfStr = [fmt stringFromDate:self];
    return selfStr;
}


- (NSTimeInterval)deltaWithNow
{
    return [self deltaWithDate:[NSDate date]];
}

- (NSTimeInterval)deltaWithDate:(NSDate*)date
{
    static int hourToSec = 24*60*60;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit=NSCalendarUnitDay |
                    NSCalendarUnitHour |
                    NSCalendarUnitMinute |
                    NSCalendarUnitSecond;
    
    NSDateComponents *components = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
    NSTimeInterval interval = components.day*24*hourToSec + components.hour*hourToSec + components.minute*60 + components.second;
    
    return interval;
    
    
}

+ (NSDateComponents*)deltaComponentsWithDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit=NSCalendarUnitDay |
                    NSCalendarUnitHour |
                    NSCalendarUnitMinute |
                    NSCalendarUnitSecond;
    
    NSDateComponents *components = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
    return components;
}


+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                  withDateFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return [NSDate datestrFromDate:date withDateFormat:format];
}
 
+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format
{
    NSDateFormatter* dateFormat = [NSDate defaultFormatter];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

static NSDateFormatter *dateFormatter;
+(NSDateFormatter *)defaultFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
    });
    return dateFormatter;
}


@end
