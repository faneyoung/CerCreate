//
//  UIViewController+help.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "UIViewController+help.h"

@implementation UIViewController (help)

- (void)adaptScrollView:(UIScrollView *)scrollView{
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

@end
