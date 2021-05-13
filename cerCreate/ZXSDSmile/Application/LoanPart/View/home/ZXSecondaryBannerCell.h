//
//  ZXSecondaryBannerCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSecondaryBannerCell : ZXBaseCell
@property (nonatomic, strong) void(^bannerClickedBlock)(int index);

@end

NS_ASSUME_NONNULL_END
