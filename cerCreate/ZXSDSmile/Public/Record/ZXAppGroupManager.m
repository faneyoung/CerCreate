//
//  ZXAppGroupManager.m
//  BroadcastNew
//
//  Created by Fane on 2021/2/20.
//  Copyright © 2021 Anirban. All rights reserved.
//

#import "ZXAppGroupManager.h"

#import <MMWormhole.h>
#import <MMWormholeSession.h>

@interface ZXAppGroupManager ()

@property (nonatomic, strong) MMWormhole *wormhole;
@property (nonatomic, strong) MMWormholeSession *watchWormholeSession;

@end

@implementation ZXAppGroupManager

static ZXAppGroupManager *manager = nil;
+ (instancetype)defaultManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZXAppGroupManager alloc] initWithGroupIdentifier:kZXDefaultAppGroupIdentifier];
    });
    
    return manager;
}

- (instancetype)initWithGroupIdentifier:(NSString*)group{
    
    if (self = [super init]) {
        _identifier = group;
        _url = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:group];
        
        self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:self.identifier optionalDirectory:@"wormhole"];
        
    }
    return self;
}

- (void)addListenerWithTypes:(NSArray*)types notifyBlock:(void(^)(NSString * _Nullable type,id _Nullable messageObject))notiBlock{
    
    self.watchWormholeSession = [MMWormholeSession sharedListeningSession];

//    @weakify(self);
    [types enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        @strongify(self);
        [self.wormhole listenForMessageWithIdentifier:obj listener:^(id  _Nullable msgObject) {
            notiBlock(obj,msgObject);
        }];
    }];
    
    [self.watchWormholeSession activateSessionListening];
}

- (id)dataWithType:(NSString*)type key:(NSString*)key{
    id messageObject = [self.wormhole messageWithIdentifier:type];
    id res = [messageObject valueForKey:key];
    
    if (res) {
        return res;
    }

    return nil;
}

- (void)passMessageObject:(nullable id <NSCoding>)messageObject type:(nullable NSString *)type{
    if (!type || !messageObject) {
        return;
    }
    
    [self.wormhole passMessageObject:messageObject identifier:type];
}



#pragma mark - NSFileManager save&read -

- (BOOL)saveData:(NSData *)data toFile:(NSString *)filename{
    
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] createFileAtPath:[fileURL path] contents:data attributes:nil];
}

- (BOOL)copyDataFromPath:(NSString *)originPath toFile:(NSString *)filename{
    
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] copyItemAtPath:originPath toPath:[fileURL path] error:nil];
}

- (NSData *)dataFromFile:(NSString *)filename{
    
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] contentsAtPath:[fileURL path]];
}

- (BOOL)deleteFile:(NSString *)filename{
    
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] removeItemAtPath:[fileURL path] error:nil];
}

#pragma mark - write tofile save -

- (BOOL)writeDictionary:(NSDictionary*)dic fileName:(NSString*)filename{

    NSString *jsonStr = [self.class dictionaryToJson:dic];
    return [self writeJson:jsonStr fileName:filename];
}

- (BOOL)writeArray:(NSArray *)array fileName:(NSString *)filename{
    
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    return [array writeToURL:fileURL atomically:YES];
}

- (BOOL)writeData:(NSData *)data fileName:(NSString *)filename{
    
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    return [data writeToURL:fileURL atomically:YES];
}

- (BOOL)writeJson:(NSString*)jsonStr fileName:(NSString*)filename{
    
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    
    return [jsonStr writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}


#pragma mark - write tofile read -

- (NSString*)jsonFromFile:(NSString *)filename{
    
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    BOOL isExist = [[NSFileManager defaultManager] isExecutableFileAtPath:[fileURL path]];
    if (isExist) {
        NSString *str = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
        return  str;
    }
    
    //文件不存在
    return nil;
}

- (NSDictionary *)dictionaryFromFile:(NSString *)filename{
    
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    NSString *str = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    if (str) {
        return [ZXAppGroupManager dictionaryWithJsonString:str];
    }
    
    return nil;
}

#pragma mark - help methods -

- (BOOL)isExistFile:(NSString *)filename;
{
    NSURL *fileURL = [self.url URLByAppendingPathComponent:filename];
    NSString *path = [fileURL path];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return isExist;
}

#pragma mark private methods

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
