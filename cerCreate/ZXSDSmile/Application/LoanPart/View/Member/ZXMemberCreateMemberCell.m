//
//  ZXMemberCreateMemberCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/2/25.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMemberCreateMemberCell.h"
#import "UUMarqueeView.h"
#import "ZXMemberUserInfo.h"

@interface ZXMemberCreateMemberCell () <UUMarqueeViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UUMarqueeView *marqueeView;

@property (nonatomic, strong) NSArray *notes;


@end

@implementation ZXMemberCreateMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.marqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(20, 18, SCREEN_WIDTH() - 2*20, 30.0f) direction:UUMarqueeViewDirectionUpward];
    _marqueeView.delegate = self;
    _marqueeView.timeIntervalPerScroll = 1.0f;
//    _marqueeView.timeDurationPerScroll = 0.5;
    _marqueeView.stopWhenLessData = YES;
    _marqueeView.scrollSpeed = 60.0f;
    _marqueeView.itemSpacing = 20.0f;
    [self.containerView addSubview:_marqueeView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewsWithData:(NSArray*)data{
    if (!IsValidArray(data)) {
        return;
    }
    
    self.notes = data;
    [self.marqueeView reloadData];

}

#pragma mark - UUMarqueeViewDelegate
- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    return 1;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
    return self.notes.count;
}


- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView {
    itemView.backgroundColor = UIColor.whiteColor;

    
    UILabel *lab = [[UILabel alloc] initWithFrame:itemView.bounds];
    lab.font = FONT_PINGFANG_X(13);
    lab.textColor = TextColorTitle;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.tag = 1001;
    [itemView addSubview:lab];
    
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    UILabel *lab = [itemView viewWithTag:1001];
    ZXMemberUserInfo *member = self.notes[index];
    
    NSString *str = [NSString stringWithFormat:@"%@  %@",member.userName,member.payStatus];
    lab.attributedText = [str attributeStrWithKeyword:member.payStatus textColor:UIColorFromHex(0x976C38) font:FONT_PINGFANG_X(13) defaultColor:TextColorTitle alignment:NSTextAlignmentLeft];

}

- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
//    UILabel *content = [[UILabel alloc] init];
//    content.numberOfLines = 0;
//    content.font = [UIFont systemFontOfSize:10.0f];
//    content.text = [_upwardDynamicHeightMarqueeViewData[index] objectForKey:@"content"];
//    CGSize contentFitSize = [content sizeThatFits:CGSizeMake(CGRectGetWidth(marqueeView.frame) - 5.0f - 16.0f - 5.0f, MAXFLOAT)];
//    return contentFitSize.height + 20.0f;
    return 30;
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
//    UILabel *lab = [marqueeView viewWithTag:1001];
//    ZXMemberUserInfo *member = self.notes[index];
//
//    lab.text = [NSString stringWithFormat:@"%@   %@",member.userName,member.payStatus];
//    return lab.intrinsicContentSize.width;  // icon width + label width (it's perfect to cache them all)
    
    return SCREEN_WIDTH()-20*2;
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
}


@end
