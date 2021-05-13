//
//  ZXLoadingManager.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXLoadingManager.h"

@interface ZXLoadingManager ()
@property (nonatomic, strong) NSMutableArray *targetViews;

+ (instancetype)sharedInstance;

@end

@implementation ZXLoadingManager

static ZXLoadingManager *sharedInstance = nil;
+(instancetype)sharedInstance{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[ZXLoadingManager alloc] init];
        }
    }
    return sharedInstance;
}


+ (void)showLoading:(NSString *__nullable)text{
    [ZXLoadingManager showLoading:text inView:nil];
}

+ (void)showLoading:(NSString * __nullable)text inView:(UIView * __nullable)aView{
    dispatch_safe_async_main(^{
        [ZXLoadingManager hideLoading];
        
        UIView *targetView = aView;
        if (!targetView) {
            targetView = [UIApplication sharedApplication].keyWindow;
        }
        else{
            [[ZXLoadingManager sharedInstance].targetViews addObject:aView];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.detailsLabel.text = text;
        
        hud.contentColor = [UIColor whiteColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0 alpha:.8];
        
        hud.removeFromSuperViewOnHide = YES;
    });
}

+ (void)hideLoading{
    
    dispatch_safe_async_main(^{
        
        [[ZXLoadingManager sharedInstance].targetViews enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [MBProgressHUD hideHUDForView:obj animated:NO];
        }];
        [[ZXLoadingManager sharedInstance].targetViews removeAllObjects];

        UIView *keywindow = [UIApplication sharedApplication].keyWindow;
        [MBProgressHUD hideHUDForView:keywindow animated:NO];
    });
}

#pragma mark - help methods -
- (NSMutableArray *)targetViews{
    if (!_targetViews) {
        _targetViews = [NSMutableArray arrayWithCapacity:1];
    }
    return _targetViews;
}

@end
