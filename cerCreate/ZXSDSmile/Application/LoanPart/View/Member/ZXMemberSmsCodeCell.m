//
//  ZXMemberSmsCodeCell.m
//  ZXSDSmile
//
//  Created by Fane on 2020/11/30.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMemberSmsCodeCell.h"


@interface ZXMemberSmsCodeCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIView *verifyCodeView;
@property (weak, nonatomic) IBOutlet UITextField *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightCS;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end

@implementation ZXMemberSmsCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.inputView.font = FONT_SFUI_X_Regular(16);
    
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc] initWithString:@"请输入6位验证码" attributes:@{NSForegroundColorAttributeName : TextColorPlacehold,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:16.0]}];
    self.inputView.attributedPlaceholder = arrStr;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldValueChange:) name:UITextFieldTextDidChangeNotification object:self.inputView];
    
    self.sendCodeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setHideTitle:(BOOL)hideTitle{
    _hideTitle = hideTitle;
    if (hideTitle) {
        self.titleHeightCS.constant = 0;
    }
    else{
        self.titleHeightCS.constant = 20;

    }
    
    [self.contentView updateFocusIfNeeded];
}

- (void)setHideSepLine:(BOOL)hideSepLine{
    _hideSepLine = hideSepLine;
    self.bottomLine.hidden = hideSepLine;
}


#pragma mark - UITextFieldDelegate -
static int MaxSMSCodeLenght = 6;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    //字母和数字判断
    if (![string isEqualToString:filtered]) {
        return NO;
    }
    
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = textField.text.length + string.length - range.length;

    return newLength <= MaxSMSCodeLenght;
}

- (void)textfieldValueChange:(id)sender{
    UITextRange *selectedRange = [self.inputView markedTextRange];
    NSString * newText = [self.inputView textInRange:selectedRange];
    if (newText.length > 0) {/**< 获取高亮部分 */
        return;
    }
        
    
    if (self.codeBlock) {
        self.codeBlock(self.inputView.text);
    }
    
}


@end
