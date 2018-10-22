//
//  UIViewController+Extension.m
//  ShopKeeper
//
//  Created by XNB2 on 16/11/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)


- (void)pushWebViewWithURL:(NSString *)URL andTitle:(NSString *)title ishidesBottomBar:(BOOL )isBarHide {
    UIViewController *viewCon = [[UIViewController alloc] init];
   

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.f)];
    webView.backgroundColor = BACKGROUND_COLOR;
    [viewCon.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [webView loadRequest:request];
    
    //设置导航栏
    viewCon.title = title;
    //隐藏TabBar
   // self.hidesBottomBarWhenPushed = isBsarHide;
    viewCon.hidesBottomBarWhenPushed = isBarHide;
   [self.navigationController pushViewController:viewCon animated:YES];
  
 
}
@end
