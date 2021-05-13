//
//  ZXSDPersonalInfoCell.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDPersonalInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, assign) BOOL canEdit;

@end

NS_ASSUME_NONNULL_END
