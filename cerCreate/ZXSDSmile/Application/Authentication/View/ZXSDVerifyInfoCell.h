//
//  ZXSDVerifyInfoCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"
#import "ZXSDEmployeeInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDVerifyInfoCell : ZXSDBaseTableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

NS_ASSUME_NONNULL_END
