//
//  UserProtocolVC.m
//  ledong
//
//  Created by luojiao  on 16/3/24.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "UserProtocolVC.h"
#import "HttpClient.h"

@interface UserProtocolVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UserProtocolVC

- (void)viewDidLoad
{
    self.titleName = @"用户协议";
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_USERPROTOCOL_URL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView.opaque = NO;//webview加载黑条问题
    self.webView.scrollView.showsVerticalScrollIndicator = false;
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    HttpClient *httpShowMessage = [HttpClient shareHttpClient];
    [httpShowMessage showMessageHUD:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    HttpClient *httpShowMessage = [HttpClient shareHttpClient];
    [httpShowMessage hiddenMessageHUD];
}

@end
