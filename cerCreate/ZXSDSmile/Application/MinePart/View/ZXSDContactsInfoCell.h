//
//  ZXSDContactsInfoCell.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDContactsInfoCell : UITableViewCell

@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) BOOL canContract;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIButton *contractButton;

@end

NS_ASSUME_NONNULL_END
