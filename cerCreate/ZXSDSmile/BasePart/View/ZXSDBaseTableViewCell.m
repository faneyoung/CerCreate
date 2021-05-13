//
//  ZXSDBaseTableViewCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseTableViewCell.h"

@implementation ZXSDBaseTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass(self.class);
}

+ (CGFloat)height
{
    return UITableViewAutomaticDimension;
}

+ (instancetype)instanceCell:(UITableView *)tableView sepStyle:(UITableViewCellSeparatorStyle)style{
    ZXSDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = style;
    tableView.separatorColor = kThemeColorLine;
    return cell;
}

+ (instancetype)instanceCell:(UITableView *)tableView{
    ZXSDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initView];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (instancetype)init
{
    return [self initWithReuseIdentifier:[ZXSDBaseTableViewCell identifier]];
}

- (void)setRenderData:(id)renderData
{
}

- (void)updateViewsWithData:(id)data{
    
}

- (NSDictionary *)fetchResultDictionary;
{
    return nil;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    ZGLog(@"Undefined key found: %@.%@", self.class, key);
    return nil;
}

- (void)initView
{}


@end
