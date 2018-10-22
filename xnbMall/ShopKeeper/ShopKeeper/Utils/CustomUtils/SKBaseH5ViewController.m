//
//  SKBaseH5ViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/9/9.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKBaseH5ViewController.h"
#import "MAGoodsDetailsViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIDragButton.h"
#import "FloatWindow.h"

#define PROGRESS_VIEW_HEIGHT 2
#define floatSize 45 //按钮的宽高

@protocol jsForOC <JSExport>
//xnbBridge.openItemView(goodsSpecId);
JSExportAs
(getback,
 - (void)jsCallNativeGoback:(NSNumber *)noPrameter
 );

JSExportAs
(openItemView,
 - (void)getGoodsInfoFromJs:(NSString *)goodsSpecId goodsID:(NSString*)goodsId
 );

@end

@interface SKBaseH5ViewController ()<UIWebViewDelegate, UIDragButtonDelegate, jsForOC>{
    
    JSContext *_jsContext;              //js context
    
    UIWebView* myWebView;
    CGFloat webViewHeight;
    
//    UIView* progressView;
    //悬浮窗口
    FloatWindow *_window;
    //悬浮按钮
    UIDragButton *_button;
}

@end

@implementation SKBaseH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    webViewHeight = self.view.frame.size.height;
    
    myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [myWebView setBackgroundColor:[UIColor whiteColor]];
    
    myWebView.scrollView.scrollEnabled = YES;
    myWebView.scalesPageToFit = YES;
    myWebView.delegate = self;
    
    [self.view addSubview:myWebView];
    
    JKView *statusBarMask = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 20.f)];
    statusBarMask.backgroundColor = THEMECOLOR;
    [myWebView addSubview:statusBarMask];
    
    NSString* urlStr = [_dic objectForKey:@"link"];
    
    if (![SERVER_ADDR_XNBMALL containsString:@"http://m.51xnb.cn"]) {
        urlStr =  [urlStr stringByReplacingOccurrencesOfString:@"http://m.51xnb.cn" withString:@"http://alpham.51xnb.cn"];
        
    }
    
    if (urlStr != nil) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [myWebView loadRequest:request];
    }
    
//    progressView = [[UIView alloc]init];
//    [progressView setBackgroundColor:[UIColor greenColor]];
//    [progressView setFrame:CGRectMake(0, 64, 0, PROGRESS_VIEW_HEIGHT)];
//    [self.view addSubview:progressView];
//    [self.view bringSubviewToFront:progressView];不要了，shit。web的导航栏根本不知道是多高，乱搞的，弄上去很难看._jack
    
//    [UIView animateWithDuration:5 animations:^(void){
//        //5秒钟，跑一半
//        NSLog(@"progressView1");
//        [progressView setFrame:CGRectMake(0, 0, self.view.frame.size.width/2.0, PROGRESS_VIEW_HEIGHT)];
//    } completion:^(BOOL finished){
//        [UIView animateWithDuration:10 animations:^(void){
//            //10秒钟，再跑1/4
//            [progressView setFrame:CGRectMake(0, 0, self.view.frame.size.width * 3.0/4.0, PROGRESS_VIEW_HEIGHT)];
//        } completion:^(BOOL finished){
//            NSLog(@"progressView2");
//        }];
//    }];
    
    if (_showFloatBtn) {  //通过外部设置是否显示悬浮返回按钮
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createButton];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_showFloatBtn) {
        // 关闭悬浮窗
        [_window resignKeyWindow];
        _window = nil;
        [_button removeFromSuperview];
    }
    [self.navigationController setNavigationBarHidden:NO];
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

/**
 *  创建悬浮窗口
 */
- (void)createButton {
    // 悬浮按钮
    _button = [UIDragButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, floatSize, floatSize);
    
    [_button setTitle:@"返回" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont fontWithName:@"Helvetica_Bold" size:14.f];
    [_button setTitleColor:RGBCOLOR(209.f,40.f,41.f) forState:UIControlStateNormal];
    _button.backgroundColor = RGBAGRAY(210.f, 0.5f);
    _button.clipsToBounds = YES;
    _button.layer.cornerRadius = floatSize / 2.f;
    _button.layer.borderColor = RGBGRAY(230.f).CGColor;
    _button.layer.borderWidth = 1.f;
    
    // 按钮点击事件
    [_button addTarget:self action:@selector(floatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 初始选中状态
    _button.selected = NO;
    // 禁止高亮
    _button.adjustsImageWhenHighlighted = NO;
    _button.rootView = self.view.superview;
    _button.btnDelegate = self;
    _button.imageView.alpha = 0.8;
    // 悬浮窗
    _window = [[FloatWindow alloc]init];  //初始化显示在右边中间位置
    _window.floatFrame = CGRectMake(SCREEN_WIDTH - floatSize, SCREEN_HEIGHT - floatSize - 100.f, floatSize, floatSize);
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor clearColor];
    _window.layer.cornerRadius = floatSize/2;
    _window.layer.masksToBounds = YES;
    // 将按钮添加到悬浮按钮上
    [_window addSubview:_button];
    //显示window
    [_window makeKeyAndVisible];
}

#pragma mark - Touch events
/**
 *  悬浮按钮点击
 */
- (void)floatBtnClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)dragButtonClicked:(UIButton *)sender {
    // 按钮选中关闭切换
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate
              
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [UIView animateWithDuration:0.2 animations:^(void){
//        [progressView setFrame:CGRectMake(0, 0, self.view.frame.size.width, PROGRESS_VIEW_HEIGHT)];
//    }completion:^(BOOL finished){
//        NSLog(@"removeFromSuperview");
//        [progressView removeFromSuperview];
//    }];
    
    _jsContext = [myWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _jsContext[@"xnbBridge"] = self;
    _jsContext[@"dianBridge"] = self;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAutoDissmissHud:@"数据加载失败"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

#pragma mark - JS Interactive

 - (void)jsCallNativeGoback:(NSNumber *)noPrameter {
    
     dispatch_async(dispatch_get_main_queue(), ^{
         [self.navigationController popViewControllerAnimated:YES];
     });
}

- (void)getGoodsInfoFromJs:(NSString *)goodsSpecId goodsID:(NSString*)goodsId {
    
    NSLog(@"openItemView:goodsSpecId = %@,goodsId = %@",goodsSpecId,goodsId);
    dispatch_async(dispatch_get_main_queue(), ^{
        MAGoodsDetailsViewController* vc = [[MAGoodsDetailsViewController alloc]init];
        vc.goodsSpecId = goodsSpecId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    });
}

@end
