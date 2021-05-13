//
//  YJYZFRSAKey.h
//  YJYZFoundation
//
//  Created by fenghj on 15/7/29.
//  Copyright (c) 2015年 YJYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YJYZFBigInteger;

@interface YJYZFRSAKey : NSObject

/**
 *  bits in key
 */
@property (nonatomic) int bits;

/**
 *  modulus
 */
@property (nonatomic, strong) YJYZFBigInteger *n;

/**
 *  public exponent
 */
@property (nonatomic, strong) YJYZFBigInteger *e;

/**
 *  private exponent
 */
@property (nonatomic, strong) YJYZFBigInteger *d;

@end
