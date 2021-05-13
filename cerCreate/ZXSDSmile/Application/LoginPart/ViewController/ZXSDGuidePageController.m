//
//  ZXSDGuidePageController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDGuidePageController.h"

@interface ZXSDGuidePageController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *vScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIView *anchorView;

@end

@implementation ZXSDGuidePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHideNavigationBar = YES;
    [self addUserInterfaceConfigure];
}

- (void)addUserInterfaceConfigure
{
    [self.view addSubview:self.vScrollView];
    [self.vScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (@available(iOS 11.0, *)) {
        self.vScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSArray *images = @[@"guide_page_0",@"guide_page_1", @"guide_page_2"];
    NSArray *titles = @[@"预支工资，你有薪朋友",@"0 利息", @"500 免费，2000 最高"];

    for (NSInteger k = 0; k < images.count; k++) {
        UIView *guide = [self guideView:images[k] index:k title:titles[k]];
        [self.vScrollView addSubview:guide];
        guide.frame = CGRectMake(self.view.frame.size.width * k, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.vScrollView.contentSize = CGSizeMake(SCREEN_WIDTH() * images.count, SCREEN_HEIGHT());
    
    
    UIButton *btn = [UIButton buttonWithFont:FONT_PINGFANG_X(16) title:@"薪朋友登录" textColor:[UIColor whiteColor] cornerRadius:22];
    btn.backgroundColor = kThemeColorMain;
    [btn addTarget:self action:@selector(doLoginAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
        if (iPhoneXSeries()) {
            make.bottom.equalTo(self.view).offset(-55);
        } else {
            make.bottom.equalTo(self.view).offset(-21);
        }
    }];
    
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.anchorView.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
    }];
}

- (UIView *)guideView:(NSString *)imageName index:(NSInteger )index title:(NSString *)title
{
    UIView *guide = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGFloat offsetY = 120 * (SCREEN_HEIGHT()/812.0);
    if (iPhone4() || iPhone5() || iPhone6()) {
        offsetY -= 15;
    } 
    
    UIImageView *content = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [guide addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guide).offset(STATUSBAR_HEIGHT() + offsetY);
        //make.left.equalTo(guide).offset(20);
        //make.right.equalTo(guide).offset(-20);
        make.width.mas_equalTo(216.0 * (SCREEN_WIDTH()/375.0));
        make.height.mas_equalTo(content.mas_width).multipliedBy(1.0);
        
        //make.width.height.mas_equalTo(216);
        make.centerX.mas_equalTo(0);
    }];
    
    if (index == 0) {
        UILabel *descLabel = [UILabel labelWithText:@"预支工资，你有薪朋友" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X_Medium(24)];
        descLabel.textAlignment = NSTextAlignmentCenter;
        [guide addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(guide);
            make.top.equalTo(content.mas_bottom).offset(40 * (SCREEN_HEIGHT()/812.0));
        }];
    } else {
        UILabel *descLabel = [UILabel labelWithText:title textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X_Medium(24)];
        descLabel.textAlignment = NSTextAlignmentCenter;
        [guide addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(guide);
            //make.top.equalTo(content.mas_bottom).offset(10);
            make.top.equalTo(content.mas_bottom).offset(40 * (SCREEN_HEIGHT()/812.0));
            
            NSMutableAttributedString *attributedString = nil;
            NSDictionary *numberAttributes = @{
                NSForegroundColorAttributeName:kThemeColorMain,
                NSFontAttributeName:FONT_SFUI_X_Medium(24)
            };
            if (index == 2) {
                
                attributedString = [[NSMutableAttributedString alloc]initWithString:descLabel.text];
                [attributedString addAttributes:numberAttributes range:NSMakeRange(0, 3)];
                [attributedString addAttributes:numberAttributes range:NSMakeRange(7, 4)];
                
            } else {
                attributedString = [[NSMutableAttributedString alloc]initWithString:descLabel.text];
                [attributedString addAttributes:numberAttributes range:NSMakeRange(0, 1)];
            }
            
            descLabel.attributedText = attributedString;
            
        }];
        /*
        UIView *box = [self detailBox];
        [guide addSubview:box];
        [box mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(guide).offset(20);
            make.right.equalTo(guide).offset(-20);
            make.top.equalTo(descLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(33);
        }];*/
        
        self.anchorView = descLabel;
    }

    return guide;
}

- (UIView *)detailBox
{
    UIView *box = [UIView new];
    box.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR_FROM_HEX(0xE8E8E8);
    [box addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(box);
        make.width.mas_equalTo(.5);
        make.height.mas_equalTo(24);
    }];
    
    UILabel *leftLabel = [UILabel labelWithText:@"¥ 500 免费" textColor:kThemeColorMain font:FONT_PINGFANG_X_Medium(24)];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [box addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(box);
        make.right.equalTo(line.mas_left);
    }];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:leftLabel.text];
    [attributedString addAttributes: @{NSFontAttributeName:FONT_PINGFANG_X(16)} range: [leftLabel.text rangeOfString:@"¥"]];
    leftLabel.attributedText = attributedString;
    
    
    UILabel *rightLabel = [UILabel labelWithText:@"¥ 2000 最高" textColor:kThemeColorMain font:FONT_PINGFANG_X_Medium(24)];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    [box addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(box);
        make.left.equalTo(line.mas_right);
    }];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:rightLabel.text];
    [attributedString2 addAttributes: @{NSFontAttributeName:FONT_PINGFANG_X(16)} range: [rightLabel.text rangeOfString:@"¥"]];
    rightLabel.attributedText = attributedString2;
    
    return box;
}

- (void)doLoginAction
{
    if (self.jumpGuideBlock) {
        self.jumpGuideBlock();
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == self.vScrollView) {
        CGFloat past = scrollView.contentOffset.x - (scrollView.contentSize.width - SCREEN_WIDTH());
        
        if (past > SCREEN_WIDTH() * 0.1 && self.jumpGuideBlock) {
            //self.jumpGuideBlock();
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.vScrollView) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH();

        self.pageControl.currentPage = index;
    }
}


- (UIScrollView *)vScrollView {
    if (!_vScrollView) {
        _vScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _vScrollView.backgroundColor = [UIColor whiteColor];
        _vScrollView.delegate = self;
        _vScrollView.pagingEnabled = YES;
        _vScrollView.showsHorizontalScrollIndicator = NO;
        _vScrollView.bounces = YES;
    }
    return _vScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = UICOLOR_FROM_HEX(0xEAEFF2);
        _pageControl.currentPageIndicatorTintColor = kThemeColorMain;
    }
    return _pageControl;
}

@end
