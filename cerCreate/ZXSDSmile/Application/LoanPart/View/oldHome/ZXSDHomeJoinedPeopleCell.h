//
//  ZXSDHomeJoinedPeopleCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"
#import "ZXSDHomeLoanInfo.h"

NS_ASSUME_NONNULL_BEGIN

// 邀请活动
@interface ZXSDHomeJoinedPeopleCell : ZXSDBaseTableViewCell

@property (nonatomic, assign) NSInteger joinedNumber;
@property (nonatomic, copy) void(^bannerAction)(void);

@end

NS_ASSUME_NONNULL_END
