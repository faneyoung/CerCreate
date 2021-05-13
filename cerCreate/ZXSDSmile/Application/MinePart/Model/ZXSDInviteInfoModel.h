//
//  ZXSDInviteInfoModel.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDInviteItem : ZXSDBaseModel

__string(phone)
__string(certifyAmount)
__string(advanceAmount)
__string(wageFlowAmount)

@end


@interface ZXSDInviteInfoModel : ZXSDBaseModel

__string(recommendUrl) //邀请链接

@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, assign) CGFloat balanceLeft;

@property (nonatomic, assign) NSInteger totalRecommend;//总邀请人

@property (nonatomic, assign) CGFloat totalReward;//共获得的红包(奖励)

@property (nonatomic, assign) CGFloat certifyAmount;//注册奖励
@property (nonatomic, assign) CGFloat advanceAmount;//预支奖励
@property (nonatomic, assign) CGFloat wageAmount;//上传流水奖励

@property (nonatomic, strong) NSArray<ZXSDInviteItem*> *records;

@property (nonatomic, strong) NSString *action;

@end


NS_ASSUME_NONNULL_END
