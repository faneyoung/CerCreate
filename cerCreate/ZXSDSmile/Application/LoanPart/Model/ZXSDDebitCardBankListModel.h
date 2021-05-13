//
//  ZXSDDebitCardBankListModel.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDDebitCardBankListModel : ZXSDBaseModel

__string(bankName)
__string(bankCode)
__string(bankPic)

+ (NSMutableArray *)parsingDataWithJson:(id)data;

@end

NS_ASSUME_NONNULL_END
