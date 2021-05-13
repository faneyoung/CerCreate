//
//  ZXSDHomePartnerCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"
#import "ZXSDHomeLoanInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDHomePartnerCell : ZXSDBaseTableViewCell

@property (nonatomic, strong) NSArray<ZXSDHomePartnerModel*> *partners;

@end

NS_ASSUME_NONNULL_END
