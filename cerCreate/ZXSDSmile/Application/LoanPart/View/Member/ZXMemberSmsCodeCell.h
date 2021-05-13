//
//  ZXMemberSmsCodeCell.h
//  ZXSDSmile
//
//  Created by Fane on 2020/11/30.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SMSCodeBlock)(NSString* code);

@interface ZXMemberSmsCodeCell : ZXBaseCell

@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) SMSCodeBlock codeBlock;
@property (nonatomic, assign) BOOL hideTitle;
@property (nonatomic, assign) BOOL hideSepLine;

@end

NS_ASSUME_NONNULL_END
