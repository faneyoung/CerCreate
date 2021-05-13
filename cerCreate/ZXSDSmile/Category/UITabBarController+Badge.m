//
//  UITabBarController+Badge.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "UITabBarController+Badge.h"

#define kBadgeViewTag   109090

@implementation UITabBarController (Badge)

- (void)showBadgeAtIndex:(int)index{
 
    //移除之前的小红点
    [self removeBadgeAtIndex:index];

    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
 
    badgeView.tag = kBadgeViewTag + index;
    badgeView.layer.cornerRadius = 4;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.tabBar.frame;
 
    //确定小红点的位置
    float percentX = (index +0.54) / self.viewControllers.count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
 
    badgeView.frame = CGRectMake(x, y, 8, 8);
 
    [self.tabBar addSubview:badgeView];
 
}
 
 
 ///移除小红点

- (void)hideBadgeAtIndex:(int)index{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self removeBadgeAtIndex:index];
}
 
 
 ///按照tag值进行移除
- (void)removeBadgeAtIndex:(int)index{
 
    [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.tag == kBadgeViewTag + index) {
            [obj removeFromSuperview];
        }
    }];
}

@end
