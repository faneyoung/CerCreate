//
//  ZXExistNoteViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/12.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXExistNoteViewController.h"
#import "EPNetworkManager.h"

@interface ZXExistNoteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *oldPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@end

@implementation ZXExistNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - views -

- (void)setupSubViews{
    self.oldPhoneLab.text = [NSString stringWithFormat:@"原手机号: %@",[self.checkModel.oldPhone phoneNumSensitiveProcessing]];
    self.phoneLab.text = [NSString stringWithFormat:@"请确定使用宜信预留手机号 %@ 换原手机号并继续使用",[self.checkModel.phone phoneNumSensitiveProcessing]];
    
}

#pragma mark - data handle -

- (void)submitCompanyPhoneChange{
    if (!self.checkModel) {
        return;
    }
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.checkModel.oldPhone forKey:@"oldPhone"];
    [tmps setSafeValue:self.checkModel.phone forKey:@"newPhone"];

    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] postAPI:kPath_companyPhoneChangeSubmit parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();
        
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        NSDictionary *dic = (NSDictionary*)response.originalContent;
        BOOL success = [dic boolValueForKey:@"success"];
        NSString *msg = [dic stringObjectForKey:@"message"];

        if (success) {
            [self showToastWithText:msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];

                dispatch_queue_after_S(0.3, ^{
                    [ZXSDCurrentUser logout];
                });
            });
        }
        else{
            [self showToastWithText:msg];
        }
        
    }];
}

#pragma mark - action methods -

- (IBAction)rebindBtnClick:(id)sender {
    
    [self submitCompanyPhoneChange];
    
}


@end
