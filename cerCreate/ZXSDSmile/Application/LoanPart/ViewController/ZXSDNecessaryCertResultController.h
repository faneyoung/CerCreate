//
//  ZXSDNecessaryCertResultController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/18.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

// 雇主审核结果页
@interface ZXSDNecessaryCertResultController : ZXSDBaseViewController

@property (nonatomic, copy) ZXSDHomeUserApplyStatus reviewStatus;
// 雇主审核失败原因
@property (nonatomic, copy) NSString *failReason;

@end

NS_ASSUME_NONNULL_END
