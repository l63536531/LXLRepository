/**
 * MAGoodsCommentCell.h 16/11/26
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
 *  @author 黎国基, 16-11-26 10:11
 *
 *  商品评价，对单个商品的评价
 */

@protocol MAGoodsCommentCellDelegate <NSObject>

- (void)starViewDidSetStarCount:(NSInteger)starCount atRow:(NSInteger)row;

- (void)starViewRemoveMarkIndexsAtRow:(NSInteger)row;

- (void)starViewDidSetMark:(NSInteger)mark opration:(NSInteger)opration atRow:(NSInteger)row;//mark[0-4]，只是本次点击事件的mark，;[opration 0:remove,1:add]

- (void)starViewDidSetMessage:(NSString *)message atRow:(NSInteger)row;//设置message

- (void)addImageAtRow:(NSInteger)row;

- (void)removeImageByImageId:(NSString *)imageId atRow:(NSInteger)row;

- (void)activeTextViewBottomPoint:(CGPoint)origin forCell:(UITableViewCell *)cell;

@end

@interface MAGoodsCommentCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <MAGoodsCommentCellDelegate> delegate;


@property (nonatomic, assign) BOOL isSatisfied;             //3星及以上，为满意

@property (nonatomic, assign) NSInteger row;

//商品信息
@property (nonatomic, strong) NSString *imageUrlStr;

@property (nonatomic, strong) NSString *titleStr;

//评价信息

@property (nonatomic, assign) NSInteger starCount;

- (void)setCommentInfoDic:(NSDictionary *)commentInfoDic isPopOut:(BOOL)isPopOut userLocalData:(NSDictionary *)userLocalDataDic;


+ (CGFloat)cellHeightForCommentInfoDic:(NSDictionary *)commentInfoDic isPopOut:(BOOL)isPopOut;

+ (BOOL)isAlreadyCommented:(NSDictionary *)commentInfoDic;

@end
