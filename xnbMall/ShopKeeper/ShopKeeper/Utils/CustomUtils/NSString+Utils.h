//
//  NSString+Utils.h
//  TaskGanGan
//
//  Created by zzheron on 1/5/16.
//  Copyright © 2016 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
+ (BOOL) isBlankString:(NSString *)string;
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validateMobile:(NSString *)mobile;
+ (BOOL) validateCarNo:(NSString *)carNo;
+ (BOOL) validateCarType:(NSString *)CarType;
+ (BOOL) validateUserName:(NSString *)name;
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) validateNickname:(NSString *)nickname;
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
+(BOOL)isPureInt:(NSString *)string;
+(BOOL)isPureFloat:(NSString *)string;

@end
