//
//  ZXAcountSecurityPhoneCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAcountSecurityPhoneCell.h"

@interface ZXAcountSecurityPhoneCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end

@implementation ZXAcountSecurityPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statusLab.text = @"已绑定";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(id)model{
    NSString *userName = [ZXSDCurrentUser currentUser].phone;
    if (userName.length == 11) {
        NSString *subStr = [NSString stringWithFormat:@"%@ **** %@",[userName substringWithnumber:3 reverse:NO],[userName substringWithnumber:4 reverse:YES]];

        self.titleLab.text = subStr;
    }
    else{
        self.titleLab.text = @"";
    }

}

- (void)setCanModify:(BOOL)canModify{
    _canModify = canModify;
//    self.statusLab.text = canModify ? @"已绑定":@"";
}

@end
