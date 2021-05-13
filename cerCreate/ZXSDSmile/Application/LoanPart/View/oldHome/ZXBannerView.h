//
//  ZXBannerView.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseView.h"
#import "ZXBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WLBannerViewType) {
    WLBannerViewTypeHomeTop,
    WLBannerViewTypeAuctionTop,
    WLBannerViewTypeMine,
};

@protocol ZXBannerViewDelegate <NSObject>

@optional;
- (void)bannerView:(UIView *)bannerView didSelectItemAtIndex:(NSInteger)index;

@end

@interface ZXBannerView : ZXBaseView

@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) CGFloat pageDotBottomOffset;
@property(nonatomic, assign) WLBannerViewType bannerType;

// 查看大图, 默认no
@property (nonatomic) BOOL showBrowser;

@end

NS_ASSUME_NONNULL_END
