//
//  UITableViewCell+BottomLine.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/16.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "UITableViewCell+BottomLine.h"

@implementation UITableViewCell (BottomLine)

- (UIView *)bottomLine
{
    UIView *line = objc_getAssociatedObject(self, _cmd);
    if (!line) {
        line = [[UIView alloc]init];
        line.backgroundColor = UICOLOR_FROM_HEX(0xE5E5E5);
        objc_setAssociatedObject(self, _cmd, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return line;
}

- (void)showBottomLine
{
    if (!self.bottomLine.superview) {
        [self addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self);
        }];
    }
    self.bottomLine.hidden = NO;
}

- (void)hideBottomLine
{
    self.bottomLine.hidden = YES;
}
- (void)shouldHideBottomLine:(BOOL)hidden{
    if (hidden) {
        [self hideBottomLine];
    }
    else{
        [self showBottomLine];
    }
}
@end
