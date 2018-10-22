//
//  TransDataProxy2.h
//  MobileHall
//
//  Created by oracle on 16/2/22.
//  Copyright © 2016年 www.gzspark.net. All rights reserved.
//
/*
 旧的TransDataProxy使用NSURLConnection的同步方法sendSynchronousRequest在iOS9过期
 改用NSURLSession的block方法
 */


#import <Foundation/Foundation.h>

#define ERROR_DOMAIN_REQUEST @"ERROR_DOMAIN_REQUEST"
#define ERROR_DOMAIN_HTTP @"ERROR_DOMAIN_HTTP"
#define ERROR_DOMAIN_BUSINESS @"ERROR_DOMAIN_BUSINESS"
#define ERROR_DOMAIN_JSON @"ERROR_DOMAIN_JSON"

@interface TransDataProxy2 : NSObject

+ (TransDataProxy2*) shareController;

- (void) login:(NSString*)username passwd:(NSString*)passwd block:(void (^)(NSDictionary *dic, NSError *error))block;

- (void) logout:(void (^)(NSDictionary *dic, NSError *error))block;


- (void) getVertifyCode:(NSString*)phone type:(NSInteger)type block:(void (^)(NSDictionary *dic, NSError *error))block;

- (void) queryCardInfo:(NSString*)cardNum block:(void (^)(NSDictionary *dic, NSError *error))block;

- (void) queryCardInfo2:(NSString*)cardNum block:(void (^)(NSDictionary *dic, NSError *error))block;

- (void) openCard:(NSString*)cardNum name:(NSString*)name phone:(NSString*)phone IDNum:(NSString*)IDNum passwd:(NSString*)passwd block:(void (^)(NSDictionary *dic, NSError *error)) block;

- (void) createRechargeOrder:(NSString*)cardNum money:(NSString*)money  block:(void (^)(NSDictionary *dic, NSError *error)) block;

- (void) preABCPay:(NSString*)payid walletSharing:(NSString*)walletSharing  block:(void (^)(NSDictionary *dic, NSError *error)) block;

- (void) preWeiXinPay:(NSString*)tradeNum block:(void (^)(NSDictionary *dic, NSError *error)) block;

- (void) queryAccount:(void (^)(NSDictionary *, NSError *))block;

- (void) queryHotGoods:(void (^)(NSArray *, NSError *))block;

- (void) findPwd:(NSString*)phone code:(NSString*)code pwd:(NSString*)pwd block:(void (^)(NSDictionary *dic, NSError *error))block;

- (void) queryAdvert:(void (^)(NSArray *array, NSError *error))block;

- (void) checkMemberCardPwd:(NSString*)cardID pwd:(NSString*)pwd block:(void (^)(NSError *error))block;

- (void) queryName:(void (^)(NSDictionary *, NSError *))block;

- (void) removeGoods:(NSString*)goodsid block:(void (^)(NSError *))block;

@end