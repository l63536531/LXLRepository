//
//  JKTool.m
//  LifeTelling
//
//  Created by IOS－001 on 15/4/22.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import "JKTool.h"

#import <CoreText/CoreText.h>

#import <AVFoundation/AVFoundation.h>

@implementation JKTool

#pragma mark - 类方法

+(CGFloat)sizeFactor
{
    CGFloat sizeFactor = 1.f;
    switch ([self devType]) {
        case DEVTYPEIPHONE4:
        {
            sizeFactor = 320.f/360.f;
        }
            break;
        case DEVTYPEIPHONE5:
        {
            sizeFactor = 320.f/360.f;//0.888888888888889
        }
            break;
        case DEVTYPEIPHONE6:
        {
            sizeFactor = 375.f/360.f;
        }
            break;
        case DEVTYPEIPHONE6P:
        {
            sizeFactor = 414.f/360.f;
        }
            break;
            
        default:
            break;
    }
    return sizeFactor;
}

+(DEVTYPE)devType
{
    DEVTYPE dtype = DEVTYPEIPHONE5;
    CGFloat screenW = SCREEN_WIDTH;
    CGFloat screenH = SCREEN_HEIGHT;
    if (screenW == 320.f) {
        if (screenH == 480.f) {
            dtype = DEVTYPEIPHONE4;
        }else if (screenH == 568.f)
        {
            dtype = DEVTYPEIPHONE5;
        }
    }else if (screenW == 375.f && screenH ==667.f)
    {
        dtype = DEVTYPEIPHONE6;
    }else if (screenW == 414.f && screenH ==736.f)
    {
        dtype = DEVTYPEIPHONE6P;
    }
    return dtype;
}
/**
 *  注意此处的转换，如 [@"7.1.2" float]，结果是7.0999
 *  故而，该方法只能准确得到整数部分，小数部分毫无意义。
 *
 *  @return 截取小数点后一位，
 */
+(float)iOSVersion
{
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    NSArray *components = [iosVersion componentsSeparatedByString:@"."];
    
    NSString *intPart = [components objectAtIndex:0];
    NSString *decimal = nil;
    if (components.count>=2) {
        decimal = [NSString stringWithFormat:@"0.%@",[components objectAtIndex:1]];
    }else
    {
        decimal = @"0";
    }
    
    CGFloat version = [intPart integerValue]+[decimal floatValue];
    
    return version;
}

+(NSString *)appVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

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
+ (BOOL)appVersion1:(NSString *)version1 isHeigherThanVersion2:(NSString *)version2 {
    
    NSArray *version1Components = [version1 componentsSeparatedByString:@"."];
    NSArray *version2Components = [version2 componentsSeparatedByString:@"."];
    
    NSInteger version1_1 = 0;
    NSInteger version1_2 = 0;
    NSInteger version1_3 = 0;
    
    NSInteger version2_1 = 0;
    NSInteger version2_2 = 0;
    NSInteger version2_3 = 0;
    
    for (int i = 0; i < version1Components.count; i++) {
        if (i == 0) {
            version1_1 = [version1Components[i] integerValue];
        }else if (i == 1) {
            version1_2 = [version1Components[i] integerValue];
        }else if (i == 2) {
            version1_3 = [version1Components[i] integerValue];
        }
    }
    
    for (int i = 0; i < version2Components.count; i++) {
        if (i == 0) {
            version2_1 = [version2Components[i] integerValue];
        }else if (i == 1) {
            version2_2 = [version2Components[i] integerValue];
        }else if (i == 2) {
            version2_3 = [version2Components[i] integerValue];
        }
    }
    
    if (version1_1 > version2_1) {
        return YES;
    }else if (version1_1 == version2_1) {
        //第一段相等，下面比较第二段
        if (version1_2 > version2_2) {
            return YES;
        }else if (version1_2 == version2_2) {
            //第二段相等，下面比较第三段
            if (version1_3 > version2_3) {
                return YES;
            }else {
                return NO;//小于或等于
            }
        }else {
            return NO;
        }
        //
    }else {
        return NO;
    }
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|//d{3})//d{7,8}$";
    
    
    /*
     14开头的号码目前为上网卡专属号段，如联通的是145，移动的是147等等。不过上网卡是无法使用语音通话业务的，只能使用上网业务和短信业务（联通的145号段的上网卡就可以发短信/接收短信）。所以你想买145号段的卡可以前往附近的移动、联通、电信的营业厅购买。
     145，147暂不支持
     */
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(NSString *)ToHex:(long long int)tmpShang
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int temYushu;
    
    while (1) {
        temYushu=tmpShang%16;
        tmpShang=tmpShang/16;
        switch (temYushu)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%zd",temYushu];
        }
        
        str = [nLetterValue stringByAppendingString:str];
        
        if (tmpShang == 0) {
            break;
        }
    }
    
    return str;
}

+(CGFloat)realSize:(CGFloat)size
{
    //因为参考的切图是iphone6,1920*1080，是每个point对应3*3个pixels.所以需要/3.f
    return (size/3.f)*[self sizeFactor];
}

+(UIEdgeInsets)insetsFromFrame:(CGRect)fFrame toFrame:(CGRect)tFrame
{
    CGFloat fOrgX = fFrame.origin.x;
    CGFloat fOrgY = fFrame.origin.y;
    CGFloat fMaxX = fOrgX+fFrame.size.width;
    CGFloat fMaxY = fOrgY+fFrame.size.height;
    
    CGFloat tOrgX = tFrame.origin.x;
    CGFloat tOrgY = tFrame.origin.y;
    CGFloat tMaxX = tOrgX+tFrame.size.width;
    CGFloat tMaxY = tOrgY+tFrame.size.height;
    
    CGFloat top = -(fOrgY-tOrgY);
    CGFloat left = -(fOrgX-tOrgX);
    CGFloat bottom = fMaxY-tMaxY;
    CGFloat right = fMaxX-tMaxX;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

#pragma mark - color

+(UIColor *)HexRGBColor:(NSString *)hexColorStr
{
    UIColor *rgbColor = [JKTool HexRGBColor:hexColorStr alpha:1.f];
    return rgbColor;
}

/**
 *  16进制RGB字符串生成UIColor
 *
 *  @param hexColorStr 字符串只能是'000000'到'FFFFFF'之间的值
 *
 *  @return UIColor ,if nil，means incorrect input value.
 */

//关于16进制转换成10进制，请百度:unsigned long strtoul(const char *nptr,char **endptr,int base);
+(UIColor *)HexRGBColor:(NSString *)hexColorStr alpha:(CGFloat)alpha
{
    UIColor *rgbColor = nil;
    
    NSString *regex = @"([a-f]|[A-F]|[0-9])+";
    //谓语表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (hexColorStr.length == 6 && [predicate evaluateWithObject:hexColorStr]) {
        
        char red_high = [hexColorStr characterAtIndex:0];
        char red_low = [hexColorStr characterAtIndex:1];
        NSInteger redValue = 16*[JKTool getDecimalFromHex:red_high]+[JKTool getDecimalFromHex:red_low];
        
        char green_high = [hexColorStr characterAtIndex:2];
        char green_low = [hexColorStr characterAtIndex:3];
        NSInteger greenValue = 16*[JKTool getDecimalFromHex:green_high]+[JKTool getDecimalFromHex:green_low];
        
        char blue_high = [hexColorStr characterAtIndex:4];
        char blue_low = [hexColorStr characterAtIndex:5];
        NSInteger blueValue = 16*[JKTool getDecimalFromHex:blue_high]+[JKTool getDecimalFromHex:blue_low];
        
        if ((redValue >= 0 && redValue <= 255)&&(greenValue >= 0 && greenValue <= 255)&&(blueValue >= 0 && blueValue <= 255)) {
            rgbColor = [UIColor colorWithRed:redValue/255.f green:greenValue/255.f blue:blueValue/255.f alpha:alpha];
        }
    }
    return rgbColor;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect frame = CGRectMake(0.f, 0.f, 1.f, 1.f);
    
    UIGraphicsBeginImageContext(frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, frame);
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return colorImage;
}

#pragma mark - mathematics

+ (NSInteger)getDecimalFromHex:(char)hexCharactor
{
    char asii_a = 'a';
    char asii_f = 'f';
    char asii_A = 'A';
    char asii_F = 'F';
    char asii_0 = '0';
    char asii_9 = '9';
    
    NSInteger result = -1;//-1表示输入的字符不是 0-9，a-f,A-F
    
    if (hexCharactor >= asii_0 && hexCharactor <= asii_9) {
        result = hexCharactor-asii_0;
    }else if (hexCharactor >= asii_a && hexCharactor <= asii_f)
    {
        result = 10+(hexCharactor-asii_a);
    }else if (hexCharactor >= asii_A && hexCharactor <= asii_F)
    {
        result = 10+(hexCharactor-asii_A);
    }
    
    return result;
}

+(NSNumber *)getNumberInt:(id)obj
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }else if ([obj isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithInteger:[(NSString *)obj integerValue]];
    }
    
    return @0;
}

+(NSNumber *)getNumberFloat:(id)obj
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }else if ([obj isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithInteger:[(NSString *)obj floatValue]];
    }
    
    return @0.f;
}

#pragma mark - textfield

/**
 *  @author 黎国基, 16-09-28 15:09
 *
 *  用于textfield委托- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 *  判断当前输入的值是否能组成符合预期规矩的数值
 *
 *  @param textField
 *  @param range
 *  @param string    当前输入的字符
 *  @param maxCount  预设的最大允许的小数位数
 *
 *  @return 是否允许该输入
 */
+ (BOOL)legalDicimalInputForTextField:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)string withMaxFractionDigits:(NSInteger)maxCount {
    
    if (string.length == 0) {
        return YES;//删除键
    }else {
        
        NSArray *numbers = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"."];
        if (range.location == 0) {
            if ([numbers containsObject:string] && ![string isEqualToString:@"."]) {
                return YES;//不能以'.'开头
            }
        }else {
            if ([numbers containsObject:string]) {
                
                if ([textField.text containsString:@"."]) {
                    if ([string isEqualToString:@"."]) {
                        return NO;//只允许输入一个'.'
                    }
                    
                    NSInteger locationOfDot = [textField.text rangeOfString:@"."].location;
                    //超过了限定位数的小数
                    if (range.location > locationOfDot + maxCount) {
                        return NO;
                    }
                }
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - string

+(NSString *)getStr:(id)obj
{
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }else if ([obj isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@",obj];
    }
    
    return @"";
}

+(BOOL)isNilStrOrSpace:(NSString *)str
{
    if (str == nil) {
        return YES;
    }
    
    NSString *strWithoutSpace = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([strWithoutSpace isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

+(NSString *)NoNilStringForString:(NSString *)originStr
{
    if (originStr != nil && [originStr isKindOfClass:[NSString class]] && originStr.length>0) {
        return originStr;
    }else
    {
        return @"";
    }
}

//无论传入什么，都返回一个非nil，且不含空白符的字符串
+ (NSString *)noNilOrSpaceStringForStr:(NSString *)originStr {
    
    if (originStr == nil || ![originStr isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    NSString *strWithoutSpace = [originStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return strWithoutSpace;
}

+(NSInteger)componentCountOfStr:(NSString *)cpnStr
{
    NSArray *tempArr = [self getArrayFromComponentStr:cpnStr];
    if (tempArr != nil) {
        return tempArr.count;
    }else
    {
        return 0;
    }
}

+(NSArray *)getArrayFromComponentStr:(NSString *)cpnStr
{
    NSArray *retArr = nil;
    
    if (cpnStr != nil) {
        NSArray *temArr = [cpnStr componentsSeparatedByString:@","];
        if (temArr != nil) {
            if (temArr.count == 1) {
                NSString *onlyStr = temArr[0];
                onlyStr = [onlyStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (onlyStr.length != 0) {
                    retArr = temArr;
                }
            }else
            {
                retArr = temArr;
            }
        }
    }
    
    return retArr;
}

+(NSMutableAttributedString *)attrStrWithStrings:(NSArray *)strComponents colors:(NSArray *)colors fonts:(NSArray *)fonts
{
    
     //strComponents必须为非空，
    if (strComponents == nil || strComponents.count == 0) {
        return nil;
    }
   
    NSString *combiledStr = @"";
    for (NSString *strComponent in strComponents) {
        combiledStr = [combiledStr stringByAppendingString:strComponent];
    }
    
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:combiledStr];
    
    //colors,fonts可以为nil，但如果不为nil，那么其array.count必须和strComponents.count相等！！
    
    BOOL setAttrColor = (colors != nil && colors.count == strComponents.count);
    BOOL setAttrFont = (fonts != nil && fonts.count == strComponents.count);
    
    NSInteger currentLocation = 0;
    for (int i = 0; i < strComponents.count; i++)
    {
        NSString *tempStrComponent = strComponents[i];
        if (setAttrColor) {
            [mAttrStr addAttribute:NSForegroundColorAttributeName value:colors[i] range:NSMakeRange(currentLocation, tempStrComponent.length)];
        }
        if (setAttrFont) {
            [mAttrStr addAttribute:NSFontAttributeName value:fonts[i] range:NSMakeRange(currentLocation, tempStrComponent.length)];
        }
        currentLocation = currentLocation+tempStrComponent.length;
    }
    return mAttrStr;
}

//获得指定最小整数位数、指定最大小数位数的字符串
+ (NSString *)strForDigit:(CGFloat)digit withMinInteger:(NSInteger)min maxFraction:(NSInteger)max {
    
    NSNumberFormatter *formmater = [[NSNumberFormatter alloc] init];
    formmater.minimumIntegerDigits = min;
    formmater.maximumFractionDigits = max;
    
    return [formmater stringFromNumber:@(digit)];
}

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
+ (NSString *)strFromNum:(id)num withMaxFracion:(NSInteger)max {
    
    NSString *numStr = [self strFromNum:num];
    
    if ([numStr rangeOfString:@"."].location != NSNotFound) {
        //如果存在小数点
        
        NSNumberFormatter *formmater = [[NSNumberFormatter alloc] init];
        formmater.minimumIntegerDigits = 1;
        formmater.maximumFractionDigits = max;
        
        NSNumber *number = [NSNumber numberWithFloat:[numStr floatValue]];
        
        return [formmater stringFromNumber:number];
    }
    
    return numStr;//无小数点
}

/**
 *  @author 黎国基, 16-11-02 14:11
 *
 *  传入NSString 或 NSNumber 或 nil 或 NSNul
 *
 *  @param num 传入的数值
 *
 *  @return 返回对应的数字字符串
 */
+ (NSString *)strFromNum:(id)num {
    
    NSNumberFormatter *formmater = [[NSNumberFormatter alloc] init];
    formmater.minimumIntegerDigits = 1;
    formmater.maximumFractionDigits = 14;//最多位小数
    
    if ([num isKindOfClass:[NSNumber class]]) {
        return [formmater stringFromNumber:num];
    }
    
    if ([num isKindOfClass:[NSString class]]) {
        NSString *nonilStr = [self noNilOrSpaceStringForStr:num];
        
        //正确的数字格式（包括负数）
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"^-[0-9]+([.][0-9]+)?$"];
        if ([predicate evaluateWithObject:nonilStr]) {
            return nonilStr;
        }
        //有数字，且以一个'.'结束（包括负数）
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"^-[0-9]+.$"];
        if ([predicate1 evaluateWithObject:nonilStr]) {
            return [nonilStr stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
        //以'.'开始，且后面有数字（不包括负数），'.98'->'0.98'，如果是'-.98'，直接返回错误'-'
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"^.[0-9]+$"];
        if ([predicate2 evaluateWithObject:nonilStr]) {
            return [@"0" stringByAppendingString:nonilStr];
        }
    }
    
    return @"-";
}

#pragma mark - decimalNumber

+ (NSDecimalNumber *)decimalNumberFromNumber:(id)number {
    
    if ([number isKindOfClass:[NSNumber class]]) {
        NSString *floatStr = [NSString stringWithFormat:@"%f",[number floatValue]];
        return [NSDecimalNumber decimalNumberWithString:floatStr];
    }
    
    if ([number isKindOfClass:[NSString class]]) {
        //绝对不要把string转成float.....得到的值并不一定是你想象中的那个
        return [NSDecimalNumber decimalNumberWithString:number];
    }
    
    if ([number isKindOfClass:[NSDecimalNumber class]]) {
        return (NSDecimalNumber *)number;
    }
    
    return nil;
}

#pragma mark - switch UIImage & Base64

//Base64图片 -> UIImage

+ (UIImage *) base64ToImage: (NSString *) imgStr
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:imgStr options:0];
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}

//UIImage -> Base64图片

+ (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (NSString *) imageToJpegBase64: (UIImage *) image
{
    NSData *jpegData = UIImageJPEGRepresentation(image, 0.1f);
    
    NSString *retStr = [jpegData base64EncodedStringWithOptions: 0];
    
    return retStr;//NSDataBase64Encoding64CharacterLineLength
}

/**
 *  上传到服务器的base64需要encodeURL才能显示！！
 *
 *  @param imageDataStr imageToJpegBase64:方法生成的字符串
 *
 *  @return 最终上传服务器的字符串
 */
+(NSString *)encodeURL:(NSString *)imageDataStr
{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)imageDataStr, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    
    if (!newString) {
        newString = @"";
    }
    return newString;
}


+ (UIImage *)fixOrientation:(UIImage *)orgImage {

// No-op if the orientation is already correct
    
    if (orgImage.imageOrientation == UIImageOrientationUp) return orgImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orgImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, orgImage.size.width, orgImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, orgImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, orgImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
            break;
        }
    switch (orgImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, orgImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, orgImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            case UIImageOrientationUp:
            case UIImageOrientationDown:
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
            break;
        }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, orgImage.size.width, orgImage.size.height,
                                                    CGImageGetBitsPerComponent(orgImage.CGImage), 0,
                                                    CGImageGetColorSpace(orgImage.CGImage),
                                                    CGImageGetBitmapInfo(orgImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (orgImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,orgImage.size.height,orgImage.size.width), orgImage.CGImage);
            break;
            default:
            CGContextDrawImage(ctx, CGRectMake(0,0,orgImage.size.width,orgImage.size.height), orgImage.CGImage);
            break;
        }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)image:(UIImage *)orgImage byScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = orgImage;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

#pragma mark - date
/**
 *  1秒 = 1000毫秒
 */
+(NSDate *)dateWithSeconsSince1970:(double_t)seconds
{
    if (seconds >= 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
        return date;
    }
    
    return nil;
}

+(NSDate *)dateWithMSeconsSince1970:(double_t)mSeconds
{
    if (mSeconds >= 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:mSeconds/1000.f];
        return date;
    }
    
    return nil;
}

+(NSString *)dateStringForDate:(NSDate *)date WithFormat:(NSString *)format
{
    if (date) {
        if (format == nil) {
            format = @"yyyy-MM-dd HH:mm:ss";
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = format;
        NSString *dateStr = [dateFormatter stringFromDate:date];
        return dateStr;
    }
    return nil;
}

//求一个日期所在的月的第一天
+ (NSDate *)monthBeginDateOfDate:(NSDate *)date {
    
    NSDate *beginDate = nil;        //月初日
    NSTimeInterval interval;
    //获取月初、月末
    
    NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    BOOL ok = [gregorianCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    
    if (ok) {
        return beginDate;
    }
    return nil;
}
//求一个日期所在的月的最后天
+ (NSDate *)monthEndDateOfDate:(NSDate *)date {
    
    NSDate *beginDate = nil;        //月初日
    NSDate *endDate = nil;          //月末日
    NSTimeInterval interval;
    //获取月初、月末
    
    NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    BOOL ok = [gregorianCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval - 1];
        return endDate;
    }
    return nil;
}
//返回一个日期的0点 date
+(NSDate *)dateZero_ofDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    NSDate *todayZero =  [NSDate dateWithTimeIntervalSince1970:ts];
    return todayZero;
}

//返回一个日期的23:59:59 date
+(NSDate *)dateMaxSecond_ofDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    NSDate *todayMax =  [NSDate dateWithTimeIntervalSince1970:ts];
    return todayMax;
}

#pragma mark - separate label text
/**
 *  将一段文本贴到label中，找label出每一行所包含的文字。
 *
 *  @param text    初始文本
 *  @param lbWidth label的实际宽度
 *  @param font    label的font
 *
 *  @return 分离成单行文本的text
 */
+ (NSArray *)getSeparatedLinesFromLabelText:(NSString *)text Width:(CGFloat)lbWidth font:(UIFont *)font
{
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,lbWidth,MAXFLOAT));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(frameSetter);
    CFRelease(path);//_jack, add
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
     CFRelease(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}


/**
 *  获取 根据指定行数 截断后的字符串(如果实际行数未达到预期行数，则取实际字符串)
 *  宁少勿多
 *
 *  @param strArray 见getSeparatedLinesFromLabelText:Width:font:
 *  @param count    指定的行数
 *
 *  @return 字符串，如果超出指定行数，则在第count-1行末尾添加"..."
 */
+(NSString *)trucatedStringForStringArray:(NSArray *)strArray lineCount:(NSInteger)count
{
    NSString *retStr = @"";
    
    if (strArray.count <= count) {
        for (int i = 0; i < strArray.count; i++) {
            retStr = [retStr stringByAppendingString:strArray[i]];
        }
    }else
    {
        for (int i = 0; i < count-1; i++) {
            retStr = [retStr stringByAppendingString:strArray[i]];
        }
        NSString *trail = strArray[count-1];
        trail = [trail stringByReplacingCharactersInRange:NSMakeRange(trail.length-3, 3) withString:@"..."];
        retStr = [retStr stringByAppendingString:trail];
    }
    
    return retStr;
}

/**
 *  获取 根据指定行数 适当的字符串(如果实际行数未达到预期行数，则添加空行)
 *  宁少勿多
 *
 *  @param strArray 见getSeparatedLinesFromLabelText:Width:font:
 *  @param count    指定的行数
 *
 *  @return 字符串，如果超出指定行数，则在第count-1行末尾添加"..."
 */

+(NSString *)fitedStringForStringArray:(NSArray *)strArray lineCount:(NSInteger)count
{
    NSString *retStr = @"";
    
    if (strArray.count <= count) {
        for (int i = 0; i < count; i++) {
            if (i < strArray.count) {
                retStr = [retStr stringByAppendingString:strArray[i]];
            }else
            {
                retStr = [retStr stringByAppendingString:@"\n"];
            }
        }
    }else
    {
        for (int i = 0; i < count-1; i++) {
            retStr = [retStr stringByAppendingString:strArray[i]];
        }
        NSString *trail = strArray[count-1];
        trail = [trail stringByReplacingCharactersInRange:NSMakeRange(trail.length-3, 3) withString:@"..."];
        retStr = [retStr stringByAppendingString:trail];
    }
    
    return retStr;
}

#pragma mark - array

+(NSArray *)getArray:(id)obj
{
    if ([obj isKindOfClass:[NSArray class]]) {
        return obj;
    }
    return nil;
}

+(NSMutableArray *)getMArray:(id)obj
{
    if ([obj isKindOfClass:[NSArray class]])
    {
        NSMutableArray *mArray = [[NSMutableArray alloc]initWithArray:obj];
        return mArray;
    }
    return nil;
}

#pragma mark - dictionary

+(NSDictionary *)getDictionary:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return nil;
}

+(NSMutableDictionary *)getMDictionary:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithDictionary:obj];
        return mDic;
    }
    return nil;
}

#pragma mark - 判断系统设置里是否打开此软件的通知
//两种方法。。。待验证

+ (BOOL)isAllowedNotification {
   //iOS8 check if user allow notification
    CGFloat iosVersion = [JKTool iOSVersion];
    if (iosVersion >= 8.0f)
    {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types)
        {
            return YES;
        }
    }else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}

+(BOOL)isAllowedPushNotification
{
    BOOL ret = NO;
    CGFloat iosVersion = [JKTool iOSVersion];
    if(iosVersion >= 8.0f){//isIOS8
        BOOL isRemoteNotify = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
        ret = isRemoteNotify;
    }
    else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        int typeBadge = (type & UIRemoteNotificationTypeBadge);
        int typeSound = (type & UIRemoteNotificationTypeSound);
        int typeAlert = (type & UIRemoteNotificationTypeAlert);
        ret =  !typeBadge || !typeSound || !typeAlert;
    }
    return ret;
}


#pragma mark - UserDefults

+(NSDictionary *)getCurrentLocationCoordinate
{
    NSDictionary *locatedCityInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"ALocatedCityInfo"];
    NSDictionary *addressComponentDic = locatedCityInfo[@"addressComponent"];
    NSDictionary *streetNoDic = addressComponentDic[@"streetNumber"];
    NSDictionary *locationDic = streetNoDic[@"location"];
    return locationDic;//@"latitude",@"longitude"
}

#pragma mark -
+(void)showImageAtX:(CGFloat)X Y:(CGFloat)Y width:(CGFloat)width height:(CGFloat)height btn:(UIButton *)btn
{
    //当传入Y<0时，让imageview垂直方向居中
    
    CGRect fromeFrame = btn.imageView.frame;
    CGFloat imgY = Y;
    if (imgY<0) {
        imgY = (btn.frame.size.height-height)/2.f;
    }
    CGRect toFrame = CGRectMake(X, imgY, width, height);
    UIEdgeInsets insets = [JKTool insetsFromFrame:fromeFrame toFrame:toFrame];
    [btn setImageEdgeInsets:insets];
}

+(void)showTitleAtX:(CGFloat)X Y:(CGFloat)Y width:(CGFloat)width height:(CGFloat)height btn:(UIButton *)btn
{
    //当传入Y<0时，让titleLabel垂直方向居中
    
    CGRect fromeFrame = btn.titleLabel.frame;
    CGFloat imgY = Y;
    if (imgY<0) {
        imgY = (btn.frame.size.height-height)/2.f;
    }
    
    CGRect toFrame = CGRectMake(X, imgY, width, height);
    UIEdgeInsets insets = [JKTool insetsFromFrame:fromeFrame toFrame:toFrame];
    [btn setTitleEdgeInsets:insets];
}

/**
 *  @author 黎国基, 16-08-06 17:08
 *
 *  判断当前是否可接入captureDevice/captureSession（摄像头不可用或被占用）
 *
 *  @return 是否可用
 */
+ (BOOL)captureDeviceCurrentlyAvailable
{
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (input == nil) {
        return NO;
    }
    return YES;
}

/**
 *  @author 黎国基, 16-09-12 15:09
 *
 *  返回 最小rate和最大rate之间的差值
 *
 *  @return
 */
+ (CGFloat)speechRateDistance {
    
    CGFloat rateDistance = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate;
    return rateDistance;
}

/**
 *  @author 黎国基, 16-09-12 15:09
 *
 *  配置本app的语速
 *
 *  @return speachrate
 */
+ (CGFloat)defaultAppSpeechRate
{
    CGFloat myRate = 0.55f;  //最小rate * (maxrate - minrate)
    
    CGFloat rateDistance = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate; // == 1
    CGFloat myDefaultRate = AVSpeechUtteranceMinimumSpeechRate + rateDistance * myRate;
    return myDefaultRate;
}
#pragma mark - 单例

+ (instancetype)sharedInstance {
    
    static JKTool *tool  = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [[JKTool alloc] init];
        
        tool.keywindowCunstomViews = [[NSMutableArray alloc] init];
    });
    return tool;
}

#pragma mark - 对象方法

- (void)clearCustomViewsOnKeywindow {
    
    for (UIView *customView in _keywindowCunstomViews) {
        [customView removeFromSuperview];
    }
    
    [_keywindowCunstomViews removeAllObjects];
}

@end
