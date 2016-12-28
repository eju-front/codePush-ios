//
//  EJUUpdateNet.m
//  EJUHotUpdateSDK
//
//  Created by Dr_liu on 2016/12/2.
//  Copyright © 2016年 Dr_liu. All rights reserved.
//

#import "EJUUpdateNet.h"

@implementation EJUUpdateNet

- (void)GETRequestWithUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success failBlock:(FailBlock)fail {
    
    NSMutableString *mString = [[NSMutableString alloc] init];
    // 遍历参数字典,一一取出参数
    [paramaters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *paramKey   = key;
        NSString *paramValue = obj;
        [mString appendFormat:@"%@=%@", paramKey, paramValue];
    }];
    
    NSData *bodyData = [mString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    request.HTTPMethod = @"GET";
    request.HTTPBody   = bodyData;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && !error) {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            // 如果 obj 能解析，它是json，否则返回二进制数据
            if (!obj) {
                obj = data;
            }
            // 成功回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(obj, response);
                }
            });
        } else {
            // 失败回调
            if (fail) {
                fail(error);
            }
        }
    }];
    [task resume];
}


@end
