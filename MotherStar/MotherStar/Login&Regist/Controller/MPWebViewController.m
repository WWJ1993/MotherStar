//
//  MPWebViewController.m
//  MotherStar
//
//  Created by 王文杰 on 2020/1/8.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "MPWebViewController.h"
#import <WebKit/WebKit.h>
@interface MPWebViewController ()

@end

@implementation MPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gk_navigationItem.title = self.navigationItem.title;

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout=UIRectEdgeBottom;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.gk_navigationBar.mas_bottom);
    }];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
