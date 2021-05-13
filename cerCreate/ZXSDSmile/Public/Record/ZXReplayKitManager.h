//
//  ZXReplayKitManager.h
//  BroadcastNew
//
//  Created by Fane on 2021/2/19.
//  Copyright © 2021 Anirban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXReplayKitManager : NSObject

SingletonInterface(ZXReplayKitManager, sharedInstance);

@property (nonatomic, strong) id replayKitBroadVC;


@end

NS_ASSUME_NONNULL_END
