//
//  ZXMineHeaderView.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMineHeaderView : UIView

+ (instancetype)instanceMineHeaderView;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *couponNum;
@property (nonatomic, strong) NSString *cardNum;
@property (nonatomic, strong) NSString *memberTime;
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, assign) BOOL isMember;


@property (nonatomic, strong) void(^profileBtnBlock)(void);
@property (nonatomic, strong) void(^cardManageBtnBlock)(void);
@property (nonatomic, strong) void(^memberStatusBlock)(int pageType);

@end

NS_ASSUME_NONNULL_END
