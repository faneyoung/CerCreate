//
//  ZXShareModel.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/21.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXShareModel : ZXBaseModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) id thumImage;
@property (nonatomic, strong) id image;

@property (nonatomic, assign) int type;



@end

NS_ASSUME_NONNULL_END
