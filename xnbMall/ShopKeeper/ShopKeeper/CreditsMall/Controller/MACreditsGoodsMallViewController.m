/**
 * MACreditsGoodsMallViewController.m 16/11/14
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MACreditsGoodsMallViewController.h"

#import "MAGoodsDetailsViewController.h"
#import "SDCycleScrollView.h"
#import "SKBaseH5ViewController.h"
#import "MACreditsGoodsCell.h"
#import "SKPointExchangeViewController.h"
#import "LoginViewController.h"

@interface MACreditsGoodsMallViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate, MACreditsGoodsCellDelegate> {
    
    UICollectionView *_collectionView;
    
    NSMutableArray *_mGoodsArray;
    NSMutableArray *_mBannerListArray;
    NSMutableArray *_mBannerImageListArray;
    
    NSInteger _currentPageIndex;
    BOOL _isRefreshing;
    SDCycleScrollView *_cycleScrollView;
    JKLabel *_tipLabel;
    
    CGFloat _userCredits;
}

@end

@implementation MACreditsGoodsMallViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"积分商城"];
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
    
    [self requestUserCredits];
    [self requestBannerList];
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
    _isRefreshing = NO;
    _mGoodsArray = [[NSMutableArray alloc] initWithCapacity:16];
    
    _userCredits = MAXFLOAT;//如果网络请求失败，允许用户进入兑换页面
    
    _mBannerListArray = [NSMutableArray array];
    _mBannerImageListArray = [NSMutableArray array];
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
    
    [collectionView registerClass:[MACreditsGoodsCell class] forCellWithReuseIdentifier:@"cellID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"emptyFooterID"];
    
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoods0)];
    _collectionView.mj_footer.automaticallyHidden = YES;
    
    [self initBanner];
    
    _tipLabel = [[JKLabel alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 50.f)];
    _tipLabel.font = FONT_HEL(14.f);
    _tipLabel.textColor = RGBGRAY(100.f);
    _tipLabel.text = @"  可使用礼券抵扣部分金额的商品";
}

/**
 *  @author 黎国基, 16-11-02 20:11
 *
 *  banner
 */
-(void)initBanner{
    float lwidth = self.view.frame.size.width;
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0.f, lwidth, lwidth/2) delegate:self placeholderImage:[UIImage imageNamed:@"banner_default"]];
    _cycleScrollView.tag = 1;
    
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.autoScrollTimeInterval = 3.0;
}

#pragma mark - Touch events

- (void)refresh {
    
    _currentPageIndex = 1;
    _isRefreshing = YES;
    
    [self loadMoreGoods];
}

- (void)loadMoreGoods0 {
    
    _isRefreshing = NO;
    
    [self loadMoreGoods];
}

#pragma mark - Custom tasks

#pragma mark - Http request

- (void)requestBannerList {
    
    NSString* areaId = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:AREA_ID];
    if(areaId == nil) areaId = @"";
    NSDictionary *prameterDic = @{@"areaId":areaId, @"location":@"17"};
    
    [JKURLSession taskWithMethod:@"ad/banner.do" parameter:prameterDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        if (error == nil) {
            [_mBannerListArray removeAllObjects];
            [_mBannerImageListArray removeAllObjects];
            
            [_mBannerListArray addObjectsFromArray:resultDic[@"data"]];
            
            for(NSDictionary *dic in _mBannerListArray){
                [_mBannerImageListArray addObject:dic[@"imgUrl"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_cycleScrollView setImageURLStringsGroup:_mBannerImageListArray];
            });
        }
    }];
}

- (void)requestUserCredits {
    
    [JKURLSession taskWithMethod:@"points/balance.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                
                NSNumber * total = resultDic[@"data"][@"balance"];
                _userCredits =[total floatValue];
            }
        });
    }];
}

- (void)loadMoreGoods{
    
    NSDictionary *praDic = @{@"pageIndex":[NSString stringWithFormat:@"%zd",_currentPageIndex],@"pageSize":@"16"};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"points/items.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            [_collectionView.mj_header endRefreshing];
            
            if (error == nil) {
                if (_isRefreshing) {
                    [_mGoodsArray removeAllObjects];
                }
                NSDictionary *dic = resultDic[@"data"];
                
                NSArray *pageArray = dic[@"list"];
                
                if (pageArray != nil && pageArray.count > 0) {
                    [_mGoodsArray addObjectsFromArray:pageArray];
                    [_collectionView.mj_footer endRefreshing];
                }else {
                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                }
                [_collectionView reloadData];
                
                _currentPageIndex ++;
            }else {
                
            }
        });
    }];
}

#pragma mark - MACreditsGoodsCellDelegate

- (void)creditsCellExchangeGoodsAtItem:(NSInteger)item {
    
    NSDictionary *goodInfoDic = _mGoodsArray[item];
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0){
        //强制登录
        LoginViewController* vc = [[LoginViewController alloc]init];
        
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        navi.navigationBar.translucent = NO;
        [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [self presentViewController:navi animated:YES completion:nil];
        
        return;
    }
    
    NSInteger goodsCredits = [goodInfoDic[@"bonus"] floatValue];
    if (_userCredits < goodsCredits) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"积分不足兑换~" message:nil preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:^{}];
        
    }else {
        SKPointExchangeViewController *vc = [SKPointExchangeViewController new];
        vc.data = goodInfoDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    SKBaseH5ViewController* vc = [[SKBaseH5ViewController alloc]init];
    vc.dic = _mBannerListArray[index];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    return _mGoodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *goodInfoDic = _mGoodsArray[indexPath.item];
    
    static NSString *cellID = @"cellID";
    MACreditsGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        cell.delegate = self;
        cell.item = indexPath.item;
        cell.imageUrlStr = goodInfoDic[@"logoImgUrl"];
        cell.titleStr = goodInfoDic[@"title"];
        cell.credits = [goodInfoDic[@"bonus"] integerValue];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderID" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            [view addSubview:_cycleScrollView];
        }else if (indexPath.section == 1) {
            [view addSubview:_tipLabel];
        }
    }else {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"emptyFooterID" forIndexPath:indexPath];
    }
    
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //积分商城 不允许 查看商品详情
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
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
    
    return 1.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return _cycleScrollView.bounds.size;
    }
    return CGSizeMake(SCREEN_WIDTH, _tipLabel.fHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 0);
}

@end
