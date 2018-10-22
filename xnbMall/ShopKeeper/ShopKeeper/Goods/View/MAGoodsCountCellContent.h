/**
 * MAGoodsCountCellContent.h 16/11/19
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "JKView.h"

/**
 *  @author 黎国基, 16-11-19 15:11
 *
 * 参见 MAShoppingCartCell
 */
@protocol MAGoodsCountCellContentDelegate <NSObject>

/**
 *  @author 黎国基, 16-11-19 15:11
 *
 *  - + 操作
 *
 *  @param opration 1：-，2：+
 */
- (void)goodsCountCellContentOpration:(NSInteger)opration;

- (void)setGoodsCountByTextField:(NSInteger)count;

- (void)activeTextFieldBottomPoint:(CGPoint)origin;

- (void)goodsCountCellContentShowInfo;

- (void)goodsCountCellContentSeeMoreMixGoods;

@end

@interface MAGoodsCountCellContent : JKView

@property (nonatomic, unsafe_unretained) id<MAGoodsCountCellContentDelegate>delegate;

@property (nonatomic, assign) NSInteger count;                      //件数

- (void)setIsMixBuy:(BOOL)isMinBuy mixBuyDesc:(NSString *)mixBuyDesc;  //是否支持混批

@end
