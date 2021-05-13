//
//  ZXSDHomeHeaderView.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/11/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXSDHomeLoanInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDHomeHeaderView : UIView
@property (nonatomic, assign) BOOL hasNewMsg;

@property (nonatomic, copy) void(^employerAction)(void);

- (void)configWithData:(ZXSDHomeLoanInfo *)info;

@end

NS_ASSUME_NONNULL_END
