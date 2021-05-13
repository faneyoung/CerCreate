//
//  ZXBankincomeUploadItemModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/23.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBankincomeUploadItemModel.h"

@implementation ZXBankincomeUploadItemModel

- (BOOL)showDelete{
    if (self.imgUrl &&
        [self.imgUrl rangeOfString:@"http"].location != NSNotFound) {
        return YES;
    }
    
    return NO;
    
}

@end
