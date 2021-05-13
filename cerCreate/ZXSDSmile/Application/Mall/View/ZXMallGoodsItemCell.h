//
//  ZXMallGoodsItemCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMallGoodsItemCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isLeftItem;

- (void)updateWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
