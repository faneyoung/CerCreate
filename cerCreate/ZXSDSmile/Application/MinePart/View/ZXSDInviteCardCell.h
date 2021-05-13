//
//  ZXSDInviteCardCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDInviteCardCell : ZXSDBaseTableViewCell

@property (nonatomic, copy) void (^historyAction)(void);

@end

NS_ASSUME_NONNULL_END
