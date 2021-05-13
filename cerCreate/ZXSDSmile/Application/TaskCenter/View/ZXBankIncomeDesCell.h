//
//  ZXBankIncomeDesCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXBankIncomeDesItem : ZXBaseModel
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *des;

+ (NSArray*)desItemsWithTitle:(NSString*)title;

@end

@interface ZXBankIncomeDesCell : ZXBaseCell

@property (nonatomic, assign) BOOL isBottomItem;

@end

NS_ASSUME_NONNULL_END
