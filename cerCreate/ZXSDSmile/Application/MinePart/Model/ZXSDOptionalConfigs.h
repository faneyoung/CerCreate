//
//  ZXSDOptionalConfigs.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/21.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDOptionalConfigs : ZXSDBaseModel

// 孩子数量
@property (nonatomic, strong) NSArray<NSString *> *childrenNum;

//常住时长
@property (nonatomic, strong) NSArray<NSString *> *dwellDuration;
//学历
@property (nonatomic, strong) NSArray<NSString *> *education;

//职业
@property (nonatomic, strong) NSArray<NSString *> *job;

//职务
@property (nonatomic, strong) NSArray<NSString *> *leaderPost;

//婚姻状况
@property (nonatomic, strong) NSArray<NSString *> *maritalStatus;

//亲属关系
@property (nonatomic, strong) NSArray<NSString *> *relativeType;
//发薪日
@property (nonatomic, strong) NSArray<NSString *> *salaryDay;

//社会关系
@property (nonatomic, strong) NSArray<NSString *> *socialType;

@end

NS_ASSUME_NONNULL_END
