//
//  UITableViewCell+BottomLine.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/16.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (BottomLine)

@property (nonatomic, strong, readonly) UIView *bottomLine;

- (void)showBottomLine;
- (void)hideBottomLine;

- (void)shouldHideBottomLine:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
