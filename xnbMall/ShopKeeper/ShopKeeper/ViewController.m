//
//  ViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/3.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#import "UserCenterViewController.h"
#import "MsgCenterViewController.h"
#import "MAShoppingCartViewController.h"
#import "Utils.h"
#import "LoginViewController.h"
#import "NSString+Utils.h"
#import "UserInfo.h"

#import "MsgpushViewController.h"
#import "TransDataProxyCenter.h"
#import "MAMainViewController.h"
#import "UIColor+_6DataColor.h"

#import "JKURLSession.h"

@interface ViewController ()<UITabBarControllerDelegate,UITabBarDelegate>{
    
    NSInteger _selectedTabbarItemTag;
    
    NSTimer *timer;
    UINavigationController *c2;
    
}
@property(nonatomic) UserInfo *user;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor *clor = HEXCOLOR(0xEE2C2Cff);
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#646464"]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:clor} forState:UIControlStateSelected];
    self.tabBar.translucent = NO;
    
    self.delegate = self;
    
//    timer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userReLogin) name:@"userReLogin" object:nil];

//    AppDelegate* myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [myDelegate msseagestart];?????????
    [self MakeMainView];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"111viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"111viewDidAppear");

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    NSLog(@"111viewWillDisappear");
    
    [timer invalidate];
    timer = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    NSLog(@"111viewDidDisappear");
}

//去主页
-(void)MakeMainView{
        MAMainViewController *main=[[MAMainViewController alloc] init];
        UINavigationController *c1= [[UINavigationController alloc] initWithRootViewController:main];
        
        c1.navigationBar.barStyle = UIBarStyleBlackOpaque;
        c1.tabBarItem.title=@"首页";
        c1.tabBarItem.tag = 0;
        c1.tabBarItem.image=[[UIImage imageNamed:@"f-0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        c1.tabBarItem.selectedImage=[[UIImage imageNamed:@"f-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ;
        MsgCenterViewController *msg=[[MsgCenterViewController alloc] init];
        c2   = [[UINavigationController alloc] initWithRootViewController:msg];
        c2.navigationBar.barStyle = UIBarStyleBlackOpaque;
        c2.tabBarItem.title=@"消息";
        //c2.tabBarItem.badgeValue = @"2";
        c2.tabBarItem.tag = 1;
        
        c2.tabBarItem.image=[[UIImage imageNamed:@"f-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        c2.tabBarItem.selectedImage=[[UIImage imageNamed:@"f-5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ;
        MAShoppingCartViewController *shop=[[MAShoppingCartViewController alloc] init];
        UINavigationController *c3 = [[UINavigationController alloc] initWithRootViewController:shop];
        c3.navigationBar.barStyle = UIBarStyleBlackOpaque;
        c3.tabBarItem.title=@"购物车";
        c3.tabBarItem.tag = 2;
        
        c3.tabBarItem.image=[[UIImage imageNamed:@"f-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        c3.tabBarItem.selectedImage=[[UIImage imageNamed:@"f-6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ;
        UserCenterViewController *user=[[UserCenterViewController alloc] init];
        UINavigationController *c4 = [[UINavigationController alloc] initWithRootViewController:user];
        c4.navigationBar.barStyle = UIBarStyleBlackOpaque;
        c4.tabBarItem.title=@"个人中心";
        c4.tabBarItem.tag = 3;
        
        c4.tabBarItem.image=[[UIImage imageNamed:@"f-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        c4.tabBarItem.selectedImage=[[UIImage imageNamed:@"f-7"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.viewControllers = @[c1,c2,c3,c4];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) userReLogin{
    
    
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0){
        //前提是先执行 didSelectItem,再执行此回调方法。
        if (_selectedTabbarItemTag == 1||_selectedTabbarItemTag == 3) {
           
            return NO;
        }
        return YES;
    }else {
        return YES;
    }
}

#pragma mark - UITabBarDelegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    _selectedTabbarItemTag = item.tag;
    if (item.tag == 1||item.tag == 3) {
        NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
        
        NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
        if(isLoginStr == nil || isLoginStr.length == 0){
            //强制登录
            LoginViewController* vc = [[LoginViewController alloc]init];
            
            vc.loginResultBlock = ^(BOOL success){
                if(success) {
                    [self setSelectedIndex:_selectedTabbarItemTag];
                }
            };
            
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
            navi.navigationBar.translucent = NO;
            [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            [self presentViewController:navi animated:YES completion:nil];
        }
    }
}

@end
