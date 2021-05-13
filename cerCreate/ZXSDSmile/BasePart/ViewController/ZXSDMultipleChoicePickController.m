//
//  ZXSDMultipleChoicePickController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDMultipleChoicePickController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ZXSDCityManager.h"

@interface ZXSDMultipleChoicePickController ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    UIView *_pickBackView;
    UIPickerView *_pickView;
    UILabel *_titleLabel;
    
    NSString *_pickProvinceString;
    NSString *_pickCityString;
    NSInteger _provinceIndex;
}

@end

@implementation ZXSDMultipleChoicePickController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addUserInterfaceConfigure];
    
    if (!IsValidArray(self.provinceArray)) {
        [self prepareDataConfigure];
    }

}

- (void)prepareDataConfigure {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@".json"];
    ZXSDCityManager *manager = [ZXSDCityManager sharedManager];
    self.provinceArray = [manager parsingDataWithPath:path];

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
    [cancelButton setTitleColor:UICOLOR_FROM_HEX(0x333333) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPickView:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [_pickBackView addSubview:cancelButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 80, 18, 160, 24)];
    _titleLabel.text = self.pickTitle;
    _titleLabel.textColor = UICOLOR_FROM_HEX(0x181C1F);
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_pickBackView addSubview:_titleLabel];
    
    UIButton *achieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    achieveButton.frame = CGRectMake(SCREEN_WIDTH() - 70, 18, 70, 24);
    [achieveButton setTitle:@"完成" forState:UIControlStateNormal];
    [achieveButton setTitleColor:UICOLOR_FROM_HEX(0x00B050) forState:UIControlStateNormal];
    [achieveButton addTarget:self action:@selector(dismissPickView:) forControlEvents:UIControlEventTouchUpInside];
    achieveButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
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
            if (![ZXSDPublicClassMethod emptyOrNull:self->_pickProvinceString] && ![ZXSDPublicClassMethod emptyOrNull:self->_pickCityString]) {
                self.pickAchieveString(self->_pickProvinceString, self->_pickCityString);
            } else {
                ZXSDCityModel *model = nil;
                if (!IsValidArray(self.provinceArray)) {
                    
                    return;
                }
                model = self.provinceArray.firstObject;
                
                NSString *city = @"";
                if (IsValidArray(model.cityArray)) {
                    city = model.cityArray.firstObject;
                }
                self.pickAchieveString(GetString(model.name),city);
            }
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - UIPickViewDelegate,UIPickViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSArray *cities = [self.provinceArray[rowProvince] cityArray];
        return cities.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return component == 0 ? SCREEN_WIDTH()/2 : SCREEN_WIDTH()/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray[row] name];
    } else {
        NSArray *cities = [self.provinceArray[_provinceIndex] cityArray];
        return cities[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger rowOne;
    if (component == 0) {
        _provinceIndex = [pickerView selectedRowInComponent:0];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        rowOne = 0;
    } else {
        rowOne = [pickerView selectedRowInComponent:1];
    }
    NSString *stringOne = [self.provinceArray[_provinceIndex] name];
    NSString *stringTwo = [self.provinceArray[_provinceIndex] cityArray][rowOne];
    _pickProvinceString = stringOne;
    _pickCityString = stringTwo;
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
