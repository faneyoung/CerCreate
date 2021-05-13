//
//  UIViewController+ZXSwizzling.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "UIViewController+ZXSwizzling.h"
#import <objc/runtime.h>

#import "ZXReplayKitManager.h"


@implementation UIViewController (ZXSwizzling)

+ (void)load {
    
    //我们只有在开发的时候才需要查看哪个viewController将出现
    //所以在release模式下就没必要进行方法的交换
#if TEST
    [self methodsSwizzling];
#elif UAT
    [self methodsSwizzling];

#elif RELEASE
        
#endif
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(presentViewController:animated:completion:) withAnotherSelector:@selector(mna_presentViewController:animated:completion:)];
    });

    
}

+ (void)methodsSwizzling{
    //原本的viewWillAppear方法
    Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    //需要替换成 能够输出日志的viewWillAppear
    Method logViewWillAppear = class_getInstanceMethod(self, @selector(logViewWillAppear:));
    //两方法进行交换
    method_exchangeImplementations(viewWillAppear, logViewWillAppear);

}

- (void)logViewWillAppear:(BOOL)animated {
    
    NSString *className = NSStringFromClass([self class]);
    
    NSLog(@"**********  %@ will appear ****************************",className);
    
    //下面方法的调用，其实是调用viewWillAppear
    [self logViewWillAppear:animated];
}

- (void)mna_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([NSStringFromClass(viewControllerToPresent.class) isEqualToString:@"RPBroadcastPickerStandaloneViewController"]) {
        ZXReplayKitManager.sharedInstance.replayKitBroadVC = viewControllerToPresent; //该管理类监听录制进程启动完成的通知然后进行Dismiss
        [self mna_presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [self mna_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    
}



#pragma mark - methods exchange utility -
+ (void)swizzleSelector:(SEL)originalSelector withAnotherSelector:(SEL)swizzledSelector
{
    Class aClass = [self class];

    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);

    BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
