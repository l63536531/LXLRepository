//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIpViewTool.h"

typedef enum :NSInteger{
    
    K_Rank_style_A_Z = 0,
    K_Rank_style_Z_A,
    K_Rank_style_Price_Small_Big,
    K_Rank_style_Price_Big_Small,
    K_Rank_style_Star,
    K_Rank_style_Sales
    
    
} K_Rank_style;

@interface Tool : NSObject

/**
 *  获取当前时间的时间戳（例子：1464326536）
 *
 *  @return 时间戳字符串型
 */
+ (NSString *)getCurrentTimestamp;

/**
 *  获取当前标准时间（例子：2015-02-03）
 *
 *  @return 标准时间字符串型
 */
+ (NSString *)getCurrentStandarTime;

/**
 *  时间戳转换为时间的方法
 *
 *  @param timestamp 时间戳
 *
 *  @return 标准时间字符串 1464326536 ——》 2015-02-03
 */
+ (NSString *)timestampChangesStandarTime:(NSString *)timestam;
//时间转换星期
+ (NSString *)timeToweek:(NSString *)time;

+ (NSString *)timeToBrith:(NSString *)time;
+ (NSString *)timeToMonth:(NSString *)timestamp;
+ (NSString *)timeToYear:(NSString *)timestamp;
/**
 *  手机号码验证
 *
 *  @param NSString 手机号码字符串
 *
 *  @return 是否手机号
 *
 *  (13[0-9]) 13开头
 */
+ (BOOL) validateMobile:(NSString *)mobile;

/**
 *  验证认证
 *
 *  @param NSString 密码字符串
 *
 *  @return 是否密码
 *  {6,20}  6到20位
 */
+ (BOOL) validateVerify:(NSString *)verifyCode;

//判断是否为邮箱
+ (BOOL) validateEmail:(NSString *)email;

//判断内容是否全部为空格
+ (BOOL)isEmpty:(NSString *)str;

//判断用户密码6-16位数字和字母组合
+ (BOOL)checkPassword:(NSString *)password;

#pragma mark 文字提示框
+ (void)addTextTipsDialog:(NSString*) aText;//显示文字提示框
+ (void)addTextTopTipsDialog:(NSString*) aText;//显示文字提示框

+(void)addTextWithEmoJi:(NSString*) aText;


+ (CGFloat) P_updateHeightWithStr:(NSString *)labelStr fontSize:(CGFloat)fontsize labelWidth:(CGFloat)lbWidth;

#pragma mark -  boundingRectWithSize 代替 sizeWithFont  Label自适应宽度
+(CGSize) getAdaptionSizeWithText:(NSString *)sendText andFont:(UIFont *)sendFont andLabelWidth:(CGFloat)sendWidth;
#pragma mark -  boundingRectWithSize 代替 sizeWithFont  Label自适应高度
+(CGSize) getAdaptionSizeWithText:(NSString *)sendText AndFont:(CGFloat )sendFont andLabelHeight:(CGFloat)sendHeight;

//时间排序
+ (NSString *)setCreatTime:(NSString *)timeStr;

//游戏时间排序
+ (NSString *)setCreatTime1:(NSString *)timeStr;

//订单详情付款剩余时间
+ (NSString *)getOrderlLastTime:(NSString *)timeStr;

//今天的具体时间  时分
+ (NSString *)timestampChangesTodayStandarTime:(NSString *)timestamp;

//消息时间轴
+ (NSString *)timestampToMessageTimeline:(NSString *)timestamp;

//聊天消息时间是否显示
+ (BOOL)showWithOldTimestamp:(NSString *)OldTimestamp andNewTimestamp:(NSString *)NewTimestamp;

//颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//无数据显示 大图
+ (void)showBigUnDataImageWithText:(NSString *)text andView:(UIView *)view isHidden:(BOOL)isHidden;

//无数据显示 小图
+ (void)showSmallUnDataImageWithText:(NSString *)text andView:(UIView *)view isHidden:(BOOL)isHidden;

//判断是否是10位时间戳
+ (NSString *)timestampIsRightTime:(NSString *)timeStr;

//判断输入的文本是否有表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

+(void)coreNetworkChangeNoti:(NSNotification *)noti;
//添加菊花
- (void)showWaitingView:(UIView *)view;
//隐藏菊花
- (void)hideWaitingView;

//得到未读总数
+ (int)getAllUnreadNumber;

//+ (UIImage *)getImgWithImgUrlString:(NSString *)imgUrl;

+ (void)zipImageFiles:(UIImage *)image
              imageKB:(CGFloat)fImageKBytes
           imageBlock:(void(^)(UIImage *image))block;

+ (NSString *)calculateTimeWithTimeFormatter:(long long )timeSecond;


+ (UILabel *)creatLabelWithText:(NSString *)text TextColStr:(UIColor *)textCol TextFontSize:(CGFloat)fontSize TextAlignment:(NSTextAlignment)textAlignment;

+ (UIButton *)creatButtonCustomWithNorTitle:(NSString *)norTitle norTextColor:(UIColor *)norColor norImage:(UIImage *)norImage seleTitle:(NSString *)seleTitle seleTextColor:(UIColor *)seleColor seleImage:(UIImage *)seleImage funtion:(SEL)funtion target:(id)target;



//排序的方法
+ (NSMutableArray *) getGameListDataBy:(NSMutableArray *)array withRank_style:(K_Rank_style)rank_style;
+ (NSMutableArray *) getGameListSectionBy:(NSMutableArray *)array;



+(void)makeLabelPatternForCurrentPriceWithLable:(UILabel *)label TitleStr:(NSString *)titleStr Content:(NSString *)content CurrentColor:(UIColor*)currentColor LastColor:(UIColor*)lastColor;
//给label根据人民币符号和小数点设置不一样大小
+ (void)makeLabelPatternForCurrentPriceWithLable:(UILabel *)lable content:(NSString *)content bigFontSize:(CGFloat)bigFontSize smallFontSize:(CGFloat)smallFontSize;
//给原价label设置删除线
+ (void)makeLabelPatternForOriginalPriceWithLable:(UILabel *)lable content:(NSString *)content;

@end
