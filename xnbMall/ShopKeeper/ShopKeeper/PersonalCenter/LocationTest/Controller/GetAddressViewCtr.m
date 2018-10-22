//
//  GetAddressViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/3.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "GetAddressViewCtr.h"
#import "LocationManager.h"

#import "AFHTTPSessionManager+Util.h"
#import "TransDataProxyCenter.h"
#import "ShareWithFriendsView.h"
#import "AppDelegate.h"
#import "LocationView.h"

@interface GetAddressViewCtr (){

    ShareWithFriendsView* shareview;
    LocationView * lacationVC;
}
@end

@implementation GetAddressViewCtr
#pragma mark-懒加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    lab = [[UILabel alloc] init];
    [lab setFrame:CGRectMake(0, 160, SCREEN_WIDTH, 40)];
    [lab setBackgroundColor:[UIColor whiteColor]];
    [lab setText:@""];
    [lab setTextColor:[UIColor blackColor]];
    [self.view addSubview:lab];
    
    
    
    UIButton* btn =[[UIButton alloc] init];
    [btn setFrame:CGRectMake(100, 100, SCREEN_WIDTH/2, 40)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"定位" forState:UIControlStateNormal];
    
    [btn bk_addEventHandler:^(id sender) {
        
        
//            [[LocationManager sharedInstance] startUpdatingLocation];


//        [[TransDataProxyCenter shareController] login:nil passwd:nil block:^(NSDictionary *dic, NSError *error) {
//            NSNumber* code = dic[@"code"];
//            
//            if ([code intValue]  == 200) {
//                NSLog(@"成功");
//                
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSString* token =dic[@"data"][@"token"];
//                    NSLog(@"token:%@",token);
//                    NSString* userid =dic[@"data"][@"userid"];
//                    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:LOGIN_TOKEN object:token];
//                    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:LOGIN_NAME object:userid];
//                    
//
//                    
//                });
//                
//                
//            }
//
//            
//                  }];
        
        lacationVC = [[LocationView alloc] init];
        lacationVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        lacationVC.preferredContentSize = CGSizeMake(300, 300);
        lacationVC.popoverPresentationController.sourceView = self.navigationItem.titleView;//self.button;
        lacationVC.popoverPresentationController.sourceRect = self.navigationItem.titleView.bounds;
        
        UIPopoverPresentationController *pop = lacationVC.popoverPresentationController;
        pop.delegate = self;
        pop.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        [self presentViewController:lacationVC animated:YES completion:nil];
        
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    

    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(city_Action) name:@"city" object:nil];

    

    
    UIButton* btntwo =[[UIButton alloc] init];
    [btntwo setFrame:CGRectMake(100, 220, SCREEN_WIDTH/2, 40)];
    [btntwo setBackgroundColor:[UIColor redColor]];
    [btntwo setTitle:@"获取" forState:UIControlStateNormal];
    [btntwo bk_addEventHandler:^(id sender) {
        
        [lab setText:lacationVC.proNameStr];//[LocationManager sharedInstance].country
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
//        NSDictionary *postdata = @{@"barcode":barcode};
        NSString *surl =@"http://betam.51xnb.cn/api/login/logout.do";// [NSString stringWithFormat:@"%@/goods/queryClerkGoodsByBarcode.do",SERVER_ADDR];
//        NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
        
//        NSLog(@"token:%@",token)
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];//text/html;charset=utf-8
        

        
        
        [manager POST:surl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            //NSLog(@"uploadProgress %@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
            NSInteger code = [[retdata objectForKey:@"code"] integerValue];
            NSLog(@"retdata:%@",retdata);
            if(code == 200){
//                for(NSDictionary *dic in retdata[@"data"][@"list"]){
//                    NSMutableDictionary *mdic = [dic mutableCopy];
//                    [mdic setValue:@(0) forKey:@"amount"];
//                    NSLog(@"mdic : %@",mdic);
////                    [_data addObject:mdic];
//                }
//                if([retdata[@"data"][@"list"] count] > 0){
//                    
//                }else{
                    UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"成功！"];
                    [alertView bk_setCancelButtonWithTitle:@"确定" handler:nil];
                    [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
                        //[self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertView show];
//                }
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"没有搜索到相关的商品！"];
                [alertView bk_setCancelButtonWithTitle:@"确定" handler:nil];
                [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
                    //[self.navigationController popViewControllerAnimated:YES];
                }];
                [alertView show];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"商品请求 %@",error);
            UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"查询商品错误！"];
            [alertView bk_setCancelButtonWithTitle:@"确定" handler:nil];
            [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
            }];
            [alertView show];
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btntwo];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    shareview = [[ShareWithFriendsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [shareview setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
    [shareview createview];
    [appDelegate.window addSubview:shareview];
    UITapGestureRecognizer* singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1;
    singleFingerOne.numberOfTapsRequired = 1;
    singleFingerOne.delegate = self;
    [shareview addGestureRecognizer:singleFingerOne];
    
}
-(void)viewClickEvent:(UITapGestureRecognizer*)tap{

    
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
        [shareview setHidden:YES];

    }];

}
-(void)city_Action{
    NSLog(@"监控");

    [[LocationManager sharedInstance] addObserver:self forKeyPath:@"city" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:NULL];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    

    if([keyPath isEqualToString:@"city"])
        
    {
        
        NSLog(@"city");
        [lab setText:lacationVC.proNameStr];

    }
    
    
}

- (void)dealloc
{
    [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"city" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];

}





@end
