//
//  ZXBankincomeUploadItemModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/23.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXBankincomeUploadItemModel : ZXBaseModel
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *mouth;

@property (nonatomic, assign) BOOL showDelete;

@end

NS_ASSUME_NONNULL_END
