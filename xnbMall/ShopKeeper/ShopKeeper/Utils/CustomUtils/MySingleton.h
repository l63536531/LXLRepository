//
//  MySingleton.h
//  TaskGanGan
//
//  Created by zzheron on 15/11/2.
//  Copyright © 2015年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MySingleton : NSObject

+(MySingleton *)sharedSingleton;

-(id)getUser;
-(void)saveUser:(NSDictionary*)data;
+(UIImage *)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
-(BOOL)checkLogin;

@end
