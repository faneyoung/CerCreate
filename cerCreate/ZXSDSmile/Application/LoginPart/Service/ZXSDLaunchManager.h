//
//  ZXSDLaunchManager.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/25.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDLaunchManager : NSObject

+ (instancetype)manager;


- (void)startLaunch;
- (void)showAppGuide;
@end

NS_ASSUME_NONNULL_END
