//
//  ZXSDAdvanceDetailCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDAdvanceDetailCell : UITableViewCell

- (void)config:(NSString *)loan
      interest:(NSString *)interest
          date:(NSString *)date
         total:(NSString *)total;
@end

NS_ASSUME_NONNULL_END
