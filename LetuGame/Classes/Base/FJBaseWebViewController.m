//
//  FJBaseWebViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJBaseWebViewController.h"

@interface FJBaseWebViewController () <UIWebViewDelegate>

@property(nonatomic, strong)UIWebView *webView;

@end

@implementation FJBaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 构建webView
    UIWebView* webView = [[UIWebView alloc] init];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    // 根据传入的参数加载数据源
//    NSLog(@"self.urlString = %@", self.urlString);
//    NSLog(@"self.htmlString = %@", self.htmlString);
    if (self.urlString && ![self.urlString isEqualToString:@""]) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    } else if (self.htmlString && ![self.htmlString isEqualToString:@""]){
        [webView loadHTMLString:self.htmlString baseURL:nil];
    } else {
        DLog(@"webView没有数据源");
    }
    
    self.webView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // tableView 偏移20/64适配
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(iphoneX? 88 : 64, 0, 0, 0);
    self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [FJProgressHUB showWithMessage:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [FJProgressHUB dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [FJProgressHUB dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [FJProgressHUB dismiss];
}

- (void)dealloc
{
    DLog(@"---dealloc---");
}

@end
