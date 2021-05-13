//
//  ZXSDMultipleChoicePickController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnProvinceAndCityBlock)(NSString *province, NSString *city);

@interface ZXSDMultipleChoicePickController : ZXSDBaseViewController

@property (nonatomic, copy) NSString *pickTitle;
@property (nonatomic, retain) NSArray *provinceArray;
@property (nonatomic, copy) ReturnProvinceAndCityBlock pickAchieveString;

- (void)beginAnimation;

@end

NS_ASSUME_NONNULL_END
