//
//  ZXSDCertificationCenterModel.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDCertificationCenterModel : ZXSDBaseModel

__string(certType)
__string(certName)
__string(certStatus)
__string(certContent)
__string(certDes)
@property (nonatomic, strong) NSString *url;


+ (NSMutableArray *)parsingDataWithJson:(id)data;

@end

NS_ASSUME_NONNULL_END
