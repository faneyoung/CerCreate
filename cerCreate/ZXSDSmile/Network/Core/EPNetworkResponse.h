//
//  EPNetworkResponse.h
//  EPNetwork
//
//  Created by chrislos on 2017/3/20.
//  Copyright © 2017年 chrislos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXBaseModel.h"

#define ZXSD_API_RESULT_KEY @"result"
#define ZXSD_API_RESULT_CODE_KEY @"code"
#define ZXSD_API_RESULT_SIGN_KEY @"sign"
#define ZXSD_API_MESSAGE_KEY @"message"

@interface ZXResultModel : ZXBaseModel
@property (nonatomic, assign) int code;
@property (nonatomic, strong) NSString *responseMsg;
@property (nonatomic, strong) id data;

///解析出的model
@property (nonatomic, strong) id deCls;
///解析出的models
@property (nonatomic, strong) NSArray *items;


@end

@interface EPNetworkResponse : NSObject

@property (nonatomic, strong) ZXResultModel *resultModel;

// http状态码
@property (nonatomic, strong, readonly) NSString *statusCode;

//业务错误状态码
@property (nonatomic, strong, readonly) NSString *errorCode;

// 解析后的业务数据（单个对象或者对象数组）
@property (nonatomic, strong, readonly) id modelObject;

// 返回的原始JSON数据
@property (nonatomic, strong, readonly) id originalContent;

// HTTP 's Response
@property (nonatomic, strong, readonly) NSURLResponse *response;

// 错误信息，根据状态码自定义消息
@property (nonatomic, strong, readonly) NSString *errorMessage;


- (instancetype)initWithErrorCode:(NSString *)code errorMessage:(NSString *)message;

- (instancetype)initWithContent:(id)content
                       response:(NSURLResponse *)response
                     modelClass:(Class)modelClass;

@end
