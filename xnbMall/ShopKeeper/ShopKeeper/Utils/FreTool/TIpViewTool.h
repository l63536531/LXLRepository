//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TIpViewTool : NSObject
{
    UILabel *tipLabel;
    BOOL topTipBool;
}
@property(nonatomic,copy)UILabel *tipLabel;
-(void)showAnimation;
-(void)showTipWithText:(NSString *)tipStr;
-(void)showTopTipWithText:(NSString *)tipStr;
-(void) eMoJiShowTipWithText:(NSString *)tipStr;
@end
