//
//  UserSecondCelltwo.h
//  ShopKeeper
//
//  Created by zhough on 16/9/12.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UserSecondCelltwoDelegate;

@interface UserSecondCelltwo : UITableViewCell
@property(nonatomic , strong)NSArray *imagearray;
@property(nonatomic , strong)NSArray * titlearray;

@property (nonatomic,weak) id<UserSecondCelltwoDelegate> delegate;




@end
//代理方法
@protocol UserSecondCelltwoDelegate <NSObject>

-(void)clickButton:(NSInteger)tag title:(NSString*)title;



@end