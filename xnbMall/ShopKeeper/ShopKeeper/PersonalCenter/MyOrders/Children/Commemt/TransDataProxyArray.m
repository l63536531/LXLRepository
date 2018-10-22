//
//  TransDataProxyArray.m
//  ShopKeeper
//
//  Created by zhough on 16/7/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "TransDataProxyArray.h"

@implementation TransDataProxyArray
static TransDataProxyArray* shareController = nil;

+(TransDataProxyArray*) shareController{
    if(shareController == nil){
        shareController = [[TransDataProxyArray alloc]init];
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

- (NSData*) getHttpBodyDataNSArray:(NSArray*)param{
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




- (void) comment:(NSArray*)array block:(void (^)(NSDictionary *dic, NSError *error))block{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];//将JSONObject的实例转成NSData
    NSString* jsonText = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    [dic setValue:jsonText forKey:@"comments"];

    NSData* bodyData = [self getHttpBodyData:dic];
    if (bodyData == nil) {
        block(nil,[self createError:ERROR_DOMAIN_JSON code:-1 desc:@"http body text is not json."]);
        return;
    }
    
    [self queryDic:[self getRequest:@"comment/appraise.do"] bodyData:bodyData block:^(NSDictionary *dic, NSError *error) {
        if (dic == nil) {
            block(nil,error);
            return;
        }
        block(dic ,error);
    }];
}







@end