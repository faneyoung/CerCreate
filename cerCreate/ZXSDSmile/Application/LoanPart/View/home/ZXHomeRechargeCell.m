//
//  ZXHomeRechargeCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/6.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeRechargeCell.h"
#import "ZXHomeItemFlowLayout.h"

#import "ZXHomeRechargeItemCell.h"

#import "ZXBannerModel.h"

///一屏最多显示的item
#define kMaxRows          1
#define kMaxItemsInRow    4

@interface ZXHomeRechargeCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *itemContainerView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZXHomeBannerModel *model;

@end

@implementation ZXHomeRechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 4, 0.1, kThemeColorLine);
    [self.shadowView homeCardShadowSetting];

    [self setupSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - data -
- (void)updateWithData:(ZXHomeBannerModel*)model{
    self.model = model;
    self.collectionView.scrollEnabled = model.list.count > kMaxItemsInRow;
    [self.collectionView reloadData];
}

#pragma mark - views -
- (void)setupSubviews{
//    int rowNum = 4;
//    CGFloat margin = 16;
//    CGFloat space = 13;
//    CGFloat halfItem = 0;
//    CGFloat itemWidth = (SCREEN_WIDTH()-4*margin-(rowNum-1)*space-halfItem)/rowNum;
//    CGFloat itemHeight = 119;
//
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
//    layout.minimumInteritemSpacing = 0;
//    layout.minimumLineSpacing = space;
//    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
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
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);

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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(ZXHomeRechargeItemCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(ZXHomeRechargeItemCell.class)];
    
    
    
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


@end
