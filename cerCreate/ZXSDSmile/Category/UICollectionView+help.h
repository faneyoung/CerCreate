//
//  UICollectionView+help.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/14.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (help)
-(void)registerNibs:(NSArray *)nibArr;
-(void)registerClasses:(NSArray *)classes;

@end

NS_ASSUME_NONNULL_END
