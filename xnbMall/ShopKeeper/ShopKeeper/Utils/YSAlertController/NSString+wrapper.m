#import "NSString+wrapper.h"

@implementation NSString (wrapper)

- (NSString *)trim
{
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *string = [temp mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)string);
    NSString *result = [string copy];
    return result;
}

//验证手机格式
+ (BOOL)isPhoneFormate:(NSString *)string
{
    NSString *reg = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [predicate evaluateWithObject:string];
}

//第二种方式
//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *PhoneFormat = @"^(\\+86)?[0-9]{11}$";//有+86开头，或没有；11位号码（不含+86位数）
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PhoneFormat];
    
    BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
    
    if (isMatch1) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)macthRegularExp:(NSString *)regularExp
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regularExp];
    return [predicate evaluateWithObject:self];
}

+ (Boolean)isEmptyOrNull:(NSString *)string
{
    if (!string) {
        return YES;
    } else if ([string isEqual:[NSNull null]]) {
        return YES;
    } else {
        NSString *trimedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (NSString *)trmSubstringWithRange:(int)location Length:(int)length{
    if ([self isNotEmpty:self]) {
        NSRange range;
        range.location = location;
        range.length = length;
        return [self substringWithRange:range];
    }
    return @"";
}

-(BOOL)isNotEmpty:(id)object{
    if ([object isKindOfClass:[NSNull class]] || !object)
        return NO;
    
    else if([object isKindOfClass:[NSString class]]){
        NSString *string  = object;
        if (!string.length || [@"" isEqualToString:string])
            return NO;
        return YES;
    }
    
    else if([object isKindOfClass:[NSArray class]]){
        if (((NSArray *)object).count )return YES;
        return NO;
    }
    
    else if( [object isKindOfClass:[NSDictionary class]]){
        if (((NSDictionary *)object).count)return YES;
        return NO;
    }
    
    return NO;
}

@end
