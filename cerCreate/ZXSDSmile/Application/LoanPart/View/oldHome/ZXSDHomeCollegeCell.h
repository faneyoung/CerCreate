//
//  ZXSDHomeCollegeCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"
#import "ZXSDHomeLoanInfo.h"

NS_ASSUME_NONNULL_BEGIN

// 薪朋友学院
@interface ZXSDHomeCollegeCell : ZXSDBaseTableViewCell

@property (nonatomic, strong) NSArray<ZXSDHomeCollegeModel*> *colleges;

@property (nonatomic, copy) void(^showDetail)(NSString *url);

@end

NS_ASSUME_NONNULL_END
