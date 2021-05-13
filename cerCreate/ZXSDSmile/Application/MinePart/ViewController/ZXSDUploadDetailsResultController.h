//
//  ZXSDUploadDetailsResultController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/16.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDUploadDetailsResultController : ZXSDBaseViewController

@property (nonatomic, copy) NSString *certType;
@property (nonatomic, copy) NSString *certStatus;
@property (nonatomic, copy) NSString *failureDesc;
@property (nonatomic, assign) BOOL canGoBack;

@end

NS_ASSUME_NONNULL_END
