//
//  ZXMainBannerItemCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/1.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMainBannerItemCell : UICollectionViewCell
@property (nonatomic, assign) CGFloat contentRadio;

- (void)updateContentViewWithData:(ZXBannerModel*)data;

@end

NS_ASSUME_NONNULL_END
