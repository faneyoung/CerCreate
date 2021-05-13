//
//  ZXSDAdvanceSalaryInfoCell.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDAdvanceSalaryInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, assign) BOOL canChoice;


@end

NS_ASSUME_NONNULL_END
