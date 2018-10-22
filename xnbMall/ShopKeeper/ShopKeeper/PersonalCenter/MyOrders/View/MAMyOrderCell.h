/**
 * MAMyOrderCell.h 16/11/8
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import <UIKit/UIKit.h>

@protocol MAMyOrderCellDelegate <NSObject>

- (void)tableViewTag:(NSInteger)tableViewTag row:(NSInteger)row operation:(NSInteger)operation state:(NSInteger)state isdelay:(BOOL)isdelay isCommented:(BOOL)isCommented;

@end

@interface MAMyOrderCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id<MAMyOrderCellDelegate>delegate;

/**
 *  @author 黎国基, 16-11-08 13:11
 *
 *  区分是哪个tableView的操作
 */
@property (nonatomic, assign) NSInteger tableViewTag;

/**
 *  @author 黎国基, 16-11-08 13:11
 *
 *  区分行
 */
@property (nonatomic, assign) NSInteger row;

/**
 *  @author 黎国基, 16-11-08 17:11
 *
 *  订单状态
 */

@property (nonatomic, strong) NSDictionary *orderInfoDic;

+ (CGFloat)cellHeight;

@end
