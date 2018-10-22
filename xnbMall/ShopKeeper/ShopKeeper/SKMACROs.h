//
//  SKMACROs.h
//  ShopKeeper
//
//  Created by XNB2 on 16/10/28.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#ifndef SKMACROs_h
#define SKMACROs_h

#define RGBGRAY(g) [UIColor colorWithRed:g/255.f green:g/255.f blue:g/255.f alpha:1.0]
#define RGBAGRAY(g,a) [UIColor colorWithRed:g/255.f green:g/255.f blue:g/255.f alpha:a]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define FONT_HEL(s) [UIFont fontWithName:@"Helvetica" size:s]

//全局导航栏颜色
#define THEMECOLOR RGBCOLOR(221.f, 60.f, 44.f) //dd3c44

//用法UIColor* c = HEXCOLOR(0xff00ffff);
#define ColorFromRGB(Red,Green,Blue) [UIColor colorWithRed:(Red)/255. green:(Green)/255. blue:(Blue)/255. alpha:1.]

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0];

#define ColorFromHex(hexValue) ColorFromHex_Alpha(hexValue,1.0)

#define ColorFromHex_Alpha(hexValue,Alpha) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0f green:((float)((hexValue & 0xFF00) >> 8))/255.0f blue:((float)(hexValue & 0xFF))/255.0f alpha:Alpha]

//根据rgb获得颜色
#define KColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//设置唯一背景色(TableView背景底色色)
#define BACKGROUND_COLOR KColor(229,229,229)
//TableViewGrouped样式背景色
#define BACKGrouped_COLOR KColor(235,235,241)
//默认颜色
#define TEXTCURRENT_COLOR KColor(100,100,100)
//浅灰色字体(副字体)
#define TEXTVICE_COLOR KColor(170,170,170)


#define LOGIN_PHONE @"LOGIN_PHONE"//用户手机
#define LOGIN_TOKEN @"LOGIN_TOKEN"
#define LOGIN_NAME @"LOGIN_NAME"//用户userid
#define LOGIN_UIYP @"LOGIN_UIYP"
#define LOGIN_SHOPNAME @"LOGIN_SHOPNAME"
#define AREA_ID @"AREA_ID"
#define LOGOURL @"LOGOURL"//用户头像url
#define NETWORKNAME @"NETWORKNAME" //用户名字
#define ARWANAME @"ARWANAME"//地址
#define GENDER @"GENDER"//性别
#define MALL_IS_LOGIN @"MALL_IS_LOGIN" //用户是否登录判断

//商城
#define kGtAppId           @"zNL4IcHbK88FngdNfpbHm8"//新农宝id
#define kGtAppKey          @"ntDcwowQP96gqQbvEOd9P9"//新农宝key
#define kGtAppSecret       @"RVS2yA4p0G8RdIKQVEUWi4"//新农宝secret
#define WXAppKey @"wxec780609e910565f"
#define DICKEY_LOGIN @"DICKEY_LOGINMaLL"
//易极付添加的商户参数
#define SERVER_YJF @"pay/startAppYijifuJHPay.do"
#define PARTNER_ID_YJF  @"20160722020011689765" //商户号
#define SECURITY_CODE_YJF @"ce634e52ef9ebdde93103d59d7baa6c1"




#endif /* SKMACROs_h */
