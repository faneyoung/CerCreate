//
//  ZXCouponListModel.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCouponListModel : ZXBaseModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *couponRefId;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *expires;
@property (nonatomic, strong) NSString *faceValue;
/// 01:10元券  02:20元券
@property (nonatomic, strong) NSString *type;
///01:可使用 02:已核销 03:以过期 04:已作废
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *batchNo;
@property (nonatomic, strong) NSString *desc;

///note selected
@property (nonatomic, assign) BOOL selected;
///coupon selected
@property (nonatomic, assign) BOOL couponSelected;


+ (NSArray*)modelsWithData:(NSArray*)datas;
+ (NSArray*)testModels;

@end

NS_ASSUME_NONNULL_END
