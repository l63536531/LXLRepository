/**
 * SKPayWallcellmodel.h 16/12/30
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import <Foundation/Foundation.h>



@interface SKPayWallcellmodel : NSObject
/** 支付名称 */
@property (nonatomic, copy)NSString *title;
/** 支付类型 */
@property (nonatomic, assign)NSInteger type;
/** 云商通id */
@property (nonatomic, copy)NSString *accountId;
/** 会员卡余额 */
@property (nonatomic, strong) NSString *balance;

@end



