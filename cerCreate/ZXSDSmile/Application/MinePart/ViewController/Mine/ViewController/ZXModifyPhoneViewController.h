//
//  ZXModifyPhoneViewController.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ModifyPhonePageType) {
    ModifyPhonePageTypeDefault,
    ModifyPhonePageTypeSingleChange,
};

@interface ZXModifyPhoneViewController : ZXSDBaseViewController
@property (nonatomic, assign) ModifyPhonePageType pageType;

@end

NS_ASSUME_NONNULL_END
