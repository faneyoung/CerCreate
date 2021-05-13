//
//  ZXMemberPayCardCell.h
//  ZXSDSmile
//
//  Created by Fane on 2020/11/30.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMemberPayCardCell : ZXBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@end

NS_ASSUME_NONNULL_END
