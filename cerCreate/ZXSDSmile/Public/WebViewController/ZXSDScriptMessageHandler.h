//
//  ZXSDScriptMessageHandler.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/28.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDScriptMessageHandler : NSObject

- (instancetype)initWithWebView:(WKWebView *)webView navigationController:(nonnull UINavigationController *)naviController;

- (void)addScriptHandlers;

- (void)removeScriptHandlers;

@end

NS_ASSUME_NONNULL_END
