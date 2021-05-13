//
//  ZXSDBankCardCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/22.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"
#import "ZXSDBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDBankCardCell : ZXSDBaseTableViewCell

@property (nonatomic, assign) BOOL mainCard;
@property (nonatomic, assign) BOOL isSmile;
@property (nonatomic, copy) void(^mainCardAction)(void);

@end

NS_ASSUME_NONNULL_END
