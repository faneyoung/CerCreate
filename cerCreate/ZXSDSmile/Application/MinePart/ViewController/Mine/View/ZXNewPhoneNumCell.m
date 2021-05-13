//
//  ZXNewPhoneNumCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXNewPhoneNumCell.h"
#import "UITextField+help.h"

@interface ZXNewPhoneNumCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countryNumCSWidth;

@end

@implementation ZXNewPhoneNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldValueChange:) name:UITextFieldTextDidChangeNotification object:self.inputView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}

- (void)setPlaceholderStr:(NSString *)placeholderStr{
    _placeholderStr = placeholderStr;
    self.textField.placeholder = placeholderStr;
}

- (void)setShowCountry:(BOOL)showCountry{
    _showCountry = showCountry;
    if (showCountry) {
        self.countryNumCSWidth.constant = 53;
    }
    else{
        self.countryNumCSWidth.constant = 0;
        
    }
    
    [self.contentView layoutIfNeeded];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [textField filter:kPureNumFilter toString:string range:range maxLenght:11];
    
}

- (void)textfieldValueChange:(id)sender{
    UITextRange *selectedRange = [self.inputView markedTextRange];
    NSString * newText = [self.inputView textInRange:selectedRange];
    if (newText.length > 0) {/**< 获取高亮部分 */
        return;
    }
        
    
    if (self.inputBlock) {
        self.inputBlock(self.textField.text);
    }
    
}



@end
