//
//  ZXReservedPhoneUpdateViewController.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/20.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"
#import "ZXSDBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN
///预留手机号更新
@interface ZXReservedPhoneUpdateViewController : ZXSDBaseViewController
@property (nonatomic, strong) ZXSDBankCardItem *card;
@property (nonatomic, assign) BOOL isMainCard;

@end

NS_ASSUME_NONNULL_END
