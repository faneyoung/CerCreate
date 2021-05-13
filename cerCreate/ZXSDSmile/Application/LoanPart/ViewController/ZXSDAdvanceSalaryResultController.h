//
//  ZXSDAdvanceSalaryResultController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//工资预支结果页
@interface ZXSDAdvanceSalaryResultController : ZXSDBaseViewController

// 预支成功
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *loanAmount;

@end

NS_ASSUME_NONNULL_END
