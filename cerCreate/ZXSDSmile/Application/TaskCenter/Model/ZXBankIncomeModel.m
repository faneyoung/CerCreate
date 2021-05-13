//
//  ZXBankIncomeModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBankIncomeModel.h"
#import "ZXBankIncomeDesCell.h"
#import "ZXBankincomeUploadItemModel.h"

@implementation ZXBankIncomeModel

- (NSArray *)desItems{
    if (!IsValidString(self.text)) {
        return [ZXBankIncomeDesItem desItemsWithTitle:@"--"];
    }
    
    return [ZXBankIncomeDesItem desItemsWithTitle:self.text];
}

- (NSArray *)uploadImgItems{
    if (!_uploadImgItems) {
        
       __block NSMutableArray *tmps = @[].mutableCopy;
        [self.months enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZXBankincomeUploadItemModel *item = [[ZXBankincomeUploadItemModel alloc] init];
            item.mouth = obj;
            [tmps addObject:item];
            
        }];
        _uploadImgItems = tmps.copy;
    }
    
    return _uploadImgItems;
}

@end
