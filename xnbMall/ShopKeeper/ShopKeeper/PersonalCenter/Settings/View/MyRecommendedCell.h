//
//  MyRecommendedCell.h
//  ShopKeeper
//
//  Created by zhough on 16/5/29.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRecommendedCell : UITableViewCell

@property(nonatomic , copy)NSString *imagestring;
@property(nonatomic , copy)NSString * titlestring;

-(void)update:(NSString*)imagearray title:(NSString*)titlearray;

@end
