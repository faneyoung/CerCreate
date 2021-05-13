//
//  ZXCouponListViewController.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, CouponListPageType) {
    CouponListPageTypeUnused=1,
    CouponListPageTypeUsed,
    CouponListPageTypeOverdue,
};
@interface ZXCouponListViewController : ZXSDBaseViewController <JXCategoryListContentViewDelegate>
@property (nonatomic, assign) CouponListPageType counponType;

@end

NS_ASSUME_NONNULL_END
