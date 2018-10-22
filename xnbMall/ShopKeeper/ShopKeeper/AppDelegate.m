//
//  AppDelegate.m
//  ShopKeeper
//
//  Created by zzheron on 16/5/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
//
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "UPPaymentControl.h"
#import "TransDataProxy2.h"
#import "LoginViewController.h"
#import "Utils.h"
#import "TransDataProxyCenter.h"
#import "WebViewController.h"
#import "JKURLSession.h"

#import <YJPaySDK/YJPaySDK.h>

@interface AppDelegate ()<UIScrollViewDelegate>{
    
    NSString * getDeviceToken;
    NSString * getclientId;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self umengTrack];

    [self initGeTui:launchOptions];
    
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:80  * 1024 * 1024 diskPath:nil];
    
    [NSURLCache setSharedURLCache:cache];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    

    [self handleNavigationBar];
    //向微信注册
    [WXApi registerApp:WXAppKey];
    
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];

    //    消息获取块
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSLog(@"第一  %@",remoteNotification);
    
    ViewController *mainView = [[ViewController alloc]init];

    [self.window setRootViewController:mainView];
    [self.window makeKeyAndVisible];

    NSDictionary *sysConfig = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [sysConfig objectForKey:@"CFBundleShortVersionString"];
    
    NSString *getversion = [[NSUserDefaults standardUserDefaults] valueForKey:@"LASTGUIDANCEVERSION"];
    
    if (getversion == nil || ![getversion isEqualToString:version]) {
        [self showScrollView];
    }
    
    return YES;
}

- (void)initGeTui:(NSDictionary *)launchOptions{
    NSLog(@"141414");
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册APNS
    //    *  @param isEnable 设置地理围栏功能是否运行（默认值：NO）
    //    *  @param isVerify 设置是否SDK主动弹出用户定位请求（默认值：NO）
    [GeTuiSdk lbsLocationEnable:NO andUserVerify:NO];
    [GeTuiSdk runBackgroundEnable:YES];
    // 处理远程通知启动 APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
    [self registerUserNotification];
}

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions) return;
    
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"\n>>>[Launching RemoteNotification]:%@",userInfo);
    }
}

- (void)handleNavigationBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
 
    UIColor *color =ColorFromHex(0xec584c);
    //全局设置导航栏title的字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    [[UINavigationBar appearance] setBackgroundImage:[Utils createImageWithColor:color] forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //易极付回调
    [YJPayService handleOpenURL:url srcApp:nil];
//    
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        
        return [TencentOAuth HandleOpenURL:url];
        
    }else{
    
        return  [WXApi handleOpenURL:url delegate:self];
    }
}

- (void)umengTrack {
    [MobClick setLogEnabled:NO];
    UMConfigInstance.appKey = @"58706650f43e487d6100033e";//新农宝key
    UMConfigInstance.secret = @"AnyString_XNB";
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [MobClick setAppVersion:version];
}
#pragma - mark 易极付支付回调

/**
 *  微信和银联回调
 */

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    
    
    NSLog(@"options = %@",annotation);
    [YJPayService handleOpenURL:url srcApp:sourceApplication];
    return YES;
}

- (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<NSString*, id>*)options {
    [YJPayService handleOpenURL:url srcApp:nil];
    NSLog(@"options = %@",options);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 用户通知(推送) _自定义方法

/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}
#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    getDeviceToken= token;

    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);

    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    getclientId= clientId;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kGtAppId forKey:@"appId"];//@"6Meej3qddt7FcflmeGXI12"
    [dic setValue:clientId forKey:@"clientId"];
    [dic setValue:@"0" forKey:@"appType"];//"APP类型：0表示新农宝商城，1表示农掌柜(店老板)，2表示店小二"
    [dic setValue:@"0" forKey:@"platform"];//"0表示IOS平台，1表示Android平台"
    [dic setValue:getDeviceToken forKey:@"deviceTokent"];
    
    [JKURLSession taskWithMethod:@"message/bind.do" parameter:dic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) { }];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    NSLog(@"remote notification test ----------------------3");
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    NSDictionary *content = nil;
    if (payloadData) {
        content = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        
        NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @"在线"];
        NSLog(@"\n>>>[12424GexinSdk ReceivePayload]:%@\n\n", msg);
        
        NSString *userid = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_NAME];
        
        NSLog(@"remote notification test ----------------------payload dic : %@",content);
        
        BOOL isMsgForThisUser = NO;
        if ([content[@"userid"] isEqualToString:userid]) {
            isMsgForThisUser = YES;
        }else{
            isMsgForThisUser = NO;
        }
        
        if (isMsgForThisUser) {
            
            NSString *msgid = content[@"content"];//消息id，用于上报通知接收状态
            [self read:msgid];
            
            if (offLine == YES) {//离线状态
                NSLog(@"离线状态");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GetuiNotificationOffLine" object:content];
            }else{//在线状态
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GetuiNotificationOnLine" object:content];
            }
        }
    }
}

-(void)read:(NSString*)msgid{

    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:msgid forKey:@"msgId"];
    [JKURLSession taskWithMethod:@"message/reportRead.do" parameter:dic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) { }];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    NSLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

#pragma mark -- 滑动滚动页面
-(void) showScrollView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.backgroundColor = RGBGRAY(240.f);
    
    //设置UIScrollView 的显示内容的尺寸，有n张图要显示，就设置 屏幕宽度*n ，这里假设要显示4张图
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width *2, [UIScreen mainScreen].bounds.size.height);
    
    scrollView.tag = 101;
    
    //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    CGFloat btnW = SCREEN_WIDTH * (251.f / 620.f);
    CGFloat btnH = SCREEN_HEIGHT * (70.f / 1062.f);
    
    CGFloat btnX = (SCREEN_WIDTH  - btnW) / 2.f;
    CGFloat btnY = SCREEN_HEIGHT * (967.f / 1062.f);
    //在UIScrollView 上加入 UIImageView
    for (int i = 0 ; i < 2; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        //将要加载的图片放入imageView 中
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"guidancePageImage%d",i+1]];
        imageView.image = image;
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;

        UIButton* guidanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        guidanceBtn.tag = i;
        guidanceBtn.frame = CGRectMake(btnX ,btnY,btnW, btnH);
        guidanceBtn.backgroundColor = [UIColor clearColor];
        [guidanceBtn addTarget:self action:@selector(guidanceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:guidanceBtn];
    }
    
    //初始化 UIPageControl 和 _scrollView 显示在 同一个页面中
    UIPageControl *pageConteol = [[UIPageControl alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 25, btnY - 60, 50, 40)];
    pageConteol.numberOfPages = 2;//设置pageConteol 的page 和 _scrollView 上的图片一样多
    pageConteol.tag = 201;
    
    [self.window addSubview:scrollView];
    //    //    放到最顶层;
    [self.window bringSubviewToFront:scrollView];
    
    [self.window addSubview:pageConteol];
    //    //    放到最顶层;
    [self.window bringSubviewToFront:pageConteol];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.window viewWithTag:201];
    page.currentPage = current;
}

#pragma mark -- 进入首页
-(void)guidanceBtn:(UIButton *)btn{
    
    if (btn.tag == 0) {
        UIScrollView *scrollView = (UIScrollView *)[self.window viewWithTag:101];
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0.f) animated:YES];
    }else if (btn.tag == 1) {
        [self scrollViewDisappear];
    }
}

-(void)scrollViewDisappear{
    NSDictionary *sysConfig = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [sysConfig objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"版本号为：%@", version);

    [[NSUserDefaults standardUserDefaults] setValue:version forKey:@"LASTGUIDANCEVERSION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //拿到 view 中的 UIScrollView 和 UIPageControl
    UIScrollView *scrollView = (UIScrollView *)[self.window viewWithTag:101];
    UIPageControl *page = (UIPageControl *)[self.window viewWithTag:201];

    [scrollView removeFromSuperview];
    [page removeFromSuperview];
}

@end
