//
//  ZXTaskReferenceItemCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXTaskReferenceItemCell : UICollectionViewCell

@property (nonatomic, strong) void(^uploadBtnBlock)(id data);

- (void)updateViewWithModel:(id)data;
@end

NS_ASSUME_NONNULL_END
