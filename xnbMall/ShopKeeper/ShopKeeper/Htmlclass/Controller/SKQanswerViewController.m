/**
 * SKBannerHtmlViewController.m 16/11/3
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "SKQanswerViewController.h"
#import "SKXWebView.h"



@interface SKQanswerViewController ()<SKXWebViewDelegate>


@property (nonatomic, strong)UIView *buttomBarView;

@property (nonatomic, strong)SKXWebView *my;
@end

@implementation SKQanswerViewController

#pragma mark - Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问答";
    //状态栏
    [self preferredStatusBarStyle];
  
    
   _my = [[SKXWebView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT  - 49)];
    _my.delegate = self;
    [self.view addSubview:_my];


    //初始化
    [self simpleExampleTest];
    
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


- (void)simpleExampleTest {
    
       //获取用户的id
    NSString* userid = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_NAME];
    NSLog(@"%@",userid);
    [_my loadURLString:[NSString stringWithFormat:@"http://app.nongguanjia.com/communication/callback.php?openid=%@",userid]];  //正式
    
    //js调用oc返回通知监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getBack) name:WKScriptMessageDidChangedNotification object:nil];
}

#pragma  - mark SKXWebViewDelegate
- (void)zlcwebViewDidStartLoad:(SKXWebView *)webview
{
    //NSLog(@"页面开始加载");
}

- (void)zlcwebView:(SKXWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
 
}
- (void)zlcwebView:(SKXWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    // NSLog(@"页面加载完成");
    
}


//加载错误返回
- (void)zlcwebView:(SKXWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"加载错误!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
       // [self getBack];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark - Touch events
- (void)getBack {  //返回
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Custom tasks
// 设置状态栏字体白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WKScriptMessageDidChangedNotification object:nil];
    
}

@end
