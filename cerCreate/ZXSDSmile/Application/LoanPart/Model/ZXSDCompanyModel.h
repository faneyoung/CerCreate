//
//  ZXSDCompanyModel.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDCompanyModel : ZXSDBaseModel

__string(companyName) //
__string(companyRefId) //
__string(logoUrl)
__string(shortName)
__string(salaryDay) //发薪日

/**
  员工信息查询
 ​ EMPLOYEE_QUERY,
 ​ 雇主审核
 ​ EMPLOYER_APPROVE;
 */
__string(cooperationModel) //业务模式

///选中标记
@property (nonatomic, assign) BOOL selecteStatus;

@end

NS_ASSUME_NONNULL_END
