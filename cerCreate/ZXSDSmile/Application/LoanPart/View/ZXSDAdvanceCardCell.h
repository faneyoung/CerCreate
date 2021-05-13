//
//  ZXSDAdvanceCardCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXSDAdvanceCardCellDelegate <NSObject>

- (void)protocolChanged:(BOOL)checked;
- (void)showProtocol;

@end

@interface ZXSDAdvanceCardCell : UITableViewCell


@property (nonatomic, weak) id<ZXSDAdvanceCardCellDelegate> delegate;
@property (nonatomic, assign) MemberReviewStatus status;

- (void)updateMemberDate:(NSString *)start end:(NSString *)end;

@end

NS_ASSUME_NONNULL_END
