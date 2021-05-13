//
//  ZXSDRadioPickController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDRadioPickController.h"

@interface ZXSDRadioPickController ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    UIView *_pickBackView;
    UILabel *_titleLabel;
    UIPickerView *_pickView;
    
    NSString *_pickDoneString;
}

@end

@implementation ZXSDRadioPickController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUserInterfaceConfigure];
}

- (void)addUserInterfaceConfigure {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissPickViewWithTap:)];
    [self.view addGestureRecognizer:tap];
    
    _pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT(), SCREEN_WIDTH(), 300)];
    _pickBackView.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_pickBackView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(16.0, 16.0)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
    cornerRadiusLayer.frame = _pickBackView.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    _pickBackView.layer.mask = cornerRadiusLayer;
    [self.view addSubview:_pickBackView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 18, 70, 24);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UICOLOR_FROM_HEX(0x626F8A) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPickView:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = FONT_PINGFANG_X(16);
    [_pickBackView addSubview:cancelButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 80, 18, 160, 24)];
    _titleLabel.text = self.pickTitle;
    _titleLabel.textColor = UICOLOR_FROM_HEX(0x3C465A);
    _titleLabel.font = FONT_PINGFANG_X(16);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_pickBackView addSubview:_titleLabel];
    
    UIButton *achieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    achieveButton.frame = CGRectMake(SCREEN_WIDTH() - 70, 18, 70, 24);
    [achieveButton setTitle:@"完成" forState:UIControlStateNormal];
    [achieveButton setTitleColor:kThemeColorMain forState:UIControlStateNormal];
    [achieveButton addTarget:self action:@selector(dismissPickView:) forControlEvents:UIControlEventTouchUpInside];
    achieveButton.titleLabel.font = FONT_PINGFANG_X(16);
    [_pickBackView addSubview:achieveButton];
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH(), 256)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.backgroundColor = [UIColor whiteColor];
    [_pickBackView addSubview:_pickView];
}

- (void)beginAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        self->_pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT() - 300, SCREEN_WIDTH(), 300);
    }];
    
    if (self.selectedValue.length > 0) {
        _selectedIndex = [self.pickArray indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *target = nil;
            if ([obj isKindOfClass:[NSNumber class]]) {
                target = [obj stringValue];
            } else if ([obj isKindOfClass:[NSString class]]) {
                target = obj;
            } else {
                *stop = YES;
                return NO;
            }
            if ([self.selectedValue isEqualToString:target]) {
                *stop = YES;
                return YES;
            }
            
            return NO;
        }];
    }
    
    if (self.pickArray.count > 0 ) {
        if (_selectedIndex >= 0 && _selectedIndex < self.pickArray.count) {
            [_pickView selectRow:_selectedIndex inComponent:0 animated:YES];
            [self pickerView:_pickView didSelectRow:_selectedIndex inComponent:0];
        }
    }
}

//点击取消退出
- (void)cancelPickView:(UIButton *)btn {
    [UIView animateWithDuration:0.2 animations:^{
        self->_pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT(), SCREEN_WIDTH(), 300);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

//点击空白退出
- (void)dissmissPickViewWithTap:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.2 animations:^{
        self->_pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT(), SCREEN_WIDTH(), 300);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

//点击完成退出
- (void)dismissPickView:(UIButton *)btn {
    [UIView animateWithDuration:0.2 animations:^{
        self->_pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT(), SCREEN_WIDTH(), 300);
    } completion:^(BOOL finished) {
        if (self.pickAchieveString) {
            if (![ZXSDPublicClassMethod emptyOrNull:self->_pickDoneString]) {
                self.pickAchieveString(self->_pickDoneString);
            } else {
                if (self.isSelectNumber) {
                    self.pickAchieveString([NSString stringWithFormat:@"%ld",[self->_pickArray[0] integerValue]]);
                } else {
                    self.pickAchieveString(self->_pickArray[0]);
                }
            }
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - UIPickViewDelegate,UIPickViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 240.f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.f;
}
/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.isSelectNumber) {
        return [NSString stringWithFormat:@"%ld",[_pickArray[row] integerValue]];
    } else {
        return _pickArray[row];
    }
}
*/

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *plain = nil;
    if (self.isSelectNumber) {
        plain =  [NSString stringWithFormat:@"%ld",[_pickArray[row] integerValue]];
    } else {
        plain = _pickArray[row];
    }
    UILabel *label = [UILabel labelWithText:plain textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.isSelectNumber) {
        _pickDoneString = [NSString stringWithFormat:@"%ld",[_pickArray[row] integerValue]];
    } else {
        _pickDoneString = _pickArray[row];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
