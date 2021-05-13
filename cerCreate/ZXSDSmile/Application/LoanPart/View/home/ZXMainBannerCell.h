//
//  ZXMainBannerCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/31.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMainBannerCell : ZXBaseCell
@property (nonatomic, strong) void(^bannerClickedBlock)(int index);

@end

NS_ASSUME_NONNULL_END
