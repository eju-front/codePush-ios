//
//  ViewController.m
//  EJUUpdate
//
//  Created by Dr_liu on 2016/12/30.
//  Copyright © 2016年 Dr_liu. All rights reserved.
//

#import "ViewController.h"
#import "EJUHotUpdateServe.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"checkUpdate";
    self.view.backgroundColor = [UIColor whiteColor];
    [self checkUpdate];
}

- (void)checkUpdate {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test2.html" ofType:nil];
    EJUHotUpdateServe *updateServe = [EJUHotUpdateServe sharedInstance];
    [updateServe startServeWithHost:@"172.29.32.215:10086"
                           filePath:filePath
                            appName:@"EJUUpdate"
                          h5Version:@1];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
