//
//  GiftVouchersCell.h
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftVouchersCell : UITableViewCell
@property(nonatomic , copy)NSString *imagestring;
@property(nonatomic , copy)NSString * titlestring;

-(void)update:(NSString*)imagearray title:(NSString*)titlearray;

@end
