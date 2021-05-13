//
//  ZXSDDetectionHeadCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDDetectionHeadCell.h"

@implementation ZXSDDetectionHeadCell

+ (CGFloat)height
{
    return iPhone4() || iPhone5() ? 223 : 304;;
}

- (void)initView
{
    CGFloat bigImageHeight = iPhone4() || iPhone5() ? 163 : 244;
    
    UIImageView *faceImageViewOne = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_face_cert_one")];
    [self.contentView addSubview:faceImageViewOne];
    [faceImageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(bigImageHeight);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
}

@end
