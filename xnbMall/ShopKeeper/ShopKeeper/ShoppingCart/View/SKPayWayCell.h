//
//  SKPayWayCell.h
//  Demo-10.11
//
//  Created by djk on 16/10/13.
//  Copyright © 2016年 NQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKPayWayCell : UITableViewCell
/**
 *  选中Btn
 */
@property (nonatomic,weak) UIButton *pointBtn;
/**
 *  图标ImageView
 */
@property (nonatomic,weak) UIImageView *iconImageView;
/**
 *  上限Label
 */
@property (nonatomic,weak) UILabel *limitLabel;
/**
 *  查看各银行限额Btn
 */
@property (nonatomic,weak) UIButton *seeLimitBtn;
/**
 *  会员余额Label
 */
@property (nonatomic,weak) UILabel *memberMoneyLabel;


/**
 *  点击选中按钮的回调
 */
@property (nonatomic,copy) void(^point)(UIButton *);
/**
 *  点击查看限制额度的回调
 */
@property (nonatomic,copy) void(^seeLimite)();

@end
