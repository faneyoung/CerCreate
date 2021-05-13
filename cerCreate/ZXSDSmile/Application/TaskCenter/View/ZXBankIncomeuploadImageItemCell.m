//
//  ZXBankIncomeuploadImageItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/23.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBankIncomeuploadImageItemCell.h"
#import <SDWebImage.h>

#import "UIButton+ExpandClickArea.h"

#import "ZXBankincomeUploadItemModel.h"


@interface ZXBankIncomeuploadImageItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong) ZXBankincomeUploadItemModel *item;


@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end

@implementation ZXBankIncomeuploadImageItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteBtn.hitTestEdgeInsets = UIEdgeInsetsMake(0, -20, -20, 0);
    ViewBorderRadius(self.imgView, 4, 0.5, TextColorgray);
    
}

#pragma mark - data -
- (void)updateViewWithModel:(ZXBankincomeUploadItemModel*)data{
    self.item = data;
    
    [self.imgView sd_setImageWithURL:data.imgUrl.URLByCheckCharacter placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    
    self.deleteBtn.hidden = !data.showDelete;
    self.titleLab.text = GetString(data.mouth);
}

- (IBAction)deleteBtnClicked:(id)sender{
    if (self.deleteBtnBlock) {
        self.deleteBtnBlock(self.item);
    }
}

@end
