//
//  TransDataProxyCenter.m
//  ShopKeeper
//
//  Created by zhough on 16/6/7.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "TransDataProxyCenter.h"

@implementation TransDataProxyCenter
static TransDataProxyCenter* shareController = nil;

+(TransDataProxyCenter*) shareController{
    if(shareController == nil){
        shareController = [[TransDataProxyCenter alloc]init];
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
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",SERVER_ADDR_XNBMALL,urlStr]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_ADDR_XNBMALL,urlStr]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:15];
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
        


        if (error != nil) {
            block(nil,[self createError:ERROR_DOMAIN_REQUEST code:error.code desc:error.localizedDescription]);
            return ;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
        //NSLog(@"request response: %ld",statusCode);
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
            block(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-998 desc:@"无数据"]);
            return;
        }
        
        if ([code integerValue] == 200) {
//            NSDictionary* dicData = [dic objectForKey:@"data"];
            block(dic,nil);
            return;
        }else{
            block(dic,[self createError:ERROR_DOMAIN_BUSINESS code:[code integerValue] desc:message]);
            return;
        }
    }];
}

- (void) queryArray:(NSMutableURLRequest*)request bodyData:(NSData*)bodyData block:(void (^)(NSArray *array, NSError *error))block{
    [self queryData:request bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        NSNumber* code = [dic objectForKey:@"code"];
        NSString* message = [dic objectForKey:@"msg"];
        if (code == nil ) {
            block(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-998 desc:@"无数据"]);
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
        NSLog(@"response: %@  \nresponse = %@",result,response);
        
        block(result,nil);
    }] resume];
    
}

//-----------------------------------------------------------------------------------------------------------------




- (void) login:(NSString*)username passwd:(NSString*)passwd block:(void (^)(NSDictionary *dic, NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"18682013077" forKey:@"username"];
    [dic setValue:@"123456" forKey:@"password"];
    [dic setValue:@"1" forKey:@""];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"错误：返回的数据格式不是json格式"]);
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



#pragma mark 退出登录
- (void) loginOut:(void (^)(NSDictionary *dic, NSError *error))block{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"错误：返回的数据格式不是json格式"]);
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

#pragma mark 性别修改

- (void) queryGender:(NSString*)gender block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:gender forKey:@"gender"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/setgender.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 修改昵称
- (void) queryNickName:(NSString*)nickName block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:nickName forKey:@"nickName"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/setalias.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}


#pragma mark 8.1.0 查询用户积分余额
- (void) pointsBalanceblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"points/balance.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 8.1.1 查询用户积分流水
- (void) pointsflow:(NSString*)lastDate block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:lastDate forKey:@"lastDate"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"points/flow.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 8.7.0 查询当前用户的个人信息
- (void) queryUserInfoblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/info.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
}

#pragma mark 8.6.0 设置用户的居住地区
- (void) queryAreaId:(NSString*)areaId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:areaId forKey:@"areaId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/setregion.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 8.9.3 提交云商通会员卡充值信息
- (void) ystmemberrechargeaId:(NSString*)aid chargeAmount:(NSString*)chargeAmount PhotoId:(NSString*)PhotoId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    

    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:chargeAmount forKey:@"chargeAmount"];
    [dic setValue:aid forKey:@"aid"];
    [dic setValue:PhotoId forKey:@"certificatePhotoId"];

    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/ystmemberrecharge.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 8.9.4 查询云商通会员卡充值记录
- (void) ystmemberrechargerecordsaId:(NSString*)aid pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aid forKey:@"aid"];
    [dic setValue:pageIndex forKey:@"pageIndex"];
    [dic setValue:pageSize forKey:@"pageSize"];
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/ystmemberrechargerecords.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 8.9.5 查询云商通会员卡的资金流水
- (void) ystmemberflowaId:(NSString*)aid pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
 
    [dic setValue:aid forKey:@"aid"];
    [dic setValue:pageIndex forKey:@"pageIndex"];
    [dic setValue:pageSize forKey:@"pageSize"];

    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/ystmemberflow.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 8.10.2 获取分享新农宝链接的参数
- (void) xnbspreadblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/xnbspread.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}


#pragma mark 8.10.3 获取分享新农宝掌柜链接的参数

- (void) xnbzgspreadblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/xnbzgspread.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}



#pragma mark 资金账户列表
- (void) querymyaccountsblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"money/myaccounts.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}


#pragma mark 资金账户详情
- (void) queryAccounts:(NSString*)aid block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:aid forKey:@"aid"];
        NSData* bodyData = [self getHttpBodyData:dic];
        
        [self queryDic:[self getRequest:@"money/account.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
            block(dic ,error);
        }];
    
    
   }

#pragma mark 资金账户绑定的银行卡
- (void) queryBankcards:(NSString*)aid block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aid forKey:@"aid"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"money/bankcards.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 资金账户绑定银行卡

- (void) queryBindcard:(NSString*)aid  bankNO:(NSString*)bankNO bankName:(NSString*)bankName bankUserName:(NSString*)bankUserName IDCardNO:(NSString*)IDCardNO block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aid forKey:@"aid"];
    [dic setValue:bankNO forKey:@"bankNO"];
    [dic setValue:bankName forKey:@"bankName"];
    [dic setValue:bankUserName forKey:@"bankUserName"];
    [dic setValue:IDCardNO forKey:@"IDCardNO"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"money/bindcard.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}



#pragma mark 设置默认的银行卡
- (void) querySetDefaultCard:(NSString*)aid  cid:(NSString*)cid block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aid forKey:@"aid"];
    [dic setValue:cid forKey:@"cid"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"money/setdefaultcard.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 删除银行卡
- (void) queryDeleteCard:(NSString*)cid  pwd:(NSString*)pwd block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cid forKey:@"cid"];
    [dic setValue:pwd forKey:@"pwd"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"money/deletecard.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}


#pragma mark 查询资金明细
- (void) queryFlow:(NSString*)aid pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aid forKey:@"aid"];
    [dic setValue:pageIndex forKey:@"pageIndex"];
    [dic setValue:pageSize forKey:@"pageSize"];

    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"money/flow.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 查询提现请求
- (void) queryListwithdraw:(NSString*)aid pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aid forKey:@"aid"];
    [dic setValue:pageIndex forKey:@"pageIndex"];
    [dic setValue:pageSize forKey:@"pageSize"];
    
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"money/listwithdraw.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}



#pragma mark 资金账户请求提现

- (void) queryWithdraw:(NSString*)aid pwd:(NSString*)pwd amount:(NSString*)amount block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aid forKey:@"aid"];
    [dic setValue:pwd forKey:@"pwd"];
    [dic setValue:amount forKey:@"amount"];
    
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"money/withdraw.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}


#pragma mark 资金账户提现请求预评估

- (void) queryAssesWithdraw:(NSString*)aid block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aid forKey:@"aid"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"money/asseswithdraw.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}


#pragma mark 设置用户个人头像

- (void) querySetphoto:(NSString*)logoId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:logoId forKey:@"logoId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/setphoto.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}
#pragma mark 查询当前用户的收获地址清单

- (void) queryMyaddressblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/myaddress.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}







#pragma mark 删除当前用户的收货地址

- (void) queryDeleteaddress:(NSString*)rid block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:rid forKey:@"rid"];

    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/deleteaddress.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
}



#pragma mark 添加或者修改当前用户的收货地址

- (void) queryAddaddress:(NSString*)rid contactName:(NSString*)contactName contactPhone:(NSString*)contactPhone areaId:(NSString*)areaId address:(NSString*)address isDefault:(NSString*)isDefault block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:rid forKey:@"rid"];
    [dic setValue:contactName forKey:@"contactName"];

    [dic setValue:contactPhone forKey:@"contactPhone"];
    [dic setValue:areaId forKey:@"areaId"];
    [dic setValue:address forKey:@"address"];
    [dic setValue:isDefault forKey:@"isDefault"];


    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/addaddress.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
}

#pragma mark 设置当前用户的默认收货地址

- (void) querySetdefaultaddress:(NSString*)rid block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:rid forKey:@"rid"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/setdefaultaddress.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
}


#pragma mark 上报定位

- (void) queryMylocation:(NSString*)stationId latitude:(NSString*)latitude longitude:(NSString*)longitude block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:stationId forKey:@"stationId"];
    [dic setValue:latitude forKey:@"latitude"];
    [dic setValue:longitude forKey:@"longitude"];
      
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/mylocation.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}



#pragma mark 查询最近上架的商品

- (void) queryYstnewarrival:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block{
    

    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:pageSize forKey:@"pageSize"];
    [dic setValue:pageIndex forKey:@"pageIndex"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"goods/ystnewarrival.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 查询当前用户的所有云商通会员卡列表

- (void) queryMyystmembersblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/myystmembers.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}

#pragma mark 问题反馈

- (void) queryfeedback:(NSString*)content photoList:(NSString*)photoList block:(void (^)(NSDictionary *dic, NSError *error))block{
    
   
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:content forKey:@"content"];
    [dic setValue:photoList forKey:@"photoList"];

    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/feedback.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
}


#pragma mark 查询登录用户的云商通订单计数

- (void) queryYstordercountblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
         [self queryDic:[self getRequest:@"order/ystordercount.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
            block(dic ,error);
        }];
    
}



#pragma mark 查询登录用户的云商通订单

- (void) queryYtorders:(int)state searchKey:(NSString*)searchKey pageIndex:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[self getOrderState:state] forKey:@"state"];
    [dic setValue:searchKey forKey:@"searchKey"];
    [dic setValue:pageIndex forKey:@"pageIndex"];

    NSData* bodyData = [self getHttpBodyData:dic];
        [self queryDic:[self getRequest:@"order/ystorders.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
            block(dic ,error);
        }];

    
}
#pragma mark 3.2.1、启动订单支付

- (void) queryPayOrderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/pay.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 3.3.2、查询订单详情

- (void) querydetailorderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/detail.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 3.3.3、查询订单追踪信息

- (void) querytrackorderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/track.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}
#pragma mark 3.4.0、查询我服务的订单

- (void) querymyserviceorders:(int)state searchKey:(NSString*)searchKey pageIndex:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[self getOrderState:state] forKey:@"state"];
    [dic setValue:searchKey forKey:@"searchKey"];
    [dic setValue:pageIndex forKey:@"pageIndex"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/myserviceorders.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}



#pragma mark 3.4.0、查询辖区订单

- (void) queryMyruleorders:(int)state searchKey:(NSString*)searchKey pageIndex:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[self getOrderState:state] forKey:@"state"];
    [dic setValue:searchKey forKey:@"searchKey"];
    [dic setValue:pageIndex forKey:@"pageIndex"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/myruleorders.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}



#pragma mark 3.7.0 确认收货

- (void) queryReceiveorderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/receive.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 3.8.0 延迟收货

- (void) querydelayreceiveorderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/delayreceive.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 视频

- (void) queryLearnVideoblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/learnVideoJson.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}


#pragma mark 查询指定id的用户最新的云商通会员卡信息

- (void) queryMyystmember:(NSString*)aid block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aid forKey:@"aid"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/myystmember.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}



#pragma mark 3.2.1、启动订单支付

- (void) queryorderpay:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/pay.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
}

#pragma mark 3.6.0 删除订单

- (void) queryOrderBelete:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/delete.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
}

#pragma mark 4.2.2 查询当前用户的礼券余额

- (void) queryGiftcardBalanceblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"giftcard/balance.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
}

#pragma mark 4.2.3 激活礼券

- (void) giftcardactivatecode:(NSString*)code block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:code forKey:@"code"];

    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"giftcard/activate.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 4.2.4 礼券优惠记录

- (void) giftcardmyGiftCardLogsblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"giftcard/myGiftCardLogs.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 4.2.5 我的礼券有效期

- (void) giftcardmyGiftCards:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:pageIndex forKey:@"pageIndex"];
    [dic setValue:@"10" forKey:@"pageSize"];

  
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"giftcard/myGiftCards.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}
#pragma mark 4.4.1 激活现金券

- (void) cashcouponActivate:(NSString*)code block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:code forKey:@"code"];

    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"cashcoupon/activate.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}


#pragma mark 2.1.0、获取首页banner广告

- (void) banner:(NSString*)areaId location:(NSString*)location block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:areaId forKey:@"areaId"];
    [dic setValue:location forKey:@"location"];

    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"ad/banner.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

/************农掌柜模块下************/
#pragma mark 7.1.0 查询服务店铺的订单列表
- (void) querykeeperOrdersState:(int)state serviceShopId:(NSString*)serviceShopId pageIndex:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:serviceShopId forKey:@"serviceShopId"];//服务店铺ID
    if (state == 4) {
        state = 5;
    }
    [dic setValue:[NSString stringWithFormat:@"%d",state] forKey:@"state"];//订单状态
    [dic setValue:pageIndex forKey:@"pageIndex"];
    [dic setValue:@"10" forKey:@"pageSize"];

    NSData* bodyData = [self getHttpBodyData:dic];//15075352308
    
    [self queryDic:[self getRequest:@"keeper/orders.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}



#pragma mark 7.1.1 统计服务店铺的订单计数
- (void) querykeeperOrdercountblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"keeper/keeperindex.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}
#pragma mark 7.4.0 查询我负责的服务店铺列表
- (void) querykeeperearningblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"keeper/myshops.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}
#pragma mark 7.6.0、查询订单详情

- (void) querykeeperorderdetail:(NSString*)orderId serviceShopId:(NSString*)shopId block:(void (^)(NSDictionary *dic, NSError *error))block{

    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];//订单状态
    [dic setValue:shopId forKey:@"shopId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];//15075352308
    
    [self queryDic:[self getRequest:@"keeper/orderdetail.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 7.6.1、查询订单追踪信息

- (void) querykeepertrackorderId:(NSString*)orderId shopId:(NSString*)shopId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    [dic setValue:shopId forKey:@"shopId"];

    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"keeper/ordertrack.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 7.2.0 订单发货

- (void) querykeeperDelivery:(NSString*)orderId shopId:(NSString*)shopId  Company:(NSString*)Company Ticket:(NSString*)Ticket notes:(NSString*)notes block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    [dic setValue:shopId forKey:@"serviceShopId"];
    [dic setValue:Company forKey:@"expressCompany"];//物流公司
    [dic setValue:Ticket forKey:@"expressTicket"];//物流单号
    [dic setValue:notes forKey:@"notes"];

     NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"keeper/delivery.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}


#pragma mark 7.6.2、查询订单物流信息

- (void) querykeeperorderlogistictrack:(NSString*)orderId orderLogId:(NSString*)orderLogId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"shopId"];
    [dic setValue:orderLogId forKey:@"orderLogId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"keeper/orderlogistictrack.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 7.5.0 分享店铺

- (void) querykeepershareshop:(NSString*)shopId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:shopId forKey:@"shopId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"keeper/shareshop.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 7.3.0 订单转云商通

- (void) querykeeperforwardyst:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderId forKey:@"orderId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"keeper/forwardyst.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}



#pragma mark 3.3.4、查询订单物流信息

- (void) logistictrackorderLogId:(NSString*)orderLogId block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderLogId forKey:@"orderLogId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"order/logistictrack.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 1.8.0 获取验证码图片参数

- (void) loginprepareconfusionblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"login/prepareconfusion.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}


#pragma mark 8.2.0 重置密码

- (void) userresetpwd:(NSString*)oldpwd newpwd:(NSString *)newpwd phoneNumber:(NSString*)phoneNumber block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:oldpwd forKey:@"verifyCode"];
    [dic setValue:newpwd forKey:@"password"];
    [dic setValue:@"1" forKey:@"appType"];
    [dic setValue:phoneNumber forKey:@"phoneNumber"];

       NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"login/findPwd.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}


#pragma mark 8.2.1 变更手机号

- (void) serresetphonenumber:(NSString*)phoneNumber verifyCode:(NSString *)verifyCode block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneNumber forKey:@"phoneNumber"];
    [dic setValue:verifyCode forKey:@"verifyCode"];
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/resetphonenumber.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 3、登录获取随机密码

- (void) logingetVerifyCode:(NSString*)phoneNumber verifyCodeType:(NSString *)verifyCodeType vid:(NSString*)vid cid:(NSString*)cid block:(void (^)(NSDictionary *dic1, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneNumber forKey:@"phoneNumber"];
    [dic setValue:verifyCodeType forKey:@"verifyCodeType"];
    [dic setValue:@"1" forKey:@"appType"];
    [dic setValue:vid forKey:@"vid"];//图片验证码参数包的key
    [dic setValue:cid forKey:@"cid"];//用户选中的验证码图片id
 
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"login/getVerifyCode.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}



#pragma mark 8.2.2 变更手机号时获取验证码

- (void) getVerifyCodeForChangePhone:(NSString*)phoneNumber verifyCodeType:(NSString *)verifyCodeType vid:(NSString*)vid cid:(NSString*)cid block:(void (^)(NSDictionary *dic1, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneNumber forKey:@"phoneNumber"];
    [dic setValue:verifyCodeType forKey:@"verifyCodeType"];
    [dic setValue:vid forKey:@"vid"];//图片验证码参数包的key
    [dic setValue:cid forKey:@"cid"];//用户选中的验证码图片id
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"user/getVerifyCodeForChangePhone.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

/************农掌柜模块上************/


#pragma mark 9.1.3、绑定推送平台的clientId

- (void) messagebinddeviceTokent:(NSString * )deviceTokent clientId:(NSString *)clientId block:(void (^)(NSDictionary *dic1, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kGtAppId forKey:@"appId"];//@"6Meej3qddt7FcflmeGXI12"
    [dic setValue:clientId forKey:@"clientId"];
    [dic setValue:@"1" forKey:@"appType"];
    [dic setValue:@"0" forKey:@"platform"];//图片验证码参数包的key
    [dic setValue:deviceTokent forKey:@"deviceTokent"];//用户选中的验证码图片id

    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"message/bind.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 9.1.0、检查是否有新消息

- (void) messagecheckunreadblock:(void (^)(NSDictionary *dic1, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"message/checkunread.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}


#pragma mark 9.1.1、消息列表

- (void) messageMessageListpageIndex:(NSString * )pageIndex block:(void (^)(NSDictionary *dic1, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:pageIndex forKey:@"pageIndex"];
    
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"message/messageList.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}


#pragma mark 9.1.2、消息详细

- (void) messageMessageDetail:(NSString * )getId block:(void (^)(NSDictionary *dic1, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:getId forKey:@"messageMemberDetailId"];
    
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"message/messageDetail.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}

#pragma mark 9.1.4、上报通知的接收状态

- (void) messageReport:(NSString * )status msgId:(NSString*)msgId block:(void (^)(NSDictionary *dic1, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:status forKey:@"status"];
    [dic setValue:msgId forKey:@"msgId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"message/report.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
}
#pragma mark 9.1.5、上报通知的阅读状态

- (void) messagereportRead:(NSString * )msgId block:(void (^)(NSDictionary *dic1, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:msgId forKey:@"msgId"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"message/reportRead.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
}


-(NSString*)getOrderState:(int)state{

    NSString * getstatestring = nil;
    
    switch (state) {
        case 0://所有
            getstatestring = @"1,2,3,4,5,6,7,8,99";
            break;
        case 1://待付款
            getstatestring = @"1";
            break;
        case 2://待发货
            getstatestring = @"2,7";

            break;
        case 3://待签收
            getstatestring = @"3,8";

            break;
        case 4://已完成
            getstatestring = @"4,5,6,99";

            break;
       
        default:
            
            getstatestring = @"1,2,3,4,5,6,7,8,99";

            break;
    }

    
    return getstatestring;

}

#pragma mark -- 商家注册
- (void) mallregister:(NSString*)oldpwd newpwd:(NSString *)newpwd phoneNumber:(NSString*)phoneNumber block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:oldpwd forKey:@"verifyCode"];
    [dic setValue:newpwd forKey:@"password"];
    [dic setValue:phoneNumber forKey:@"username"];
    
    NSData* bodyData = [self getHttpBodyData:dic];
    
    [self queryDic:[self getRequest:@"login/register.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        block(dic ,error);
    }];
    
    
    
}




@end
