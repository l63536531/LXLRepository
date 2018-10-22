//
//  WithdrawalRecordCell.h
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawalRecordModel.h"

@interface WithdrawalRecordCell : UITableViewCell
@property (nonatomic ,strong)NSArray* titlearray;
@property (nonatomic) WithdrawalRecordModel * withmodel;

-(void)update:(WithdrawalRecordModel*)titlearray;
@end
