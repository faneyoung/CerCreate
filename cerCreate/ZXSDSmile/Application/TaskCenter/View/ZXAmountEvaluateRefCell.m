//
//  ZXAmountEvaluateRefCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/9.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAmountEvaluateRefCell.h"

//views
#import "ZXAmountEvaluateRefItemCell.h"
#import "ZXAmountEvaluateRefProgressCell.h"

#import "ZXTaskCenterModel.h"

@interface ZXAmountEvaluateRefCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *shadowLab;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewCSHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIView *containerview;
@property (weak, nonatomic) IBOutlet UIView *itemContainerView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *taskItems;

@end

@implementation ZXAmountEvaluateRefCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerview, 8, 0.01, UIColor.whiteColor);

    [self setupSubViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupSubViews{
    
    [self.itemContainerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    NSArray *cellName = @[
        NSStringFromClass(ZXAmountEvaluateRefItemCell.class),
        NSStringFromClass(ZXAmountEvaluateRefProgressCell.class),
    ];
    
    [cellName enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.collectionView registerNib:[UINib nibWithNibName:obj bundle:nil] forCellWithReuseIdentifier:obj];
    }];

}

- (void)setHideTopView:(BOOL)hideTopView{
    _hideTopView = hideTopView;
    CGFloat height = 72;
    if (hideTopView) {
        height = 0;
    }
    self.topViewCSHeight.constant = height;
    [self.topView layoutIfNeeded];
    [self.contentView layoutIfNeeded];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat margin = 16;
        CGFloat space = 7;
        CGFloat itemWidth = (SCREEN_WIDTH()-4*margin-space)/2;
        CGFloat itemHeight = 102;

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = space;
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    
    return _collectionView;
}

#pragma mark - data -
- (void)updateWithData:(NSArray*)taskItems{
    
    //collectionView refresh
    self.taskItems = taskItems;
    [self.collectionView reloadData];
    
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.taskItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXTaskCenterItem *data = [self.taskItems objectAtIndex:indexPath.row];
    if ([data showProgressView]) {//Success & Expired
        ZXAmountEvaluateRefProgressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXAmountEvaluateRefProgressCell" forIndexPath:indexPath];
        [cell updateViewWithModel:data];
        return cell;
        
    }
    
    /** NotDone  & Fail & Submit & humanCheck */
    
    ZXAmountEvaluateRefItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXAmountEvaluateRefItemCell" forIndexPath:indexPath];
    [cell updateViewWithModel:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//#warning --test--
//    ZXTaskCenterItem *testModel = [self.taskItems objectAtIndex:indexPath.row];
//    testModel.certStatus = @"NotDone";
//    if (!testModel) {
//        return;
//    }
//    if ([testModel.certStatus isEqualToString:@"NotDone"]||
//        [testModel.certStatus isEqualToString:@"Fail"]) {
//        [URLRouter routerUrlWithPath:kRouter_scoreUpload extra:@{@"taskItem":testModel}];
//    }
//
//    return;
//#warning --test--

    
    ZXTaskCenterItem *taskItem = [self.taskItems objectAtIndex:indexPath.row];
    
    if (!taskItem) {
        return;
    }
    if ([taskItem.certStatus isEqualToString:@"NotDone"]||
        [taskItem.certStatus isEqualToString:@"Fail"] ||
        [taskItem.certStatus isEqualToString:@"Expired"]) {
        [URLRouter routerUrlWithPath:kRouter_scoreUpload extra:@{@"taskItem":taskItem}];
    }

}

@end
