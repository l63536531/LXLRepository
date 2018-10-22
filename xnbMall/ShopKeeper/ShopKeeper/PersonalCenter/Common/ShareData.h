//
//  ShareData.h
//  ShopKeeper
//
//  Created by zhough on 16/7/5.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareData : NSObject
+(ShareData*) shareController;
-(NSString*)getOrderState:(int)state;
@end
