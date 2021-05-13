//
//  ZXMainBannerView.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/1.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ZXMainBannerViewDelegate <NSObject>

@optional;
- (void)pagerView:(UIView *)bannerView didScrollAIndex:(NSInteger)toIndex;

- (void)bannerView:(UIView *)bannerView didSelectItemAtIndex:(NSInteger)index;

@end

@interface ZXMainBannerView : ZXBaseView

@property (nonatomic, weak) id <ZXMainBannerViewDelegate> delegate;

@property (nonatomic, assign) BOOL hidePageControl;
@property (nonatomic, assign) CGFloat pageControlBottom;
@property (nonatomic, assign) int pageControlAlignment;
@property (nonatomic, assign) CGFloat pageIndicatorSpaing;
@property (nonatomic, assign) CGFloat autoScrollInterval;

/// 是否自动滚动。默认yes
@property (nonatomic, assign) BOOL autoScroll;


///width/height
@property (nonatomic, assign) CGSize contentSize;

- (void)updateViewWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
