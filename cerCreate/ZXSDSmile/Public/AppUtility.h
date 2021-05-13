//
//  AppUtility.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppUtility : NSObject

+ (void)textWithInputView:(UITextField *)textView maxNum:(NSInteger)limitNum;
+ (BOOL)textWithInputView:(UITextField *)textView maxNum:(NSInteger)limitNum shouldResign:(BOOL)resign;

+ (BOOL)textWithInputView:(UITextField *)textView maxNum:(NSInteger)limitNum shouldResign:(BOOL)resign allowZH:(BOOL)zh;

+ (void)showAppstoreEvaluationView;

+ (void)saveImage:(UIImage *)img complete:(void (^)(NSError *error))complete;

+ (void)alertContentView:(id)content;

+ (void)alertViewWithTitle:(NSString* __nullable)title des:(NSString* __nullable)des cancel: (void(^)(void))cancelBlock confirm:(void(^)(void))confirmBlock;
+ (void)alertViewWithTitle:(NSString* __nullable)title des:(NSString* __nullable)des confirm:(void(^)(void))confirmBlock;
+ (void)alertViewWithTitle:(NSString* __nullable)title des:(NSString* __nullable)des confirm:(NSString*)confirm confirmBlock:(void(^)(void))confirmBlock;
+ (void)alertViewWithTitle:(NSString* __nullable)title content:(NSString* __nullable)des cancelTitle:(NSString*)cStr cancel: (void(^)(void))cancelBlock confirmTitle:(NSString*)fStr confirm:(void(^)(void))confirmBlock;

@end

NS_ASSUME_NONNULL_END
