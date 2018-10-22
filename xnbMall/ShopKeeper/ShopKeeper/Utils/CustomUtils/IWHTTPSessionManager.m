/**
 * IWHTTPSessionManager.m 16/8/8
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "IWHTTPSessionManager.h"
#import "AppDelegate.h"


#define ERROR_DOMAIN_REQUEST @"ERROR_DOMAIN_REQUEST"
#define ERROR_DOMAIN_HTTP @"ERROR_DOMAIN_HTTP"         //服务器
#define ERROR_DOMAIN_BUSINESS @"ERROR_DOMAIN_BUSINESS" //网络错误
#define ERROR_DOMAIN_JSON @"ERROR_DOMAIN_JSON"         //数据解析错误
@implementation IWHTTPSessionManager

//单例
+ (instancetype)shareSessionManager {
    
    static dispatch_once_t onceToken;
    static IWHTTPSessionManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:SERVER_ADDR_XNBMALL]];
        // NSLocalizedDescription=Request failed: unacceptable content-type: text/html -- 碰到这种错误需要配置数据的解析的类型
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return manager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static id instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copy {
    return self;
}

- (void)GET:(NSString *)path parameters:(id)parameters token:(BOOL)token comletionHandle:(void(^)(id responseObject, NSError *error))comletionHandle {
    
    if (token) {
        NSString* tokenStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
        
        if (tokenStr == nil) {
            comletionHandle(nil,[NSError errorWithDomain:@"CustomErrorDomain" code:-998 userInfo:@{NSLocalizedDescriptionKey:@"用户未登录！"}]);
            return;
        }
        [self.requestSerializer setValue:tokenStr forHTTPHeaderField:@"x_token"];
        
    }
    // 自己定义的方法，然后要去调用封装好的方法
    [self GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        comletionHandle(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        comletionHandle(nil, error);
    }];
    
}

- (void)POST:(NSString *)path parameters:(id)parameters token:(BOOL)token comletionHandle:(void(^)(id responseObject, NSError *error))comletionHandle {
    
    if (token) { //判断token是否有值
        NSString* tokenStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
        
        if (tokenStr == nil) {
            comletionHandle(nil,[NSError errorWithDomain:@"CustomErrorDomain" code:-998 userInfo:@{NSLocalizedDescriptionKey:@"用户未登录！"}]);
            return;
        }
        [self.requestSerializer setValue:tokenStr forHTTPHeaderField:@"x_token"];
        
    }
    // 自己定义的方法，然后要去调用封装好的方法
    [self POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSURLResponse *response = task.response;
       
        NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
        
        if (statusCode != 200) {//没有请求到数据
            comletionHandle(nil,[self createError:ERROR_DOMAIN_HTTP code:statusCode desc:@"没有找到数据"]);
            return;
        }
        
        if (responseObject == nil) {  //网络错误
            comletionHandle(nil,[self createError:ERROR_DOMAIN_BUSINESS code:-999 desc:@"网络似乎有问题!"]);
            return ;
        }
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if([responseObject[@"code"] integerValue] == 401){
//                [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_TOKEN];
                [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_SHOPNAME];
//                [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_GOWHERE];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [appDelegate resetRootViewForLogout];
//                });
                return;
            }
        }

        comletionHandle(responseObject, nil);
         //输出
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"请求参数:%@",jsonStr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error != nil) {   //错误有值
        comletionHandle(nil, [self createError:ERROR_DOMAIN_REQUEST code:error.code desc:error.localizedDescription]);
            return ;
        }
    }];
    
}


/**
 *  @author 黎国基, 16-08-01 11:08
 *
 *  创建一个自定义的NSError
 *
 *  @param domain error域
 *  @param code   错误代码
 *  @param desc   error code本地描述(NSLocalizedDescriptionKey)
 *
 *  @return NSError
 */
- (NSError*) createError:(NSString*)domain code:(NSInteger)code desc:(NSString*)desc{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if(desc == nil){
        desc = @"";
    }
    [dic setObject:desc forKey:NSLocalizedDescriptionKey];
    NSError* error = [[NSError alloc]initWithDomain:domain code:code userInfo:dic];
    return error;
}
@end
