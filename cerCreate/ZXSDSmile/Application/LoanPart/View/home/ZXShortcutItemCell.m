//
//  ZXShortcutItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/31.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXShortcutItemCell.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "ZXHomeItemFlowLayout.h"

#import "ZXShortcutTopItemCell.h"
#import "ZXBannerModel.h"

///一屏最多显示的item
#define kMaxRows          1
#define kMaxItemsInRow    5

@interface ZXShortcutItemCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) TYPageControl *pageControl;

@property (nonatomic, strong) NSArray *banners;


@end

@implementation ZXShortcutItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSubViews{
    
    
//    [self addPagerView];
//    [self addPageControl];
    
    CGFloat margin = 20;
    CGFloat space = 14;
    CGFloat vSpace = 0;
    CGFloat halfItem = 0;
    CGFloat itemWidth = (SCREEN_WIDTH()-2*margin-(kMaxItemsInRow-1)*space-halfItem)/kMaxItemsInRow;
    CGFloat itemHeight = 60;
    
    
    ZXHomeItemFlowLayout *layout = [[ZXHomeItemFlowLayout alloc] init];
    layout.size = CGSizeMake(itemWidth, itemHeight);
    layout.columnSpacing =space;
    layout.rowSpacing = vSpace;
    layout.row = kMaxRows;
    layout.column = kMaxItemsInRow;
    layout.showLastPageFull = YES; // 不完全展示最后一页
    layout.pageWidth = SCREEN_WIDTH();

    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.containerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(ZXShortcutTopItemCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(ZXShortcutTopItemCell.class)];

}

- (void)updateWithData:(NSArray*)model{
    self.banners = model;
    
//    [self reloadData];
    self.collectionView.scrollEnabled = self.banners.count > kMaxItemsInRow;
    [self.collectionView reloadData];
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.banners.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXShortcutTopItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXShortcutTopItemCell" forIndexPath:indexPath];
    id data = [self.banners objectAtIndex:indexPath.row];
    [cell updateViewWithModel:data];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ZXBannerModel *banner = [self.banners objectAtIndex:indexPath.row];

    NSString *bannerUrl = banner.url;
    if (![bannerUrl hasPrefix:@"http"]) {
        if (self.itemClickBlock) {
            self.itemClickBlock(banner);
        }
        return;
    }
    
    [URLRouter routerUrlWithBannerModel:banner extra:@{@"bannerAnaly":@(YES)}];
}


//#pragma mark - TYCyclePagerViewDataSource
//
//- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView
//{
//    return [self pageCount];
//}
//
//- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index
//{
//    ZXShortcutTopItemCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"ZXShortcutTopItemCell" forIndex:index];
//    [cell updateViewWithModel:self.banners index:(int)index];
//    @weakify(self);
//    cell.shortcutItemBlock = ^(id  _Nonnull data) {
//        @strongify(self);
//        if (self.itemClickBlock) {
//            self.itemClickBlock(data);
//        }
//    };
//    return cell;
//}
//
//- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView
//{
//    CGFloat margin = 16;
//    CGFloat height = 60;
//    CGFloat space = 0;
//    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
//    CGFloat width = SCREEN_WIDTH()-2*margin;
//
//    layout.itemSize = CGSizeMake(width, height);
//    layout.itemSpacing = space;
//    layout.itemHorizontalCenter = YES;
//    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
//    return layout;
//}
//
//- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
//    _pageControl.currentPage = toIndex;
//    //[_pageControl setCurrentPage:newIndex animate:YES];
//    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
//}
//
//
//- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
//{
//
//
//}
//
//#pragma mark - help methods -
//
//- (int)pageCount{
//    int count = (int)self.banners.count/kMaxItemsInRow;
//    int delt = (int)self.banners.count % kMaxItemsInRow == 0 ? 0 : 1;
//    return count+delt;
//}
//
//- (void)reloadData{
//
//    _pageControl.numberOfPages = [self pageCount];
//    _pageControl.hidden = _pageControl.numberOfPages <= 1;
//    [_pagerView reloadData];
//}
//
//- (void)addPagerView {
//    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
//    pagerView.isInfiniteLoop = [self pageCount] > 1;
//    pagerView.autoScrollInterval = CGFLOAT_MAX;
//    pagerView.dataSource = self;
//    pagerView.delegate = self;
//    // registerClass or registerNib
//    [pagerView registerNib:[UINib nibWithNibName:@"ZXShortcutTopItemCell" bundle:nil] forCellWithReuseIdentifier:@"ZXShortcutTopItemCell"];
//
//    [self.containerView addSubview:pagerView];
//    [pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.inset(0);
//        make.left.right.inset(16);
//    }];
//    _pagerView = pagerView;
//}
//
//- (void)addPageControl {
//    TYPageControl *pageControl = [[TYPageControl alloc]init];
//    //pageControl.numberOfPages = _datas.count;
//    pageControl.currentPageIndicatorSize = CGSizeMake(10, 5);
//    pageControl.pageIndicatorSize = CGSizeMake(5, 5);
//    pageControl.currentPageIndicatorTintColor = kThemeColorMain;
//    pageControl.pageIndicatorTintColor = TextColorgray;
//    [self.contentView addSubview:pageControl];
//
//    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.inset(0);
//        make.bottom.inset(8);
//        make.height.mas_equalTo(5);
//    }];
//
//    _pageControl = pageControl;
//}

@end
