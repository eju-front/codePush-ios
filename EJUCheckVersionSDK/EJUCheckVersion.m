//
//  EJUCheckVersion.m
//  EJUCheckVersionSDK
//
//  Created by Dr_liu on 2016/11/25.
//  Copyright © 2016年 Dr_liu. All rights reserved.
//

#import "EJUCheckVersion.h"
#import <UIKit/UIKit.h>

#define KItunesLookup @"http://itunes.apple.com/lookup?id="
#define KRootViewController [[[UIApplication sharedApplication] keyWindow] rootViewController]

@interface EJUCheckVersion ()

@property (nonatomic, copy) NSString *lastVersion;
@property (nonatomic, copy) NSString *trackViewUrl;

@end

@implementation EJUCheckVersion

+ (instancetype)sharedInstance {
    static EJUCheckVersion *checkVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checkVersion = [[EJUCheckVersion alloc] init];
    });
    return checkVersion;
}

- (void)checkVersion:(NSString *)appleID {
    // 获得当前app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", KItunesLookup, appleID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *infoArray = [jsonDic objectForKey:@"results"];
        
        if ([infoDictionary count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            // 获得最新版本
            _lastVersion = [releaseInfo objectForKey:@"version"];
            // 获得app在itunes的地址
            _trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
            
            if (![currentVersion isEqualToString:_lastVersion]) {
                
                UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"提 示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"立刻更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_trackViewUrl] options:nil completionHandler:^(BOOL success) {
                        
                    }];
                }];
                [alerController addAction:cancelAction];
                [alerController addAction:action];
                [KRootViewController presentViewController:alerController animated:YES completion:^{
                    
                }];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此版本为最新版本" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:alertAction];
                [KRootViewController presentViewController:alertController animated:YES completion:^{
                    
                }];
            }
        }
    }];
    [dataTask resume];
}

@end
