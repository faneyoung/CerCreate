//
//  ZXScoreUploadModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreStepItemModel : ZXBaseModel
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *des;

+ (instancetype) itemWithType:(NSString*)type step:(int)step;

@end

@interface ZXScoreUploadModel : ZXBaseModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *cameraImg;
@property (nonatomic, strong) UIImage *authImg;
@property (nonatomic, strong) NSString *scoreTitle;

@property (nonatomic, strong) NSString *scoreUrl;
@property (nonatomic, strong) NSString *nameUrl;

@property (nonatomic, strong) NSString *uploadDesTitle;
@property (nonatomic, strong) NSString *uploadDesAuthTitle;
@property (nonatomic, strong) NSString *uploadDesShotScreen;
@property (nonatomic, strong) NSString *uploadDesShotScreenAuth;
@property (nonatomic, strong) NSArray *uploadDesItems;
@property (nonatomic, strong) NSArray *uploadDesAuthItems;

///支付宝分
- (BOOL)isAliScore;
///微信分
- (BOOL)isWxScore;

@end

NS_ASSUME_NONNULL_END
