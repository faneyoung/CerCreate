//
//  ZXSDBindDebitCardInfoCell.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/19.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBindDebitCardInfoCell.h"

@implementation ZXSDBindDebitCardInfoCell

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
        [self.contentView addSubview:self.sendButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(20, 20, 105, 20);
    self.nextImageView.frame = CGRectMake(SCREEN_WIDTH() - 36, 22, 16, 16);
    self.textField.frame = CGRectMake(95 + 40 , 15, SCREEN_WIDTH() - 95 - 40 - 20, 30);
    self.sendButton.frame = CGRectMake(SCREEN_WIDTH() - 100, 20, 80, 44);
    
    if (self.canChoice) {
        self.nextImageView.hidden = NO;
    } else {
        self.nextImageView.hidden = YES;
    }
    
    CGRect tfRect = self.textField.frame;
    
    if (self.canSendSms) {
        self.sendButton.hidden = NO;
        
        self.textField.frame = CGRectMake(tfRect.origin.x, tfRect.origin.y, tfRect.size.width-80, tfRect.size.height);
        [self.sendButton setCenterY:self.textField.centerY];

    } else {
        self.sendButton.hidden = YES;
    }
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = UICOLOR_FROM_HEX(0x333333);
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
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

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.backgroundColor = [UIColor clearColor];
        _sendButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f];
        [_sendButton setTitleColor:UICOLOR_FROM_HEX(0x00B050) forState:UIControlStateNormal];
    }
    return _sendButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
