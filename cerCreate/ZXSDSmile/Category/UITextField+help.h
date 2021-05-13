//
//  UITextField+help.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/28.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (help)

- (BOOL)filter:(NSString*)filter toString:(NSString*)string range:(NSRange)range maxLenght:(int)lenght;

@end

NS_ASSUME_NONNULL_END
