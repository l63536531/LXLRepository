//
//  JKTool.h
//  LifeTelling
//
//  Created by IOS－001 on 15/4/22.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import "JKDecimalTool.h"

typedef NS_ENUM(NSInteger, DEVTYPE) {
    DEVTYPEIPHONE4 = 0,    //320*480
    DEVTYPEIPHONE5,        //320*568
    DEVTYPEIPHONE6,        //375*667
    DEVTYPEIPHONE6P        //414*736
};

@interface JKTool : NSObject

+(float)iOSVersion;

+(DEVTYPE)devType;

/**
 *  app的版本号
 *
 *  @return 是Version,非Build
 */
+(NSString *)appVersion;

/**
 *  @author 黎国基, 16-08-27 16:08
 *
 *  判断一个app版本是否比另一个版本更高（相等、小于都返回NO）
 *
 *  @param version1 比较版本1
 *  @param version2 比较版本2
 *
 *  @return version1是否高于version2
 */
+ (BOOL)appVersion1:(NSString *)version1 isHeigherThanVersion2:(NSString *)version2;
/**
 *  比例因子，以iphone6 plus为基准
 *  取标iphone6 plus物理像素px:1080*1920，:360*640,因为切图是这个尺寸
 *  如，iphone 6+ 总宽度为360
 *  iphone5 总宽度为320
 *  则在iphone5上，水平比例因子为 320/360
 *  因为设计以iphone6+为准，所以，在iphone6+上，宽度为100的view
 *  在iphone5上，其宽度为 100*(320/414)=77.3
 *  iphone5,6,6+宽高比是一致的，但iphone4宽高比不同于其他，故而参考时需谨慎
 */

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/*
    10进制数转16进制，结果是字符串，字母大写，无Prefix  0x，
    例子：输入 14，输出 @"E"
 */
+(NSString *)ToHex:(long long int)tmpShang;

+(CGFloat)sizeFactor;

+(NSString *)NoNilStringForString:(NSString *)originStr;

//无论传入什么，都返回一个非nil，且不含空白符的字符串
+ (NSString *)noNilOrSpaceStringForStr:(NSString *)originStr;

/**
 *  根据1080*1920像素下的切图，计算出在具体设备上的points点数
 *  如，像素1080在iphone5下，sizeFactor = 320.f/360.f
 *  realSize = 1080/3*sizeFactor=320.f;
 */

+(CGFloat)realSize:(CGFloat)size;

#pragma mark - color

/**
 *  用于UIButton内，imageview,titlelabel位置的移动，
 *  计算出从fFrame移动到tFrame处所需要的偏移量
 *
 *  @param fFrame imageview的frame.
 *  @param tFrame 最终图片所需要展示的区域
 *
 *  imageEdgeInsets;                // default is UIEdgeInsetsZero
 *  titleEdgeInsets;                // default is UIEdgeInsetsZero
 */

/**
 *  支持大小写
 *
 *  @param hexColorStr 16进制颜色值字符串，如@"FF0000"
 *
 *  @return 颜色UIColor
 */
+(UIColor *)HexRGBColor:(NSString *)hexColorStr;

+(UIColor *)HexRGBColor:(NSString *)hexColorStr alpha:(CGFloat)alpha;

+ (UIImage *)imageWithColor:(UIColor *)color;

+(NSInteger)getDecimalFromHex:(char)hexCharactor;

+(NSNumber *)getNumberInt:(id)obj;

+(NSNumber *)getNumberFloat:(id)obj;

#pragma mark - textfield;

+ (BOOL)legalDicimalInputForTextField:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)string withMaxFractionDigits:(NSInteger)maxCount;

#pragma mark - string

+(NSString *)getStr:(id)obj;

+(BOOL)isNilStrOrSpace:(NSString *)str;

+(NSInteger)componentCountOfStr:(NSString *)cpnStr;

+(NSArray *)getArrayFromComponentStr:(NSString *)cpnStr;

+(NSAttributedString *)attrStrWithStrings:(NSArray *)strComponents colors:(NSArray *)colors fonts:(NSArray *)fonts;

//获得指定最小整数位数、指定最大小数位数的字符串
+ (NSString *)strForDigit:(CGFloat)digit withMinInteger:(NSInteger)min maxFraction:(NSInteger)max;

/**
 *  @author 黎国基, 16-11-02 11:11
 *
 *  传入NSString 或 NSNumber 或 nil 或 NSNul
 *
 *  @param num 传入的数值
 *  @param max 最大小数位数
 *
 *  @return 结果至少保留一位整数。如果传入的不是数字，则返回'-'
 */
+ (NSString *)strFromNum:(id)num withMaxFracion:(NSInteger)max;

#pragma mark - decimalNumber

+ (NSDecimalNumber *)decimalNumberFromNumber:(id)number;

#pragma mark - switch UIImage & Base64

+ (UIImage *) base64ToImage: (NSString *) imgStr;

/**
 *  转换后的base64码可在
 *  http://www.vgot.net/test/image2base64.php 中直接显示为图片
 *  但上传服务器后显示乱码
 *  经过encodeURL:的字符串在http://www.vgot.net/test/image2base64.php 中无法显示图片
 *  但上传服务器后，能显示出来正确图片。
 *
 */
+ (NSString *) imageToJpegBase64: (UIImage *) image;

/**
 *  上传到服务器的base64需要encodeURL才能显示！！
 *
 *  @param imageDataStr imageToJpegBase64:方法生成的字符串
 *
 *  @return 最终上传服务器的字符串
 */
+(NSString *)encodeURL:(NSString *)imageDataStr;

/**
 *  @author 黎国基, 16-08-20 18:08
 *
 *  图片方位调整（图片是正位，而不是横着的）
 *
 *  @param orgImage 原始图片
 *
 *  @return 输出图片
 */
+ (UIImage *)fixOrientation:(UIImage *)orgImage;

/**
 *  @author 黎国基, 16-08-20 19:08
 *
 *  图片缩小
 *
 *  @param orgImage   原始图片
 *  @param targetSize 目标图片大小
 *
 *  @return 缩小后的图片，可为nil
 */
+ (UIImage *)image:(UIImage *)orgImage byScalingToSize:(CGSize)targetSize;

#pragma mark - date
/**
 *  单位是秒
 */
+(NSDate *)dateWithSeconsSince1970:(double_t)seconds;
/**
 *  单位是毫秒
 */
+(NSDate *)dateWithMSeconsSince1970:(double_t)mSeconds;

+(NSString *)dateStringForDate:(NSDate *)date WithFormat:(NSString *)format;
//求一个日期所在的月的第一天
+ (NSDate *)monthBeginDateOfDate:(NSDate *)date;
//求一个日期所在的月的最后天
+ (NSDate *)monthEndDateOfDate:(NSDate *)date;

/**
 *返回一个日期的0点 date
*/
+(NSDate *)dateZero_ofDate:(NSDate *)date;

/**
 *  @author 黎国基, 16-09-03 18:09
 *
 *  //返回一个日期的23:59:59 date
 *
 *  @param date 输入的日期
 *
 *  @return //返回一个日期的23:59:59 date
 */
+(NSDate *)dateMaxSecond_ofDate:(NSDate *)date;

#pragma mark - separate label text

+ (NSArray *)getSeparatedLinesFromLabelText:(NSString *)text Width:(CGFloat)lbWidth font:(UIFont *)font;

+(NSString *)trucatedStringForStringArray:(NSArray *)strArray lineCount:(NSInteger)count;

+(NSString *)fitedStringForStringArray:(NSArray *)strArray lineCount:(NSInteger)count;

#pragma mark - array

+(NSArray *)getArray:(id)obj;

+(NSMutableArray *)getMArray:(id)array;

+(NSDictionary *)getDictionary:(id)obj;

+(NSMutableDictionary *)getMDictionary:(id)obj;

#pragma mark - 判断系统设置里是否打开此软件的通知

+ (BOOL)isAllowedNotification;

#pragma mark - UserDefults

+(NSDictionary *)getCurrentLocationCoordinate;

#pragma mark - 

+(UIEdgeInsets)insetsFromFrame:(CGRect)fFrame toFrame:(CGRect)tFrame;

+(void)showImageAtX:(CGFloat)X Y:(CGFloat)Y width:(CGFloat)width height:(CGFloat)height btn:(UIButton *)btn;

+(void)showTitleAtX:(CGFloat)X Y:(CGFloat)Y width:(CGFloat)width height:(CGFloat)height btn:(UIButton *)btn;

+ (BOOL)captureDeviceCurrentlyAvailable;

/**
 *  @author 黎国基, 16-09-12 15:09
 *
 *  返回 最小rate和最大rate之间的差值
 *
 *  @return
 */
+ (CGFloat)speechRateDistance;

/**
 *  @author 黎国基, 16-09-12 15:09
 *
 *  配置本app的语速
 *
 *  @return speachrate
 */
+ (CGFloat)defaultAppSpeechRate;

#pragma mark - 属性、对象方法

/**
 *  @author 黎国基, 16-09-12 13:09
 *
 *  用于统一管理加在Keywindow上的子视图，方便统一清理。每次添加customview到keywindow时，同时加入keywindowCunstomViews
 *  统一清理时，调用clearCustomViewsOnKeywindow
 */
@property (nonatomic, strong) NSMutableArray *keywindowCunstomViews;

+ (instancetype)sharedInstance;

/**
 *  @author 黎国基, 16-09-12 13:09
 *
 *  统一清理keywindow上的customview（仅能清理那些已经手动添加进keywindowCunstomViews的子视图）
 */
- (void)clearCustomViewsOnKeywindow;

@end