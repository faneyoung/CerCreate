//
//  ZXScreenshotDesViewController.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/3.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXScreenshotDesViewController : ZXSDBaseViewController
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) void (^desVCConfirmBlock)(void);

@end

NS_ASSUME_NONNULL_END
