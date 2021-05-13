//
//  ZXAppGroupManager.h
//  BroadcastNew
//
//  Created by Fane on 2021/2/20.
//  Copyright © 2021 Anirban. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//默认的app group
static NSString *const kZXDefaultAppGroupIdentifier = @"group.com.zxsd.smile.ios.app";

@interface ZXAppGroupManager : NSObject

///your  app groupId   < group.com.company.testname >
@property (nonatomic, copy) NSString *identifier;
///file path for app group
@property (nonatomic, strong) NSURL *url;


+ (instancetype)defaultManager;

/**
 *进程间通讯
 */

/// 发送passMessageObject通知
/// @param messageObject 传递的参数
/// @param type 业务类型
- (void)passMessageObject:(nullable id <NSCoding>)messageObject type:(nullable NSString *)type;

/// 接收通知方式 获取passMessageObject：的值
/// @param types 各种业务类型
/// @param notiBlock 收到通知回调
- (void)addListenerWithTypes:(NSArray*)types notifyBlock:(void(^)(NSString * _Nullable type,id _Nullable messageObject))notiBlock;


/// 主动方式 获取passMessageObject值
/// @param type 业务类型
/// @param key  值的key
- (id)dataWithType:(NSString*)type key:(NSString*)key;


/**
 *app group 文件存取
 */

#pragma mark - writeToFile方式 data/string/dic/array as file -
///是将字典转换成字符串存入Json文件
- (BOOL)writeDictionary:(NSDictionary*)dic fileName:(NSString*)filename;
- (BOOL)writeArray:(NSArray *)array fileName:(NSString *)filename;
- (BOOL)writeData:(NSData *)data fileName:(NSString *)filename;
///写入jsonStr字符串到Json文件中
- (BOOL)writeJson:(NSString*)jsonStr fileName:(NSString*)filename;

#pragma mark - NSFileManager方式 data write & read & delete -

///data写入文件中
- (BOOL)saveData:(NSData *)data toFile:(NSString *)filename;

///copy file from originPath to "(appgroup url)/filename"
- (BOOL)copyDataFromPath:(NSString *)originPath toFile:(NSString *)filename;

#pragma mark - read -

///read data (image,file...) from "(appgroup url)/filename"
- (NSData *)dataFromFile:(NSString *)filename;

///read json string from file that name is filename
- (NSString *)jsonFromFile:(NSString *)filename;
///as same as upon, just turn string to dictionary
- (NSDictionary *)dictionaryFromFile:(NSString *)filename;

#pragma mark - clear -

///delete File
- (BOOL)deleteFile:(NSString *)filename;

#pragma other
///judge file is exist;
- (BOOL)isExistFile:(NSString *)filename;

@end

NS_ASSUME_NONNULL_END
