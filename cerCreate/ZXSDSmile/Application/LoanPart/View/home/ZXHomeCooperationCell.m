//
//  ZXHomeCooperationCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeCooperationCell.h"
#import "ZXHomeItemFlowLayout.h"

#import "ZXHomeCooperationItemCell.h"

#define kMaxRows        2
#define kMaxItemsInRow   4


@interface ZXHomeCooperationCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *itemContainerView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *cooItems;

@end

@implementation ZXHomeCooperationCell

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

#pragma mark - views -
- (void)setupSubviews{
    int rowNum = 4;
    CGFloat margin = 16;
    CGFloat space = 13;
    CGFloat vSpace = 16;
    CGFloat halfItem = 0;
    CGFloat itemWidth = (SCREEN_WIDTH()-4*margin-(rowNum-1)*space-halfItem)/rowNum;
    CGFloat itemHeight = 74;
    
    
    ZXHomeItemFlowLayout *layout = [[ZXHomeItemFlowLayout alloc] init];
    layout.size = CGSizeMake(itemWidth, itemHeight);
    layout.columnSpacing =space;
    layout.rowSpacing = vSpace;
    layout.row = kMaxRows;
    layout.column = kMaxItemsInRow;
    layout.showLastPageFull = YES; // 不完全展示最后一页
    layout.pageWidth = SCREEN_WIDTH()-2*margin;

    layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);

//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
//    layout.minimumInteritemSpacing = margin;
//    layout.minimumLineSpacing = space;
//    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(ZXHomeCooperationItemCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(ZXHomeCooperationItemCell.class)];
    
    
    
}

#pragma mark - data -
- (void)updateWithData:(NSArray*)model{
    self.cooItems = model;
    
    self.collectionView.scrollEnabled = self.cooItems.count > kMaxItemsInRow;
    [self.collectionView reloadData];
    
    
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cooItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXHomeCooperationItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXHomeCooperationItemCell" forIndexPath:indexPath];
    id data = [self.cooItems objectAtIndex:indexPath.row];
    [cell updateViewWithModel:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZXBannerModel *data = [self.cooItems objectAtIndex:indexPath.row];
    [URLRouter routerUrlWithBannerModel:data extra:nil];
}


@end
