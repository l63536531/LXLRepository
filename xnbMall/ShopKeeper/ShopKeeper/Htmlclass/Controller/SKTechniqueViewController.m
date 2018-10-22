//
//  SKTechniqueViewController.m
//  ShopKeeper
//
//  Created by XNB2 on 16/11/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKTechniqueViewController.h"
#import "SKXWebView.h"

@interface SKTechniqueViewController ()<SKXWebViewDelegate>

@end

@implementation SKTechniqueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"学农技"];
    //初始化
    [self simpleExampleTest];
    
    //状态栏
    [self preferredStatusBarStyle];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)simpleExampleTest {
  
    SKXWebView *my = [[SKXWebView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    [my loadURLString:@"http://app.nongguanjia.com/wap/course/list.php?pcode=xinnongbao"];
    my.delegate = self;
  
    [self.view addSubview:my];
    
    //js调用oc返回通知监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getBack) name:WKScriptMessageDidChangedNotification object:nil];
}



#pragma  - mark SKXWebViewDelegate

- (void)zlcwebViewDidStartLoad:(SKXWebView *)webview
{
  //  NSLog(@"页面开始加载");
}

- (void)zlcwebView:(SKXWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
  
}
- (void)zlcwebView:(SKXWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
   // NSLog(@"页面加载完成");
    
}

- (void)zlcwebView:(SKXWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"加载错误!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self getBack];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)getBack {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  - mark 状态栏设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WKScriptMessageDidChangedNotification object:nil];
    
}

@end
