//
//  MySingleton.m
//  TaskGanGan
//
//  Created by zzheron on 15/11/2.
//  Copyright © 2015年 zzheron. All rights reserved.
//

#import "MySingleton.h"

@implementation MySingleton

+(MySingleton *)sharedSingleton
{
    static MySingleton *sharedSingleton;
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[MySingleton alloc] init];
        }
        return sharedSingleton;
    }
}

-(id)getUser{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    return [accountDefaults objectForKey:@"userinfo"];
}

-(void)saveUser:(NSDictionary*)data {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:data forKey:@"userinfo"];
}

-(BOOL)checkLogin{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    return [[accountDefaults objectForKey:@"userinfo"] objectForKey:@"token"]?YES:NO;
}


+(UIImage *)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 22 * borderWidth;
    CGFloat imageH = oldImage.size.height + 22 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文,这里得到的就是上面刚创建的那个图片上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆。As a side effect when you call this function, Quartz clears the current path.
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}




@end
