//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    
    NetResult_internet,// outData被设置为在线数据，是最新的
    NetResult_local,// outData被设置为离线数据，是本地存储的
    NetResult_null// outData未被设置，原因为在线离线数据均获取失败
    
} NetResult ;
typedef void  (^callBack)(NetResult  result,NSString *dataStr, BOOL fail_success);
typedef void  (^NetCallBack)(NetResult  result,NSDictionary *dicStr, BOOL fail_success);

@interface NetWorkManager : NSObject

+ (instancetype)shareManager;
- (void)netWWorkWithReq:(id)req PresentLogionController:(UIViewController *)logionVC Tooken:(NSString *)token CallBack:(callBack) callBack;




-(void)netWWorkWithReqUrl:(NSString*)reqUrl ReqParam:(NSDictionary*)reqParam BoolForTooken:(BOOL)tooken  PresentLogionController:(UIViewController *)logionVC CallBack:(NetCallBack)callBack;

@end
