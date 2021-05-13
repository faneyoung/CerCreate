//
//  ZXSDAgreementAlertView.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/8.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnVoidBlock)(void);

@interface ZXSDAgreementAlertView : UIView

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, assign) NSInteger alertTitleLines;
@property (nonatomic, copy) NSString *alertContent;
@property (nonatomic, copy) NSString *confirmButtonTitle;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) ReturnVoidBlock confirmBlock;
@property (nonatomic, copy) ReturnVoidBlock cancelBlock;
@property (nonatomic, copy) ReturnVoidBlock userAgreementBlock;
@property (nonatomic, copy) ReturnVoidBlock privacyAgreementBlock;
@property (nonatomic, copy) ReturnVoidBlock personalPrivacyBlock;

- (id)initWithFrame:(CGRect)frame alertTitle:(NSString *)title alertTitleLines:(NSInteger)lines alertContent:(NSString *)content hasJumpLink:(BOOL)exist cancelButtonTitle:(NSString *)cancelTitle andConfirmButtonTitle:(NSString *)confirmTitle;

- (void)setTitleColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
