//
//  ZXHomeLoanNoteCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeLoanNoteCell : ZXBaseCell

@property (nonatomic, strong) void (^cancelNoteBlock)(void);

- (void)updateViewsWithData:(NSArray*)data;

@end

NS_ASSUME_NONNULL_END
