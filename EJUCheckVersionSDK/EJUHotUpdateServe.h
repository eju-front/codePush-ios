//
//  EJUHotUpdateServe.h
//  EJUHotUpdateSDK
//
//  Created by Dr_liu on 2016/12/2.
//  Copyright © 2016年 Dr_liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(NSString *version);

@interface EJUHotUpdateServe : NSObject

+ (instancetype)sharedInstance;

/**
 启动更新服务

 @param host 要检查的服务器版本号的链接host（包括端口号） 例如：172.29.108.138:10086
 @param filePath H5 资源路径
 @param appName  app 名称
 */
- (void)startServeWithHost:(NSString *)host
                  filePath:(NSString *)filePath
                   appName:(NSString *)appName
                 h5Version:(NSNumber *)h5Version;


/**
 检查服务器端h5版本号
 */
- (void)checkVersionWithHost:(NSString *)host filePath:(NSString *)filePath appName:(NSString *)appName h5Version:(NSNumber *)h5Version successBlock:(successBlock)success;

@end
