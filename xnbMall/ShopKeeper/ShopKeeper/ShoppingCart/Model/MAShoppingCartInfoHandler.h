/**
 * MAShoppingCartInfoHandler.h 16/11/15
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

/**
 *  @author 黎国基, 16-11-15 18:11
 *
 *  购物车 商品的选中状态 缓存
 */
@interface MAShoppingCartInfoHandler : NSObject

#pragma mark - 游客 + 登录用户

/**
 *  @author 黎国基, 16-11-15 17:11
 *
 *  如果商品原来是选中的，就改为不选中；反之亦然
 *
 *  @param goodsSpecificationId 商品规格id
 */
+ (void)changeSateForGoods:(NSString *)goodsSpecificationId;

+ (void)setGoods:(NSString *)goodsSpecificationId selected:(BOOL)selected;

+ (BOOL)isGoodsSelected:(NSString *)goodsSpecificationId;

#pragma mark - 游客

+ (void)setVisitorGoods:(NSString *)goodsSpecificationId selected:(BOOL)selected;

+ (BOOL)isVisitorGoodsSelected:(NSString *)goodsSpecificationId;

/**
 *  @author 黎国基, 16-11-15 18:11
 *
 *  在用户登录时，清空
 */
+ (void)clearVisitorGoodsState;

#pragma mark - 登录用户

+ (void)setUserGoods:(NSString *)goodsSpecificationId selected:(BOOL)selected;

+ (BOOL)isUserGoodsSelected:(NSString *)goodsSpecificationId;

/**
 *  @author 黎国基, 16-11-15 18:11
 *
 *  暂时没有用到清空的功能
 */
+ (void)clearGoodsStateForAllUser;

+ (void)clearGoodsStateForUser:(NSString *)phone;

@end
