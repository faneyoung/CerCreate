//
//  ZXBaseView.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBaseView : UIView

- (void)initSubViews;
- (void)updateViewWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
