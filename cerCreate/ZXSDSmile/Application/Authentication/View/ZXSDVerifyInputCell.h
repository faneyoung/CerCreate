//
//  ZXSDVerifyInputCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDVerifyInputCell : ZXSDBaseTableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendButton;

//@property (nonatomic, copy) void (^sendCodeAction)(void);

@end

NS_ASSUME_NONNULL_END
