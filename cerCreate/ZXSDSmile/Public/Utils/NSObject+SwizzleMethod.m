//
//  NSObject+SwizzleMethod.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "NSObject+SwizzleMethod.h"

@implementation NSObject (SwizzleMethod)

+ (void)swizzleInstaceMethodWithOriginSel:(SEL)originSel swizzleSel:(SEL)swizzleSel {
    Method originMethod = class_getInstanceMethod(self, originSel);
    Method swizzleMethod = class_getInstanceMethod(self, swizzleSel);
    [self swizzleMethodWithOriginSel:originSel originMethod:originMethod swizzleSel:swizzleSel swizzleMethod:swizzleMethod class:self];
}

+ (void)swizzleMethodWithOriginSel:(SEL)originSel originMethod:(Method)originMethod swizzleSel:(SEL)swizzleSel swizzleMethod:(Method)swizzleMethod class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, originSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzleSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else {
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}

@end
