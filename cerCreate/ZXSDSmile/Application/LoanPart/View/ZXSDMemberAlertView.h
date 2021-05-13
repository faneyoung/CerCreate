//
//  ZXSDMemberAlertView.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDMemberAlertView : UIView

@property (nonatomic, copy) void(^confirmAction)(void);

- (void)configWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
