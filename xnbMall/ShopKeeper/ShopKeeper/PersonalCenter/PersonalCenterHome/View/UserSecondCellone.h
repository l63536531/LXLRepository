//
//  UserSecondCellone.h
//  ShopKeeper
//
//  Created by zhough on 16/9/12.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UserSecondCelloneDelegate;

@interface UserSecondCellone : UITableViewCell
@property(nonatomic , strong)NSArray *imagearray;
@property(nonatomic , strong)NSArray * titlearray;

@property (nonatomic,weak) id<UserSecondCelloneDelegate> delegate;




@end
//代理方法
@protocol UserSecondCelloneDelegate <NSObject>

-(void)clickButton:(NSInteger)tag title:(NSString*)title;



@end