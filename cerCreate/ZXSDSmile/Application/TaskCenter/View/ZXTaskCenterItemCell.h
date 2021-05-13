//
//  ZXTaskCenterItemCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/18.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXTaskCenterItemCell : ZXBaseCell
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, assign) BOOL isBottom;

@end

NS_ASSUME_NONNULL_END
