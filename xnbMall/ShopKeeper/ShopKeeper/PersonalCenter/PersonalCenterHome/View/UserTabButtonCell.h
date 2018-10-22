//
//  UserTabButtonCell.h
//  画图demo
//
//  Created by zhough on 16/5/27.
//  Copyright © 2016年 gzspark. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserTabButtonCellDelegate;

@interface UserTabButtonCell : UITableViewCell
@property(nonatomic , strong)NSArray *imagearray;
@property(nonatomic , strong)NSArray * titlearray;

@property (nonatomic,weak) id<UserTabButtonCellDelegate> delegate;




@end
//代理方法
@protocol UserTabButtonCellDelegate <NSObject>

-(void)clickButton:(NSInteger)tag title:(NSString*)title;



@end