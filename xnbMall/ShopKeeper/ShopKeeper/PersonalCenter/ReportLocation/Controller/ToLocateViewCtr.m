//
//  ToLocateViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/20.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ToLocateViewCtr.h"
#import "LocationManager.h"

#import "TransDataProxyCenter.h"
#import "ShareUnity.h"

@interface ToLocateViewCtr ()

@end

@implementation ToLocateViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
     UILabel * lab = [[UILabel alloc] init];
    [lab setFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 150)];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setFont:[UIFont systemFontOfSize:14]];
    [lab setText:@"请点击下方的“上报”按钮，确定上报\n\n1、上报您的服务网点定位后，您可以获得更多的顾客访问，更加精准地为周边的客户提供服务。\n\n2、建议您在手机“设置”中打开GPS定位功能，定位更加准确。"];
    [lab setTextColor:[UIColor grayColor]];
    [lab setAdjustsFontSizeToFitWidth:YES];
    [lab setNumberOfLines:0];
    [self.view addSubview:lab];

    UIButton* btn =[[UIButton alloc] init];
    [btn setFrame:CGRectMake(SCREEN_WIDTH/4, 200, SCREEN_WIDTH/2, 40)];
    [btn setBackgroundColor:ColorFromHex(0xec584e)];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn.layer setCornerRadius:5];
    
    [btn bk_addEventHandler:^(id sender) {
        
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil                                                                            message:@"您现在在您的店中吗？"  preferredStyle:UIAlertControllerStyleAlert];
        //添加Button
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"立即上报" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[LocationManager sharedInstance] startUpdatingLocation];
            
            
        }]];
        
        
      
        [alertController addAction: [UIAlertAction actionWithTitle: @"稍后再试" style: UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController: alertController animated: YES completion: nil];

        
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(city_Action) name:@"city" object:nil];
    
    
    
    
    [self setTitle:@"上报定位"];

    // Do any additional setup after loading the view.
}

-(void)city_Action{

  
 [[LocationManager sharedInstance] addObserver:self forKeyPath:@"city" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    
    if([keyPath isEqualToString:@"city"])
        
    {
        
        NSLog(@"89city");
        
//        [LocationManager sharedInstance].city
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"提交中..."];
        NSString * centerID = [ShareUnity serviceShopId];
        [[TransDataProxyCenter shareController] queryMylocation:centerID latitude:[LocationManager sharedInstance].latitude longitude:[LocationManager sharedInstance].longitude block:^(NSDictionary *dic, NSError *error) {
            
            NSNumber* code = dic[@"code"];
            NSString* msg = [error localizedDescription];
            if (dic) {
                
                
                if ([code intValue]  == 200) {
                    NSLog(@"成功");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [MyUtile showAlertViewByMsg:@"上报成功" vc:self];

                        
                    });
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD showWithStatus:msg];
                        
                        [SVProgressHUD dismissWithDelay:1];
                        
                    });
                    
                }
                
                
            }else{
                
                [SVProgressHUD showWithStatus:@"请检查网络"];
                
                [SVProgressHUD dismissWithDelay:1];
                
            }
            [SVProgressHUD dismiss];


        }];
        
        
        
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"city" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];

    // Dispose of any resources that can be recreated.
}


@end
