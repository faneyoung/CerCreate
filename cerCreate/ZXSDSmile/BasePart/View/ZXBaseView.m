//
//  ZXBaseView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseView.h"

@implementation ZXBaseView


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
}

- (void)updateViewWithModel:(id)model{
    
}

@end
