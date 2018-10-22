#import <Foundation/Foundation.h>

@interface NSString (wrapper)

/**
 *  移除字符串两侧的空白字符
 *
 *  @return result
 */
- (NSString *)trim;

/**
 *  校验String是否手机号码
 *
 *  @param string 等待校验字符串
 *
 *  @return BOOL
 */
+ (BOOL)isPhoneFormate:(NSString *)string;
/**
 *  验证手机号格式是否正确
 *
 *  @param mobile 等待经验的字符串
 *
 *  @return BOOL
 */
+ (BOOL)valiMobile:(NSString *)mobile;


/**
 *
 *
 *  @param regularExp 正则表达式
 *
 *  @return BOOL
 */
- (BOOL)macthRegularExp:(NSString *)regularExp;

/**
 *  判断字符串是否为空
 *
 *  @param string 等待校验字符串
 *
 *  @return BOOL
 */
+ (Boolean)isEmptyOrNull:(NSString *)string;

/// 返回子字符串  location:开始位置   length:子字符串长度
- (NSString *)trmSubstringWithRange:(int)location Length:(int)length;


@end
