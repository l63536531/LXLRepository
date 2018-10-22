/**
 * MAShoppingCartCell.h 16/11/14
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

@protocol MAShoppingCartCellDelegate <NSObject>

/**
 *  @author 黎国基, 16-11-15 13:11
 *
 *  cell的点击操作
 *
 *  @param opration  [1,2,3] 1--勾选按钮，2--'-',3--'+'
 *  @param indexPath 操作的section,row
 */
- (void)shoppingCartCellOpration:(NSInteger)opration atIndexPath:(NSIndexPath *)indexPath;

/**
 *  @author 黎国基, 16-11-15 20:11
 *
 *  在cell textfield里面修改了 商品数量
 *
 *  @param count     商品数量
 *  @param indexPath
 */
- (void)setGoodsCountByTextField:(NSInteger)count atIndexPath:(NSIndexPath *)indexPath;

- (void)activeTextFieldBottomPoint:(CGPoint)origin forCell:(UITableViewCell *)cell;

@end

@interface MAShoppingCartCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id<MAShoppingCartCellDelegate>delegate;

@property (nonatomic, assign) BOOL isChecked;

@property (nonatomic, assign) NSInteger count;                      //件数

@property (nonatomic, assign) CGFloat price;                        //仅用于显示，并不做计算，所以可以用float

@property (nonatomic, strong) NSString *titleStr;                   //标题

@property (nonatomic, strong) NSString *goodsSpecificationDesc;     //规格

@property (nonatomic, strong) NSString *imageUrlStr;                //图片

@property (nonatomic, strong) NSIndexPath *indexPath;               //坐标

+ (CGFloat)cellHeight;



@end
