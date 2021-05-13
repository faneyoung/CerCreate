//
//  EPNetworkResponse.m
//  EPNetwork
//
//  Created by chrislos on 2017/3/20.
//  Copyright © 2017年 chrislos. All rights reserved.
//

#import "EPNetworkResponse.h"

@implementation ZXResultModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"code" : @[@"code",@"responseCode"],
        @"responseMsg" : @[@"responseMsg",@"message"],
    };
}

@end

@interface EPNetworkResponse()

@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, strong) id modelObject;
@property (nonatomic, strong) id originalContent;
@property (nonatomic, strong) NSString *errorMessage;

@end

@implementation EPNetworkResponse

- (instancetype)initWithErrorCode:(NSString *)code errorMessage:(NSString *)message
{
    if (self = [super init] ) {
        _errorCode = code;
        _errorMessage = message;
    }
    return self;
}

- (instancetype)initWithContent:(id)content
                       response:(NSURLResponse *)response
                     modelClass:(Class)modelClass
{
    if (self = [super init] ) {
        _originalContent = content;
        _response = response;
        
        if (content && [content isKindOfClass:[NSData class]]) {
            NSError *error;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:content
                                                         options:0
                                                           error:&error];
            if (jsonObj) {
                _originalContent = jsonObj;
            } else {
                NSLog(@"%@", error);
            }
        }
        /* 目前由于接口不规范，没有办法统一获取业务数据进行转换
        id parseContent = _originalContent;
        
        if ([parseContent isKindOfClass:[NSDictionary class]]) {
            _errorCode = [parseContent valueForKey:ZXSD_API_RESULT_CODE_KEY];
            
            if (_errorMessage == nil) {
                _errorMessage = [parseContent valueForKey:ZXSD_API_MESSAGE_KEY];
            }
            
            if (modelClass) {
                id data = [parseContent valueForKey:ZXSD_API_RESULT_KEY];
                NSError *error;
                
                if ([data isKindOfClass:[NSDictionary class]]) {
                    if ([(NSDictionary *)data allKeys].count > 0) {
                        _modelObject = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:data error:&error];
                    }

                } else if ([data isKindOfClass:[NSArray class]]) {
                    if ([(NSArray *)data count] > 0) {
                        _modelObject = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:data error:&error];
                    }
                    
                }
            } else {
                _modelObject = [parseContent valueForKey:ZXSD_API_RESULT_KEY];
            }
        }*/
    }
    return self;
}

- (ZXResultModel *)resultModel{
    if (!_resultModel) {
        _resultModel = [ZXResultModel instanceWithDictionary:self.originalContent];
    }
    return _resultModel;
}

@end
