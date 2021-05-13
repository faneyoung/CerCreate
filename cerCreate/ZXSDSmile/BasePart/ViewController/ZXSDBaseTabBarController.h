//
//  ZXSDBaseTabBarController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXSDNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZXTabBarType) {
    ZXTabBarTypeHome,
    ZXTabBarTypeMall,
    ZXTabBarTypeTaskCenter,
    ZXTabBarTypeMine
};

@protocol TabBarSelectedDelegate <NSObject>

@optional;
- (void)tabBar:(UITabBarController*)tabBarController willSelectIndex:(int)nIdx currentIndex:(int)curIdx;

@end

@interface ZXSDBaseTabBarController : UITabBarController
@property (nonatomic, weak) id tabBarDelegate;

- (void)selectTab:(NSInteger)index;

- (void)shouldShowBadge:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
