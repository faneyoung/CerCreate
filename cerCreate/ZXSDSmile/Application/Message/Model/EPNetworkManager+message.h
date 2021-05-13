//
//  EPNetworkManager+message.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "EPNetworkManager.h"
#import "ZXMessageStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MessageListType) {
    MessageListTypeActivity,
    MessageListTypeMsg,
    MessageListTypeMember,
};

@interface EPNetworkManager (message)

- (void)requestMessageStatus:(void(^)(NSError *error, ZXMessageStatusModel *statusModel))completionBlock;

@end

NS_ASSUME_NONNULL_END
