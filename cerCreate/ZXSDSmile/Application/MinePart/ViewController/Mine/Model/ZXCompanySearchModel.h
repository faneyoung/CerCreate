//
//  ZXCompanySearchModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 "companyName" : "杭州四喜",
                 "companyRefId" : "fNcF84RUcKBS7C9PHGOoqqq",
                 "salaryDay" : "12",
                  "shortName" : "众薪速达",
                 "logoUrl" : "https://cashbus-hrhx-app.oss-cn-beijing.aliyuncs.com/prod/logo/dlr.png",
                 "cooperationModel" : "EMPLOYEE_QUERY",
                   "keyWord":"四喜"

 */

@interface ZXCompanySearchModel : ZXBaseModel

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyRefId;
@property (nonatomic, strong) NSString *keyWord;

@property (nonatomic, strong) NSAttributedString *name;



@end

NS_ASSUME_NONNULL_END
