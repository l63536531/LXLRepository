//
//  MsgViewCell.h
//  ShopKeeper
//
//  Created by zzheron on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgViewCell : UITableViewCell
@property (nonatomic) NSDictionary *data;

@property(nonatomic ,strong)UILabel *title;
@property(nonatomic ,strong)UILabel *datelabel;
@property(nonatomic ,strong)UILabel *subtitle;


/** 是否已读 */
@property (nonatomic, assign)NSInteger readed;
@end
