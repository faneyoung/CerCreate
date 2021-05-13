//
//  ZXCardListViewController.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/6.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"
@class ZXSDBankCardItem;

NS_ASSUME_NONNULL_BEGIN

@interface ZXCardListViewController : ZXSDBaseViewController
@property (nonatomic, strong) ZXSDBankCardItem *card;

@end

NS_ASSUME_NONNULL_END
