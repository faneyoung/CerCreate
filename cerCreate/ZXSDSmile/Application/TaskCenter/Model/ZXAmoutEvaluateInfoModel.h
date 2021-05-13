//
//  ZXAmoutEvaluateInfoModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/11.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXTaskCenterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAmountEvaluateItemModel : ZXBaseModel
@property (nonatomic, strong) NSString *titleCode;
@property (nonatomic, strong) NSString *titleDesc;
@property (nonatomic, strong) NSArray *taskItems;
@property (nonatomic, assign) BOOL hidden;

///展开/折叠
@property (nonatomic, assign) BOOL expand;

@end

@interface ZXAmoutEvaluateInfoModel : ZXBaseModel
///当前可预支额度资格
@property (nonatomic, strong) NSString *limit;
///额度资格说明
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSArray *evaluateItemModels;


@end

NS_ASSUME_NONNULL_END
