//
//  ZXBankIncomeUploadCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBankIncomeUploadCell.h"
#import "ZXBankIncomeuploadImageItemCell.h"
#import "ZXBankincomeUploadItemModel.h"


@interface ZXBankIncomeUploadCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCSHeight;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UIButton *firstDeleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *secBtn;
@property (weak, nonatomic) IBOutlet UILabel *secLab;
@property (weak, nonatomic) IBOutlet UIButton *secDeleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UILabel *thirdLab;
@property (weak, nonatomic) IBOutlet UIButton *thirdDeleteBtn;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *taskItems;


@end

@implementation ZXBankIncomeUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.containerView.backgroundColor = kThemeColorBg;
    [self setupSubViews];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSubViews{
    CGFloat margin = 16;
    CGFloat space = 9;
    CGFloat itemWidth = (SCREEN_WIDTH()-2*(margin+space))/3;
    CGFloat itemHeight = itemWidth + 30;

    self.containerCSHeight.constant = itemHeight;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = space;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.containerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(ZXBankIncomeuploadImageItemCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(ZXBankIncomeuploadImageItemCell.class)];
    
    [self.contentView layoutIfNeeded];

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
    ZXBankIncomeuploadImageItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXBankIncomeuploadImageItemCell" forIndexPath:indexPath];
    id data = [self.taskItems objectAtIndex:indexPath.row];
    [cell updateViewWithModel:data];
    
    __block int selIdx = 0;
    cell.deleteBtnBlock = ^(ZXBankincomeUploadItemModel*  _Nonnull data) {
        [self.taskItems enumerateObjectsUsingBlock:^(ZXBankincomeUploadItemModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.mouth isEqualToString:data.mouth]) {
                selIdx = (int)idx;
                *stop = YES;
            }
        }];

        if (self.deleteBtnClickBlock) {
            self.deleteBtnClickBlock(selIdx);
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if (self.imgItemClickedBlock) {
        self.imgItemClickedBlock((int)indexPath.row);
    }
    
    
}




@end
