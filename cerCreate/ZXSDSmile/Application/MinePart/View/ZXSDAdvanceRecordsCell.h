//
//  ZXSDAdvanceRecordsCell.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXSDAdvanceRecordsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnVoidBlock)(void);

@interface ZXSDAdvanceRecordsCell : UITableViewCell

- (void)reloadSubviewsWithModel:(ZXSDAdvanceRecordsModel *)model;

@property (nonatomic, copy) ReturnVoidBlock jumpToLoanContractBlock;

@end


@interface ZXSDAdvanceRecordExtendCell : UITableViewCell

@property (nonatomic, copy) ReturnVoidBlock jumpToLoanContractBlock;

@property (nonatomic, copy) void(^extendAction)(void);
@property (nonatomic, copy) void(^extendAlert)(void);
@property (nonatomic, copy) void(^repaymentAction)(void);


- (void)reloadSubviewsWithModel:(ZXSDAdvanceRecordsModel *)model;

@end

NS_ASSUME_NONNULL_END
