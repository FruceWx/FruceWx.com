//
//  WebViewController.m
//  Day10_PodDemo
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@end

@implementation WebViewController
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view showHUD];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.view hideHUD];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.view showMsg:error.description];
}





- (instancetype)initWithURL:(NSURL *)webURL{
    if (self = [super init]) {
        self.webURL = webURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [UIWebView new];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    [_webView loadRequest:[NSURLRequest requestWithURL:_webURL]];
    self.navigationItem.title = self.webTitle;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)goback:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
