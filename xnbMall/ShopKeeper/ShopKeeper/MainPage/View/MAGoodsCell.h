/**
 * MAGoodsCell.h 16/11/11
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

/**
 *  @author 黎国基, 16-11-11 13:11
 *
 *  collection view cell。商品cell
 */

@interface MAGoodsCell : UICollectionViewCell

@property (nonatomic, strong) NSString *imageUrlStr;            //商品图片链接

@property (nonatomic, strong) NSString *titleStr;               //商品标题

@property (nonatomic, assign) CGFloat price;                  //售价

@property (nonatomic, assign) CGFloat sellCount;              //已售数量

@property (nonatomic, assign) BOOL isSellOut;                   //已经卖光了

@end
