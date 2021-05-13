//
//  UITextField+help.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/28.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "UITextField+help.h"

@implementation UITextField (help)

- (BOOL)filter:(NSString*)filter toString:(NSString*)string range:(NSRange)range maxLenght:(int)lenght{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:filter] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if ([filter isEqualToString:kChineseFilter]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",filter];
        BOOL isChinese = [predicate evaluateWithObject:string];
        if (!isChinese) {
            return isChinese;
        }
    }
    else{
        //字母和数字判断
        if (![string isEqualToString:filtered]) {
            return NO;
        }
    }
    
    if (range.length + range.location > self.text.length) {
        return NO;
    }
    NSUInteger newLength = self.text.length + string.length - range.length;
    return newLength <= lenght;

}

@end
