//
//  ZXSDInviteRecordsCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"
#import "ZXSDInviteInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDInviteItemCell : ZXSDBaseTableViewCell

@end

@interface ZXSDInviteRecordsCell : ZXSDBaseTableViewCell

@property (nonatomic, strong) NSArray<ZXSDInviteItem*> *records;
@property (nonatomic, copy) void (^moreAction)(void);

@end

NS_ASSUME_NONNULL_END
