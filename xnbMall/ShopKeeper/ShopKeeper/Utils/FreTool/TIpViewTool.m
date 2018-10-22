//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "TIpViewTool.h"
#import "AppDelegate.h"
#import "UIColor+_6DataColor.h"

@implementation TIpViewTool
@synthesize tipLabel;
-(id)init
{
    self=[super init];
    if (self)
    {
        tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        tipLabel.layer.cornerRadius=7;
       // tipLabel.textColor=[UIColor redColor];
        tipLabel.alpha = 0.7;
        tipLabel.layer.masksToBounds=YES;
        tipLabel.backgroundColor=[UIColor colorWithHexString:@"#ec594d"];
        tipLabel.font=[UIFont systemFontOfSize:14.0];
        tipLabel.textAlignment=NSTextAlignmentCenter;
        topTipBool = NO;
    }
    return self;
}

-(void)showTipWithText:(NSString *)tipStr
{
    if (tipStr&&![tipStr isEqualToString:@""])
    {
        tipLabel.text=tipStr;
        CGRect bounds = tipLabel.bounds;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:tipLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        bounds.size = [tipStr sizeWithAttributes:attributes];//sizeWithFont:tipLabel.font];
        tipLabel.frame=CGRectMake((SCREEN_WIDTH-bounds.size.width-40)/2, (SCREEN_HEIGHT-bounds.size.height-30)/2, bounds.size.width+40, 44);
       
        AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app.window addSubview:tipLabel];
        [self showAnimation];
    }
}

-(void) eMoJiShowTipWithText:(NSString *)tipStr
{
    if (tipStr&&![tipStr isEqualToString:@""])
    {
        tipLabel.text=tipStr;
        CGRect bounds = tipLabel.bounds;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:tipLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        bounds.size = [tipStr sizeWithAttributes:attributes];//sizeWithFont:tipLabel.font];
        tipLabel.frame=CGRectMake((SCREEN_WIDTH-bounds.size.width-40)/2, (SCREEN_HEIGHT-bounds.size.height-30)/2-100, bounds.size.width+40, 44);
        
        AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app.window addSubview:tipLabel];
        [self showAnimation];
    }
}


-(void)showTopTipWithText:(NSString *)tipStr
{
    if (tipStr&&![tipStr isEqualToString:@""])
    {
        topTipBool = YES;
        tipLabel.text=tipStr;
        CGRect bounds = tipLabel.bounds;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:tipLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        bounds.size = [tipStr sizeWithAttributes:attributes];//sizeWithFont:tipLabel.font];
        tipLabel.frame=CGRectMake(10, 20,SCREEN_WIDTH -20, 44);
        
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app.window addSubview:tipLabel];
        [self showTopAnimation];
    }
}

-(void) showTopAnimation
{
    tipLabel.transform=CGAffineTransformMakeScale(0.1, 0.1);
    [UIView beginAnimations:NULL context:Nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop1)];
    [UIView setAnimationDuration:0.07];
    tipLabel.transform=CGAffineTransformMakeScale(0.4,0.4);
    [UIView commitAnimations];
}

-(void)showAnimation
{
    topTipBool = NO;
    tipLabel.transform=CGAffineTransformMakeScale(0.1, 0.1);
    [UIView beginAnimations:NULL context:Nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop1)];
    [UIView setAnimationDuration:0.07];
    tipLabel.transform=CGAffineTransformMakeScale(0.4,0.4);
    [UIView commitAnimations];
}

-(void)animationDidStop1
{
    [UIView beginAnimations:NULL context:Nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop2)];
    [UIView setAnimationDuration:0.035];
    tipLabel.transform=CGAffineTransformMakeScale(1.1,1.1);
    [UIView commitAnimations];
}

-(void)animationDidStop2
{
    [UIView beginAnimations:NULL context:Nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop3)];
    [UIView setAnimationDuration:0.035];
    tipLabel.transform=CGAffineTransformMakeScale(1.0,1.0);
    [UIView commitAnimations];
}

-(void)animationDidStop3
{
    if (topTipBool)
    {
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissTipView) userInfo:Nil repeats:NO];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismissTipView) userInfo:Nil repeats:NO];
    }
    
}

-(void)dismissTipView
{
    [UIView beginAnimations:NULL context:Nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeTipView)];
    [UIView setAnimationDuration:1.0];
    tipLabel.alpha=0.0;
    [UIView commitAnimations];
}

-(void)removeTipView
{
    [tipLabel removeFromSuperview];
}
@end
