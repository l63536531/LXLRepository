//
//  ShareWithFriendsView.m
//  ShopKeeper
//
//  Created by zhough on 16/6/8.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ShareWithFriendsView.h"

@implementation ShareWithFriendsView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(!self){
        
        return self;
        
    }
    return self;
    
}


-(void)createview{

    CGFloat  leftX = SCREEN_WIDTH/6;
    CGFloat  viewWidth = SCREEN_WIDTH - leftX*2;
    CGFloat  imageleft = 20;
    CGFloat  imageWidth = viewWidth - imageleft*2;
    CGFloat labheight = 25 ;
    
    CGFloat labY = imageleft + imageWidth;
    CGFloat lineY = labY+ labheight ;
    CGFloat bgheight = viewWidth/4*5+50;
    
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6, (SCREEN_HEIGHT - bgheight)/2, SCREEN_WIDTH/6*4, bgheight)];
    [bgview setBackgroundColor:[UIColor whiteColor]];
    [bgview.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [bgview.layer setShadowOffset:CGSizeMake(1, 1)];
    [self addSubview:bgview];
    
    
    
    UIImageView * imageview = [[UIImageView alloc] init];
    [imageview setFrame:CGRectMake(imageleft, imageleft,imageWidth, imageWidth)];
    [imageview setImage:[UIImage imageNamed:@"农掌柜二维码"]];
    [bgview addSubview:imageview];
    
    UILabel * labtitle = [[UILabel alloc]init];
    [labtitle setFrame:CGRectMake(0, labY, viewWidth, labheight)];
    [labtitle setBackgroundColor: [UIColor clearColor]];
    [labtitle setText:@"下载新农宝商城app"];
    [labtitle setTextColor:[UIColor blackColor]];
    [labtitle setTextAlignment:NSTextAlignmentCenter];
    [labtitle setFont:[UIFont boldSystemFontOfSize:14]];
    [bgview addSubview:labtitle];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, lineY, viewWidth, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [bgview addSubview:line];
    
    
    UILabel * labshare = [[UILabel alloc]init];
    [labshare setFrame:CGRectMake(0, lineY, viewWidth, labheight)];
    [labshare setBackgroundColor: [UIColor clearColor]];
    [labshare setText:@"  分享到"];
    [labshare setTextColor:[UIColor blackColor]];
    [labshare setTextAlignment:NSTextAlignmentLeft];
    [labshare setFont:[UIFont boldSystemFontOfSize:14]];
    [bgview addSubview:labshare];

    
    CGFloat btnbgviewheight =  viewWidth/4;
    
    NSArray* titlearray = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    NSArray* imagArray =  @[@"wxshareicon",@"frshareicon",@"qqshareicon",@"QQ空间"];

    for (int i = 0; i< 4; i++) {
        
        UIView * btnbgview = [[UIView alloc] init];
        [btnbgview setBackgroundColor:[UIColor whiteColor]];
        [btnbgview setFrame:CGRectMake( btnbgviewheight*i, lineY+ labheight, btnbgviewheight, btnbgviewheight+20)];
        [bgview addSubview:btnbgview];
        
        
        UIButton* btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0,btnbgviewheight,  btnbgviewheight)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:imagArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [btnbgview addSubview:btn];
        
        UILabel* labtitle = [[UILabel alloc] init];
        [labtitle setFrame:CGRectMake(0, btnbgviewheight, btnbgviewheight, 20)];
        [labtitle setText:titlearray[i]];
        [labtitle setTextAlignment:NSTextAlignmentCenter];
        [labtitle setFont:[UIFont systemFontOfSize:10]];
        [labtitle setAdjustsFontSizeToFitWidth:YES];
        [labtitle setTextColor:[UIColor lightGrayColor]];
        [labtitle setBackgroundColor:[UIColor clearColor]];
        [btnbgview addSubview:labtitle];
        
        
        
    }
    
    


}
-(void)btnclick:(id)sender{
    UIButton * btn = sender;
    NSInteger index = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(shareclickButton:)]) {
        [self.delegate shareclickButton:index];
    }
    

    NSLog(@"%ld",btn.tag);

}



@end
