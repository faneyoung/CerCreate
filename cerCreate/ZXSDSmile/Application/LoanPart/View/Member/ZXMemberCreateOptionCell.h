//
//  ZXMemberCreateOptionCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/2/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMemberCreateOptionCell : ZXBaseCell
@property (nonatomic, strong) void (^optionSelectedBlock)(int idx);

@property (nonatomic, strong) NSString *loanAmount;
@property (nonatomic, strong) NSString *interest;


@end

NS_ASSUME_NONNULL_END
