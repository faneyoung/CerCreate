//
//  ZXMessageList.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMessageItem : ZXBaseModel
@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *created;

/**
 推荐岗位
 */

@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *pattern;
@property (nonatomic, strong) NSString *salary;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) NSString *configId;
@property (nonatomic, strong) NSString *distance;




@end

@interface ZXMessageList : ZXBaseModel
@property (nonatomic, assign) int totalCount;
@property (nonatomic, strong) NSArray <ZXMessageItem*>*messages;


@end

NS_ASSUME_NONNULL_END
