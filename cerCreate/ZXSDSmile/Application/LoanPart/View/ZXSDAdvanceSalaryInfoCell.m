//
//  ZXSDAdvanceSalaryInfoCell.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAdvanceSalaryInfoCell.h"

@implementation ZXSDAdvanceSalaryInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.nextImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(20, 20, 95, 20);
    self.nextImageView.frame = CGRectMake(SCREEN_WIDTH() - 36, 22, 16, 16);
    self.textField.frame = CGRectMake(95 + 40 , 15, SCREEN_WIDTH() - 136 - 30, 30);
    if (self.canChoice) {
        self.nextImageView.hidden = NO;
    } else {
        self.nextImageView.hidden = YES;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UICOLOR_FROM_HEX(0x3C465A);
        _titleLabel.font = FONT_PINGFANG_X(14);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = UICOLOR_FROM_HEX(0x626F8A);
        _textField.font = FONT_PINGFANG_X(14);
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc] init];
        _nextImageView.backgroundColor = [UIColor clearColor];
        _nextImageView.image = UIIMAGE_FROM_NAME(@"smile_mine_arrow");
    }
    return _nextImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
