//
//  ZXShareInfoModel.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/23.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXShareInfoModel : ZXBaseModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *qrCodeUrl;



@end

NS_ASSUME_NONNULL_END
