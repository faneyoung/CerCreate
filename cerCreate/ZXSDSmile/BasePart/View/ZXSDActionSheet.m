//
//  ZXSDActionSheet.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDActionSheet.h"

#define ZXSDTitleHeight 60.0f
#define ZXSDButtonHeight  49.0f
#define ZXSDDarkShadowViewAlpha 0.35f
#define ZXSDShowAnimateDuration 0.3f
#define ZXSDHideAnimateDuration 0.2f

@interface ZXSDActionSheet () {
    UIView *_buttonBackgroundView;
    UIView *_darkShadowView;
    
    NSString *_cancelButtonTitle;
    NSString *_destructiveButtonTitle;
    NSArray  *_otherButtonTitles;
}

@end

@implementation ZXSDActionSheet

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles actionSheetBlock:(ZXSDActionSheetBlock) actionSheetBlock {
    self = [super init];
    if(self) {
        self.title = title;
        _cancelButtonTitle = cancelButtonTitle.length > 0 ? cancelButtonTitle : @"取消";
        _destructiveButtonTitle = destructiveButtonTitle;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        if (_destructiveButtonTitle.length > 0) {
            [titleArray addObject:_destructiveButtonTitle];
        }
        [titleArray addObjectsFromArray:otherButtonTitles];
        _otherButtonTitles = [NSArray arrayWithArray:titleArray];
        self.actionSheetBlock = actionSheetBlock;
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT());
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    _darkShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT())];
    _darkShadowView.backgroundColor = RGBCOLOR(20, 20, 20);
    _darkShadowView.alpha = 0.0f;
    [self addSubview:_darkShadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    [_darkShadowView addGestureRecognizer:tap];
    
    _buttonBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _buttonBackgroundView.backgroundColor = RGBCOLOR(220, 220, 220);
    [self addSubview:_buttonBackgroundView];
    
    if (self.title.length > 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ZXSDButtonHeight - ZXSDTitleHeight, SCREEN_WIDTH(), ZXSDTitleHeight)];
        titleLabel.text = self.title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = RGBCOLOR(125, 125, 125);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [_buttonBackgroundView addSubview:titleLabel];
    }
    
    for (NSInteger i = 0; i < _otherButtonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:_otherButtonTitles[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0 && _destructiveButtonTitle.length > 0) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [button setBackgroundImage:[ZXSDPublicClassMethod initImageFromColor:RGBCOLOR(243, 243, 243) Size:self.frame.size] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonY = ZXSDButtonHeight * (i + (_title.length > 0 ? 1 : 0));
        button.frame = CGRectMake(0, buttonY, SCREEN_WIDTH(), ZXSDButtonHeight);
        [_buttonBackgroundView addSubview:button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = RGBCOLOR(210, 210, 210);
        line.frame = CGRectMake(0, buttonY, SCREEN_WIDTH(), 0.5);
        [_buttonBackgroundView addSubview:line];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = _otherButtonTitles.count;
    [cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[ZXSDPublicClassMethod initImageFromColor:RGBCOLOR(243, 243, 243) Size:self.frame.size] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat buttonY = ZXSDButtonHeight * (_otherButtonTitles.count + (_title.length > 0 ? 1 : 0)) + 5;
    if (iPhoneXSeries()) {
        cancelButton.frame = CGRectMake(0, buttonY, SCREEN_WIDTH(), 88.0);
        [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(-22, 0, 0, 0)];
    } else {
        cancelButton.frame = CGRectMake(0, buttonY, SCREEN_WIDTH(), ZXSDButtonHeight);
    }
    [_buttonBackgroundView addSubview:cancelButton];
    
    CGFloat height;
    if (iPhoneXSeries()) {
        height = ZXSDButtonHeight * (_otherButtonTitles.count + 1 + (_title.length > 0 ? 1 : 0)) + 44;
    } else {
        height = ZXSDButtonHeight * (_otherButtonTitles.count + 1 + (_title.length > 0 ? 1 : 0)) + 5;
    }
    _buttonBackgroundView.frame = CGRectMake(0, SCREEN_HEIGHT(), SCREEN_WIDTH(), height);
}

- (void)didClickButton:(UIButton *)button {
    if (self.actionSheetBlock) {
        self.actionSheetBlock(button.tag);
    }
    [self hide];
}

- (void)dismissView:(UITapGestureRecognizer *)tap {
    if (self.actionSheetBlock) {
        self.actionSheetBlock(_otherButtonTitles.count);
    }
    [self hide];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:ZXSDShowAnimateDuration animations:^{
        self->_darkShadowView.alpha = ZXSDDarkShadowViewAlpha;
        self->_buttonBackgroundView.transform = CGAffineTransformMakeTranslation(0, -self->_buttonBackgroundView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [UIView animateWithDuration:ZXSDHideAnimateDuration animations:^{
        self->_darkShadowView.alpha = 0;
        self->_buttonBackgroundView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
