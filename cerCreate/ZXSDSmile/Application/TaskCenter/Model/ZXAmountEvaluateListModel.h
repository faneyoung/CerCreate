//
//  ZXAmountEvaluateListModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXTaskCenterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAmountEvaluateListModel : ZXBaseModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, assign) BOOL isUnfold;
@property (nonatomic, strong) NSArray *taskItems;


@end

NS_ASSUME_NONNULL_END
