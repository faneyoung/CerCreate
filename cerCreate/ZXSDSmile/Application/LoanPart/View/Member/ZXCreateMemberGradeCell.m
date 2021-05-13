//
//  ZXCreateMemberGradeCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCreateMemberGradeCell.h"
#import "ZXCreateMemberGradeItemCell.h"

@interface ZXCreateMemberGradeCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *items;

@end

@implementation ZXCreateMemberGradeCell

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
    CGFloat space = 12;
    CGFloat itemWidth = (SCREEN_WIDTH()-2*(margin+space))/3;
    CGFloat itemHeight = 124;

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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(ZXCreateMemberGradeItemCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(ZXCreateMemberGradeItemCell.class)];
}

#pragma mark - data -
- (void)updateWithData:(NSArray*)items{

    self.items = items;
    [self.collectionView reloadData];
    
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXCreateMemberGradeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ZXCreateMemberGradeItemCell.class) forIndexPath:indexPath];
    id data = [self.items objectAtIndex:indexPath.row];
    [cell updateViewWithModel:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
//    if (self.statusModel) {
//        if ([self.statusModel shouldBindCardOrBindEmployer]) {
//            return;
//        }
//    }
//
//    ZXTaskCenterItem *taskItem = [self.items objectAtIndex:indexPath.row];
//
//    if (!taskItem) {
//        return;
//    }
//    if ([taskItem.certStatus isEqualToString:@"NotDone"]||
//        [taskItem.certStatus isEqualToString:@"Fail"]) {
//        [URLRouter routerUrlWithPath:kRouter_scoreUpload extra:@{@"taskItem":taskItem}];
//    }
    if (self.itemDidSelectedBlock) {
        self.itemDidSelectedBlock(indexPath);
    }
    
    [self.collectionView reloadData];
    

}


@end
