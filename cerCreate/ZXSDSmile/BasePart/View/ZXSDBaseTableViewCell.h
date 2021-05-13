//
//  ZXSDBaseTableViewCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZXSD_KEY_CELL_IDENTIFIER       @"cellIdentifier"   //
#define ZXSD_KEY_CELL_HEIGHT           @"cellHeight"
#define ZXSD_KEY_DEFAULT_DATA          @"defaultData"
#define ZXSD_KEY_SELECTOR_NAME         @"selector_name"    //选中cell调用的方法
#define ZXSD_KEY_SELECTOR_OBJ         @"selector_obj"    //选中cell调用的方法需要的传值

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDBaseTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)height;

+ (instancetype)instanceCell:(UITableView *)tableView;
+ (instancetype)instanceCell:(UITableView *)tableView sepStyle:(UITableViewCellSeparatorStyle)style;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)initView;
- (void)setRenderData:(id)renderData;


- (void)updateViewsWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
