//
//  ZXPhoneUpdateInputCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/11.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXPhoneUpdateInputCell.h"
#import "UITextField+help.h"

@interface ZXPhoneUpdateInputCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ZXPhoneUpdateInputCell

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldValueChange:) name:UITextFieldTextDidChangeNotification object:self.inputView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - data -
- (void)setType:(PhoneUpdateType)type{
    _type = type;
    if (type == PhoneUpdateTypePhone) {
        self.titleLab.text = @"旧手机号";
        self.textField.placeholder = @"请输入旧手机号";
    }
    else if(type == PhoneUpdateTypeName){
        self.titleLab.text = @"姓名";
        self.textField.placeholder = @"请输入您的姓名";
    }
    else if(type == PhoneUpdateTypeIdcard){
        self.titleLab.text = @"身份证号";
        self.textField.placeholder = @"请输入您的身份证号";
    }

}
#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.type == PhoneUpdateTypePhone) {
        return [textField filter:kPureNumFilter toString:string range:range maxLenght:11];
    }
    else if(self.type == PhoneUpdateTypeName){

    }
    else if(self.type == PhoneUpdateTypeIdcard){
        
        return [textField filter:kIDCardNumFilter toString:string range:range maxLenght:18];
    }
    
    return YES;
}

#pragma mark - noti -

- (void)textfieldValueChange:(id)sender{

    if(self.type == PhoneUpdateTypeName){
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
    
    if (self.inputBlock) {
        self.inputBlock(self.textField.text,self.type);
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    //过滤非汉字字符
    textField.text = [self filterCharactor:textField.text withRegex:kChineseFilter];
    
    if (textField.text.length >= kMaxNameLength) {
        textField.text = [textField.text substringToIndex:kMaxNameLength];
    }
    return NO;
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
