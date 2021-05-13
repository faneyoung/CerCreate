//
//  ZXReferenceTaskCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/20.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXReferenceTaskCell.h"
#import "ZXTaskReferenceItemCell.h"

#import "ZXTaskCenterModel.h"

@interface ZXReferenceTaskCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCSHeight;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *taskItems;


@end

@implementation ZXReferenceTaskCell

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
    CGFloat margin = 20;
    CGFloat space = 7;
    CGFloat itemWidth = (SCREEN_WIDTH()-2*margin-space)/2;
    CGFloat itemHeight = itemWidth;

    self.containerCSHeight.constant = itemHeight;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = space;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.containerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(ZXTaskReferenceItemCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(ZXTaskReferenceItemCell.class)];
    
    

}

#pragma mark - data -
- (void)updateWithData:(NSArray*)taskItems{

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
    ZXTaskReferenceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXTaskReferenceItemCell" forIndexPath:indexPath];
    id data = [self.taskItems objectAtIndex:indexPath.row];
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

    if (self.statusModel) {
        if ([self.statusModel shouldBindCardOrBindEmployer]) {
            return;
        }
    }
    
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
