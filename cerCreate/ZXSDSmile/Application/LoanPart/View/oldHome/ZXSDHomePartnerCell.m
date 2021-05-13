//
//  ZXSDHomePartnerCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomePartnerCell.h"

@interface ZXSDPartnerCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;

- (void)configData:(ZXSDHomePartnerModel *)model;

@end

@implementation ZXSDPartnerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)configData:(ZXSDHomePartnerModel *)model
{
    self.titleLabel.text = model.name;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
}

- (void)initUI
{
    UIView *box = [UIView new];
    box.backgroundColor = UICOLOR_FROM_HEX(0xF8F8F8);
    box.layer.cornerRadius = 8;
    [self.contentView addSubview:box];
    [box mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.width.height.mas_equalTo(72);
    }];
    [box addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.center.equalTo(box);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(box);
        make.top.equalTo(box.mas_bottom).offset(12);
        make.bottom.equalTo(self.contentView).offset(-4);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(12)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

@end




@interface ZXSDHomePartnerCell() <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation ZXSDHomePartnerCell

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[NSArray class]]) {
        return;
    }
    self.partners = renderData;
    [self.collectionView reloadData];
}

- (void)initView
{
    UILabel *titleLabel = [UILabel labelWithText:@"合作伙伴" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(20)];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(105);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
    
    [self.collectionView registerClass:[ZXSDPartnerCollectionCell class] forCellWithReuseIdentifier:@"partnerCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.partners.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXSDPartnerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"partnerCell" forIndexPath:indexPath];
    
    ZXSDHomePartnerModel *model = [self.partners objectAtIndex:indexPath.row];
    [cell configData:model];
    
    return cell;
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 8;
        layout.itemSize = CGSizeMake(72, 105);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        //_collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}


@end
