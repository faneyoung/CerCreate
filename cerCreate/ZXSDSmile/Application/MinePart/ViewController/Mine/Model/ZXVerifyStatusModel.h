//
//  ZXVerifyStatusModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXVerifyStatusModel : ZXBaseModel
@property (nonatomic, assign) BOOL bankCardDone;//绑卡
@property (nonatomic, assign) BOOL jobInfoDone;//雇主信息

@property (nonatomic, assign) BOOL idCardDone;//身份证ocr
@property (nonatomic, assign) BOOL faceDone; //人脸活体

- (BOOL)shouldBindCardOrBindEmployer;

@end

NS_ASSUME_NONNULL_END
