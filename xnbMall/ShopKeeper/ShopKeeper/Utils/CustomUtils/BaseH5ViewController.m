//
//  BaseH5ViewController.m
//  groupVIP
//
//  Created by oracle on 16/1/6.
//  Copyright © 2016年 kinal guo. All rights reserved.
//

#import "BaseH5ViewController.h"

#define PROGRESS_VIEW_HEIGHT 2
@interface BaseH5ViewController ()

@end

@implementation BaseH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:[_dic objectForKey:@"name"]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    webViewHeight = self.view.frame.size.height;
    
    myWebView = [[UIWebView alloc]init];
    [myWebView setBackgroundColor:[UIColor whiteColor]];
    [myWebView setFrame:CGRectMake(0, 0, self.view.frame.size.width, webViewHeight)];
    myWebView.scrollView.scrollEnabled = YES;
    myWebView.scalesPageToFit = YES;
    myWebView.delegate = self;
    
    [self.view addSubview:myWebView];
    
    NSString* url = [_dic objectForKey:@"url"];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [myWebView loadRequest:request];
    }
    
    progressView = [[UIView alloc]init];
    [progressView setBackgroundColor:[UIColor greenColor]];
    [progressView setFrame:CGRectMake(0, 0, 0, PROGRESS_VIEW_HEIGHT)];
    [self.view addSubview:progressView];
    [self.view bringSubviewToFront:progressView];
    
    [UIView animateWithDuration:5 animations:^(void){
        //5秒钟，跑一半
        NSLog(@"progressView1");
        [progressView setFrame:CGRectMake(0, 0, self.view.frame.size.width/2.0, PROGRESS_VIEW_HEIGHT)];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:10 animations:^(void){
            //10秒钟，再跑1/4
            [progressView setFrame:CGRectMake(0, 0, self.view.frame.size.width * 3.0/4.0, PROGRESS_VIEW_HEIGHT)];
        } completion:^(BOOL finished){
            NSLog(@"progressView2");
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    myWebView.delegate = nil;
    [myWebView stopLoading];
}


#pragma mark UIWebViewDelete
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIView animateWithDuration:0.2 animations:^(void){
        [progressView setFrame:CGRectMake(0, 0, self.view.frame.size.width, PROGRESS_VIEW_HEIGHT)];
    }completion:^(BOOL finished){
        NSLog(@"removeFromSuperview");
        [progressView removeFromSuperview];
    }];
    
}

@end
