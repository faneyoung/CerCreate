//
//  ZXSDHomeLoanInfo.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZXSDCertifiedStatusNone = 0,
    ZXSDCertifiedStatusDoing = 1,
    ZXSDCertifiedStatusDone = 2
} ZXSDCertifiedStatus;

@class ZXSDHomeLoanActionModel;
@class ZXSDHomeLoanDataModel;
@class ZXSDHomeLoanExtraInfo;

@interface ZXSDHomeLoanInfo : ZXSDBaseModel

@property (nonatomic, strong) ZXSDHomeLoanActionModel *actionModel;
@property (nonatomic, strong) ZXSDHomeLoanActionModel *nextActionModel;
@property (nonatomic, strong) ZXSDHomeLoanDataModel *loanModel;
@property (nonatomic, strong) ZXSDHomeLoanExtraInfo *extraInfo;

@property (nonatomic, strong) NSDictionary *partnerMap;

@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSArray *notice;


- (ZXSDCertifiedStatus)currentCertifiedStatus;
- (NSArray *)allPartners;

@end

@interface ZXSDHomeLoanActionModel : ZXSDBaseModel

__string(action) //动作指令
__string(actionDesc) //指令描述
__string(enable) // 按钮是否可点击
__string(title) //动作标题
__string(tips) //该字段有值则表示目前还在四要素认证中

@end

// 当前周期的展期数据信息
@interface ZXSDHomeExtendCalculation : ZXSDBaseModel

// 总金额
@property (nonatomic, assign) NSInteger amount;
// 笔数
@property (nonatomic, assign) NSInteger count;

@end

// 当前周期的逾期数据信息
@interface ZXSDHomeOverdueCalculation : ZXSDBaseModel

// 总金额
@property (nonatomic, assign) NSInteger amount;
// 笔数
@property (nonatomic, assign) NSInteger count;

@end

@interface ZXSDHomeCreditItem : ZXSDBaseModel

// 距离该额度可用还剩余的天数
/** 值为0的情况:
 1. 该金额目前已经可用
 2. 该金额距离可用的剩余天数超过了一个预支周期内剩余的时间
 */
@property (nonatomic, assign) NSInteger days;

// 该额度是否可以预支
@property (nonatomic, assign) BOOL eable;

//当前预支的额度是否需要开通会员
@property (nonatomic, assign) BOOL customerOpen;

// 额度
@property (nonatomic, assign) NSInteger unit;
@property (nonatomic, copy) NSString *fee;

// 本额度的可用状态描述
@property (nonatomic, copy) NSString *title;

@end

@interface ZXSDHomeLoanDataModel : ZXSDBaseModel

__string(bank2Number) //银行卡号
__string(payDayStr) // eg:发薪日10号
__string(nextBeforeDayStr) //eg:次月8号


@property (nonatomic, assign) NSInteger borrowingLimit; //当前可借金额
@property (nonatomic, assign) CGFloat borrowingLimitMax; //最大可借金额
@property (nonatomic, assign) NSInteger sumLoan; // 已借款金额

@property (nonatomic, assign) NSInteger payDay;
@property (nonatomic, assign) NSInteger quota;

@property (nonatomic, assign) NSInteger to500Days;
@property (nonatomic, assign) NSInteger to1000Days;
@property (nonatomic, assign) NSInteger to1500Days;
@property (nonatomic, assign) NSInteger to2000Days;

@property (nonatomic, strong) NSArray *creditLimitList; // 对应图中点亮的金额

// 额度配置信息
@property (nonatomic, strong) NSArray<ZXSDHomeCreditItem *> *creditUnitList;

// 本周期内发生借款的天数
@property (nonatomic, strong) NSArray<NSNumber *> *createdLoanDays;

// 一个周期内最大借款次数
@property (nonatomic, assign) NSInteger loanCountMax;

// 当前周期内已借款次数
@property (nonatomic, assign) NSInteger loanNumberCurrentCycle;

#pragma mark - 首页改版部分
// 当前周期内工资已经可用的天数
@property (nonatomic, assign) NSInteger dayInterval;


@property (nonatomic, strong) ZXSDHomeExtendCalculation *extendCalculation;
@property (nonatomic, strong) ZXSDHomeOverdueCalculation *overdueCalculation;

@end

@interface ZXSDHomeLoanExtraInfo : ZXSDBaseModel

__string(companyName) //雇主公司名字
__string(logoUrl) // 雇主公司logo
__string(eventRefId) // 风控ID
__string(failReason) // 雇主审核拒绝后的原因
__string(cooperationModel) //企业合作模式

// 立即还款信息
__string(overduLoanRefId)
__string(bankCardRefId)

@property (nonatomic, strong) NSString *currentLoanRefId;


/** 审核中
​    SUBMIT("Submit", "审核中"),
​    审核拒绝
​    REJECT("Reject", "审核拒绝"),
​    审核通过 
​    ACCEPT("Accept", "审核通过");
*/
__string(smileStatus)

@property (nonatomic, assign) BOOL userBank2Done; // 是否点亮银行卡
@property (nonatomic, assign) BOOL canEditJobInfo; // 是否可以编辑雇主信息

@property (nonatomic, copy) NSString *customerValidity; // 会员有效期
@property (nonatomic, copy) NSString *userRole; // smile/normal
@property (nonatomic, assign) BOOL isOldUser;

@property (nonatomic, assign) BOOL isCertified;

//当前加入人数
@property (nonatomic, assign) NSInteger userSum;

// 是否开启VA用户专享活动
@property (nonatomic, assign) BOOL vaActivitySwitch;
@property (nonatomic, copy) NSString *vaActivityUrl;

@end


@interface ZXSDHomeCollegeModel : ZXSDBaseModel

__string(title) //
__string(detailURL)
__string(iconName)

@property (nonatomic, assign) NSInteger hexColor;
@property (nonatomic, assign) NSInteger btnColor;

@property (nonatomic, strong) NSArray *collegeModelItems;


@end

@interface ZXSDHomeQuestionModel : ZXSDBaseModel


__string(avatar)
__string(phone)

__string(title) //
__string(desc)
__string(detailURL)
__string(readNumber)

@property (nonatomic, strong) NSArray *questionItems;

@end

@interface ZXSDHomePartnerModel : ZXSDBaseModel

__string(name) //
__string(icon)

@end

NS_ASSUME_NONNULL_END
