//
//  ZXLoadingManager.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kLoadingTip = @"加载中...";

@interface ZXLoadingManager : NSObject

+ (void)showLoading:(NSString * __nullable)text;
+ (void)showLoading:(NSString * __nullable)text inView:(UIView * __nullable)aView;

+(void)hideLoading;

@end

static inline void LoadingManagerShow(){
    [ZXLoadingManager showLoading:kLoadingTip];
}

static inline void LoadingManagerShowText(NSString * _Nullable tip){
    if (IsValidString(tip)) {
        [ZXLoadingManager showLoading:tip];
    }
    else{
        [ZXLoadingManager showLoading:kLoadingTip];
    }
}


static inline void LoadingManagerHidden(){
    [ZXLoadingManager hideLoading];
}

static inline void ToastShow(NSString* text){
    if (!IsValidString(text)) {
        return;
    }
    [EasyTextView showText:text];
}



NS_ASSUME_NONNULL_END
