//
//  YJYZFXmlNode.h
//  YJYZFoundation
//
//  Created by fenghj on 15/9/17.
//  Copyright © 2015年 YJYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  XML节点
 */
@interface YJYZFXmlNode : NSObject

/**
 *  父级节点
 */
@property (nonatomic, weak) YJYZFXmlNode *parentNode;

/**
 *  节点名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  属性集合
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *attributes;

/**
 *  子节点
 */
@property (nonatomic, strong, readonly) NSMutableArray *children;

/**
 *  文本信息
 */
@property (nonatomic, copy) NSString *text;

/**
 *  获取节点的字典结构描述
 *
 *  @return 字典结构
 */
- (NSDictionary *)dictionaryValue;

@end
