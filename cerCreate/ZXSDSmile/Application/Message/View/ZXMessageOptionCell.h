//
//  ZXMessageOptionCell.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMessageOptionCell : ZXBaseCell
@property (nonatomic, strong) void(^optionBtnBlock)(int type);

@end

NS_ASSUME_NONNULL_END
