//
//  ZXSDAdvanceRecordsModel.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDAdvanceExtendModel : ZXSDBaseModel

// 展期相关
__string(action)
__string(actionDesc)
__string(title)

@property (nonatomic, assign) BOOL enable;

@end

@interface ZXSDAdvanceRecordsModel : ZXSDBaseModel

__string(loanDate)
__string(loanMoney)

/**
 //贷款已创建 ("Created", "等待放款"),
 //已提交    ("Submitted", "等待放款")
 //已审批    ("Approved", "等待放款"),
 //已确认    ("Confirmed", "等待放款")
 //已放款    ("Funded", "等待还款")
 //放款失败  ("FundFailed", "等待放款")
 //已还款    ("PaidOff", "已还款")
 //取消     ("Canceled", "已取消");
 //已展期   ("Extended", "等待还款")
 */
__string(loanStatus)
__string(repaymentDate) //扣款日期
__string(loanStatusDes)
__string(loanID)

__string(oldRepaymentDate)
__string(bankcardRefId)


@property (nonatomic, assign) BOOL isContractView;
@property (nonatomic, assign) BOOL canRepay;

@property (nonatomic, strong) ZXSDAdvanceExtendModel *extendButton;

@end

NS_ASSUME_NONNULL_END
