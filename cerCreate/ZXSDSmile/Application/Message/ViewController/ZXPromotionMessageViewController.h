//
//  ZXPromotionMessageViewController.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXPromotionMessageViewController : ZXSDBaseViewController

//1推荐工作，不传默认以前老逻辑
@property (nonatomic, strong) NSString *businessType;

@property (nonatomic, strong) NSDictionary *locationDic;

@end

NS_ASSUME_NONNULL_END
