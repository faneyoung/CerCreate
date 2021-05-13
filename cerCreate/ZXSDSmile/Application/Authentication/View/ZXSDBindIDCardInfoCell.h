//
//  ZXSDBindIDCardInfoCell.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/20.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDBindIDCardInfoCell : ZXSDBaseTableViewCell

@property (nonatomic, assign) BOOL canChoice;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *endButton;
@property (nonatomic, strong) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
