//
//  SettingViewController.m
//  ShopKeeper
//
//  Created by zhough on 16/5/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"

#import "ChangePasswordCtrl.h"
#import "ForgetPasswordViewCtrl.h"
#import "MyRecommendedUserCtrl.h"
#import "AboutShopkeeperTableViewCtr.h"

#import "TransDataProxyCenter.h"
#import "ShareUnity.h"

#import "MAShoppingCartInfoHandler.h"

@interface SettingViewController () {
    UITableView * mianTableView;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设置"];
    [self.view setBackgroundColor:ColorFromRGB(230, 230, 230)];
    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
//                                                                             style:(UIBarButtonItemStylePlain)
//                                                                            target:nil
//                                                                            action:nil];
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    mianTableView.scrollEnabled = YES;
    mianTableView.bounces = NO;
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    [self maketabelfooterview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
   return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingTableViewCell *cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
    
    NSArray * imagearray = @[@"重置密码",@"变更手机",@"about",@"wodelan"];
    NSArray * titlearray =@[@"重置密码",@"变更手机号",@"关于新农宝商城"];
    
    NSString * titlestring =[titlearray objectAtIndex:indexPath.row];
    
    [cell update:[imagearray objectAtIndex:indexPath.row] title:titlestring];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.row) {
        case 0:
        {
            
            ForgetPasswordViewCtrl* forgetvc = [[ForgetPasswordViewCtrl alloc] init];
            forgetvc.title = @"重置密码";
            [self.navigationController pushViewController:forgetvc animated:YES];
        }
            break;
        case 1:
        {
            ChangePasswordCtrl* changevc = [[ChangePasswordCtrl alloc] init];
            [self.navigationController pushViewController:changevc animated:YES];
        }
            break;
       
        case 2:
        {
            AboutShopkeeperTableViewCtr *aboutvc = [[AboutShopkeeperTableViewCtr alloc] init];
            [self.navigationController pushViewController:aboutvc animated:YES];

        }
            break;
            
        default:
            break;
    }
    
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)maketabelfooterview{

    UIView* bgview = [[UIView alloc] init];
    [bgview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [bgview setBackgroundColor: [UIColor clearColor]];
    
    mianTableView.tableFooterView = bgview;
    
    UIColor *color = ColorFromHex(0xec584e);

     UIButton* loginout = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginout setBackgroundColor:color];
    [loginout setFrame:CGRectMake(20,30, SCREEN_WIDTH - 40, 30)];
    [loginout setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginout.layer setCornerRadius:5.];
    
    [loginout addTarget:self action:@selector(loginoutclick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:loginout];


}

-(void)loginoutclick:(id)sender{
    
    [MAShoppingCartInfoHandler clearVisitorGoodsState];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                             message:@"退出登录"  preferredStyle:UIAlertControllerStyleAlert];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MyUtile clearAllUserDefaultsData];

        {//原来请求成功才允许退出，但实际上，没有网络也不应该限制用户不能退出！_jack
            [ShareUnity removeTheUserInformation];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:DICKEY_LOGIN];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_PHONE];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_SHOPNAME];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:MALL_IS_LOGIN];//商城的登录判断
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [MyUtile delUserDataUiyp];
            
            UITabBarController *tabVC = self.navigationController.tabBarController;//必须在navigationVC pop之前获取，
            [tabVC setSelectedIndex:0];
            
            [self.navigationController popViewControllerAnimated:NO];//返回个人中心首页,_jack
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userReLogin" object:nil];
        }
        
        [JKURLSession taskWithMethod:@"login/logout.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            if (error == nil) {
                 NSLog(@"退出登录成功");
            }
        }];
    }]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
