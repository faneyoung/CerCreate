//
//  ZXSDContactsInfoCell.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDContactsInfoCell.h"

@implementation ZXSDContactsInfoCell

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
        [self.contentView addSubview:self.contractButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldValueChange:) name:UITextFieldTextDidChangeNotification object:self.textField];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(20, 20, 95, 20);
    self.nextImageView.frame = CGRectMake(SCREEN_WIDTH() - 36, 22, 16, 16);
    self.textField.frame = CGRectMake(95 + 20 , 15, SCREEN_WIDTH() - 126 - 40, 30);
    self.contractButton.frame = CGRectMake(SCREEN_WIDTH() - 42, 8, 22, 44);
    
    if (self.canEdit) {
        self.nextImageView.hidden = YES;
    } else {
        self.nextImageView.hidden = NO;
    }
    
    if (self.canContract) {
        self.contractButton.hidden = NO;
    } else {
        self.contractButton.hidden = YES;
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

- (UIButton *)contractButton {
    if (!_contractButton) {
        _contractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contractButton setImage:UIIMAGE_FROM_NAME(@"smile_cert_contract") forState:UIControlStateNormal];
    }
    return _contractButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - noti -

- (void)textfieldValueChange:(id)sender{

    if(self.textField.tag == 100 ||
       self.textField.tag == 200){
        UITextRange *selectedRange = self.textField.markedTextRange;
        UITextPosition *position = [self.textField positionFromPosition:selectedRange.start offset:0];
        
        if (!position) { // 没有高亮选择的字
            //过滤非汉字字符
            self.textField.text = [self filterCharactor:self.textField.text withRegex:kChineseFilter];
            
            if (self.textField.text.length >= kMaxNameLength) {
                self.textField.text = [self.textField.text substringToIndex:kMaxNameLength];
            }
        }else { //有高亮文字
            //do nothing
        }
    }
}

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

@end
