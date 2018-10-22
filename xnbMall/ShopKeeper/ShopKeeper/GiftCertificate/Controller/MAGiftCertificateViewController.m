/**
 * MAGiftCertificateViewController.m 16/11/14
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAGiftCertificateViewController.h"

#import "MAGoodsDetailsViewController.h"
#import "SDCycleScrollView.h"
#import "SKBaseH5ViewController.h"
#import "MAHotGoodsCell.h"

@interface MAGiftCertificateViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate> {
    
    UICollectionView *_collectionView;
    
    NSMutableArray *_mGoodsArray;
    NSMutableArray *_mBannerListArray;
    NSMutableArray *_mBannerImageListArray;
    
    NSString *_lastValue;
    BOOL _isRefreshing;
    SDCycleScrollView *_cycleScrollView;
    JKLabel *_tipLabel;
}

@end

@implementation MAGiftCertificateViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"礼券"];
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
    
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
    
    _lastValue = @"";
    _isRefreshing = NO;
    _mGoodsArray = [[NSMutableArray alloc] initWithCapacity:16];
    
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
    
    [collectionView registerClass:[MAHotGoodsCell class] forCellWithReuseIdentifier:@"cellID"];
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
    
    _lastValue = @"";
    _isRefreshing = YES;
    
    [self loadMoreGoods];
}

- (void)loadMoreGoods0 {
    
    _isRefreshing = NO;
    
    if (_lastValue != nil) {
        [self loadMoreGoods];
    }
}

#pragma mark - Custom tasks

#pragma mark - Http request

- (void)requestBannerList {

    NSString* areaId = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:AREA_ID];
    if(areaId == nil) areaId = @"";
    NSDictionary *prameterDic = @{@"areaId":areaId, @"location":@"15"};
    
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

- (void)loadMoreGoods{
    
    NSDictionary *praDic = @{@"lastValue":_lastValue};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"giftcard/items.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
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
                    
                    NSDictionary *goodsDic = [pageArray lastObject];
                    _lastValue = goodsDic[@"createdDate"];
                    
                    [_collectionView.mj_footer endRefreshing];
                }else {
                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                }
                [_collectionView reloadData];
            }else {
                
            }
        });
    }];
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
    MAHotGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        cell.imageUrlStr = goodInfoDic[@"thumbnailUrl"];
        cell.titleStr = goodInfoDic[@"title"];
        [cell setPriceLabelText:[NSString stringWithFormat:@"￥%.2f",[goodInfoDic[@"goodsPrice"][@"retailPrice"] floatValue]]];
        if (goodInfoDic[@"goodsPrice"] == nil || goodInfoDic[@"goodsPrice"][@"retailPrice"] == nil) {
            cell.isSellOut = YES;
        }else {
            cell.isSellOut = NO;
        }
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
    
    return 4.f;
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
