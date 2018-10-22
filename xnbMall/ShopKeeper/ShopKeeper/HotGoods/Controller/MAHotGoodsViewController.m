/**
 * MAHotGoodsViewController.m 16/11/12
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAHotGoodsViewController.h"

#import "MAHotGoodsCell.h"
#import "MAGoodsDetailsViewController.h"

@interface MAHotGoodsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
    UICollectionView *_collectionView;
    JKView *_noActivityView;                                //没有商品，显示 活动尚未开始

    NSMutableArray *_mGoodsArray;
    
    NSInteger _currentPageIndex;
    BOOL _isRefreshing;
    BOOL _noMoreData;                                       //没有更多商品了
}

@end

@implementation MAHotGoodsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"爆款"];
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
    
    [self loadMoreGoods];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/**
 *  @author 黎国基, 16/11/12
 *
 *  初始化数据
 */
- (void)initData {
    
    _currentPageIndex = 1;
    _noMoreData = NO;
    _isRefreshing = NO;
    _mGoodsArray = [[NSMutableArray alloc] initWithCapacity:16];
}

/**
 *  @author 黎国基, 16/11/12
 *
 *  创建UI界面
 */
- (void)createUI {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGFloat collectionViewH = SCREEN_HEIGHT - 64;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, collectionViewH) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.alwaysBounceVertical = YES;          //保证数据不足时也能滚动！
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = RGBGRAY(245.f);
    _collectionView = collectionView;
    
    [collectionView registerClass:[MAHotGoodsCell class] forCellWithReuseIdentifier:@"cellID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"emptyFooterID"];
    
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoods0)];
    _collectionView.mj_footer.automaticallyHidden = YES;
    
    [self initNoActivityView];
}

- (void)initNoActivityView {
    
    _noActivityView = [[JKView alloc] initWithFrame:_collectionView.bounds];
    [_collectionView addSubview:_noActivityView];
    _noActivityView.backgroundColor = RGBGRAY(240.f);
    
    CGFloat iconD = 80.f;
    JKImageView *icon = [[JKImageView alloc] initWithFrame:CGRectMake(0.f , 0.f, iconD, iconD)];
    icon.centerX = _noActivityView.fWidth / 2.f;
    icon.centerY = _noActivityView.fHeight / 2.f - 50.f;
    [icon setImage:[UIImage imageNamed:@"yuan1"]];
    [_noActivityView addSubview:icon];
    
    JKLabel *label0 = [[JKLabel alloc] initWithFrame:CGRectMake(0.f, icon.maxY, _noActivityView.fWidth, 21.f)];
    label0.font = FONT_HEL(14.f);
    label0.textColor = RGBGRAY(100.f);
    label0.textAlignment = NSTextAlignmentCenter;
    label0.text = @"活动还未开始";
    [_noActivityView addSubview:label0];
    
    JKLabel *label1 = [[JKLabel alloc] initWithFrame:CGRectMake(0.f, label0.maxY, _noActivityView.fWidth, 21.f)];
    label1.font = FONT_HEL(12.f);
    label1.textColor = RGBGRAY(200.f);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"敬请期待";
    [_noActivityView addSubview:label1];
}

#pragma mark - Touch events

- (void)refresh {
    
    _currentPageIndex = 1;
    _noMoreData = NO;
    _isRefreshing = YES;
    
    [self loadMoreGoods];
}

 - (void)loadMoreGoods0 {
     
     _isRefreshing = NO;

    [self loadMoreGoods];
}

#pragma mark - Custom tasks

#pragma mark - Http request

- (void)loadMoreGoods{
    
    NSDictionary *praDic = @{@"pageIndex":[NSString stringWithFormat:@"%zd",_currentPageIndex],@"pageSize":@"10"};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"explosion/items.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            [_collectionView.mj_header endRefreshing];
            
            if (error == nil) {
                if (_isRefreshing) {
                    [_mGoodsArray removeAllObjects];
                }
                NSDictionary *dic = resultDic[@"data"];
                NSArray *pageArray = dic[@"list"];
                BOOL isLastPage = [dic[@"lastPage"] boolValue];
                if (pageArray != nil && pageArray.count > 0) {
                    [_mGoodsArray addObjectsFromArray:pageArray];
                }
                
                if (isLastPage) {
                    _noMoreData = YES;
                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [_collectionView.mj_footer endRefreshing];
                }
                
                [_collectionView reloadData];
                
                _currentPageIndex ++;
            }else {
                
            }
        });
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    _noActivityView.hidden = (_mGoodsArray.count > 0);
    
    return _mGoodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *goodInfoDic = _mGoodsArray[indexPath.item];
    
    static NSString *cellID = @"cellID";
    MAHotGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.imageUrlStr = goodInfoDic[@"thumbnailUrl"];
    cell.titleStr = goodInfoDic[@"title"];
    cell.price = [goodInfoDic[@"goodsPrice"][@"retailPrice"] floatValue];
    if (goodInfoDic[@"goodsPrice"] == nil || goodInfoDic[@"goodsPrice"][@"retailPrice"] == nil) {
        cell.isSellOut = YES;
    }else {
        cell.isSellOut = NO;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderID" forIndexPath:indexPath];
        
    }else {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"emptyFooterID" forIndexPath:indexPath];
    }
    
    view.backgroundColor = RGBGRAY(245.f);
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *itemDic = _mGoodsArray[indexPath.item];
    
    MAGoodsDetailsViewController* vc = [[MAGoodsDetailsViewController alloc]init];
    vc.goodsSpecId = itemDic[@"goodsSpecId"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0.f, 4.f, 0.f, 4.f);
}

/**
 *  @author 黎国基, 16-09-26 11:09
 *
 *  W = H
 *
 *
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellW = (SCREEN_WIDTH - 12.f) / 2.f;
    CGFloat imageW = cellW;
    CGFloat imageH = imageW * 1.f;
    
    return CGSizeMake(cellW, imageH + 60.f);
}

//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4.f;
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 4.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    
    return CGSizeMake(SCREEN_WIDTH, 4.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    return CGSizeMake(SCREEN_WIDTH, 0);
}

@end
