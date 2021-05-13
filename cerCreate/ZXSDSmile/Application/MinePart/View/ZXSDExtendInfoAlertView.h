//
//  ZXSDExtendInfoAlertView.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDExtendInfoAlertView : UIView

- (void)showInView:(UIView *)container;
- (void)configDate:(NSString *)left
         freshDate:(NSString *)date;
@end

NS_ASSUME_NONNULL_END
