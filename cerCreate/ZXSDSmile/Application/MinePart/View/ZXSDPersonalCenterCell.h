//
//  ZXSDPersonalCenterCell.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/12.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPersonalCenterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDPersonalCenterCell : UITableViewCell

- (void)reloadSubviewsWithModel:(ZXPersonalCenterModel *)model;

@end

NS_ASSUME_NONNULL_END
