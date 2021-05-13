//
//  ZXShortcutItemCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/31.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXShortcutItemCell : ZXBaseCell

@property (nonatomic, strong) void(^itemClickBlock)(id data);

@end

NS_ASSUME_NONNULL_END
