//
//  ZXSDDebitCardBankListCell.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXSDDebitCardBankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDDebitCardBankListCell : UITableViewCell

- (void)reloadSubviewsWithModel:(ZXSDDebitCardBankListModel *)model;

@end

NS_ASSUME_NONNULL_END
