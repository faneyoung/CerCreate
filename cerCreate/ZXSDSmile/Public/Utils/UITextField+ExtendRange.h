//
//  UITextField+ExtendRange.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (ExtendRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
