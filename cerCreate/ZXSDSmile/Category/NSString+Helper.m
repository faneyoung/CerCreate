//
//  NSString+Helper.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "NSString+Helper.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import <NSDate+YYAdd.h>

@implementation NSString (Helper)

//判断NSString是否为银行卡号.
- (BOOL)validateStringIsBankCardFormate {
    if (self.length == 0) {
        return NO;
    }
    
    NSString *lastNum = [[self substringFromIndex:(self.length - 1)] copy];//取出最后一位
    NSString *forwardNum = [[self substringToIndex:(self.length - 1)] copy];//前15或18位
    
    NSMutableArray *forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < forwardNum.length; i++) {
        NSString *subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray *forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = (forwardArr.count - 1); i > -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray *arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray *arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray *arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (NSInteger i = 0; i < forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i % 2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        } else {//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            } else {
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal = 0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal % 10 == 0) ? YES : NO;
}

//判断NSString是否为银行卡号和信用卡号.
- (BOOL)validateStringIsAllBankCardFormate {
    if (self.length == 0) {
        return NO;
    }
    
    NSInteger oddsum = 0;     //奇数求和
    NSInteger evensum = 0;    //偶数求和
    NSInteger allsum = 0;
    NSInteger cardNoLength = (NSInteger)[self length];
    NSInteger lastNum = [[self substringFromIndex:cardNoLength - 1] intValue];
    
    NSString *temp = [self substringToIndex:cardNoLength - 1];
    for (NSInteger i = cardNoLength -1 ; i >= 1; i--) {
        NSString *tmpString = [temp substringWithRange:NSMakeRange(i - 1,1)];
        NSInteger tmpVal = [tmpString integerValue];
        if (cardNoLength % 2 == 1 ) {
            if((i % 2) == 0) {
                tmpVal *= 2;
                if(tmpVal >= 10)
                    tmpVal -= 9;
                evensum += tmpVal;
            } else {
                oddsum += tmpVal;
            }
        } else {
            if((i % 2) == 1) {
                tmpVal *= 2;
                if(tmpVal >= 10)
                    tmpVal -= 9;
                evensum += tmpVal;
            } else {
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    
    if((allsum % 10) == 0) {
        return YES;
    } else {
        return NO;
    }
}

//判断NSString是否为整数格式.
- (BOOL)validateStringIsIntegerFormate {
    NSString *regex = @"^[0-9]+$";
    return [self validateStringIsRegexFormate:regex];
}

//判断NSString是否为小数格式.
- (BOOL)validateStringIsDoubleFormate {
    NSString *regex = @"^[0-9]+([.]{1}[0-9]+){0,1}$";
    return [self validateStringIsRegexFormate:regex];
}

//判断NSString是否为纯数字.
- (BOOL)validateStringIsOnlyNumberFormate {
    NSString *regex = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(regex.length > 0) {
        return NO;
    }
    return YES;
}

//判断NSString是否为邮箱格式.
- (BOOL)validateStringIsEmailFormate {
    NSString *regex = @"\\w+(\\.\\w)*@\\w+(\\.\\w{2,3}){1,3}";
    return [self validateStringIsRegexFormate:regex];
}

//判断NSString是否为身份证格式.
- (BOOL)validateStringIsIDCardFormate {
    NSString *value = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([value length]!=18){
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@",year,mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@",leapYear,leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))",yearMmdd,leapyearMmdd,@"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@",area,yyyyMmdd,@"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if(![regexTest evaluateWithObject:value]){
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

//判断NSString是否为手机号码格式.
- (BOOL)validateStringIsPhoneNumberFormate {
    NSString *regex = @"^[1][3,4,5,6,7,8,9][0-9]{9}$";
    return [self validateStringIsRegexFormate:regex];
}

//判断NSString是否为车牌号码格式.
- (BOOL)validateStringIsCarNumberFormate {
    NSString *regex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    return [self validateStringIsRegexFormate:regex];
}

//判断NSString是否为URL格式.
- (BOOL)validateStringIsURLFormate {
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    return [self validateStringIsRegexFormate:regex];
}

//判断NSString是否为中文格式.
- (BOOL)validateStringIsChineseFormate {
    NSString *regex = @"^[\u4e00-\u9fa5]*";
    return [self validateStringIsRegexFormate:regex];
}

//判断NSString是否为姓名格式
- (BOOL)validateStringIsNameFormate {
    NSString *regex = @"^[\u4E00-\u9FA5]{2,8}(?:[·•]{1}[\u4E00-\u9FA5]{2,10})*$";
    return [self validateStringIsRegexFormate:regex];
}

- (BOOL)validateStringIsRegexFormate:(NSString *)formate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",formate];
    return [predicate evaluateWithObject:self];
}

//对NSString进行MD5加密
- (NSString *)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash mutableCopy];
}

//对NSString进行HmacSHA512加密
- (NSString *)hmacSHA512StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
    NSMutableString *hash = [NSMutableString string];
    for (NSInteger i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", buffer[i]];
    }
    return [hash mutableCopy];
}

- (NSString*)phoneNumSensitiveProcessing{
    
    NSString *phone = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (phone.length == 11) {
        NSString *subStr = [NSString stringWithFormat:@"%@ **** %@",[phone substringWithnumber:3 reverse:NO],[phone substringWithnumber:4 reverse:YES]];

        return subStr;
    }

    return @"";
}

#pragma mark - UI -

- (NSAttributedString *)attributeStrWithKeyword:(NSString *)keyword textColor:(UIColor *)textColor font:(UIFont*)font defaultColor:(UIColor *)acolor alignment:(NSTextAlignment)alignment{
    NSArray *ranges = @[[NSValue valueWithRange:[self rangeOfString:keyword]]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;
    
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSInteger i = 0; i < ranges.count; i++) {
        NSRange range = [[ranges objectAtIndex:i] rangeValue];
        [attstr addAttribute:NSForegroundColorAttributeName value:textColor range:range];
        [attstr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [attstr addAttribute:NSFontAttributeName value:font range:range];
    }
    return attstr;
    
}

#pragma mark - url -

- (NSURL *)URLByCheckCharacter{
    if (!IsValidString(self)) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:self];
    if (!url) {
        NSString *encodedURLString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:encodedURLString];
    }
    return url;
}

#pragma mark - 字符串截取 -
- (NSString*)substringWithnumber:(int)num reverse:(BOOL)reverse{
    if (!IsValidString(self)) {
        return nil;
    }
    
    if (num >= self.length) {
        return self;
    }
    
    if (reverse) {
        return [self substringWithRange:NSMakeRange(self.length-num, num)];
    }
    else{
        return [self substringToIndex:num];
    }
    
}

- (NSString *)timeString:(NSTimeInterval)time format:(NSString *)format{
    
    
    NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat = format;
    
    NSString* string=[formatter stringFromDate:data];
    
    return string;
}


@end
