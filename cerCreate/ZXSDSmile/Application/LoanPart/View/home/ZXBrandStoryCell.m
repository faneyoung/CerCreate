//
//  ZXBrandStoryCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBrandStoryCell.h"
#import "ZXBannerModel.h"
#import "ZXBrandStoryItemCell.h"

@interface ZXBrandStoryCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *itemContainerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZXHomeBannerModel *bannerModel;

@end

@implementation ZXBrandStoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 4, 0.01, UIColor.whiteColor);
    self.layer.cornerRadius = 14;
    self.layer.masksToBounds = YES;
    
    [self setupSubViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - views -

- (void)setupSubViews{
    CGFloat margin = 16;
    CGFloat space = 8;
    CGFloat halfItem = 15;
//    CGFloat itemWidth = (SCREEN_WIDTH()-3*margin-2*space-halfItem)/2;
    CGFloat itemWidth = 148;
    CGFloat itemHeight = 158;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = space;
    layout.sectionInset = UIEdgeInsetsMake(-9, margin, 0, margin);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.itemContainerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(ZXBrandStoryItemCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(ZXBrandStoryItemCell.class)];
    
    

}

#pragma mark - data -
- (void)updateWithData:(ZXHomeBannerModel*)model{

    self.bannerModel = model;
    [self.collectionView reloadData];
    
    if (IsValidArray(model.titleList)) {
        self.titleLab.text = GetString(model.titleList.firstObject);
        if (model.titleList.count > 1) {
            self.desLab.text = GetString(model.titleList[1]);
        }
    }
    else{
        self.titleLab.text = self.desLab.text  = @"";
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bannerModel.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXBrandStoryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXBrandStoryItemCell" forIndexPath:indexPath];
    id data = [self.bannerModel.list objectAtIndex:indexPath.row];
    [cell updateViewWithModel:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZXBannerModel *data = [self.bannerModel.list objectAtIndex:indexPath.row];
    [URLRouter routerUrlWithBannerModel:data extra:nil];

}


@end
