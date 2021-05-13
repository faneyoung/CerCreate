//
//  ZXSDDetectionHintCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDDetectionHintCell.h"

@interface ZXSDDetectionHintCell ()

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ZXSDDetectionHintCell

+ (CGFloat)height
{
    return iPhone4() || iPhone5() ? 117 : 140;
}

- (void)initView
{
    self.imageArray = @[@"smile_face_cert_two",@"smile_face_cert_three",@"smile_face_cert_four"];
    self.titleArray = @[@"正对手机",@"光线充足",@"不能遮挡"];
    
    CGFloat smallImageWidth = iPhone4() || iPhone5() ? 52 : 78;
    CGFloat smallImageHeight = iPhone4() || iPhone5() ? 47 : 70;

    CGFloat gapIntervel = (SCREEN_WIDTH() - 40 - smallImageWidth * 3)/2;
    
    for (NSInteger i = 0; i < _imageArray.count; i++) {
        UIImageView *imageView = [UIImageView new]; 
        CGFloat offset = 20 + (smallImageWidth + gapIntervel) * i;
        imageView.image = UIIMAGE_FROM_NAME(_imageArray[i]);
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(offset);
            make.top.equalTo(self.contentView).offset(20);
            make.width.mas_equalTo(smallImageWidth);
            make.height.mas_equalTo(smallImageHeight);
            
        }];
        
        UILabel *titleLabel = [UILabel labelWithText:_titleArray[i] textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
    }
    
}

@end
