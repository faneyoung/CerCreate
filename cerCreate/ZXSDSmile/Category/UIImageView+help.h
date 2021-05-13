//
//  UIImageView+help.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (help)

- (void)setImgWithUrl:(NSString*)url;

- (void)setImgWithUrl:(NSString*)url completed:(nullable void (^)(UIImage*))completedBlock;

@end

NS_ASSUME_NONNULL_END
