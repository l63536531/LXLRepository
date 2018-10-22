//
//  WebViewController.m
//  ShopKeeper
//
//  Created by zhough on 16/5/29.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>{
    
    MBProgressHUD* HUD;
}

@property (nonatomic,retain) UIWebView* websiteView;

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:_titleString];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect rect = CGRectMake(0,0.f, self.view.frame.size.width, self.view.frame.size.height  - 64);
    
    _websiteView = [[UIWebView alloc]initWithFrame:rect];
    _websiteView.delegate = self;
    _websiteView.alpha=0.85;
    [_websiteView setUserInteractionEnabled:YES];
    
    [_websiteView setBackgroundColor:[UIColor whiteColor]];
    
   
    [self.view addSubview:_websiteView];
    
    
    NSURL *url =[NSURL URLWithString:_url];
    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [_websiteView loadRequest:request];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"web view did start load");
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:_websiteView];
    [_websiteView addSubview:HUD];
    HUD.opacity = 0.1;
    [HUD showAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"web view did finish load");
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"web view load failed");
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

-(void)HUDaddviewtitle:(NSString*)HUDstring{
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
        
    }
    NSString *tet = HUDstring;
    MBProgressHUD*  HUDv = [MBProgressHUD showHUDAddedTo:_websiteView animated:YES];
    HUDv.delegate = self;
    HUDv.mode = MBProgressHUDModeText;
    HUDv.detailsLabelText = tet;
    HUDv.labelFont = [UIFont systemFontOfSize:15];
    HUDv.removeFromSuperViewOnHide = YES;
    [HUDv hide:YES afterDelay:2];
}

@end
