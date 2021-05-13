//
//  UITabBarController+Badge.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarController (Badge)

- (void)showBadgeAtIndex:(int)index;
- (void)hideBadgeAtIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
