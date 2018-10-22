//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "NetWorkManager.h"
#import "JSONModel.h"
#import "AFNetworking.h"
#import "AllModel.h"
#import "LoginViewController.h"
#import "ShareUnity.h"
@implementation NetWorkManager

{
    AFHTTPSessionManager *manager;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        manager =[AFHTTPSessionManager manager];
        manager.responseSerializer =[AFHTTPResponseSerializer  serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval =13;
    }
    return self;
}
+ (instancetype)shareManager
{
    static NetWorkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager==nil) {
            manager =[[NetWorkManager alloc] init];
        }
    });
    return manager;
    
}
-(void)netWWorkWithReq:(id)req PresentLogionController:(UIViewController *)logionVC Tooken:(NSString *)token CallBack:(callBack) callBack
{
    NSDictionary *param =[req toDictionary];
    
      NSData *temp = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
  
    NSString *reqStr = [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
    NSString *sss= [NSString stringWithFormat:@"%@", [req class ] ];
    
    NSArray *tempArr = [sss componentsSeparatedByString:@"_"];
   
    
    NSString *reqUrl =[NSString stringWithFormat:@"http://alpham.51xnb.cn/api/%@/%@",tempArr[1],[(NSString *)tempArr[2] stringByAppendingString:@".do"] ];
    NSLog(@"当前的路径为：%@当前的请求参数为：%@",reqUrl,reqStr);

    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:reqUrl  parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *jsonStr =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"当前的响应参数为：%@",jsonStr);
        Model_Rsp *model_Rsp =[[Model_Rsp alloc] initWithString:jsonStr error:nil];
        if(model_Rsp.code==401)
        {
            [ShareUnity removeTheUserInformation];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:DICKEY_LOGIN];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_PHONE];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_SHOPNAME];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
            
            [MyUtile delUserDataUiyp];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            LoginViewController *login =[[LoginViewController alloc]init];
//            login.forLogin =YES;
            UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:login];
            [logionVC presentViewController:nav animated:YES completion:nil];
        }

        callBack( NetResult_internet,jsonStr,YES);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callBack( NetResult_null,nil, NO);
        NSLog(@"当前的响应网络错误");
    }];

}

-(void)netWWorkWithReqUrl:(NSString*)reqUrl ReqParam:(NSDictionary*)reqParam BoolForTooken:(BOOL)tooken  PresentLogionController:(UIViewController *)logionVC CallBack:(NetCallBack)callBack{
     NSString *allUrl =[NSString stringWithFormat:@"%@/%@",SERVER_ADDR_XNBMALL,reqUrl];
    if (tooken==YES) {
       NSString *tooken = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
        [manager.requestSerializer setValue:tooken forHTTPHeaderField:@"x_token"];

    }
        
    [manager POST:allUrl parameters:reqParam progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        NSString *jsonStr =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"当前的响应参数为：%@",jsonStr);
        Model_Rsp *model_Rsp =[[Model_Rsp alloc] initWithString:jsonStr error:nil];
        if(model_Rsp.code==401)
        {
           
            [ShareUnity removeTheUserInformation];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:DICKEY_LOGIN];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_PHONE];
            [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_SHOPNAME];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [MyUtile delUserDataUiyp];
            
            LoginViewController *login =[[LoginViewController alloc]init];
//            login.forLogin =YES;
            UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:login];
            [logionVC presentViewController:nav animated:YES completion:nil];
            
        }
        
        callBack( NetResult_internet,dic,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                callBack( NetResult_null,nil,NO);
        NSLog(@"当前的响应网络错误");

    }];
    
    
    
}
@end
