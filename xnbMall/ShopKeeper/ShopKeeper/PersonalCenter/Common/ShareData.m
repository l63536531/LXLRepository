//
//  ShareData.m
//  ShopKeeper
//
//  Created by zhough on 16/7/5.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ShareData.h"

@implementation ShareData
static ShareData* shareController = nil;

+(ShareData*) shareController{
    if(shareController == nil){
        shareController = [[ShareData alloc]init];
    }
    return shareController;
}

-(id)init{
    self = [super init];
    if(!self){
        return self;
    }
    
    return self;
}

-(NSString*)getOrderState:(int)state{


    NSString * getstatestring = nil;
    
    switch (state) {
        case 1://待付款
            getstatestring = @"1";
            break;
        case 2://待发货
        case 7://待发货
            getstatestring = @"2";
            
            break;
        case 3://待签收
        case 8://待签收
            getstatestring = @"3";
            break;
        case 4://已完成
        case 5:
        case 6:
        case 99:
            getstatestring = @"4";
            
            break;
            
        default:
            
            getstatestring = @"";
            
            break;
    }
    
    
    return getstatestring;
    

}



@end
