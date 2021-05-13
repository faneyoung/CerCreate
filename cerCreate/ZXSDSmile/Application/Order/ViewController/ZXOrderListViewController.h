//
//  ZXOrderListViewController.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/15.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OrderPageType) {
    OrderPageTypeAll,///全部
    OrderPageTypeToPay,///待支付
    OrderPageTypeFinished,///已支付
    OrderPageTypeChargeback,///已退单
};

@interface ZXOrderListViewController : ZXSDBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) OrderPageType pageType;

@end

NS_ASSUME_NONNULL_END
