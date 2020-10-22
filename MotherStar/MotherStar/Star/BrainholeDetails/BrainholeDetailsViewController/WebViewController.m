//
//  WebViewController.m
//  MotherStar
//
//  Created by yanming niu on 2020/1/13.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate, WKUIDelegate> {
    WKWebView *wkWebView;

}

@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWebView];
}

- (void)initWebView {
    wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-StatusAndNaviHeight)];
    [self.view addSubview:wkWebView];

    wkWebView.navigationDelegate = self;
    wkWebView.UIDelegate = self;
//    [wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [wkWebView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}

- (void)dealloc {
//    [wkWebView removeObserver:self forKeyPath:@"title"];
    wkWebView  = nil;
    wkWebView.UIDelegate = nil;
    wkWebView.navigationDelegate = nil;
}

@end
