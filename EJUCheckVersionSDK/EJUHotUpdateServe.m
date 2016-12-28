//
//  EJUHotUpdateServe.m
//  EJUHotUpdateSDK
//
//  Created by Dr_liu on 2016/12/2.
//  Copyright © 2016年 Dr_liu. All rights reserved.
//

#import "EJUHotUpdateServe.h"
#import "EJUUpdateNet.h"
#import "ZipArchive.h"

#define KRootViewController  [[[UIApplication sharedApplication] keyWindow] rootViewController]

@interface EJUHotUpdateServe ()

@property (nonatomic, strong) EJUUpdateNet *net;
//@property (nonatomic, copy) NSString *appVersion;
//@property (nonatomic, copy) NSString *h5Version;
@property (nonatomic, copy) NSString *forceUpdate;  // false 0 ， true 1

@end

@implementation EJUHotUpdateServe

+ (instancetype)sharedInstance {
    static EJUHotUpdateServe *serve = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serve = [[EJUHotUpdateServe alloc] init];
    });
    return serve;
}

- (void)startServeWithHost:(NSString *)host
                  filePath:(NSString *)filePath
                   appName:(NSString *)appName
                 h5Version:(NSNumber *)h5Version {
    if (!appName) {
        appName = @"example";
    }
    
    [self setDefaultsObject:@"FirsEnter" forKey:@"firstInto"];
    
    self.net = [[EJUUpdateNet alloc] init];
    
    // 检查服务器的版本号
    [self checkVersionWithHost:host filePath:filePath appName:appName h5Version:h5Version successBlock:^(NSString *version) {
        
    }];
}

- (void)checkVersionWithHost:(NSString *)host filePath:(NSString *)filePath appName:(NSString *)appName h5Version:(NSNumber *)h5Version successBlock:(successBlock)success{
    
    // 获得当前app版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDic objectForKey:@"CFBundleVersion"];
    NSNumber *appVersion = @([version intValue]);
    
    // appVersion:也要变化，从本地的文件中取
    NSString *urlCheck = [NSString stringWithFormat:@"http://%@/app/checkVersion?appVersion=%@&h5Version=%d&appName=%@&os=ios", host, appVersion, [h5Version intValue], appName];
    // 检查服务器的版本号信息
    [self.net GETRequestWithUrl:urlCheck paramaters:nil successBlock:^(id object, NSURLResponse *response) {
        
        NSString *newVersion = object[@"data"][@"version"];
        NSNumber *newH5Version = @([newVersion intValue]);    // 服务器的版本号
        
        self.forceUpdate = object[@"data"][@"forceUpdate"];   // 记录是否要强制更新
        
            if (success) {
            success(newVersion);
        }
        
        NSLog(@"newH5Version = %@", newH5Version);
        
        [self downloadH5VersionWithHost:host filePath:filePath appName:appName h5Version:h5Version newH5:newH5Version];
        
    } failBlock:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

- (void)downloadH5VersionWithHost:(NSString *)host filePath:(NSString *)filePath appName:(NSString *)appName h5Version:(NSNumber *)h5Version newH5:(NSNumber *)newH5 {
    
        // 下载服务器最新版本
        NSString *urlDownload = [NSString stringWithFormat:@"http://%@/app/download?version=%d&appName=%@&os=ios&type=1", host, [newH5 intValue], appName];
        [_net GETRequestWithUrl:urlDownload paramaters:nil successBlock:^(id object, NSURLResponse *response) {
            // 存到本地，再替换到filePath
            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *zipPath = [caches stringByAppendingPathComponent:@"download.zip"];
            [object writeToFile:zipPath options:0 error:nil];
            
            
            NSString *unZipPath = [caches stringByAppendingPathComponent:@"download"];
            ZipArchive *zip = [[ZipArchive alloc] init];
            
            BOOL result;
            if ([zip UnzipOpenFile:zipPath]) {
                result = [zip UnzipFileTo:unZipPath overWrite:YES];   // 压缩包释放到的位置
                if (result) {
                    NSLog(@"zip解压成功");
                    NSFileManager *manager = [NSFileManager defaultManager];
                    
                    if ([self.forceUpdate intValue] == 1) { // 强制更新
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否立刻更新" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            //   [manager moveItemAtPath:unZipPath toPath:filePath error:nil];
                            
                        }];
                        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            // 替换文件
//                            [self setDefaultsObject:@"_newH5Version" forKey:@"h5Version"];
                            
                            [manager moveItemAtPath:unZipPath toPath:filePath error:nil];
                        }];
                        [alert addAction:action1];
                        [alert addAction:action2];
                        [KRootViewController presentViewController:alert animated:YES completion:nil];
                        
                    } else {
                        if ([self getDefaultsObjectForKey:@"firstInfo"]) {
                            // 不替换
                        } else {
                            // 不是第一次 则替换
                            
                            [manager moveItemAtPath:unZipPath toPath:filePath error:nil];
                        }
                    }
                }
                [zip UnzipCloseFile];
            }
            
        } failBlock:^(NSError *error) {
            
        }];
    
}

#pragma mark - NSUserDefaults
// 存值
- (void)setDefaultsObject:(id)obj forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 取值
- (id)getDefaultsObjectForKey:(NSString *)key {
   return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

@end
