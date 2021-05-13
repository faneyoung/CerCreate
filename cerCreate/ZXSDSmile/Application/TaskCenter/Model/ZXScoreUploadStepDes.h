//
//  ZXScoreUploadStepDes.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/4.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreUploadStepDes : ZXBaseModel

@property (nonatomic, strong) NSMutableAttributedString *attrTitle;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) int step;


@property (nonatomic, assign) int desType;
@property (nonatomic, strong) NSArray *stepDesModels;


@end

NS_ASSUME_NONNULL_END
