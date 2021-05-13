//
//  ZXChooseCompanyCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/11.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"
#import "ZXSDCompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCompanySelectionModel : ZXBaseModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) NSArray *companys;


@end

@protocol ZXChooseCompanyCellDelegate <NSObject>

@optional;
///checkBtn点击代理
- (void)checkBtn:(UIButton*)btn item:(id)item;
///公司选择代理
- (void)itemSelectedAtIndex:(int)idx item:(id)item;

@end

@interface ZXChooseCompanyCell : ZXBaseCell

@property (nonatomic, weak) id delegate;



@end

NS_ASSUME_NONNULL_END
