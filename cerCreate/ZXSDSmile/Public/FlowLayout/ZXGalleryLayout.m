//
//  ZXGalleryLayout.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXGalleryLayout.h"

@implementation ZXGalleryLayout

-(instancetype)init
{
    self=[super init];
    
    if (self) {
        self.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 10;
        self.sectionInset=UIEdgeInsetsMake(0, 20, 0, 20);
        ///初始布局，后面可以再赋值
        self.itemSize=CGSizeMake(SCREEN_WIDTH()-40, 293);
    }
    
    return self;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

///** 重新布局每个cell*/
//-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//
//    /** collection的可视区域*/
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//
//    CGFloat makeScaleDis = SCREEN_WIDTH();
//
//    for (UICollectionViewLayoutAttributes* attribute in array) {
//        /** 如果cell在可视区域上则进行缩放*/
//        if (CGRectIntersectsRect(attribute.frame, rect)) {
//            CGFloat space = CGRectGetMidX(visibleRect)-attribute.center.x;
//
//            if (ABS(space) < makeScaleDis) {
//                /** 滑动的进度*/
//                attribute.transform3D = CATransform3DMakeScale(1, 1, 1);
//            }
//        }
//    }
//
//    return array;
//}

/** 重新设置当滑动停止时collectionview的偏移量*/
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 最终偏移量
    CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    /** 取出在屏幕中的cell*/
    NSArray *tempArr=[self layoutAttributesForElementsInRect:CGRectMake(targetP.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)];
    CGFloat minDistnce = MAXFLOAT;
    CGFloat curCenterX=targetP.x+CGRectGetWidth(self.collectionView.bounds)/2;

    /** 取出当前所有的cell中最接近屏幕中心点的cell*/
    for (UICollectionViewLayoutAttributes* attribute in tempArr) {
//        CGFloat cellCenterX = attribute.center.x;
//        if (ABS(cellCenterX-curCenterX) < ABS(minDistnce)) {
//            minDistnce = cellCenterX-curCenterX;
//        }
        
        CGFloat cellRightX = CGRectGetMaxX(attribute.frame);
        if (ABS(cellRightX-curCenterX) < ABS(minDistnce)) {
            minDistnce = cellRightX-curCenterX;
        }

    }

    return CGPointMake(targetP.x + minDistnce+8, proposedContentOffset.y);
}


@end
