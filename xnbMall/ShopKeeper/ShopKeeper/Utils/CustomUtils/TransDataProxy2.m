//
//  TransDataProxy2.m
//  MobileHall
//
//  Created by oracle on 16/2/22.
//  Copyright © 2016年 www.gzspark.net. All rights reserved.
//

#import "TransDataProxy2.h"

//#define SERVER_URL @"http://betam.51xnb.cn/clerk/"
//#define SERVER_URL @"http://m.51xnb.cn/clerk/"

@implementation TransDataProxy2

static TransDataProxy2* shareController = nil;

+(TransDataProxy2*) shareController{
    if(shareController == nil){
        shareController = [[TransDataProxy2 alloc]init];
    }
    return shareController;
}

-(id)init{
    self = [super init];
    if(!self){
        return self;
    }
    
    return self;
}

- (NSMutableURLRequest*) getRequest:(NSString*)urlStr{
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",SERVER_ADDR,urlStr]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_ADDR,urlStr]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];//请求头
    return request;
}

- (NSData*) getHttpBodyData:(NSDictionary*)param{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];//将JSONObject的实例转成NSData
    if (error) {
        NSLog(@"dic->%@",error);
        return nil;
    }
    
    NSString* jsonText = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"request: %@",jsonText);
    
    return jsonData;
}

- (NSError*) createError:(NSString*)domain code:(NSInteger)code desc:(NSString*)desc{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if(desc == nil){
        desc = @"";
    }
    [dic setObject:desc forKey:NSLocalizedDescriptionKey];
    NSError* error = [[NSError alloc]initWithDomain:domain code:code userInfo:dic];
    return error;
}

- (void) queryData:(NSMutableURLRequest*)request bodyData:(NSData*)bodyData block:(void (^)(NSDictionary *dic, NSError *error))block{
    [request setHTTPBody:bodyData];
    
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [request setValue:token forHTTPHeaderField:@"x_token"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//数据转为nsstring型
        NSLog(@"response: %@",result);
        
        if (error != nil) {
            block(nil,[self createError:ERROR_DOMAIN_REQUEST code:error.code desc:error.localizedDescription]);
            return ;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
        NSLog(@"request response: %ld",statusCode);
        if (statusCode != 200) {
            block(nil,[self createError:ERROR_DOMAIN_HTTP code:statusCode desc:@"无法连接服务器"]);
            return;
        }
        
        if (result == nil) {
            block(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-999 desc:@"无数据"]);
            return ;
        }
        
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError* jsonError = nil;
        NSDictionary* dicResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];//将NSData类型的实例转成JSONObject，使用缓冲区数据来解析
        if (dicResult == nil) {
            block(nil,[self createError:ERROR_DOMAIN_JSON code:-2 desc:@"错误：返回的数据格式不是json格式"]);
            return;
        }
        
        block(dicResult,nil);
        
    }] resume];
    
}

- (void) queryDic:(NSMutableURLRequest*)request bodyData:(NSData*)bodyData block:(void (^)(NSDictionary *dic, NSError *error))block{
    [self queryData:request bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        NSNumber* code = [dic objectForKey:@"code"];
        NSString* message = [dic objectForKey:@"msg"];
        if (code == nil ) {
            block(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-998 desc:@"not return data"]);
            return;
        }
        
        if ([code integerValue] == 200) {
            NSDictionary* dicData = [dic objectForKey:@"data"];
            block(dicData,nil);
            return;
        }else{
            block(nil,[self createError:ERROR_DOMAIN_BUSINESS code:[code integerValue] desc:message]);
            return;
        }
    }];
}

- (void) queryArray:(NSMutableURLRequest*)request bodyData:(NSData*)bodyData block:(void (^)(NSArray *array, NSError *error))block{
    [self queryData:request bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        NSNumber* code = [dic objectForKey:@"code"];
        NSString* message = [dic objectForKey:@"msg"];
        if (code == nil ) {
            block(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-998 desc:@"not return data"]);
            return;
        }
        
        if ([code integerValue] == 200) {
            NSArray* array = [dic objectForKey:@"data"];
            block(array,nil);
            return;
        }else{
            block(nil,[self createError:ERROR_DOMAIN_BUSINESS code:[code integerValue] desc:message]);
            return;
        }
    }];
}


- (void) queryForText:(NSMutableURLRequest*)request bodyData:(NSData*)bodyData block:(void (^)(NSString* text, NSError *error))block{
    [request setHTTPBody:bodyData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//数据转为nsstring型
        NSLog(@"response: %@",result);
        
        block(result,nil);
    }] resume];
    
}

//-----------------------------------------------------------------------------------------------------------------

- (void) queryCardInfo:(NSString*)cardNum block:(void (^)(NSDictionary *dic, NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cardNum forKey:@"card_id"];
    
    [self queryDic:[self getRequest:@"member/checkCardStatus.do"] bodyData:[self getHttpBodyData:dic] block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

- (void) queryCardInfo2:(NSString*)cardNum block:(void (^)(NSDictionary *dic, NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cardNum forKey:@"card_id"];
    
    [self queryDic:[self getRequest:@"member/getCardInfo.do"] bodyData:[self getHttpBodyData:dic] block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}


- (void) login:(NSString*)username passwd:(NSString*)passwd block:(void (^)(NSDictionary *dic, NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:username forKey:@"username"];
    [dic setValue:passwd forKey:@"password"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"login/login.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        if (dic == nil) {
            block(nil,error);
            return;
        }
        block(dic ,error);
    }];
}

- (void) logout:(void (^)(NSDictionary *dic, NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"login/logout.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        if (dic == nil) {
            block(nil,error);
            return;
        }
        block(dic ,error);
    }];
}

- (void) getVertifyCode:(NSString*)phone type:(NSInteger)type block:(void (^)(NSDictionary *dic, NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:[NSNumber numberWithInteger:type] forKey:@"verifyCodeType"];
    [dic setValue:[NSString stringWithFormat:@"%d",(int)type] forKey:@"verifyCodeType"];
    [dic setValue:phone forKey:@"phoneNumber"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"login/getVerifyCode.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        if (dic == nil) {
            block(nil,error);
            return;
        }
        block(dic ,error);
    }];
}

- (void) openCard:(NSString*)cardNum name:(NSString*)name phone:(NSString*)phone IDNum:(NSString*)IDNum passwd:(NSString*)passwd block:(void (^)(NSDictionary *dic, NSError *error)) block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cardNum forKey:@"card_id"];
    [dic setValue:name forKey:@"card_name"];
    [dic setValue:phone forKey:@"card_mobile"];
    [dic setValue:IDNum forKey:@"card_idcard"];
    [dic setValue:passwd forKey:@"card_password"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"member/membercardActivate.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
}

- (void) createRechargeOrder:(NSString*)cardNum money:(NSString*)money  block:(void (^)(NSDictionary *dic, NSError *error)) block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cardNum forKey:@"card_id"];
#ifdef PAY_DEBUG
    [dic setValue:@"0.01" forKey:@"amount"];
#else
    [dic setValue:money forKey:@"amount"];
#endif
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"member/recharge.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];    
}

- (void) preABCPay:(NSString*)payid walletSharing:(NSString*)walletSharing  block:(void (^)(NSDictionary *dic, NSError *error)) block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:payid forKey:@"payId"];
    [dic setValue:walletSharing forKey:@"walletSharing"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"payment/prepareNonghangWAPPay.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

- (void) preWeiXinPay:(NSString*)tradeNum block:(void (^)(NSDictionary *dic, NSError *error)) block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:tradeNum forKey:@"payCode"];
    [dic setValue:@"10" forKey:@"gateway"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"payment/prepareWeixinPay.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}


- (void) queryAccount:(void (^)(NSDictionary *, NSError *))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"statistics/incomeStatistics.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

- (void) queryHotGoods:(void (^)(NSArray *, NSError *))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryArray:[self getRequest:@"goods/queryClerkTopGoodsList.do"] bodyData:bodyData block:^(NSArray *array, NSError *error) {
        block(array ,error);
    }];
}

- (void) findPwd:(NSString*)phone code:(NSString*)code pwd:(NSString*)pwd block:(void (^)(NSDictionary *dic, NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phone forKey:@"phoneNumber"];
    [dic setValue:code forKey:@"verifyCode"];
    [dic setValue:pwd forKey:@"password"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"login/findPwd.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

- (void) queryAdvert:(void (^)(NSArray *array, NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryArray:[self getRequest:@"ad/queryAdsByPosition.do"] bodyData:bodyData block:^(NSArray *array, NSError *error) {
        block(array ,error);
    }];
}

- (void) checkMemberCardPwd:(NSString*)cardID pwd:(NSString*)pwd block:(void (^)(NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cardID forKey:@"memberCardId"];
    [dic setValue:pwd forKey:@"cardPwd"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block([self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryArray:[self getRequest:@"order/settleCheckCardPwd.do"] bodyData:bodyData block:^(NSArray *array, NSError *error) {
        block(error);
    }];
}

- (void) queryName:(void (^)(NSDictionary *, NSError *))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"statistics/queryServiceNickName.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

- (void) removeGoods:(NSString*)goodsid block:(void (^)(NSError *))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:goodsid forKey:@"goodsId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block([self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"goods/deleteGoodsForClerk.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(error);
    }];    
}

@end
