//
//  UIButton+Align.h
//  wlive
//
//  Created by Fane on 2020/6/22.
//  Copyright © 2020 wcsz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonAlignImgType) {
    ButtonAlignImgTypeTop, // image在上，label在下
    ButtonAlignImgTypeLeft, // image在左，label在右
    ButtonAlignImgTypeBottom, // image在下，label在上
    ButtonAlignImgTypeRight // image在右，label在左
};

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Align)

- (void)alignWithType:(ButtonAlignImgType)style
               margin:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
