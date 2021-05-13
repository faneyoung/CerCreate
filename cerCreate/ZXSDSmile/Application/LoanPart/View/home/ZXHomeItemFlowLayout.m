//
//  ZXHomeItemFlowLayout.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/12.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeItemFlowLayout.h"

@interface ZXHomeItemFlowLayout ()

@property (strong,  nonatomic) NSMutableArray   *attributesArray;
@property (nonatomic,  assign) CGFloat  onePageWidth;

@end

@implementation ZXHomeItemFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showLastPageFull = YES;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;

    _attributesArray = @[].mutableCopy;
//    _onePageWidth = _size.width* _column + (_column-1)*_columnSpacing + self.sectionInset.left + self.sectionInset.right;
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_attributesArray addObject:attributes];
    }
}

//计算每个item的frame
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger index = indexPath.item;
    
    NSInteger page = index / (_row * _column);
    
    // % 运算 确定 x 是 0,1,2 ... _column-1
    int rowIdx = (int)index % _column;
    CGFloat x = self.sectionInset.left + rowIdx * (_size.width + _columnSpacing) + page * _pageWidth;
    
    // / 运算 确定 y 是 在哪行(一行有 column 个)， % 确定在 0,1,2 ... _row-1 行内的哪行
    CGFloat y = self.sectionInset.top + (index / _column % _row) * (_size.height + _rowSpacing);
    
    attribute.frame = CGRectMake(x, y, _size.width, _size.height);
    
    return attribute;
    
}

//返回所有item的frame
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributesArray;
}

//返回总的可见尺寸
//避免一页未排满，滑动显示不全
- (CGSize)collectionViewContentSize{
    CGFloat width = (CGFloat)ceil(_attributesArray.count/(_row * _column * 1.0)) * _pageWidth;
    if (!_showLastPageFull) {
        NSInteger lastCount = _attributesArray.count%(_row * _column);
        if (lastCount > 0 && lastCount < _column) {
            width = _attributesArray.count/(_row * _column) * _pageWidth;
            width += (_size.width + _columnSpacing)*lastCount;
        }
    }
    width += self.sectionInset.left + self.sectionInset.right;
    CGFloat height = (_size.height + _rowSpacing) * _row + self.sectionInset.top + self.sectionInset.bottom;
    return CGSizeMake(width, height);
}

- (CGSize)collectionViewSize
{
    CGFloat height = self.sectionInset.top + (_size.height + _rowSpacing) * _row + self.sectionInset.bottom;
    return CGSizeMake(_pageWidth, height);
}

@end
