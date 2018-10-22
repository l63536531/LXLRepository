//
//  MyUtile.m
//  EditVideo
//
//  Created by oracle on 14-9-9.
//  Copyright (c) 2014年 www.gzspark.net. All rights reserved.
//

#import "MyUtile.h"

#define SAMLL_IMAGE_FROM_VIDEO @"SAMLL_IMAGE_FROM_VIDEO"
#define MIDDLE_IMAGE_FROM_VIDEO @"MIDDLE_IMAGE_FROM_VIDEO"
#define BIG_IMAGE_FROM_VIDEO @"BIG_IMAGE_FROM_VIDEO"

@implementation MyUtile

+ (void) removeLocalFile:(NSString*) filePath{
    NSLog(@"删除文件%@",filePath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] == NO) {
            NSLog(@"removeitematpath %@ error :%@", filePath, error);
        }else{
            NSLog(@"删除成功");
        }
    }else{
        NSLog(@"文件不存在");
    }
}

+ (void) removeMovie:(NSURL*) movieURL{
    NSString* filePath = [movieURL path];
    [self removeLocalFile:filePath];
}


+ (NSString*) formatTime:(NSInteger)time{
    NSInteger hour = time/3600;
    NSInteger minute = time%3600/60;
    NSInteger second = time%60;
    
    if (hour == 0) {
        if (minute == 0) {
            return [NSString stringWithFormat:@"00:%@",[self formatTwo:second]];
        }else{
            return [NSString stringWithFormat:@"%@:%@",[self formatTwo:minute],[self formatTwo:second]];
        }
    }else{
        return [NSString stringWithFormat:@"%@:%@:%@",[self formatTwo:hour],[self formatTwo:minute],[self formatTwo:second]];
    }
}

+ (NSString*) formatTwo:(NSInteger)number{
    if (number < 10) {
        return [NSString stringWithFormat:@"0%d",(int)number];
    }else{
        return [NSString stringWithFormat:@"%d",(int)number];
    }
}

+ (void) removeObjectFromUserDefaults:(NSString*)name key:(NSString*)key{
    NSMutableDictionary* dicBuff = nil;
    NSDictionary* dic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (dic == nil) {
        dicBuff = [[NSMutableDictionary alloc]init];
    }else{
        dicBuff = [[NSMutableDictionary alloc]initWithDictionary:dic];
    }
    [dicBuff removeObjectForKey:key];
    
    //保存字典
    [[NSUserDefaults standardUserDefaults] setObject:dicBuff forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) cleanObjectFromUserDefaults:(NSString*)name{
    NSMutableDictionary* dicBuff = nil;
    NSDictionary* dic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (dic == nil) {
        dicBuff = [[NSMutableDictionary alloc]init];
    }else{
        dicBuff = [[NSMutableDictionary alloc]initWithDictionary:dic];
    }
    [dicBuff removeAllObjects];
    
    //保存字典
    [[NSUserDefaults standardUserDefaults] setObject:dicBuff forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveObjectToUserDefaults:(NSString*)name key:(NSString*)key object:(NSData *)object{
    NSMutableDictionary* dicBuff = nil;
    NSDictionary* dic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (dic == nil) {
        dicBuff = [[NSMutableDictionary alloc]init];
    }else{
        dicBuff = [[NSMutableDictionary alloc]initWithDictionary:dic];
    }
    
    [dicBuff setValue:object forKey:key];
    
    //保存字典
    [[NSUserDefaults standardUserDefaults] setObject:dicBuff forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveStringToUserDefaults:(NSString*)name key:(NSString*)key object:(NSString *)object{
    NSMutableDictionary* dicBuff = nil;
    NSDictionary* dic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (dic == nil) {
        dicBuff = [[NSMutableDictionary alloc]init];
    }else{
        dicBuff = [[NSMutableDictionary alloc]initWithDictionary:dic];
    }
    
    [dicBuff setValue:object forKey:key];
    
    //保存字典
    [[NSUserDefaults standardUserDefaults] setObject:dicBuff forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveIntegerToUserDefaults:(NSString*)name key:(NSString*)key object:(NSInteger)object{
    NSMutableDictionary* dicBuff = nil;
    NSDictionary* dic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (dic == nil) {
        dicBuff = [[NSMutableDictionary alloc]init];
    }else{
        dicBuff = [[NSMutableDictionary alloc]initWithDictionary:dic];
    }
    
    NSNumber* number = [[NSNumber alloc]initWithInteger:object] ;
    [dicBuff setValue:number forKey:key];
    
    //保存字典
    [[NSUserDefaults standardUserDefaults] setObject:dicBuff forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary*) getDictionaryFromUserDefaults:(NSString*)name{
    NSDictionary* dicBuff = nil;
    NSDictionary* dic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (dic == nil) {
        dicBuff = [[NSMutableDictionary alloc]init];
    }else{
        dicBuff = [[NSMutableDictionary alloc]initWithDictionary:dic];
    }
    return dicBuff;
}

+ (void) saveDictionaryToUserDefaults:(NSString*)name dictionary:(NSDictionary*)dictionary{
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSObject*) getObjectFromUserDefault:(NSString*)name key:(NSString*)key{
    NSDictionary* dic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (dic == nil) {
        return nil;
    }else{
        return [dic objectForKey:key];
    }
}

+ (NSString*) getStringFromUserDefault:(NSString*)name key:(NSString*)key{
    NSDictionary* dic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (dic == nil) {
        return nil;
    }else{
        return [dic objectForKey:key];
    }
}

+ (NSInteger) getIntegerFromUserDefault:(NSString*)name key:(NSString*)key{
    NSDictionary* dic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (dic == nil) {
        return 0;
    }else{
        NSNumber* number = [dic objectForKey:key];
        NSInteger object = [number integerValue];
        return object;
    }
}

+ (void) clearDictionaryFromUserDefaults:(NSString*)name{
    NSMutableDictionary* dicBuff = [[NSMutableDictionary alloc]init];
    //保存字典
    [[NSUserDefaults standardUserDefaults] setObject:dicBuff forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (MBProgressHUD*) initHUD:(UIView*) parentView{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];
    HUD.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    HUD.labelText = NSLocalizedString(@"LOADING", @"加载中,请稍后...");
    return HUD;
}

+ (MBProgressHUD*) initHUD:(UIView*) parentView labelText:(NSString*) labelText{
    MBProgressHUD* HUD = [MyUtile initHUD:parentView];
    HUD.labelText = labelText;
    return HUD;
}

+ (UITableViewCell*) getCellBySubview:(UIView*) subview{
    if (IOS8_OR_LATER) {
        return (UITableViewCell*)[[subview superview]superview];//ios6和ios8cell到contentView中间没有
    }else{
        return (UITableViewCell*)[[[subview superview]superview]superview];//ios7中cell到contentView中间还有一层UITableViewCellScrollView
    }
}

+ (UIView*) getBlurView{
    UIView* view;
    if (IOS8_OR_LATER) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        view = [[UIVisualEffectView alloc] initWithEffect:blur];
    }else{
        view = [[UIView alloc]init];
        [view setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:COMMON_VIEW_ALPHA]];
    }
    return view;
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    NSLog(@"当前语言:%@", preferredLang);
    return preferredLang;
}

+ (void) saveDateToUserDefaults:(NSString*)name key:(NSString*)key object:(NSDate*)object{
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *destDateString = [formatter stringFromDate:object];
        [MyUtile saveStringToUserDefaults:name key:key object:destDateString];
    }
    @catch (NSException *exception) {
        NSLog(@"saveDateToUserDefaults error");
    }
    @finally {
    }
}

+ (NSDate*) getDateFromUserDefault:(NSString*)name key:(NSString*)key{
    @try {
        NSString* destDateString = [MyUtile getStringFromUserDefault:name key:key];
        if (destDateString == nil || [destDateString length] == 0) {
            return nil;
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:destDateString];
        return date;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        
    }
}

+ (BOOL) needLogin{
    /*
     NSString* loginName = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_NAME];
     if (loginName == nil || [loginName length] == 0) {
     return YES;
     }
     
     NSDate *date = [NSDate date];
     NSDate* lastLoginDate = [MyUtile getDateFromUserDefault:DICKEY_LOGIN key:LOGIN_DATE];
     if (lastLoginDate == nil) {
     return YES;
     }
     
     NSTimeInterval secondsInterval= [date timeIntervalSinceDate:lastLoginDate];
     if (secondsInterval > 24*60*60*5) {
     //超过5天
     return YES;
     }
     */
    return NO;
}

#pragma mark   ==============产生随机订单号==============
+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+ (NSString*) dollar2cent:(NSString*)dollar{
    
    if (dollar == nil || [dollar isEqualToString:@""]) {
        
        return nil;
        
    }
    
    NSDecimalNumber *dnDollar = [NSDecimalNumber decimalNumberWithString:dollar];
    
    NSDecimalNumber *dnHundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    
    return [[dnDollar decimalNumberByMultiplyingBy:dnHundred] stringValue];
    
    
}

+ (NSString*) cent2dollar:(NSString*)cent{
    
    if ([cent isEqualToString:@""] || cent == nil) {
        
        return nil;
        
    }
    NSDecimalNumber *dnCent = [NSDecimalNumber decimalNumberWithString:cent];
    
    NSDecimalNumber *dnHundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    
    return [[dnCent decimalNumberByDividingBy:dnHundred] stringValue];
}

+ (UIColor*) getSystemMainColor{
    return  [UIColor colorWithRed:229/255.0 green:64.0/255.0 blue:61.0/255.0 alpha:1.0];
}

+ (void) showAlertViewByError:(NSError*) error vc:(UIViewController*)vc{
    NSString* desc = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:desc preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];
    [alertController addAction:cancelAction];
    
    [vc presentViewController:alertController animated:YES completion:nil];
}

+ (void) showAlertViewByMsg:(NSString*) msg vc:(UIViewController*)vc{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:cancelAction];
    
    [vc presentViewController:alertController animated:YES completion:nil];
}


+ (void) addGoodsToCart:(NSMutableDictionary*)goods{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* login_name = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_NAME];
    if(login_name == nil) return;
    NSString *cartname = [NSString stringWithFormat:@"%@_goodscart",login_name];
    NSMutableArray *goodscart  = [[defaults objectForKey:cartname] mutableCopy];
    
    if(goodscart == nil){
        goodscart = [[NSMutableArray alloc] init];
        [goodscart addObject:goods];
    }else{
        NSString *goodsId = goods[@"goodsId"];
        NSInteger amount = [goods[@"amount"] integerValue];
        BOOL isfind = false;
        NSInteger index = 0;
        for(NSDictionary *dic in goodscart){
            NSMutableDictionary *mdic =[dic mutableCopy];
            NSString *goodsId1 = mdic[@"goodsId"];
            NSInteger amount1 = [mdic[@"amount"] integerValue];
            if([goodsId isEqualToString:goodsId1]){
                [mdic setObject:@(amount1+amount) forKey:@"amount"];
                [goodscart replaceObjectAtIndex:index withObject:mdic];
                isfind = true;
                break;
            }
            index++;
        }
        if(!isfind){
            [goodscart addObject:goods];
        }
    }
    
    [defaults setObject:goodscart forKey:cartname];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary*) getGoodsFromCartByGoodsId:(NSString*)goodsId{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString* login_name = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_NAME];
    if(login_name == nil) return nil;
    NSString *cartname = [NSString stringWithFormat:@"%@_goodscart",login_name];
    NSMutableArray *goodscart  = [[defaults objectForKey:cartname] mutableCopy];
    if(goodscart != nil){
        for(NSDictionary *dic in goodscart){
            NSString *goodsId1 = dic[@"goodsId"];
            if([goodsId isEqualToString:goodsId1]){
                return dic;
            }
        }
    }
    return nil;
}

+ (void) delGoodsFromCartByGoodsId:(NSString*)goodsId{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString* login_name = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_NAME];
    if(login_name == nil) return;
    NSString *cartname = [NSString stringWithFormat:@"%@_goodscart",login_name];
    NSMutableArray *goodscart  = [[defaults objectForKey:cartname] mutableCopy];

    if(goodscart != nil){
        for(NSDictionary *dic in goodscart){
            NSString *goodsId1 = dic[@"goodsId"];
            if([goodsId isEqualToString:goodsId1]){
                [goodscart removeObject:dic];
            }
        }
    }
    [defaults setObject:goodscart forKey:cartname];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray*) getGoodsToCart{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString* login_name = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_NAME];
    if(login_name == nil) return nil;
    NSString *cartname = [NSString stringWithFormat:@"%@_goodscart",login_name];
    NSMutableArray *goodscart  = [[defaults objectForKey:cartname] mutableCopy];

    if(goodscart == nil){
        goodscart = [[NSMutableArray alloc] init];
        [defaults setObject:goodscart forKey:cartname];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return goodscart;
}

+ (void) UpdateGoodsToCart:(NSMutableArray*)goodslist{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString* login_name = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_NAME];
    if(login_name == nil) return;
    NSString *cartname = [NSString stringWithFormat:@"%@_goodscart",login_name];

    [defaults setObject:goodslist forKey:cartname];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (id) getUserDataUiypByKey:(NSString*)ukey {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *uiyp  = [defaults objectForKey:LOGIN_UIYP];
    if(uiyp != nil){
        return [uiyp objectForKey:ukey];
    }
    return nil;
}


+ (BOOL) saveUserDataUiyp:(NSObject*)uiyp {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[uiyp mutableCopy] forKey:LOGIN_UIYP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

+ (BOOL) updateUserDataUiypByKey:(NSString*)ukey uvalue:(id)vu {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *uiyp  = [defaults objectForKey:LOGIN_UIYP];
    if (uiyp !=nil) {
        [uiyp setObject:[vu mutableCopy] forKey:ukey];
    }
    return YES;
}


+ (BOOL) delUserDataUiyp {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:LOGIN_UIYP];
    [defaults synchronize];
    return YES;
}



+ (void) printDicToJson:(NSDictionary*)dic{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];//将JSONObject的实例转成NSData
    if (error) {
        NSLog(@"dic->%@",error);
        return;
    }
    
    NSString* jsonText = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"json: %@",jsonText);
}

+ (NSDictionary*) getDicByJson:(NSString*)json{
    NSData* jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* jsonError = nil;
    NSDictionary* dicResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];//将NSData类型的实例转成JSONObject，使用缓冲区数据来解析
    return  dicResult;
}

+(NSData *)imageData:(UIImage *)myimage

{
    
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    
    if (data.length>100*1024) {
        
        if (data.length>1024*1024) {//1M以及以上
            
            data=UIImageJPEGRepresentation(myimage, 0.1);
            
        }else if (data.length>512*1024) {//0.5M-1M
            
            data=UIImageJPEGRepresentation(myimage, 0.5);
            
        }else if (data.length>200*1024) {//0.25M-0.5M
            
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    
    return data;
}

+ (UILabel*) createNormalLabel:(CGRect)rect{
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:COMMON_VIEW_ALPHA]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:16]];
    
    return label;
}

+ (UIView*) getLineView:(CGRect) rect{
    UIView* line = [[UIView alloc]init];
    [line setFrame:rect];
    [line setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    return line;
}


+(void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}
@end
