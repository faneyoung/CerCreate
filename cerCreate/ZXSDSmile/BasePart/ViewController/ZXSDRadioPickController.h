//
//  ZXSDRadioPickController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnStringBlock)(NSString *returnString);
typedef void (^ReturnVoidBlock)(void);

@interface ZXSDRadioPickController : ZXSDBaseViewController

@property (nonatomic, copy) NSString *pickTitle;
@property (nonatomic, retain) NSArray *pickArray;
@property (nonatomic, copy) ReturnStringBlock pickAchieveString;
@property (nonatomic, assign) BOOL isSelectNumber;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *selectedValue;

- (void)beginAnimation;

@end

NS_ASSUME_NONNULL_END
