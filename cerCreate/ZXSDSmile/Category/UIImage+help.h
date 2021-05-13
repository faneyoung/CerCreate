//
//  UIImage+help.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (help)

- (UIImage*)gradientImageWithColors:(NSArray*)colors direction:(UIImageGradientDirection)direc;
- (UIImage*)imageByResizeToSize:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
