//
//  ZXSDChargeDetailAlertView.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDChargeDetailAlertView : UIView

@property (nonatomic, copy) void(^confirmAction)(void);

- (void)configWithData:(NSArray *)data;

@end

@interface  ZXSDChargeDetailAlertCell: UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

NS_ASSUME_NONNULL_END
