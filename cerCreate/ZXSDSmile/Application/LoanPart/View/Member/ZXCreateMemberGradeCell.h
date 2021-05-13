//
//  ZXCreateMemberGradeCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCreateMemberGradeCell : ZXBaseCell
@property (nonatomic, strong) void(^itemDidSelectedBlock)(NSIndexPath *idxPath);

@end

NS_ASSUME_NONNULL_END
