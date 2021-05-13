//
//  ZXHomeItemFlowLayout.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/12.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeItemFlowLayout : UICollectionViewFlowLayout
///一页展示行数
@property (nonatomic, assign) NSInteger row;
///一页展示列数
@property (nonatomic, assign) NSInteger column;
///行间距
@property (nonatomic, assign) CGFloat rowSpacing;
///列间距
@property (nonatomic, assign) CGFloat columnSpacing;
///item大小
@property (nonatomic, assign) CGSize size;
///一页的宽度,默认 [UIScreen mainScreen].bounds.size.width
@property (nonatomic, assign) CGFloat pageWidth;
///默认YES。根据最后一页的个数，是否展示完整的一页
@property (nonatomic, assign) BOOL showLastPageFull;
///collectionView Size
@property (nonatomic, assign,  readonly) CGSize  collectionViewSize;

@end

NS_ASSUME_NONNULL_END
