//
//  ZXSDActionSheet.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXSDActionSheetBlock)(NSInteger buttonIndex);

@interface ZXSDActionSheet : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) ZXSDActionSheetBlock actionSheetBlock;

/**
 *  type block
 *
 *  @param title                  title            (可以为空)
 *  @param actionSheetBlock       actionSheetBlock
 *  @param cancelButtonTitle      "取消"按钮         (默认有)
 *  @param destructiveButtonTitle "警示性"(红字)按钮  (可以为空)
 *  @param otherButtonTitles      otherButtonTitles
 */
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
             actionSheetBlock:(ZXSDActionSheetBlock) actionSheetBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
