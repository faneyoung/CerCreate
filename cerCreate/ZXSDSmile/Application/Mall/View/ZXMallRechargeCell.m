//
//  ZXMallRechargeCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMallRechargeCell.h"
#import "UICollectionView+help.h"
#import "ZXHomeItemFlowLayout.h"

#import "ZXHomeRechargeItemCell.h"
//views
#import "ZXBannerModel.h"


///一屏最多显示的item
#define kMaxRows          1
#define kMaxItemsInRow    4

@interface ZXMallRechargeCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *itemContainerView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZXHomeBannerModel *model;

@end

@implementation ZXMallRechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 4, 0.1, kThemeColorLine);
    [self.shadowView homeCardShadowSetting];

    [self setupSubviews];
}

#pragma mark - data -
- (void)updateWithData:(ZXHomeBannerModel*)model{
    self.model = model;
    
    self.collectionView.scrollEnabled = model.list.count > kMaxItemsInRow;

    [self.collectionView reloadData];
}

#pragma mark - views -
- (void)setupSubviews{
    CGFloat margin = 16;
    CGFloat space = 13;
    CGFloat vSpace = 0;
    CGFloat halfItem = 0;
    CGFloat itemWidth = (SCREEN_WIDTH()-4*margin-(kMaxItemsInRow-1)*space-halfItem)/kMaxItemsInRow;
    CGFloat itemHeight = 119;
    
    ZXHomeItemFlowLayout *layout = [[ZXHomeItemFlowLayout alloc] init];
    layout.row = kMaxRows;
    layout.column = kMaxItemsInRow;
    layout.showLastPageFull = YES;
    
    layout.columnSpacing =space;
    layout.rowSpacing = vSpace;
    layout.size = CGSizeMake(itemWidth, itemHeight);
    layout.pageWidth = SCREEN_WIDTH()-2*margin;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);

    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.itemContainerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    [self.collectionView registerNibs:@[
        NSStringFromClass(ZXHomeRechargeItemCell.class),
    ]];
    
    
    
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXHomeRechargeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXHomeRechargeItemCell" forIndexPath:indexPath];
    id data = [self.model.list objectAtIndex:indexPath.row];
    [cell updateViewWithModel:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    id data = [self.model.list objectAtIndex:indexPath.row];
    [URLRouter routerUrlWithBannerModel:data extra:@{@"bannerAnaly":@(YES)}];

}

//- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes
//{
//    [self setNeedsLayout];
//    
//    [self layoutIfNeeded];
//    
//    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
//    
//    CGRect cellFrame = layoutAttributes.frame;
//    
//    cellFrame.size.height= size.height;
//    
//    layoutAttributes.frame= cellFrame;
//    
//    return layoutAttributes;
//    
//}

@end
