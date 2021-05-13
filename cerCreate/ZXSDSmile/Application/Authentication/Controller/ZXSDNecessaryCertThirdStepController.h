//
//  ZXSDNecessaryCertThirdStepController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/19.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

// 绑定银行卡
@interface ZXSDNecessaryCertThirdStepController : ZXSDBaseViewController
@property (nonatomic, strong) NSString *customTitle;
@property (nonatomic, strong) NSString *confirmTitle;

@property (nonatomic, assign) BOOL addCardMode;

@property (nonatomic, assign) BOOL hasNote;


@end

NS_ASSUME_NONNULL_END
