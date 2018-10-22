//
//  SKHtmlTabbarController.m
//  ShopKeeper
//
//  Created by XNB2 on 16/11/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKHtmlTabbarController.h"
//学农技
#import "SKTechniqueViewController.h"
//问答
#import "SKQanswerViewController.h"
//朔农
#import "SKmoonFarmersViewController.h"
#import "LoginViewController.h"




@interface SKHtmlTabbarController ()<UITabBarDelegate, UITabBarControllerDelegate> {
    NSInteger _selectedTabbarItemTag;
}

@end

@implementation SKHtmlTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setUpChildVc];

//    //覆盖原生Tabbar的上横线
//      [[UITabBar appearance] setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
//    //背景图片为透明色
//      [[UITabBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor clearColor]]];
    
   // self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //添加view在状态栏上
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = ColorFromHex(0xec584c);
    [self.view addSubview:topView];
    [topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(20);
    }];
    
    self.delegate = self;
}

-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
   [self.navigationController setNavigationBarHidden:NO animated:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





/**
 *  设置setUpChildVc的属性，添加所有的子控件
 */
- (void)setUpChildVc
{
    
    NSMutableDictionary *normalAtrrs = [NSMutableDictionary dictionary];
    // 文字颜色
    normalAtrrs[NSForegroundColorAttributeName] = TEXTCURRENT_COLOR;
    // UIControlStateSelected情况的文字属性
    NSMutableDictionary *selectedAtrrs = [NSMutableDictionary dictionary];
    // 文字颜色
    selectedAtrrs[NSForegroundColorAttributeName] = KColor(97.f,168.f,35.f) ;
    
    SKTechniqueViewController *vc1 = [[SKTechniqueViewController alloc] init];
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"学农技" image:[UIImage imageNamed:@"normal_tec"] selectedImage:[UIImage imageNamed:@"selec_tec"]];
    [vc1.tabBarItem setTitleTextAttributes:normalAtrrs forState:UIControlStateNormal];
    [vc1.tabBarItem setTitleTextAttributes:selectedAtrrs forState:UIControlStateSelected];
    vc1.tabBarItem.tag = 0;
    
    
    SKQanswerViewController *vc2 = [[SKQanswerViewController alloc] init];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"问答" image:[UIImage imageNamed:@"normal_ask"] selectedImage:[UIImage imageNamed:@"select_ask"]];
    [vc2.tabBarItem setTitleTextAttributes:normalAtrrs forState:UIControlStateNormal];
    [vc2.tabBarItem setTitleTextAttributes:selectedAtrrs forState:UIControlStateSelected];
     vc2.tabBarItem.tag = 1;
    
    SKmoonFarmersViewController *vc3 = [[SKmoonFarmersViewController alloc] init];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"朔农" image:[UIImage imageNamed:@"normal_farm"] selectedImage:[UIImage imageNamed:@"select_farm"]];
    [vc3.tabBarItem setTitleTextAttributes:normalAtrrs forState:UIControlStateNormal];
    [vc3.tabBarItem setTitleTextAttributes:selectedAtrrs forState:UIControlStateSelected];
     vc3.tabBarItem.tag = 2;
    
    [self setViewControllers:@[vc1,vc2,vc3]];
    
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0){
        //前提是先执行 didSelectItem,再执行此回调方法。
        if (_selectedTabbarItemTag == 1) {
            
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
    if (item.tag == 1) {
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

- (void)dealloc {

    NSLog(@"%s",__FUNCTION__);
}

@end
