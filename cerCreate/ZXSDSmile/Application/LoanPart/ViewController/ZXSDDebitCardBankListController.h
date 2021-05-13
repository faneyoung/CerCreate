//
//  ZXSDDebitCardBankListController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnStringBlock)(NSString *bankName, NSString *bankLogoUrl, NSString *bankCode);

@interface ZXSDDebitCardBankListController : ZXSDBaseViewController

@property (nonatomic, copy) ReturnStringBlock selectResultBlock;

@end

NS_ASSUME_NONNULL_END
