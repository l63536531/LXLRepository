/**
 * MAShoppingCartHeader.h 16/11/15
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

@protocol MAShoppingCartHeaderDelegate <NSObject>

/**
 *  @author 黎国基, 16-11-15 13:11
 *
 *  header的点击操作 勾选按钮
 *
 *  @param section
 */
- (void)shoppingCartHeaderCheckAtSection:(NSInteger)section;

/**
 *  @author 黎国基, 16-11-15 17:11
 *
 *  查看更多、去凑单
 *
 *  @param section
 */
- (void)shoppingCartHeaderLookForSameGoodsAtSection:(NSInteger)section;

@end

@interface MAShoppingCartHeader : UITableViewHeaderFooterView

@property (nonatomic, unsafe_unretained) id<MAShoppingCartHeaderDelegate>delegate;

@property (nonatomic, assign) NSInteger section;

/**
 *  @author 黎国基, 16-11-15 17:11
 *
 */
@property (nonatomic, assign) BOOL isChecked;

/**
 *  @author 黎国基, 16-11-15 19:11
 *
 *  是否支持混批
 *
 *  @param isMinBuy     是否支持混批（如果为NO，则后面的参数都不要不需要，可随便传入）
 *  @param minCount     如果支持混批，最低购买数量
 *  @param currentCount 如果支持混批，当前已选购买数量
 *  @param increment    如果支持混批，增量
 *  @param unit         单位（用于显示，千克/件/升等等）
 */
- (void)setIsMinBuy:(BOOL)isMinBuy minCount:(NSInteger)minCount currentCount:(NSInteger)currentCount increment:(NSInteger)increment unit:(NSString *)unit;

@end
