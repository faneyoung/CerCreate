//
//  ZXSDVersionModel.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/18.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDVersionModel : ZXSDBaseModel

//
__string(updateDesc)
__string(versionName)

@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, assign) BOOL forceUpdate;
@property (nonatomic, strong) NSString *downloadUrl;

@end

NS_ASSUME_NONNULL_END
