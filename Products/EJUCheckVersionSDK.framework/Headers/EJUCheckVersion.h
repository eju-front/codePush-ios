//
//  EJUCheckVersion.h
//  EJUCheckVersionSDK
//
//  Created by Dr_liu on 2016/11/25.
//  Copyright © 2016年 Dr_liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EJUCheckVersion : NSObject

+ (instancetype)sharedInstance;

/**
 检查app版本更新

 @param appleID app对应的appStore ID，指定哪个app检测请求
 */
- (void)checkVersion:(NSString *)appleID;

@end
