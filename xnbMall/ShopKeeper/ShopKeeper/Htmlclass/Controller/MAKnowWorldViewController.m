/**
 * MAKnowWorldViewController.m 16/11/10
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAKnowWorldViewController.h"

#import "SKXWebView.h"
@interface MAKnowWorldViewController ()<SKXWebViewDelegate>


@end

@implementation MAKnowWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加view在状态栏上
    UIView *topView = [[UIView alloc] init];
    
    topView.backgroundColor = ColorFromHex(0xec584c);
    [self.view addSubview:topView];
    [topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(20);
    }];
    [self simpleExampleTest];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Http request
- (void)simpleExampleTest {
    
    SKXWebView *my = [[SKXWebView alloc]initWithFrame:CGRectMake(0.f, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    [my loadURLString:@"http://app.nongguanjia.com/wap/new.php?pcode=xinnongbao"];
     my.delegate = self;
    [self.view addSubview:my];
    
    //js调用oc返回通知监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getBack) name:WKScriptMessageDidChangedNotification object:nil];
    
}

#pragma  - mark SKXWebViewDelegate
- (void)zlcwebViewDidStartLoad:(SKXWebView *)webview
{
    // NSLog(@"页面开始加载");
}

- (void)zlcwebView:(SKXWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    
   // NSLog(@"截取到URL：%@",URL);
    
    
}
- (void)zlcwebView:(SKXWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    // NSLog(@"页面加载完成");
    
}

- (void)zlcwebView:(SKXWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
   // NSLog(@"加载出现错误");
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"加载错误!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
      [self getBack];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


#pragma mark - Touch events
- (void)getBack {  //返回
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)dealloc {
 
    //移除通知
[[NSNotificationCenter defaultCenter]removeObserver:self name:WKScriptMessageDidChangedNotification object:nil];


}

@end
