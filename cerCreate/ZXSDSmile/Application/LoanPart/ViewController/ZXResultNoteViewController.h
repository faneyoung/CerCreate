//
//  ZXResultNoteViewController.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

typedef enum : NSUInteger {
    ResultPageTypeRefundSuccess = 1,///还款成功
    ResultPageTypeRefundDoing,///还款处理中
    ResultPageTypeRefundFail,///还款失败
    ResultPageTypeMemberFeeSuccess,///开通会员成功
    ResultPageTypeMemberFeeDoing,///开通会员处理中
    ResultPageTypeMemberFeeFail,///开通会员失败
    ResultPageTypeAddCard, ///添加银行卡成功
    ResultPageTypeAdvancing,///薪资预付中……
    ResultPageTypeRebind,///未与银行签约，重绑协议
    ResultPageTypePhoneUpdate,///换绑手机号成功
    ResultPageTypeTaskScoreUpload,///任务中心支付分上传成功
    ResultPageTypeCouponSuccess,///神券购买成功
    ResultPageTypeCouponDoing,///神券处理中
    ResultPageTypeCouponFail,///神券购买失败
    ResultPageTypeWageAuthing,///银行收入明细认证中
    ResultPageTypeRiskReject,///风控拒绝


} ResultPageType;

NS_ASSUME_NONNULL_BEGIN

@interface ZXResultNoteViewController : ZXSDBaseViewController
@property (nonatomic, strong) NSString *customTitle;

@property (nonatomic, assign) ResultPageType resultPageType;
@property (nonatomic, strong) NSString *payMessage;
@property (nonatomic, strong) UIImage *confirmBgImage;


@end

NS_ASSUME_NONNULL_END
