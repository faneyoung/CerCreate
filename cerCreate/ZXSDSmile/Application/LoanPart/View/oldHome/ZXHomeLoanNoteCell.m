//
//  ZXHomeLoanNoteCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeLoanNoteCell.h"
#import "UUMarqueeView.h"

@interface ZXHomeLoanNoteCell () <UUMarqueeViewDelegate>
@property (nonatomic, strong) NSArray *notes;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) UUMarqueeView *marqueeView;


@end

@implementation ZXHomeLoanNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.tag = 100000;
    self.titleLab.numberOfLines = 0;
    
    self.marqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(46, 18, SCREEN_WIDTH() - 50 - 46.0f, 20.0f) direction:UUMarqueeViewDirectionLeftward];
    _marqueeView.delegate = self;
    _marqueeView.timeIntervalPerScroll = 2.0f;
    _marqueeView.stopWhenLessData = YES;
    _marqueeView.scrollSpeed = 60.0f;
    _marqueeView.itemSpacing = 20.0f;
    [self.contentView addSubview:_marqueeView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - data  -

- (void)updateWithData:(NSString*)model{
    self.marqueeView.hidden = YES;
    self.titleLab.alpha = 1;
    self.titleLab.text = GetString(model);
}

- (void)updateViewsWithData:(NSArray*)data{
    self.marqueeView.hidden = NO;

    if (!IsValidArray(data)) {
        return;
    }
    
//    if (data.count < 2) {
//        NSString *msg = data.firstObject;
//
//        CGFloat maxWith = SCREEN_WIDTH()-50 - 46;
//        CGFloat width = [msg boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:0 attributes:@{NSFontAttributeName:FONT_PINGFANG_X(12)} context:nil].size.width;
//        if (width+10 < maxWith) {
//            [self updateWithData:data.firstObject];
//            return;
//        }
//    }
    
    self.titleLab.alpha = 0;
    
    self.notes = data;
    [self.marqueeView reloadData];

}

#pragma mark - action methods -

- (IBAction)cancelNoteBtnClicked:(id)sender {
    
    if (self.cancelNoteBlock) {
        self.cancelNoteBlock();
    }
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
    lab.font = FONT_PINGFANG_X(12);
    lab.textColor = TextColorTitle;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.tag = 1001;
    [itemView addSubview:lab];
    
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    UILabel *lab = [itemView viewWithTag:1001];
    lab.text = self.notes[index];
//    CGSize contentFitSize = [content sizeThatFits:CGSizeMake(CGRectGetWidth(itemView.bounds) - 5.0f - 16.0f - 5.0f, MAXFLOAT)];

}

- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
//    UILabel *content = [[UILabel alloc] init];
//    content.numberOfLines = 0;
//    content.font = [UIFont systemFontOfSize:10.0f];
//    content.text = [_upwardDynamicHeightMarqueeViewData[index] objectForKey:@"content"];
//    CGSize contentFitSize = [content sizeThatFits:CGSizeMake(CGRectGetWidth(marqueeView.frame) - 5.0f - 16.0f - 5.0f, MAXFLOAT)];
//    return contentFitSize.height + 20.0f;
    return 20;
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    UILabel *lab = [marqueeView viewWithTag:1001];
    lab.text = self.notes[index];
    return lab.intrinsicContentSize.width;  // icon width + label width (it's perfect to cache them all)
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
}


@end
