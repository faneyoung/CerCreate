//
//  YJYZFRegex.h
//  YJYZFoundation
//
//  Created by yjyz on 15-1-20.
//  Copyright (c) 2015年 YJYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  替换处理
 *
 *  @param captureCount    捕获数量
 *  @param capturedStrings 捕获字符串集合
 *  @param capturedRanges  捕获字符串范围集合
 *  @param stop            是否停止捕获标识
 *
 *  @return 替换后的字符串
 */
typedef NSString *(^YJYZFReplacingOccurrencesHandler) (NSInteger captureCount, NSString *const capturedStrings[captureCount], const NSRange capturedRanges[captureCount], volatile BOOL * const stop);

/**
 正则表达式选项
 
 - YJYZFRegexOptionsNoOptions: 无匹配
 - YJYZFRegexOptionsCaseless: 不区分字母大小写的模式
 - YJYZFRegexOptionsComments: 忽略掉正则表达式中的空格和#号之后的字符
 - YJYZFRegexOptionsIgnoreMetacharacters: 将正则表达式整体作为字符串处理
 - YJYZFRegexOptionsDotAll: 允许.匹配任何字符，包括换行符
 - YJYZFRegexOptionsMultiline: 允许^和$符号匹配整段文本的开头和结尾
 - YJYZFRegexOptionsUseUnixLineSeparators: 设置\n为唯一的行分隔符，否则所有的都有效。
 - YJYZFRegexOptionsUnicodeWordBoundaries: 使用Unicode TR#29标准作为词的边界，否则所有传统正则表达式的词边界都有效
 */
typedef NS_ENUM(NSUInteger, YJYZFRegexOptions)
{
    YJYZFRegexOptionsNoOptions               = 0,
    YJYZFRegexOptionsCaseless                = 1 << 0,
    YJYZFRegexOptionsComments                = 1 << 1,
    YJYZFRegexOptionsIgnoreMetacharacters    = 1 << 2,
    YJYZFRegexOptionsDotAll                  = 1 << 3,
    YJYZFRegexOptionsMultiline               = 1 << 4,
    YJYZFRegexOptionsUseUnixLineSeparators   = 1 << 5,
    YJYZFRegexOptionsUnicodeWordBoundaries   = 1 << 6,
};

/**
 *  正则表达式工具类
 */
@interface YJYZFRegex : NSObject

/**
 *  替换字符串
 *
 *  @param regex    正则表达式
 *  @param string   原始字符串
 *  @param block    块回调处理替换规则
 *
 *  @return 字符串
 */
+ (NSString *)stringByReplacingOccurrencesOfRegex:(NSString *)regex
                                       withString:(NSString *)string
                                       usingBlock:(YJYZFReplacingOccurrencesHandler)block;

/**
 *  匹配字符串
 *
 *  @param regex    正则表达式
 *  @param options  表达式选项
 *  @param range    匹配范围
 *  @param string   原始字符串
 *
 *  @return YES 匹配，NO 不匹配
 */
+ (BOOL)isMatchedByRegex:(NSString *)regex
                 options:(YJYZFRegexOptions)options
                 inRange:(NSRange)range
              withString:(NSString *)string;

/**
 *  匹配字符串
 *
 *  @param regex 正则表达式
 *  @param string   原始字符串
 *
 *  @return 匹配的字符串集合
 */
+ (NSArray *)captureComponentsMatchedByRegex:(NSString *)regex
                                  withString:(NSString *)string;

@end
