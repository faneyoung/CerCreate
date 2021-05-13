//
//  ZXSDBindDebitCardInfoCell.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/19.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDBindDebitCardInfoCell : UITableViewCell

@property (nonatomic, assign) BOOL canChoice;
@property (nonatomic, assign) BOOL canSendSms;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIButton *sendButton;

@end

NS_ASSUME_NONNULL_END
