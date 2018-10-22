//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "BGTapView.h"

@implementation BGTapView
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    //    if (view == self) {
    //
    //        [self.goodsView dismissAnimated:YES];
    //    }
    
    if (self.tapBlock && view == self) {
        self.tapBlock();
        
    }
}
@end
