//
//  ShareUnity.m
//  ShopKeeper
//
//  Created by zhough on 16/6/16.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ShareUnity.h"

@implementation ShareUnity


+(NSString*)getwalletType:(NSString*)walletTyoe{
    
    
    if ([walletTyoe isEqualToString:@"normal"]) {
        
        return @"个人钱包";
    }else if ([walletTyoe isEqualToString:@"station"]){
        
        
        return @"服务站钱包";
    }else if ([walletTyoe isEqualToString:@"stationStore"]){
        
        
        return @"服务站门店钱包";
    }else if ([walletTyoe isEqualToString:@"center"]){
        
        
        return @"服务中心钱包";
    }else if ([walletTyoe isEqualToString:@"centerStore"]){
        
        
        return @"服务中心门店钱包";
    }else
        
        return @"";
}
+(void)saveTheUserInformation:(NSDictionary*)dic{
    
    
    
    
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:LOGIN_TOKEN object:dic[@"token"]];
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:LOGIN_NAME object:dic[@"userid"]];
    
    NSDictionary * mdic = dic[@"uiyp"];

  
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:@"preferredAreaId" object:mdic[@"preferredAreaId"]];
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:@"serviceCenterId" object:mdic[@"serviceCenterId"]];
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:@"serviceStationId" object:mdic[@"serviceStationId"]];
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:@"stationOrCenterId" object:mdic[@"stationOrCenterId"]];
    

    NSNumber * manager = mdic[@"managerPermission"];
    NSNumber * operation = mdic[@"operationPermission"];
    NSNumber * serviceCenter = mdic[@"serviceCenterPermission"];
    NSNumber * serviceStation = mdic[@"serviceStationPermission"];
    NSNumber * shopMember = mdic[@"shopMemberPermission"];
    NSNumber * yst = mdic[@"shopMemberPermission"];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"managerPermission" object:[manager integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"operationPermission" object:[operation integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"serviceCenterPermission" object:[serviceCenter integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"serviceStationPermission" object:[serviceStation integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"shopMemberPermission" object:[shopMember integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"ystPermission" object:[yst integerValue]];

    
    NSInteger intge = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"ystPermission"];
    NSInteger intge1 = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"shopMemberPermission"];

    NSLog(@"----- daying  = %ld = %ld",intge,intge1);

}





+(void)saveTheUseruserauth:(NSDictionary*)dic{
    
    
    
    
    
    
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:@"preferredAreaId" object:dic[@"preferredAreaId"]];
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:@"serviceCenterId" object:dic[@"serviceCenterId"]];
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:@"serviceStationId" object:dic[@"serviceStationId"]];
    [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:@"stationOrCenterId" object:dic[@"stationOrCenterId"]];
    
    
    NSNumber * manager = dic[@"managerPermission"];
    NSNumber * operation = dic[@"operationPermission"];
    NSNumber * serviceCenter = dic[@"serviceCenterPermission"];
    NSNumber * serviceStation = dic[@"serviceStationPermission"];
    NSNumber * shopMember = dic[@"shopMemberPermission"];
    NSNumber * yst = dic[@"shopMemberPermission"];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"managerPermission" object:[manager integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"operationPermission" object:[operation integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"serviceCenterPermission" object:[serviceCenter integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"serviceStationPermission" object:[serviceStation integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"shopMemberPermission" object:[shopMember integerValue]];
    [MyUtile saveIntegerToUserDefaults:DICKEY_LOGIN key:@"ystPermission" object:[yst integerValue]];
    
    
  
    
}



+(NSString*)preferredAreaId{

    NSString * Id = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:@"preferredAreaId"];
    return Id;

}

+(NSString*)serviceCenterId{
    
    NSString * Id = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:@"serviceCenterId"];
    return Id;
    
}

+(NSString*)serviceShopId{
    
    NSString * Id = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:@"serviceStationId"];
    return Id;
    
}

+(NSString*)stationOrCenterId{
    
    NSString * Id = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:@"stationOrCenterId"];
    return Id;
    
}




+(void)removeTheUserInformation{
    
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGOURL];

    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_PHONE];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:LOGIN_NAME];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"preferredAreaId"];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"serviceCenterId"];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"serviceShopId"];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"stationOrCenterId"];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"managerPermission"];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"operationPermission"];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"serviceCenterPermission"];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"serviceStationPermission"];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"shopMemberPermission"];
    [MyUtile removeObjectFromUserDefaults:DICKEY_LOGIN key:@"ystPermission"];

}


+(NSInteger)managerAndserviceState{


 
    NSInteger manager = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"managerPermission"]; //服务经理权限
    NSInteger operation= [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"operationPermission"];//运营中心权限
    NSInteger serviceCenter = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"serviceCenterPermission"];//服务中心权限
    NSInteger Station = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"serviceStationPermission"];//服务站权限
    NSInteger Member = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"shopMemberPermission"];//有云商通店铺会员权限

    
    if (manager ==1 && operation==0 && serviceCenter ==0 && Station ==1  &&Member == 1) { //4.服务站＋服务经理＋会员
        return 3;
    }else if (manager ==1 &&operation==0 &&serviceCenter ==1 && Station ==0  &&Member ==1 ) {//9.服务中心＋会员＋服务经理
        return 3;
    }else if (manager ==1 &&operation==0 &&serviceCenter ==0 && Station ==1  &&Member ==0 ) {//3.服务站＋服务经理
        return 1;
    }else if (manager ==1 &&operation==0 &&serviceCenter == 1&& Station == 0 &&Member == 0) {//7.服务中心＋服务经理
        return 1;
    }else if (manager ==0 &&operation==1 &&serviceCenter == 0&& Station == 1 &&Member ==0 ) {//13.运营中心＋服务站
        return 1;
    }else if (manager ==0 &&operation==1 &&serviceCenter ==1 && Station ==0  &&Member == 0) {//14.运营中心＋服务中心
        return 1;
    }else if (manager ==1 &&operation==0 &&serviceCenter ==0 && Station == 0 &&Member == 1) { //1.服务经理＋会员
        return 2;
    }else if (manager ==0 &&operation==0 &&serviceCenter ==0 && Station ==1  &&Member ==1 ) { //5.服务站＋会员
        return 3;
    }else if (manager ==0 &&operation==0 &&serviceCenter ==1 && Station == 0 &&Member == 1) {//8.服务中心＋会员
        return 3;
    }else if (manager ==1 &&operation== 1&&serviceCenter == 0&& Station == 0 &&Member == 0) {//12.运营中心＋服务经理
        return 5;
    }else if (manager ==0 &&operation==1 &&serviceCenter == 0&& Station == 0 &&Member ==1 ) {//15.运营中心＋会员
        return 6;
    }else if (manager ==0 &&operation==0 &&serviceCenter ==0 && Station ==1  &&Member ==0 ) {//2.服务站
        return 1;
    }else if (manager == 0&&operation==0 &&serviceCenter == 1&& Station == 0 &&Member ==0 ) {//6.服务中心
        return 1;
    }
    else if (manager ==0 &&operation==0 &&serviceCenter ==0 && Station == 0 &&Member == 1) {//10.会员
        return 4;
    }
    else if (manager == 0&&operation==1 &&serviceCenter ==0 && Station ==0  &&Member ==0 ) {//11.运营中心
        return 5;
    }
  

    

    return 0;

}

//第一种布局
//2.服务站：                     1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位
//3.服务站＋服务经理               1：我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位
//6.服务中心                     1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位
//7.服务中心＋服务经理             1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位
//13.运营中心＋服务站              1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位
//14.运营中心＋服务中心            1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位

//第二种布局
//1.服务经理＋会员                1:我的钱包，收货地址，推荐农掌柜，积分，视频教学，问题反馈，会员卡，辖区订单

//第三种布局
//4.服务站＋服务经理＋会员          1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位，会员卡
//5.服务站＋会员                  1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位，会员卡
//8.服务中心＋会员                1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位，会员卡
//9.服务中心＋会员＋服务经理        1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，上报定位，会员卡


//第四种布局
//10.会员                        1:我的钱包，收货地址，推荐农掌柜，视频教学，问题反馈，会员卡，积分

//第五种布局
//11.运营中心                    1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架
//12.运营中心＋服务经理            1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架


//第六种布局
//15.运营中心＋会员               1:我的钱包，收货地址，推荐新农宝，推荐农掌柜，视频教学，问题反馈，最新上架，会员卡


+(NSInteger)managerAndserviceSecondState{
    
    
    NSInteger manager = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"managerPermission"]; //服务经理权限
    NSInteger operation= [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"operationPermission"];//运营中心权限
    NSInteger serviceCenter = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"serviceCenterPermission"];//服务中心权限
    NSInteger station = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"serviceStationPermission"];//服务站权限
    NSInteger Member = [MyUtile getIntegerFromUserDefault:DICKEY_LOGIN key:@"shopMemberPermission"];//有云商通店铺会员权限
    
    
    if (manager ==1 && operation==0 && serviceCenter ==0 && station ==1  &&Member == 1) { //4.服务站＋服务经理＋会员
        return 1;
    }else if (manager ==1 &&operation==0 &&serviceCenter ==1 && station ==0  &&Member ==1 ) {//9.服务中心＋会员＋服务经理
        return 3;
    }else if (manager ==1 &&operation==0 &&serviceCenter ==0 && station ==1  &&Member ==0 ) {//3.服务站＋服务经理
        return 1;
    }else if (manager ==1 &&operation==0 &&serviceCenter == 1&& station == 0 &&Member == 0) {//7.服务中心＋服务经理
        return 3;
    }else if (manager ==0 &&operation==1 &&serviceCenter == 0&& station == 1 &&Member ==0 ) {//13.运营中心＋服务站
        return 2;
    }else if (manager ==0 &&operation==1 &&serviceCenter ==1 && station ==0  &&Member == 0) {//14.运营中心＋服务中心
        return 4;
    }else if (manager ==0 &&operation==0 &&serviceCenter ==0 && station ==1  &&Member ==1 ) { //5.服务站＋会员
        return 2;
    }else if (manager ==0 &&operation==0 &&serviceCenter ==1 && station == 0 &&Member == 1) {//8.服务中心＋会员
        return 4;
    }else if (manager ==1 &&operation== 1&&serviceCenter == 0&& station == 0 &&Member == 0) {//12.运营中心＋服务经理
        return 4;
    }else if (manager ==0 &&operation==1 &&serviceCenter == 0&& station == 0 &&Member ==1 ) {//15.运营中心＋会员
        return 2;
    }else if (manager ==0 &&operation==0 &&serviceCenter ==0 && station ==1  &&Member ==0 ) {//2.服务站
        return 2;
    }else if (manager == 0&&operation==0 &&serviceCenter == 1&& station == 0 &&Member ==0 ) {//6.服务中心
        return 4;
    }
    
    else if (manager ==0 &&operation==1 &&serviceCenter ==0 && station == 0 &&Member ==0 ) {//11.运营中心
        return 2;
    }
    
    
    
    
    return 0;

}

//第一种布局
//3.服务站＋服务经理            辖区订单，积分，现金券。礼券
//4.服务站＋服务经理＋会员       辖区订单，积分，现金券。礼券


//第二种布局
//2.服务站：                   积分，现金券。礼券
//5.服务站＋会员               积分，现金券。礼券
//11.运营中心                 积分，现金券。礼券
//13.运营中心＋服务站           积分，现金券。礼券
//15.运营中心＋会员             积分，现金券。礼券


//第三种布局
//7.服务中心＋服务经理          我服务的订单，辖区订单，积分，现金券。礼券
//9.服务中心＋会员＋服务经理     我服务的订单，辖区订单，积分，现金券。礼券

//第四种布局
//6.服务中心                  我服务的订单，积分，现金券。礼券
//8.服务中心＋会员             我服务的订单，积分，现金券。礼券
//12.运营中心＋服务经理：       我服务的订单，积分，现金券。礼券
//14.运营中心＋服务中心         我服务的订单，积分，现金券。礼券





//{
//    "data": {
//        "token": "82265d44-cd65-4f48-b73d-7dda51d7dba1",
//        "userid": "aa3eab7e-ec59-4fbc-be62-969bfbe65395",
//        "uiyp": {
//            "areaIds": [
//                        "540102001000"
//                        ],
//            "areaNames": [],
//            "managerPermission": true,
//            "operationPermission": false,
//            "preferredAreaId": "540102001000",
//            "serviceCenterId": "39e43cb8-9d2d-40c5-acbf-baa22507b201",
//            "serviceCenterPermission": true,
//            "serviceShopId": "57e7cf29-87b9-11e5-9fbe-ecf4bbc07f44",
//            "serviceStationPermission": false,
//            "shopMemberPermission": false,
//            "stationOrCenterId": "39e43cb8-9d2d-40c5-acbf-baa22507b201",
//            "ystPermission": true
//        }
//    },
//    "code": 200,
//    "msg": "成功"
//}
//备注：1.appType这个参数是终端类型，1表示农掌柜App，2表示商城App
//2.managerPermission是否有服务经理权限，operationPermission是否有运营中心权限，
//serviceCenterPermission是否有服务中心权限，serviceStationPermission是否有服务站权限，
//shopMemberPermission是否有店铺会员权限

//1:serviceCenterPermission，managerPermission  2: shopMemberPermission 3:operationPermission｜｜（serviceCenterPermission ）（ managerPermission && operationPermission） ｜｜serviceStationPermission &&（managerPermission operationPermission ）



//计算nssting的高度
+ (CGFloat)labeltext:(NSString*)text sizewidth:(CGFloat)titlew systemfont:(CGFloat)font{
    
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(titlew, 10000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil].size;
    CGFloat titleh=titleSize.height;
    return titleh;
}


+ (CGFloat)labelWidthText:(NSString*)text sizewidth:(CGFloat)titlew systemfont:(CGFloat)font{
    
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(titlew,0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil].size;
    CGFloat titleh=titleSize.width;
    return titleh;
}


+(UIButton*)creatbutton:(CGRect)rect imagename:(NSString*)imagename title:(NSString*)title sum:(NSString*)sum{
    
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:rect];
    btn.backgroundColor = [UIColor clearColor];
    [btn.layer setShadowColor:[UIColor clearColor].CGColor];
    CGFloat tabwidth = btn.frame.size.width;
    
    UIImageView* selfImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tabwidth/3, tabwidth/4, tabwidth/3, tabwidth/3)];
    
    [selfImageView setContentMode:UIViewContentModeScaleToFill];
    [selfImageView setClipsToBounds:YES];
    [selfImageView setBackgroundColor:[UIColor clearColor]];
    
    [selfImageView setImage:[UIImage imageNamed:imagename]];
    [btn addSubview:selfImageView];
    
    UILabel *sumlab = [[UILabel alloc] init];
    [sumlab setFrame:CGRectMake(tabwidth/3*2 - 5, tabwidth/4 - 8 ,16, 16)];
    [sumlab setTextColor:ColorFromHex(0xec584c)];
    [sumlab.layer setBorderColor:ColorFromHex(0xec584c).CGColor];
    [sumlab.layer setBorderWidth:1];
    [sumlab setText:sum];
    [sumlab.layer setCornerRadius:8];
    [sumlab setTextAlignment:NSTextAlignmentCenter];
    [sumlab setNumberOfLines:0];
    [sumlab setFont:[UIFont systemFontOfSize:8]];
    
    [btn addSubview:sumlab];
    
    if (sum == nil || [sum isEqualToString:@""] ) {
        [sumlab setHidden:YES];
    }
    
    
    UILabel *selflab = [[UILabel alloc] init];
    [selflab setFrame:CGRectMake(0, tabwidth*7/12+5,tabwidth, tabwidth/4)];
    [selflab setTextColor:ColorFromHex(0x646464)];
    [selflab setText:title];
    [selflab setTextAlignment:NSTextAlignmentCenter];
    [selflab setNumberOfLines:0];
    [selflab setFont:[UIFont systemFontOfSize:11]];
    selflab.adjustsFontSizeToFitWidth = YES;
    [btn addSubview:selflab];
    return btn;
    
}


+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dtb = [dateformater dateFromString:bDate];
//    NSDate *dtb = [NSDate date];//当天

    NSDateFormatter *dateformater1 = [[NSDateFormatter alloc] init];
    [dateformater1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * getadate = [aDate stringByReplacingCharactersInRange:NSMakeRange(10, 1) withString:@" "];
    NSDate *dta = [dateformater1 dateFromString:getadate];

    NSLog(@"currentDateStr = %@   %@  %@",dtb,dta , getadate);

    NSComparisonResult result = [dta compare:dtb];
    if (result ==NSOrderedSame)
    {
        aa=0;
    }else if (result == NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

//获取当前时间yyyyMMdd HHmmsss
+(NSString*)getTheCurrentTime{
    NSDate *date = [NSDate date];//当天
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [inputFormatter stringFromDate:date];
    
    NSLog(@"currentDateStr = %@",currentDateStr);
    return currentDateStr;
}

@end
