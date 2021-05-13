//
//  ZXMainBannerView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/1.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMainBannerView.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>

#import "ZXMainBannerItemCell.h"

@interface ZXMainBannerView () <TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;

@property (nonatomic, strong) NSArray *banners;

@end

@implementation ZXMainBannerView

- (void)dealloc{
    NSLog(@"--------------ZXMainBannerView dealloc");
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    self.pagerView.frame = self.bounds;
//    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.frame)-26, SCREEN_WIDTH(), 26);
//}

- (void)initSubViews{
    [super initSubViews];
    self.backgroundColor = UIColor.whiteColor;

    self.autoScroll = YES;
    [self addPagerView];
    [self addPageControl];
}

- (void)updateViewWithModel:(NSArray*)model{
    self.banners = model;
    
//    NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
//    [self.banners enumerateObjectsUsingBlock:^(ZXBannerModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [imageUrls addObject:GetString(obj.cover)];
//    }];
//    self.bannerView.imageURLStringsGroup = imageUrls;
//    if (imageUrls.count>0) {
//        self.bannerView.showPageControl = YES;
//
//    }
    
    [self reloadData];

}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView
{
    return self.banners.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    ZXMainBannerItemCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"ZXMainBannerItemCell" forIndex:index];
    [cell updateContentViewWithData:self.banners[index]];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView
{
    CGFloat margin = 16;
    CGFloat width = SCREEN_WIDTH()-2*margin;
    
    CGFloat height = (SCREEN_WIDTH()-2*margin)*128/343;

    if (self.contentSize.width > 0 &&
        self.contentSize.height > 0) {
        width = self.contentSize.width;
        height = self.contentSize.height;
    }

    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    layout.itemSize = CGSizeMake(width, height);
    layout.itemSpacing = 15;
    layout.itemHorizontalCenter = YES;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
//    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
    if ([self.delegate respondsToSelector:@selector(pagerView:didScrollAIndex:)]) {
        [self.delegate pagerView:self didScrollAIndex:toIndex];
    }
}


- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:self didSelectItemAtIndex:index];
    }

}

#pragma mark - help methods -

- (void)reloadData{
    _pageControl.numberOfPages = self.banners.count;
    _pageControl.hidden = !IsValidArray(self.banners) || self.hidePageControl;

    [_pagerView reloadData];
}

- (void)setAutoScrollInterval:(CGFloat)autoScrollInterval{
    _autoScrollInterval = autoScrollInterval;
    self.pagerView.autoScrollInterval = autoScrollInterval;
    
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScrollInterval = autoScroll;
    
    if (autoScroll) {
        [self setAutoScrollInterval:3];
    }
    else{
        [self setAutoScrollInterval:CGFLOAT_MAX];
    }
    
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 3.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerClass:[ZXMainBannerItemCell class] forCellWithReuseIdentifier:@"ZXMainBannerItemCell"];
    [self addSubview:pagerView];
    [pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    _pagerView = pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(12, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
    pageControl.pageIndicatorTintColor = TextColorgray;
//    pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
//    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
//    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_pagerView addSubview:pageControl];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(16);
        make.bottom.inset(0);
        make.height.mas_equalTo(30);
    }];
    
    _pageControl = pageControl;
}


- (void)setPageControlBottom:(CGFloat)pageControlBottom{
    _pageControlBottom = pageControlBottom;
    
    [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.inset(pageControlBottom);
    }];
    
    [self layoutIfNeeded];

}

- (void)setPageControlAlignment:(int)pageControlAlignment{
    _pageControlAlignment = pageControlAlignment;
    self.pageControl.contentHorizontalAlignment = pageControlAlignment;
}

- (void)setHidePageControl:(BOOL)hidePageControl{
    _hidePageControl = hidePageControl;
    self.pageControl.hidden = hidePageControl;
}

- (void)setPageIndicatorSpaing:(CGFloat)pageIndicatorSpaing{
    _pageIndicatorSpaing = pageIndicatorSpaing;
    self.pageControl.pageIndicatorSpaing = pageIndicatorSpaing;
}

- (void)setContentSize:(CGSize)contentSize{
    _contentSize = contentSize;
    [self.pagerView reloadData];
}

@end
