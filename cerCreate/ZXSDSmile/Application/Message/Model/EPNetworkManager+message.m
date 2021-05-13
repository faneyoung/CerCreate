//
//  EPNetworkManager+message.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "EPNetworkManager+message.h"

@implementation EPNetworkManager (message)
- (void)requestMessageStatus:(void(^)(NSError *error, ZXMessageStatusModel *statusModel))completionBlock{
    [[EPNetworkManager defaultManager] getAPI:kPathMessageStatus parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_safe_async_main(^{
                completionBlock(error,nil);
            });

        } else {
            ZXMessageStatusModel *statusModel = [ZXMessageStatusModel instanceWithDictionary:response.originalContent];
            dispatch_safe_async_main(^{
                completionBlock(nil,statusModel);

            });
        }
    }];
}

@end
