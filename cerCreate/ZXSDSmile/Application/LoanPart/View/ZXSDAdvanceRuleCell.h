//
//  ZXSDAdvanceRuleCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDAdvanceRuleCell : UITableViewCell

@property (nonatomic, assign) MemberReviewStatus status;

@property (nonatomic, copy) void (^showRules)(BOOL isSmilePlus);
@property (nonatomic, copy) void (^recommendCompany)(void);

@end

NS_ASSUME_NONNULL_END
