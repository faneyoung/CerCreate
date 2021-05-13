//
//  ZXMallTopBannerCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMallTopBannerCell.h"
#import "ZXBannerModel.h"

@interface ZXMallTopBannerCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBannerCSHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBannerCSHeight;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic, strong) ZXBannerModel *topBannerModel;
@property (nonatomic, strong) ZXBannerModel *leftBannerModel;
@property (nonatomic, strong) ZXBannerModel *rightBannerModel;


@end

@implementation ZXMallTopBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    

    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 16.0;

    CGFloat topBannerHeight = (SCREEN_WIDTH()-2*margin)*128/343;
    CGFloat leftBannerHeight = (SCREEN_WIDTH()-2*margin)*120/343;
    
    self.topBannerCSHeight.constant = topBannerHeight;
    self.leftBannerCSHeight.constant = leftBannerHeight;
    [self.contentView layoutIfNeeded];
    
}

#pragma mark - data -
- (void)updateWithData:(ZXHomeBannerModel*)model{
    
    if (model.list.count > 0) {
        self.topBannerModel = model.list.firstObject;
        
        if (model.list.count > 1) {
            self.leftBannerModel = model.list[1];
        }
        
        if(model.list.count > 2){
            self.rightBannerModel = model.list[2];
        }
    }
    
    [self.topImageView setImgWithUrl:self.topBannerModel.cover];
    [self.leftImageView setImgWithUrl:self.leftBannerModel.cover];
    [self.rightImageView setImgWithUrl:self.rightBannerModel.cover];

}

//- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes
//{
//    [self setNeedsLayout];
//    
//    [self layoutIfNeeded];
//    
//    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
//    
//    CGRect cellFrame = layoutAttributes.frame;
//    
//    cellFrame.size.height= size.height;
//    
//    layoutAttributes.frame= cellFrame;
//    
//    return layoutAttributes;
//    
//}

#pragma mark - action -

- (IBAction)senderimageViewAction:(UIButton*)sender {
    ZXBannerModel *banner = nil;
    if (sender.tag == 0) {
        banner = self.topBannerModel;
    }
    else if(sender.tag == 1){
        banner = self.leftBannerModel;
    }
    else if(sender.tag == 2){
        banner = self.rightBannerModel;
    }
    
    [URLRouter routerUrlWithBannerModel:banner extra:@{@"bannerAnaly":@(YES)}];

}
@end
