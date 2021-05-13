//
//  ZXScoreUploadStepDes.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/4.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXScoreUploadStepDes.h"

@interface ZXScoreUploadStepDes ()

@property (nonatomic, strong) NSArray *attrTitles;
@property (nonatomic, strong) NSArray *modelImages;
@property (nonatomic, strong) NSArray *heights;


@end

@implementation ZXScoreUploadStepDes

- (NSArray *)heights{
    return @[
        @"170",
        @"170",
        @"470",
    ];
}

-(NSArray *)modelImages{
    
    NSArray *modelImages = @[
        @[@"icon_uploadStep_begin",@"icon_uploadStep_countdown"],
        @"icon_uploadStep_jumpWX",
        @"icon_uploadStep_scoreWX",
    ];
    
    if (self.desType == 0) {//ali
        modelImages = @[
            @[@"icon_uploadStep_begin",@"icon_uploadStep_countdown"],
            @"icon_uploadStep_jumpAli",
            @"icon_uploadStep_scoreAli",
        ];
    }
    
    return modelImages;
}

- (NSArray*)attrTitles{
    if (!_attrTitles) {
        NSString *step2Name = @"微信";
        NSString *step3Name = @"微信支付分";
        if (self.desType == 0) {
            step2Name = @"支付宝";
            step3Name = @"芝麻信用分";
        }
        
        NSString *step1 = @"1.点击\"开始直播\"，等待\"4秒\"倒计时";
        NSString *step2 = [NSString stringWithFormat:@"2.首次跳转需要授权\"同意\"跳转去\"%@\"，为避免超时请尽快同意",step2Name];
        NSString *step3 = [NSString stringWithFormat:@"3.系统自动跳转至\"%@\"，等待直至弹出\"录制结束提示\"，点击\"前往应用程序\"完成上传",step3Name];
        
        NSMutableAttributedString *attr1 = [self attributeStr:step1 keywords:@[@"\"开始直播\"",@"\"4秒\""]];
        NSMutableAttributedString *attr2 = [self attributeStr:step2 keywords:@[@"\"同意\"",step2Name]];
        NSMutableAttributedString *attr3 = [self attributeStr:step3 keywords:@[step2Name,@"\"录制结束提示\"",step3Name,@"\"前往应用程序\""]];


        NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:3];
        if (attr1) {
            [tmps addObject:attr1];
        }
        
        if (attr2) {
            [tmps addObject:attr2];
        }
        if (attr3) {
            [tmps addObject:attr3];
        }
        _attrTitles = tmps.copy;
    }
    
    return _attrTitles;
}

- (NSArray *)stepDesModels{
    if (!_stepDesModels) {
       __block NSMutableArray *modelItems = [NSMutableArray arrayWithCapacity:self.attrTitles.count];
        
        [self.attrTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZXScoreUploadStepDes *desModel = [[ZXScoreUploadStepDes alloc] init];
            desModel.attrTitle = obj;
            desModel.imgs = self.modelImages[idx];
            desModel.cellHeight = [self.heights[idx] floatValue];
            desModel.step = idx;
            [modelItems addObject:desModel];
        }];
        
        _stepDesModels = modelItems.copy;
    }
    return _stepDesModels;
}

#pragma mark - help methods -

- (NSMutableAttributedString*)attributeStr:(NSString*)str keywords:(NSArray*)keywords{
    if (!IsValidString(str)) {
        return nil;
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];

    if (!IsValidArray(keywords)) {
        return attr;
    }
    
    [keywords enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [attr setAttributes:
         @{
            NSFontAttributeName:FONT_PINGFANG_X(14),
            NSForegroundColorAttributeName:kThemeColorOrange
         } range:[str rangeOfString:obj]];
    }];

    return attr;
}

@end
