//
//  SKmoonFarmersViewController.m
//  ShopKeeper
//
//  Created by XNB2 on 16/11/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKmoonFarmersViewController.h"
#import "SKXWebView.h"


@interface SKmoonFarmersViewController () <SKXWebViewDelegate>


@end


static NSString *xnbBridge = @"xnbBridge";  //js字符串
@implementation SKmoonFarmersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"朔农";
    //状态栏
    [self preferredStatusBarStyle];
    
    
    //js调用oc返回通知监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getBack) name:WKScriptMessageDidChangedNotification object:nil];

    [self simpleExampleTest];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)simpleExampleTest {
  
SKXWebView *my = [[SKXWebView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    [my loadURLString:@"http://www.365sn.cn/Space/Index/xinnongbaobch"];
    my.delegate = self;
 
    [self.view addSubview:my];
}

#pragma  - mark SKXWebViewDelegate
- (void)zlcwebViewDidStartLoad:(SKXWebView *)webview
{
   // NSLog(@"页面开始加载");
}

- (void)zlcwebView:(SKXWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
       NSString *urlStr = URL.absoluteString;
    //如果点击了最外面的返回阿牛
    if ([urlStr isEqualToString:@"http://www.365sn.cn/Space/Index/undefined"]) {
        NSLog(@"%@--点击了最后的返回按钮",urlStr);
        //调用OC方法
        [self getBack];
    }else{
       // NSLog(@"%@--想加载其他请求",urlStr);
    }
    
    
}
- (void)zlcwebView:(SKXWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
   // NSLog(@"页面加载完成");
    
}

- (void)zlcwebView:(SKXWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
  //  NSLog(@"加载出现错误");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"加载错误!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self getBack];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}






#pragma  - mark back
- (void)getBack {  //返回app

   [self.navigationController popViewControllerAnimated:YES];

}



#pragma  - mark 状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WKScriptMessageDidChangedNotification object:nil];

}

@end
