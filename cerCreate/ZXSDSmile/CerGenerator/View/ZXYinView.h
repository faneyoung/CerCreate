//
//  ZXYinView.h
//  ZXSDSmile
//
//  Created by Fane on 2021/5/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

/**
 自定义圆形印章。size最小400*400
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXYinView : UIView

@property (nonatomic, strong) NSString *registUnit;


- (instancetype)instancetWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
