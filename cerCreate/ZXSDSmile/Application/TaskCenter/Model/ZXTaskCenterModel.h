//
//  ZXTaskCenterModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/18.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXTaskCenterItem : ZXBaseModel

@property (nonatomic, strong) NSString *certKey;
@property (nonatomic, strong) NSString *certTitle;
@property (nonatomic, strong) NSString *certTitleDesc;
@property (nonatomic, strong) NSString *certStatus;
@property (nonatomic, strong) NSString *certStatusDesc;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *certContent;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *action;


/// 是否采信
@property (nonatomic, assign) BOOL credible;

@property (nonatomic, strong) NSString *placeholdImg;

@property (nonatomic, assign) CGFloat score;

@property (nonatomic, assign) BOOL expand;
@property (nonatomic, assign) BOOL isExpandItem;

@property (nonatomic, assign) BOOL showProgressView;


+ (ZXTaskCenterItem*)expandItem;



@end

@interface ZXTaskCenterModel : ZXBaseModel
@property (nonatomic, strong) NSString *titleCode;
@property (nonatomic, strong) NSString *titleDesc;
@property (nonatomic, strong) NSArray *taskItems;


@end

NS_ASSUME_NONNULL_END
