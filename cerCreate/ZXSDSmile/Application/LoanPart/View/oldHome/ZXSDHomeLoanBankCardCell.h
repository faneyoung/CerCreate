//
//  ZXSDHomeLoanBankCardCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"
#import "ZXSDHomeLoanInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDHomeLoanBankCardCell : ZXSDBaseTableViewCell

@property (nonatomic, assign)ZXSDCertifiedStatus certifiedStatus;
@property (nonatomic, copy) void(^certifiedAction)(void);
@property (nonatomic, copy) void(^employerAction)(void);
@property (nonatomic, copy) void(^activityAction)(void);
@property (nonatomic, copy) void(^shareAction)(void);

@end

NS_ASSUME_NONNULL_END
