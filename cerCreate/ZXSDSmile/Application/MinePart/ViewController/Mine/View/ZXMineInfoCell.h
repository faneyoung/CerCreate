//
//  ZXMineInfoCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/6.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMineInfoCell : ZXBaseCell

@property (nonatomic, strong) void (^infoActionBlock)(int type);

@end

NS_ASSUME_NONNULL_END
