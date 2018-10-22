//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "Tool.h"


@interface Tool ()


@end

@implementation Tool
/**
 *  获取当前时间的时间戳（例子：1464326536）
 *
 *  @return 时间戳字符串型
 */
+ (NSString *)getCurrentTimestamp
{
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];

    NSInteger i =(NSInteger)a;
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)i];

    // 转为字符型
    return timeString;
}

/**
 *  获取当前标准时间（例子：2015-02-03）
 *
 *  @return 标准时间字符串型
 */
+ (NSString *)getCurrentStandarTime
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMddHHMMss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

/**
 *  时间戳转换为时间的方法
 *
 *  @param timestamp 时间戳
 *
 *  @return 标准时间字符串
 */
+ (NSString *)timestampChangesStandarTime:(NSString *)timestamp
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
}
+ (NSString *)timeToweek:(NSString *)time{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *formatterDate = [inputFormatter dateFromString:time];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //    [outputFormatter setDateFormat:@"HH:mm 'on' EEEE MMMM d"];
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
    [outputFormatter setDateFormat:@"EEEE"];
    NSString *newDateString = [outputFormatter stringFromDate:formatterDate];
    return newDateString;
}

+ (NSString *)timeToBrith:(NSString *)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)timeToMonth:(NSString *)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)timeToYear:(NSString *)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
/**
 *  手机号码验证
 *
 *  @param NSString 手机号码字符串
 *
 *  @return 是否手机号
 *
 *  (13[0-9]) 13开头
 */
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(17[0-9])|(14[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/**
 *  验证认证
 *
 *  @param NSString 密码字符串
 *
 *  @return 是否密码
 *  {6,20}  6到20位
 */
+ (BOOL) validateVerify:(NSString *)verifyCode
{
    NSString *passWordRegex = @"^[0-9]{4}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:verifyCode];
}

//判断是否为邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断内容是否全部为空格
+ (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

//判断用户密码6-16位数字或字母组合
+ (BOOL)checkPassword:(NSString *)password
{
//    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}"; // 6-16位数字和字母组合
    NSString *pattern = @"^[a-z0-9A-Z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}
#pragma mark 文字提示框
+(void)addTextTipsDialog:(NSString*) aText
{
    TIpViewTool* tipView=[[TIpViewTool alloc]init];
    [tipView showTipWithText:aText];
}

+(void)addTextWithEmoJi:(NSString*) aText{
    
    TIpViewTool* tipView=[[TIpViewTool alloc]init];
    [tipView eMoJiShowTipWithText:aText];
    
}


+(void)addTextTopTipsDialog:(NSString*) aText
{
    TIpViewTool* tipView=[[TIpViewTool alloc]init];
    [tipView showTopTipWithText:aText];
}
+ (CGFloat) P_updateHeightWithStr:(NSString *)labelStr fontSize:(CGFloat)fontsize labelWidth:(CGFloat)lbWidth;
{
    if ([labelStr isEqualToString:@""]) {
        labelStr=nil;
    } 
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping ;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontsize], NSParagraphStyleAttributeName:paragraphStyle};
    CGSize abelSize = [labelStr boundingRectWithSize:CGSizeMake(lbWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return abelSize.height+1.1;
    
}

#pragma mark -  boundingRectWithSize 代替 sizeWithFont  Label自适应高度
+(CGSize) getAdaptionSizeWithText:(NSString *)sendText andFont:(UIFont *)sendFont andLabelWidth:(CGFloat)sendWidth
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:sendFont, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize abelSize = [sendText boundingRectWithSize:CGSizeMake(sendWidth, 1999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return abelSize;
}

//Label自适应宽度
+(CGSize) getAdaptionSizeWithText:(NSString *)sendText AndFont:(CGFloat )sendFont andLabelHeight:(CGFloat)sendHeight
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:sendFont], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize abelSize = [sendText boundingRectWithSize:CGSizeMake(999, sendHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return abelSize;
}

//时间排序
+ (NSString *)setCreatTime:(NSString *)timeStr
{
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    
    NSTimeInterval cha = now - [timeStr intValue];
    
    if (cha / 3600 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        if ([timeString isEqualToString:@"0"])
        {
            timeString = [NSString stringWithFormat:@"%f", cha / 60];
            timeString = [NSString stringWithFormat:@"%d秒前", (int)([timeString floatValue] * 60)];
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    if (cha / 3600 > 1 && cha / 86400 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 3600];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha / 86400 > 1)
    {
        timeString = [Tool timestampChangesStandarTime:timeStr];
    }
    return timeString;
}

//游戏时间排序
+ (NSString *)setCreatTime1:(NSString *)timeStr
{
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    
    NSTimeInterval cha = now - [timeStr intValue];
    
    if (cha / 3600 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        if ([timeString isEqualToString:@"0"])
        {
            timeString = [NSString stringWithFormat:@"1分钟前在玩"];
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%@分钟前在玩", timeString];
        }
    }
    if (cha / 3600 > 1 && cha / 86400 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 3600];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString = [NSString stringWithFormat:@"%@小时前在玩", timeString];
    }
    if (cha / 86400 > 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前在玩", timeString];
        if ([timeString intValue] > 365) {
            timeString = [NSString stringWithFormat:@"1年前在玩"];
        }
    }
    return timeString;
}

+ (NSString *)getOrderlLastTime:(NSString *)timeStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dates = [formatter dateFromString:timeStr];
    // 时间转时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dates timeIntervalSince1970]];
    
    NSString *nowTimeSp = [Tool getCurrentTimestamp];
    NSString *timeString = @"";
    
//    NSTimeInterval chas = ([nowTimeSp intValue] - [timeSp intValue]);
    NSTimeInterval cha = 7200 - ([nowTimeSp intValue] - [timeSp intValue]);
    if (cha < 0) {
        timeString = @"0小时00分钟";
    }else if (cha / 3600 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha / 60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        if (timeString.length <= 1) {
            timeString = [NSString stringWithFormat:@"0小时0%@分钟", timeString];
        }else {
            timeString = [NSString stringWithFormat:@"0小时%@分钟", timeString];
        }
    }else if (cha / 3600 > 1){
        timeString = [NSString stringWithFormat:@"%f", (cha - 3600) / 60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        if (timeString.length < 1) {
            timeString = [NSString stringWithFormat:@"1小时0%@分钟", timeString];
        }else {
            timeString = [NSString stringWithFormat:@"1小时%@分钟", timeString];
        }
    }
    return timeString;
}

//今天的具体时间  时分
+ (NSString *)timestampChangesTodayStandarTime:(NSString *)timestamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    if ([dateSMS isEqualToString:dateNow]) {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    }
    dateSMS = [dateFormatter stringFromDate:date];
    
    return dateSMS;
}

//消息时间轴
+ (NSString *)timestampToMessageTimeline:(NSString *)timestamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    
    NSArray *SMSArr = [dateSMS componentsSeparatedByString:@"-"];
    NSArray *NowArr = [dateNow componentsSeparatedByString:@"-"];
    
    //判断年是否相等
    if (![SMSArr[0] isEqualToString:NowArr[0]]) {
        return [NSString stringWithFormat:@"%@年%@月%@日", SMSArr[0], SMSArr[1], SMSArr[2]];
    }else{
        //如果年月日都相等
        if ([dateSMS isEqualToString:dateNow]) {
            [dateFormatter setDateFormat:@"HH:mm"];
            return [dateFormatter stringFromDate:date];
        }else{
            //昨天
            NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-86400];
            NSString *yesterDayStr = [dateFormatter stringFromDate:yearsterDay];
            if ([yesterDayStr isEqualToString:dateSMS]) {
                return @"昨天";
            }
            
            NSDate* dat = [NSDate date];
            NSString *timeString = @"";
            NSTimeInterval now = [dat timeIntervalSince1970]*1;
            NSTimeInterval cha = now - [timestamp intValue];
            if (cha / 86400 > 1){
                timeString = [NSString stringWithFormat:@"%d", (int)(cha/86400)];
                
                if ([timeString intValue] < 7){
                    //星期
                    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    NSDateComponents *comps = [[NSDateComponents alloc] init];
                    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
                    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                    comps = [calendar components:unitFlags fromDate:date];
                    NSInteger week = [comps weekday]-1;
                    if (week == 0) {
                        return @"星期日";
                    }else if (week == 1){
                        return @"星期一";
                    }else if (week == 2){
                        return @"星期二";
                    }else if (week == 3){
                        return @"星期三";
                    }else if (week == 4){
                        return @"星期四";
                    }else if (week == 5){
                        return @"星期五";
                    }else if (week == 6){
                        return @"星期六";
                    }
                }else{
                    //月日
                    return [NSString stringWithFormat:@"%@月%@日", SMSArr[1], SMSArr[2]];
                }
                
            }
        }
    }
    return nil;
}

//聊天消息时间是否显示
+ (BOOL)showWithOldTimestamp:(NSString *)OldTimestamp andNewTimestamp:(NSString *)NewTimestamp
{
    NSTimeInterval cha = [NewTimestamp intValue] - [OldTimestamp intValue];
    NSString *timeString = @"";
    if (cha / 3600 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        if ([timeString isEqualToString:@"0"]){
            return NO;
        }
        return YES;
    }
    return YES;
}


+ (NSString *)showTimeWithDate:(NSDate *)createDate
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:createDate];
    if (timeInterval < 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [dateFormatter stringFromDate:createDate];
    } else {
        //        int days    = (int)(timeInterval/(3600*24));
        //        int hours   = (int)((timeInterval - days*24*3600)/3600);
        //        int minute  = (int)(timeInterval - days*24*3600 - hours*3600)/60;
        //        int second  = timeInterval - days*24*3600 - hours*3600 - minute*60;
        //        if (days != 0) {
        //            return [NSString stringWithFormat:@"%d天前",days];
        //        } else if (hours != 0) {
        //            return [NSString stringWithFormat:@"%d小时前",hours];
        //        } else if (minute != 0) {
        //            return [NSString stringWithFormat:@"%d分钟前",minute];
        //        } else {
        //            return [NSString stringWithFormat:@"%d秒前",second];
        //        }
        
        
        long temp = 0;
        NSString *result;
        if (timeInterval < 60) {
            result = [NSString stringWithFormat:@"刚刚"];
        }
        else if((temp = timeInterval/60) <60){
            result = [NSString stringWithFormat:@"%ld分钟前",temp];
        }
        
        else if((temp = temp/60) <24){
            result = [NSString stringWithFormat:@"%ld小时前",temp];
        }
        
        else if((temp = temp/24) <30){
            result = [NSString stringWithFormat:@"%ld天前",temp];
        }
        
        else if((temp = temp/30) <12){
            result = [NSString stringWithFormat:@"%ld月前",temp];
        }
        else{
            temp = temp/12;
            result = [NSString stringWithFormat:@"%ld年前",temp];
        }
        return  result;
    }
}

//颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

//判断是否是10位时间戳
+ (NSString *)timestampIsRightTime:(NSString *)timeStr
{
    if (timeStr.length < 10) {
        return [Tool getCurrentTimestamp];
    }else{
        return [timeStr substringToIndex:10];
    }
}

//判断输入的文本是否有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (UIImage*)getImgWithImgUrlString:(NSString *)imgUrl
{
    if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgUrl]) {
        NSData *imageData = UIImageJPEGRepresentation([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgUrl], 0.2);
        return  [Tool  imgWithDATA:imageData];
    }
    NSData *IMGdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    return  [Tool  imgWithDATA:IMGdata];
}

+ (UIImage *)imgWithDATA:(NSData *)imgDATA{
    
    if (imgDATA.length<30000) {
        UIImage *img = [UIImage imageWithData:imgDATA];
        return img;
    }
    else{
        
                UIImage *tempImg = [UIImage imageWithData:imgDATA];
        
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.1f;
        NSData *imageData = UIImageJPEGRepresentation(tempImg, compression);
        while ([imageData length] > 30000 && compression > maxCompression) {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(tempImg, compression);
        }
        
        UIImage *compressedImage = [UIImage imageWithData:imageData];
        return compressedImage;
        
//        NSData *tempData=imgDATA;
//        
//        UIImage *tempImg = [UIImage imageWithData:imgDATA];
//        
//        
//        
//        while (tempData.length>30000) {
//            tempData = UIImageJPEGRepresentation(tempImg, 0.5);
//            tempImg =[UIImage imageWithData:tempData];
//            
//        }
//        UIImage  *image = [UIImage imageWithData:tempData];
//        
//        return image;
        
    //}

    }}

+ (void)zipImageFiles:(UIImage *)image
              imageKB:(CGFloat)fImageKBytes
           imageBlock:(void(^)(UIImage *image))block {
    
    __block UIImage *imageCope = image;
    CGFloat fImageBytes = fImageKBytes * 1024;//需要压缩的字节Byte
    
    __block NSData *uploadImageData = nil;
    
    uploadImageData = UIImagePNGRepresentation(imageCope);
    NSLog(@"图片压前缩成 %fKB",uploadImageData.length/1024.0);
    CGSize size = imageCope.size;
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height;
    
    if (uploadImageData.length > fImageBytes && fImageBytes >0) {
        
        dispatch_async(dispatch_queue_create("ZipImage", DISPATCH_QUEUE_SERIAL), ^{
            
            /* 宽高的比例 **/
            CGFloat ratioOfWH = imageWidth/imageHeight;
            /* 压缩率 **/
            CGFloat compressionRatio = fImageBytes/uploadImageData.length;
            /* 宽度或者高度的压缩率 **/
            CGFloat widthOrHeightCompressionRatio = sqrt(compressionRatio);
            
            CGFloat dWidth   = imageWidth *widthOrHeightCompressionRatio;
            CGFloat dHeight  = imageHeight*widthOrHeightCompressionRatio;
            if (ratioOfWH >0) { /* 宽 > 高,说明宽度的压缩相对来说更大些 **/
                dHeight = dWidth/ratioOfWH;
            }else {
                dWidth  = dHeight*ratioOfWH;
            }
            
           // imageCope = [self drawWithWithImage:imageCope width:dWidth height:dHeight];
           // uploadImageData = UIImagePNGRepresentation(imageCope);
            
            NSLog(@"当前的图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            //微调
            NSInteger compressCount = 0;
            /* 控制在 1M 以内**/
            while (fabs(uploadImageData.length - fImageBytes) > 1024) {
                /* 再次压缩的比例**/
                CGFloat nextCompressionRatio = 0.9;
                
                if (uploadImageData.length > fImageBytes) {
                    dWidth = dWidth*nextCompressionRatio;
                    dHeight= dHeight*nextCompressionRatio;
                }else {
                    dWidth = dWidth/nextCompressionRatio;
                    dHeight= dHeight/nextCompressionRatio;
                }
                
                imageCope = [Tool  drawWithWithImage:imageCope width:dWidth height:dHeight];
                uploadImageData = UIImagePNGRepresentation(imageCope);
                
                /*防止进入死循环**/
                compressCount ++;
                if (compressCount == 10) {
                    break;
                }
                
            }
            
            NSLog(@"图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            imageCope = [[UIImage alloc] initWithData:uploadImageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(imageCope);
            });
        });
    }
    else
    {
        block(imageCope);
    }
}

/* 根据 dWidth dHeight 返回一个新的image**/
+ (UIImage *)drawWithWithImage:(UIImage *)imageCope width:(CGFloat)dWidth height:(CGFloat)dHeight{
    
    UIGraphicsBeginImageContext(CGSizeMake(dWidth, dHeight));
    [imageCope drawInRect:CGRectMake(0, 0, dWidth, dHeight)];
    imageCope = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCope;
    
}
+ (NSString *)calculateTimeWithTimeFormatter:(long long )timeSecond{
    
    NSString * theLastTime = nil;
    if (timeSecond < 60) {
        theLastTime = [NSString stringWithFormat:@"00:%.2lld", timeSecond];
    }else if(timeSecond >= 60 && timeSecond < 3600){
        theLastTime = [NSString stringWithFormat:@"%.2lld:%.2lld", timeSecond/60, timeSecond%60];
    }else if(timeSecond >= 3600){
        theLastTime = [NSString stringWithFormat:@"%.2lld:%.2lld:%.2lld", timeSecond/3600, timeSecond%3600/60, timeSecond%60];
    }
    return theLastTime;
}
+ (UILabel *)creatLabelWithText:(NSString *)text TextColStr:(UIColor *)textCol TextFontSize:(CGFloat)fontSize TextAlignment:(NSTextAlignment)textAlignment{
    
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.textColor = textCol;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = textAlignment;
    label.numberOfLines = 0;
    return label;
}

+ (UIButton *)creatButtonCustomWithNorTitle:(NSString *)norTitle norTextColor:(UIColor *)norColor norImage:(UIImage *)norImage seleTitle:(NSString *)seleTitle seleTextColor:(UIColor *)seleColor seleImage:(UIImage *)seleImage funtion:(SEL)funtion target:(id)target{
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:norTitle forState:UIControlStateNormal];
    [button setTitle:seleTitle forState:UIControlStateSelected];
    
    [button setTitleColor:norColor forState:UIControlStateNormal];
    [button setTitleColor:seleColor forState:UIControlStateSelected];
    
    [button addTarget:target action:funtion forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:norImage forState:UIControlStateNormal];
    [button setImage:seleImage forState:UIControlStateSelected];
    
    return button;

    
    
}


+ (NSMutableArray *) getGameListSectionBy:(NSMutableArray *)array{
    
    return nil;
}

+(void)makeLabelPatternForCurrentPriceWithLable:(UILabel *)label TitleStr:(NSString *)titleStr Content:(NSString *)content CurrentColor:(UIColor*)currentColor LastColor:(UIColor*)lastColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[titleStr stringByAppendingString:content]];
    
    [str addAttribute:NSForegroundColorAttributeName value:currentColor range:NSMakeRange(0, titleStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:lastColor range:NSMakeRange(titleStr.length, content.length)];
    label.attributedText = str;

    

}
+ (void)makeLabelPatternForCurrentPriceWithLable:(UILabel *)lable content:(NSString *)content bigFontSize:(CGFloat)bigFontSize smallFontSize:(CGFloat)smallFontSize {
    if (content.length == 0) {
        lable.text = @"";
        return;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",content]];
    
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:bigFontSize] range:NSMakeRange(1, content.length)];
    
    
    NSRange range = [content rangeOfString:@"."];
    
    if (range.length > 0) {
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:smallFontSize] range:NSMakeRange(range.location+1, content.length-range.location)];
    }
    
    lable.attributedText = str;
    
}
+ (void)makeLabelPatternForOriginalPriceWithLable:(UILabel *)lable content:(NSString *)content{
    
    
    if (content.length == 0) {
        lable.text = @"";
        return;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",content]];
    
    [str addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, str.length)];
    
    lable.attributedText = str;
}



@end
