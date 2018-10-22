//
//  ShareUnity.h
//  ShopKeeper
//
//  Created by zhough on 16/6/16.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareUnity : NSObject
+(NSString*)getwalletType:(NSString*)walletTyoe;

+(void)saveTheUserInformation:(NSDictionary*)dic;
+(void)removeTheUserInformation;
+(NSInteger)managerAndserviceState;
+(NSInteger)managerAndserviceSecondState;//第二块权限

+(NSString*)preferredAreaId;
+(NSString*)serviceCenterId;
+(NSString*)serviceShopId;
+(NSString*)stationOrCenterId;
//计算nssting的高度
+ (CGFloat)labeltext:(NSString*)text sizewidth:(CGFloat)titlew systemfont:(CGFloat)font;

+ (CGFloat)labelWidthText:(NSString*)text sizewidth:(CGFloat)titlew systemfont:(CGFloat)font;

+(UIButton*)creatbutton:(CGRect)rect imagename:(NSString*)imagename title:(NSString*)title sum:(NSString*)sum;


+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;
+(NSString*)getTheCurrentTime;
+(void)saveTheUseruserauth:(NSDictionary*)dic;


@end
