//
//  ZXBankIncomeDesCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBankIncomeDesCell.h"

@implementation ZXBankIncomeDesItem

+ (NSArray*)desItemsWithTitle:(NSString*)title{
    
    NSArray *imgs = @[
        @"icon_task_upload_step1",
        @"icon_task_upload_step2",

    ];
    
    __block NSMutableArray *temps = [NSMutableArray arrayWithCapacity:imgs.count];
    [imgs enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXBankIncomeDesItem *item = [[ZXBankIncomeDesItem alloc] init];
        item.img = imgs[idx];
        if (idx == 0) {
            item.title = GetStrDefault(title, @"请登录工资卡尾号 -- 的--网银");
            item.des = @"获取您的收入明细截图等图片信息";
        }
        else if (idx == 1) {
            item.title = @"上传您近 3 个月的收入截图";
            item.des = @"请勿裁剪涂抹，以免影响您的审批结果";
        }
        
        [temps addObject:item];
    }];
    
    return temps.copy;
    
}

@end

@interface ZXBankIncomeDesCell ()
@property (weak, nonatomic) IBOutlet UIImageView *stepImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *sepLab;

@end

@implementation ZXBankIncomeDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - data -

- (void)updateWithData:(ZXBankIncomeDesItem*)model{
    self.stepImgView.image = UIImageNamed(model.img);
    self.titleLab.text = GetString(model.title);
    self.desLab.text = GetString(model.des);
}

- (void)setIsBottomItem:(BOOL)isBottomItem{
    _isBottomItem = isBottomItem;
    self.sepLab.hidden = isBottomItem;
    
}

@end
