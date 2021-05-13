//
//  ZXScoreImageUploadCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreImageUploadCell : ZXBaseCell

@property (nonatomic, strong) void(^uploadBtnClickBlock)(UIButton*btn,id data);


- (void)updateViewWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
