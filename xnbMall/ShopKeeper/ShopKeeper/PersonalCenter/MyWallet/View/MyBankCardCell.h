//
//  MyBankCardCell.h
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyBankCardCellDelegate;


@interface MyBankCardCell : UITableViewCell



@property (nonatomic ,strong)NSArray* titlearray;
-(void)update:(NSArray*)titlearray;
@property (nonatomic,weak) id<MyBankCardCellDelegate> delegate;
@property (nonatomic,assign) NSInteger gettag;


@end



@protocol MyBankCardCellDelegate <NSObject>

-(void)clickButton:(NSInteger)tag;



@end