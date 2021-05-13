//
//  ZXSDRepaymentAuthCodeCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/6.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDRepaymentAuthCodeCell : ZXSDBaseTableViewCell

@property (nonatomic, copy) void(^sendCodeAction)(UIButton *sender, ZXSDRepaymentAuthCodeCell *cell);
@property (nonatomic, copy) void(^updateAuthCode)(NSString *code);

- (void)updateCountdownValue;

@end

NS_ASSUME_NONNULL_END
