//
//  ZXBaseCell.h
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBaseCell : UITableViewCell

+ (NSString *)identifier;


+ (instancetype)instanceCell:(UITableView *)tableView;
+ (instancetype)instanceCell:(UITableView *)tableView sepStyle:(UITableViewCellSeparatorStyle)style;

+ (instancetype)instanceCell:(UITableView *)tableView indexPath:(NSIndexPath*)indexPath;

+ (instancetype)instanceCustomSeparatorCell:(UITableView *)tableView;

- (void)updateWithData:(id)model;



@end

NS_ASSUME_NONNULL_END
