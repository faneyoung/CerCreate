//
//  ZXMessageStatusModel.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMessageStatusModel : ZXBaseModel
@property (nonatomic, assign) BOOL hasNew;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int messageCount;
@property (nonatomic, assign) int activityCount;
@property (nonatomic, assign) int memberCount;



@end

NS_ASSUME_NONNULL_END
