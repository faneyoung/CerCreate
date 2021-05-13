//
//  ZXBankIncomeUploadCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXBankIncomeUploadCell : ZXBaseCell
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) void (^imgItemClickedBlock)(int idx);
@property (nonatomic, strong) void (^deleteBtnClickBlock)(int idx);

@end

NS_ASSUME_NONNULL_END
