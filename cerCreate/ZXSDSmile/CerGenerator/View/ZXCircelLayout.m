//
//  ZXCircelLayout.m
//  ZXSDSmile
//
//  Created by Fane on 2021/5/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCircelLayout.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define ITEM_SIZE 50

@interface ZXCircelLayout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> * attributeAttay;
@property (nonatomic, assign) int itemCount; //item 个数

@end

@implementation ZXCircelLayout
- (void)prepareLayout
{
    [super prepareLayout];
    //获取item的个数
    _itemCount = (int)[self.collectionView numberOfItemsInSection:0];
    _attributeAttay = [[NSMutableArray alloc]init];
    //先设定大圆的半径 取长和宽最短的
    CGFloat radius = MIN(self.collectionView.frame.size.width, self.collectionView.frame.size.height)/2;
    //计算圆心位置
    CGPoint center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    //设置每个item的大小为50*50 则半径为25
    CGFloat itemWidth = 50.0;
    CGFloat itemHeight = 50.0;
    for (int i=0; i<_itemCount; i++) {
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        //设置item大小
        
        attris.size = CGSizeMake(itemWidth, itemHeight);
        //计算每个item的圆心位置
        //算出的x y值还要减去item自身的半径大小
        float x = center.x + cosf(2 * M_PI/_itemCount * i) * (radius - itemWidth);
        float y = center.y + sinf(2 * M_PI/_itemCount * i) * (radius - itemHeight);
        
        attris.center = CGPointMake(x, y);
        [_attributeAttay addObject:attris];
    }
}
//设置内容区域的大小
-(CGSize)collectionViewContentSize{
    return self.collectionView.frame.size;
}
//返回设置数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributeAttay;
}

@end
