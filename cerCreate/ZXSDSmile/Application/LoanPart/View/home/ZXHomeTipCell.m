//
//  ZXHomeTipCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeTipCell.h"

#import "UUMarqueeView.h"

@interface ZXHomeTipCell () <UUMarqueeViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *contentAniView;

@property (nonatomic, strong) UUMarqueeView *marqueeView;

@property (nonatomic, strong) NSArray *notes;

@end

@implementation ZXHomeTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewBorderRadius(self.containerView, 4, 0.1, kThemeColorBg);
    [self.shadowView homeCardShadowSetting];

    self.marqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectZero direction:UUMarqueeViewDirectionUpward];
    _marqueeView.delegate = self;
    _marqueeView.timeIntervalPerScroll = 1.0f;
//    _marqueeView.timeDurationPerScroll = 0.5;
    _marqueeView.stopWhenLessData = YES;
    _marqueeView.scrollSpeed = 60.0f;
    _marqueeView.itemSpacing = 20.0f;
    [self.contentAniView addSubview:_marqueeView];
    [self.marqueeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateWithData:(NSArray*)data{
    
    if (!IsValidArray(data)) {
        return;
    }
    
    __block NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:data.count];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (IsValidString(obj)) {
            [tmps addObject:obj];
        }
    }];
    self.notes = tmps.copy;
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
//    ZXMemberUserInfo *member = self.notes[index];
//
//    NSString *str = [NSString stringWithFormat:@"%@  %@",member.userName,member.payStatus];
//    lab.attributedText = [str attributeStrWithKeyword:member.payStatus textColor:UIColorFromHex(0x976C38) font:FONT_PINGFANG_X(13) defaultColor:TextColorTitle alignment:NSTextAlignmentLeft];
    lab.text = self.notes[index];

}

- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
//    UILabel *content = [[UILabel alloc] init];
//    content.numberOfLines = 0;
//    content.font = [UIFont systemFontOfSize:10.0f];
//    content.text = [_upwardDynamicHeightMarqueeViewData[index] objectForKey:@"content"];
//    CGSize contentFitSize = [content sizeThatFits:CGSizeMake(CGRectGetWidth(marqueeView.frame) - 5.0f - 16.0f - 5.0f, MAXFLOAT)];
//    return contentFitSize.height + 20.0f;
    return 44;
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
//    UILabel *lab = [marqueeView viewWithTag:1001];
//    ZXMemberUserInfo *member = self.notes[index];
//
//    lab.text = [NSString stringWithFormat:@"%@   %@",member.userName,member.payStatus];
//    return lab.intrinsicContentSize.width;  // icon width + label width (it's perfect to cache them all)
    
    return SCREEN_WIDTH() - 2*16 - 65 -30;
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
}


@end
