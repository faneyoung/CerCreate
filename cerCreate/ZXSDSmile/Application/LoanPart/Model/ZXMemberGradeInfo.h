//
//  ZXMemberGradeInfo.h
//  ZXSDSmile
//
//  Created by Fane on 2021/2/4.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMemberGradeInfo : ZXBaseModel

///会员费
@property (nonatomic, assign) NSString *amount;
///原价
@property (nonatomic, strong) NSString *originalCost;

///周期
@property (nonatomic, strong) NSString *cycle;
///卡名：季卡、月卡、年卡
@property (nonatomic, strong) NSString *describe;
///会员等级
@property (nonatomic, strong) NSString *level;
///会员有效期
@property (nonatomic, strong) NSString *customerInvalidDate;
@property (nonatomic, strong) NSString *activeName;
@property (nonatomic, assign) BOOL hasActive;
@property (nonatomic, strong) NSString *activeTitle;


@property (nonatomic, assign) BOOL selected;




@end

NS_ASSUME_NONNULL_END
