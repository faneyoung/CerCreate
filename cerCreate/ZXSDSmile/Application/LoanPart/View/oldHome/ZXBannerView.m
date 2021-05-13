//
//  ZXBannerView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBannerView.h"
#import <SDCycleScrollView.h>

@interface ZXBannerView () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSMutableArray *showedBanners;

@property (nonatomic, weak)  UILabel *browserImageNumLabel;

@end

@implementation ZXBannerView

- (void)dealloc{
    NSLog(@"--------------ZXBannerView dealloc");
}

- (void)initSubViews{
    [super initSubViews];
    self.backgroundColor = UIColor.whiteColor;
    
    SDCycleScrollView *bannerView = [[SDCycleScrollView alloc] init];
    bannerView.backgroundColor = UIColor.whiteColor;
//    bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    bannerView.placeholderImage = UIImageNamed(@"");
    bannerView.autoScrollTimeInterval = 3.0;
    bannerView.pageControlDotSize = CGSizeMake(5, 5);
    bannerView.pageControlBottomOffset = 0;
    bannerView.currentPageDotColor = kThemeColorMain;
    bannerView.pageDotColor = [UIColor colorWithWhite:0 alpha:0.36];
    bannerView.delegate = self;
    [self addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _bannerView = bannerView;
}

- (void)updateViewWithModel:(id)model{
    self.banners = model;
    
    NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
    [self.banners enumerateObjectsUsingBlock:^(ZXBannerModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageUrls addObject:GetString(obj.cover)];
    }];
    self.bannerView.imageURLStringsGroup = imageUrls;
    if (imageUrls.count>0) {
        self.bannerView.showPageControl = YES;

    }

}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    ZXBannerModel *banner = [self.banners objectAtIndex:index];
    if (!IsValidString(banner.url)) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:cycleScrollView didSelectItemAtIndex:index];
    }
    else{
        [URLRouter routerUrlWithPath:banner.url extra:nil];
    }
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    ZXBannerModel *banner = [self.banners objectAtIndex:index];

}

#pragma mark - help methods -

- (void)setPageDotBottomOffset:(CGFloat)pageDotBottomOffset{
    self.bannerView.pageControlBottomOffset = pageDotBottomOffset;
}


@end
