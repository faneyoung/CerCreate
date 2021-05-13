//
//  ZXHomeBannerCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeBannerCell : ZXSDBaseTableViewCell
@property (nonatomic, strong) void(^bannerClickedBlock)(int index);

@end

NS_ASSUME_NONNULL_END
