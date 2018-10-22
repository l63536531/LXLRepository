//
//  TriangleView.m
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView



- (void)drawRect:(CGRect)rect
 {
         //1.获得图形上下文
        CGContextRef ctx=UIGraphicsGetCurrentContext();
     
     
//     CGFloat zStrokeColour[4]    = {255.0/255,255.0/255.0,25.0/255.0,1.0};
//     CGContextSetStrokeColor(ctx, zStrokeColour );
        //2.绘制三角形
         //设置起点
         CGContextMoveToPoint(ctx, 10, 0);
        //设置第二个点
         CGContextAddLineToPoint(ctx, 0, 10);
         //设置第三个点
         CGContextAddLineToPoint(ctx, 20, 10);
         //设置终点
     //     CGContextAddLineToPoint(ctx, 20, 100);
         //关闭起点和终点
         CGContextClosePath(ctx);
        [[UIColor whiteColor] setFill];
        [[UIColor whiteColor] setStroke];
        CGContextDrawPath(ctx, kCGPathFillStroke);

         // 3.渲染图形到layer上
        CGContextStrokePath(ctx);
     
}


@end
