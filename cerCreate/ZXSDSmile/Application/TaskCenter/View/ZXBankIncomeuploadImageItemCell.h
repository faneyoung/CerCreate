//
//  ZXBankIncomeuploadImageItemCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/23.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBankIncomeuploadImageItemCell : UICollectionViewCell
@property (nonatomic, strong) void(^uploadBtnBlock)(id data);
@property (nonatomic, strong) void(^deleteBtnBlock)(id data);

- (void)updateViewWithModel:(id)data;

@end

NS_ASSUME_NONNULL_END
