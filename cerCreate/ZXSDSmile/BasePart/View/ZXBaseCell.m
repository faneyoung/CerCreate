//
//  ZXBaseCell.m
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

@implementation ZXBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identifier{
    return NSStringFromClass(self.class);
}

+ (instancetype)instanceCell:(UITableView *)tableView sepStyle:(UITableViewCellSeparatorStyle)style{
    ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = style;
    tableView.separatorColor = kThemeColorLine;
    return cell;
}

+ (instancetype)instanceCell:(UITableView *)tableView{
    ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

+ (instancetype)instanceCell:(UITableView *)tableView indexPath:(NSIndexPath*)indexPath
{
    ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    return cell;
}


+ (instancetype)instanceCustomSeparatorCell:(UITableView *)tableView{
    ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *sep = [cell.contentView viewWithTag:9700101];
    if (!sep) {
        [[self class] customSepView:cell.contentView];
    }
    
    return cell;
}

+ (UIView*)customSepView:(UIView*)targetView{
    UILabel *sepView = [[UILabel alloc] init];
    sepView.backgroundColor = kThemeColorLine;
    [targetView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(0);
        make.left.right.inset(15);
        make.height.mas_equalTo(1.0);
    }];
    sepView.tag = 9700101;
    return sepView;
}

- (void)updateWithData:(id)model{
    
}

@end
