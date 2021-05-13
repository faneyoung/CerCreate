//
//  ZXMemberCreateViewController.h
//  ZXSDSmile
//
//  Created by Fane on 2021/2/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"
#import "ZXMemberInfoModel.h"

/**
 *会员开通页面
 *smile+会员用户额度<=500是不进这个页面直接预支  <haveCustomer && !isNeedCustomer>
 *
 */

/**
 haveCustomer    会员开通状态,是否是会员
 isNeedCustomer 是否需要开通会员
 
 customerOpen    当前预支的额度是否需要开通会员
 */

NS_ASSUME_NONNULL_BEGIN

@interface ZXMemberCreateViewController : ZXSDBaseViewController

@property (nonatomic, strong) ZXMemberInfoModel *memberInfoModel;

///额度
@property (nonatomic, copy) NSString *loanAmount;
///利息
@property (nonatomic, copy) NSString *interest;


@end

NS_ASSUME_NONNULL_END
