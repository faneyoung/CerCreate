//
//  UINavigationBar+Fix.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "UINavigationBar+Fix.h"
#import "NSObject+SwizzleMethod.h"

@implementation UINavigationBar (Fix)

+(void)load {
    static dispatch_once_t onceTokenBar;
    dispatch_once(&onceTokenBar, ^{
        //[self swizzleInstaceMethodWithOriginSel:@selector(layoutSubviews) swizzleSel:@selector(zxsd_layoutSubviews)];
    });
}

- (void)zxsd_layoutSubviews {
    [self zxsd_layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        if (@available(iOS 10.0, *)) {

            if (@available(iOS 13.0, *)) {
                
                self.subviews[0].subviews[0].hidden = YES;
            }else {
                
                self.subviews[0].subviews[1].hidden = YES;
            }
        } else {
            //iOS10之前使用的是_UINavigationBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                
                [view.subviews firstObject].hidden = YES;
            }
        }
    }];
    
}

@end
