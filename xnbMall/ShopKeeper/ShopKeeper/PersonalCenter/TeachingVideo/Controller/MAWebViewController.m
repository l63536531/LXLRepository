/**
 * MAWebViewController.m 16/11/17
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAWebViewController.h"

@interface MAWebViewController (){
    
    UIWebView *_webView;
}

@end

@implementation MAWebViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_titleStr == nil) {
        _titleStr = @"视频教学";
    }
    [self setTitle:_titleStr];
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/**
 *  @author 黎国基, 16/11/17
 *
 *  初始化数据
 */
- (void)initData {
    
}

/**
 *  @author 黎国基, 16/11/17
 *
 *  创建UI界面
 */
- (void)createUI {
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}

#pragma mark - Touch events

#pragma mark - Custom tasks

#pragma mark - Http request

@end
