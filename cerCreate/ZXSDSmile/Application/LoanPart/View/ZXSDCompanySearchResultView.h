//
//  ZXSDCompanySearchResultView.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXSDCompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompanySearchResultViewDidSelectModel)(ZXSDCompanyModel* model);

@interface ZXSDCompanySearchResultView : UIView

@property (nonatomic, copy) CompanySearchResultViewDidSelectModel didSelectModel;

- (void)freshResultWithResults:(NSArray<ZXSDCompanyModel*> *)data;

@end

NS_ASSUME_NONNULL_END
