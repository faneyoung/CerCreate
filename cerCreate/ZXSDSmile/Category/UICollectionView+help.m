//
//  UICollectionView+help.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/14.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "UICollectionView+help.h"

@implementation UICollectionView (help)

#pragma mark - registe cells -
-(void)registerNibs:(NSArray *)nibArr
{
    [nibArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull nib, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerNib:[UINib nibWithNibName:nib bundle:nil] forCellWithReuseIdentifier:nib];
    }];

}
-(void)registerClasses:(NSArray *)classes
{
    [classes enumerateObjectsUsingBlock:^(NSString*  _Nonnull cls, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerClass:NSClassFromString(cls) forCellWithReuseIdentifier:cls];
    }];
}

@end
