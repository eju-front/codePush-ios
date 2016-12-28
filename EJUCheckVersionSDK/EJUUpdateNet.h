//
//  EJUUpdateNet.h
//  EJUHotUpdateSDK
//
//  Created by Dr_liu on 2016/12/2.
//  Copyright © 2016年 Dr_liu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  请求成功后调用block
 *
 *  @param object   id object(如果是JSON,那么直接解析成OC中的数组或者字典.如果不是JSON,直接返回 NSData)
 *  @param response  响应头信息，主要是对服务器端的描述
 */
typedef void(^SuccessBlock)(id object, NSURLResponse *response);

/**
 *  请求失败后回调的block
 *
 *  @param error 错误信息
 */
typedef void(^FailBlock)(NSError *error);

@interface EJUUpdateNet : NSObject

/**
 GET请求

 @param urlString 请求链接
 @param paramaters 参数（可选）
 @param success 成功回调
 @param fail 失败回调
 */
- (void)GETRequestWithUrl:(NSString *)urlString
               paramaters:(NSMutableDictionary *)paramaters
             successBlock:(SuccessBlock)success
                failBlock:(FailBlock)fail;

@end
