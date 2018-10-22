//
//  ExpressTablecell.h
//  ShopKeeper
//
//  Created by zhough on 16/7/6.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressTablecell : UITableViewCell


@property (nonatomic ,strong)NSArray* titlearray;
-(void)update:(NSArray*)titlearray;


@end
