//
//  ZXSDHomeLoanProgressCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/12.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"
#import "ZXSDHomeLoanInfo.h"

NS_ASSUME_NONNULL_BEGIN

// 预支额度信息&周期时间展示
@interface ZXSDHomeLoanProgressCell : ZXSDBaseTableViewCell

@property (nonatomic, copy) void(^loanConfirmAction)(NSString * _Nullable targetAmount);
@end

@interface ZXSDHomeLoanAmountView : UIView

@property (nonatomic, strong) ZXSDHomeCreditItem *creditModel;

@property (nonatomic, copy) void(^creditItemChoosedAction)(void);

- (instancetype)initWithCreditItem:(ZXSDHomeCreditItem *)item highlighted:(BOOL)highlighted index:(NSInteger)index;

- (void)renderItemView:(BOOL)highlighted;

@end

NS_ASSUME_NONNULL_END
