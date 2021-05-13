//
//  ZXSDPersonalSettingsAlertController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnVoidBlock)(void);

@interface ZXSDPersonalSettingsAlertController : ZXSDBaseViewController

@property (nonatomic, copy) ReturnVoidBlock confirmBlock;

- (void)dismissViewController;

@end

NS_ASSUME_NONNULL_END
