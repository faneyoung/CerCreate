//
//  ZXMemberOptionServiceCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/2/25.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMemberOptionServiceCell.h"

@interface ZXMemberOptionServiceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end

@implementation ZXMemberOptionServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewsWithData:(NSDictionary*)data{
    self.imageView.image = UIImageNamed([data stringObjectForKey:@"image"]);
    self.titleLab.text = [data stringObjectForKey:@"title"];
    self.desLab.text = [data stringObjectForKey:@"des"];
}



@end
