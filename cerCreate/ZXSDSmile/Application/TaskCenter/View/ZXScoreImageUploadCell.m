//
//  ZXScoreImageUploadCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXScoreImageUploadCell.h"
#import "ZXScoreUploadModel.h"
#import "ZXTaskCenterModel.h"

@interface ZXScoreImageUploadCell ()
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *authBtn;
@property (weak, nonatomic) IBOutlet UILabel *scoreTitleLab;

@property (nonatomic, strong) ZXScoreUploadModel *uploadModel;

@end

@implementation ZXScoreImageUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXTaskCenterItem*)model{
    
}

- (void)updateViewWithData:(ZXScoreUploadModel*)data{
    self.uploadModel = data;
    
    [self.scoreBtn setImage:data.cameraImg forState:UIControlStateNormal];
    [self.authBtn setImage:data.authImg forState:UIControlStateNormal];
    
    self.scoreTitleLab.text = data.scoreTitle;
    
    
}

#pragma mark - action methods -

- (IBAction)scoreUploadBtnClicked:(UIButton *)sender {
    if(self.uploadBtnClickBlock){
        self.uploadBtnClickBlock(sender, self.uploadModel);
    }
}

- (IBAction)authUploadBtnClicked:(UIButton *)sender {
    if(self.uploadBtnClickBlock){
        self.uploadBtnClickBlock(sender, self.uploadModel);
    }
}



@end
