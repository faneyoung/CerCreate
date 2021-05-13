//
//  ZXSDPersonalInfoCell.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDPersonalInfoCell.h"

@implementation ZXSDPersonalInfoCell

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
    self.textField.frame = CGRectMake(95 + 30 , 15, SCREEN_WIDTH() - 126 - 40, 30);
    if (self.canEdit) {
        self.nextImageView.hidden = YES;
    } else {
        self.nextImageView.hidden = NO;
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
        _textField.textColor = UICOLOR_FROM_HEX(0x3C465A);
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
