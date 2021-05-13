//
//  ZXTaskCenterHeaderView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/18.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXTaskCenterHeaderView.h"

@interface ZXTaskCenterHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *statusLab;


@end

@implementation ZXTaskCenterHeaderView


+ (instancetype)instanceMineHeaderView{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
    ZXTaskCenterHeaderView *headerView = [[nib instantiateWithOwner:nil options:nil] firstObject];
    
    [headerView setupSubviews];
    

    return headerView;
    
}


- (void)setupSubviews{
    
    self.pictureImageView = [[UIImageView alloc] init];
    self.pictureImageView.image = UIImageNamed(@"icon_taskCenter_headerBg");
    
    
    self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    //剪裁超出父视图范围的子视图部分.这里就是裁剪了_pictureImageView超出_header范围的部分.
    self.pictureImageView.clipsToBounds = YES;
    
    [self insertSubview:self.pictureImageView atIndex:0];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
        make.width.mas_equalTo(SCREEN_WIDTH());
        make.height.mas_equalTo(96+kStatusBarHeight);
    }];

}



@end
