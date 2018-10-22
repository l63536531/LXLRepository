//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"AppDelegate.h"

#import "JKViews.h"
#import "JKTool.h"
#import "SKMACROs.h"
#import "JKURLSession.h"

@interface BaseController :UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,assign) BOOL isDown;//判断刷新是上拉 还是下拉
@property (nonatomic,assign) NSInteger indexNumber;//上拉的次数

@property (nonatomic,assign) NSInteger pageIndex;  //当前的pageIndex
@property (nonatomic,assign) NSString *keyForOffset;//控制偏移量的参数

@property (nonatomic,strong) UITableView *tableViews;//创建基类的tableViews
@property (nonatomic,strong) UIScrollView *scrollViews;//创建基类的scrollViews
@property (nonatomic,strong) UIImageView *navImageView;//如果隐藏导航栏的情况下可以作为导航栏来使用
@property (nonatomic,strong) UICollectionView *collectionViews;//创建基类的collectionViews
@property (nonatomic,strong) NSMutableArray *dataSource;//默认的数据源





//添加菊花
- (void)showWaitingView:(UIView *)view ;
//隐藏菊花
- (void)hideWaitingView;
//网络请求的方法。子类实现时，如果有必要，请求成功时，pageIndex++
- (void) requestDataWithMethod:(NSString *)method patams:(NSString *)params;
//添加刷新头
- (void)addReFreshHeaderWithMethod:(NSString *)method params:(NSString *)params;
//添加刷新尾部
- (void)addReFreshFooterWithMethod:(NSString *)method params:(NSString *)params;
//添加tableview
- (void)addTableView:(UITableViewStyle )style SeparatorStyle:(UITableViewCellSeparatorStyle )sepStyle;


 //添加collectionview
- (void)addCollectionView:(UICollectionViewScrollDirection) layOutScrollDirection;
//添加滑动视图
- (void)addScrollView;
//设置标题
- (void)setCurrentTitle:(NSString *)title;
//当present的时候 放置title的师视图
- (void)addNavImageViewWithBackGroundColor:(UIColor *)backGroundColor;
//设置标题当present的时候
- (void) WhenPresentsetCurrentTitle:(NSString *)title;
//设置左侧按钮的点击事件（当push的时候）
- (void)leftNavBtnCallBack;
//得到当前的应用代理
- (AppDelegate *)appDelegate;

//collectionView刷新头部
- (void)addCollectionViewReFreshHeaderWithMethod:(NSString *)method params:(NSString *)params;
//collectionView刷新尾部
- (void)addCollectionViewReFreshFootererWithMethod:(NSString *)method params:(NSString *)params;


@end
