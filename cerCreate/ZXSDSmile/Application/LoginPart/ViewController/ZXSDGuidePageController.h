//
//  ZXSDGuidePageController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnVoidBlock)(void);

@interface ZXSDGuidePageController : ZXSDBaseViewController

@property (nonatomic, copy) ReturnVoidBlock jumpGuideBlock;

@end

NS_ASSUME_NONNULL_END
