/**
 * MAGoodsSearchResultViewController.m 16/11/12
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAGoodsSearchResultViewController.h"

#import "MAGoodsCell.h"
#import "MAGoodsDetailsViewController.h"

#import "MABrandBoard.h"

@interface MAGoodsSearchResultViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MABrandBoardDelegate> {
    
    UICollectionView *_collectionView;
    JKButton *_brandBtn;                                    //品牌button，点击弹出品牌列表
    MABrandBoard *_brandBoard;
    
    NSArray *_brandArray;
    NSMutableArray *_mGoodsArray;
    
    NSString *_lastValue;
    
    BOOL _isRefreshing;
}

@end

@implementation MAGoodsSearchResultViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@""];
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
    
//    [self requestBrands];   //只调用一次
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
    _brandId = @"";
    _keywords = @"";
    
    _isRefreshing = NO;
    _mGoodsArray = [[NSMutableArray alloc] initWithCapacity:16];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    [collectionView registerClass:[MAGoodsCell class] forCellWithReuseIdentifier:@"cellID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"emptyFooterID"];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoods0)];
    _collectionView.mj_footer.automaticallyHidden = YES;
    
//    [self initBrandBtn];
    
//    _brandBoard = [[MABrandBoard alloc] initWithFrame:CGRectMake(0.f, brandBtnH, SCREEN_WIDTH, collectionViewH - brandBtnH)];
//    [self.view addSubview:_brandBoard];
//    _brandBoard.hidden = YES;
}

- (void)initBrandBtn {
    
    _brandBtn = [JKButton buttonWithType:UIButtonTypeCustom];
    [_brandBtn setFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 50.f)];
    [_brandBtn setTitle:@"0品牌0" forState:UIControlStateNormal];
    [_brandBtn setImage:[UIImage imageNamed:@"xiahongjian"] forState:UIControlStateNormal];
    _brandBtn.titleLabel.font = FONT_HEL(14.f);
    [_brandBtn setTitleColor:RGBGRAY(150.f) forState:UIControlStateNormal];
    [_brandBtn addTarget:self action:@selector(brandBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    JKView *sp = [[JKView alloc] initWithFrame:CGRectMake(0.f, _brandBtn.fHeight - 1.f, SCREEN_WIDTH, 1.f)];
    sp.backgroundColor = RGBGRAY(230.f);
    [_brandBtn addSubview:sp];
    
    [self layoutBrandBtn];
}

#pragma mark - Touch events

- (void)brandBtn:(id)sender {
    
    _brandBoard.hidden = !_brandBoard.hidden;
}

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

- (void)layoutBrandBtn {
    
    UIImageView *imageView = _brandBtn.imageView;
    UILabel *titleLabel = _brandBtn.titleLabel;
    
    CGFloat imageInset = titleLabel.frame.size.width;
    CGFloat titleInset = imageView.frame.size.width + 2.f;
    
    [_brandBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, imageInset, 0.f, -imageInset)];
    [_brandBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -titleInset, 0.f, titleInset)];
}

#pragma mark - Http request

- (void)requestBrands {
    
    NSDictionary *praDic = @{@"keywords":_keywords,
                             @"categoryId":@""};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"goods/searchbrands.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            if (error == nil) {
                
                _brandArray = resultDic[@"data"];
                _brandBoard.brandArray = _brandArray;
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

- (void)loadMoreGoods{
    
    if (_keywords == nil) {
        _keywords = @"";
    }
    if (_categoryId == nil) {
        _categoryId = @"";
    }
    if (_brandId == nil) {
        _brandId= @"";
    }

    //上传参数
    NSMutableDictionary  *params = [NSMutableDictionary dictionary];
    params[@"keywords"] = _keywords;
    params[@"categoryId"] = _categoryId;
    params[@"lastValue"] = _lastValue;
    params[@"brandId"] = _brandId;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"goods/search.do" parameter:params token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            [_collectionView.mj_header endRefreshing];
            
            if (error == nil) {
                
                if (_isRefreshing) {
                    [_mGoodsArray removeAllObjects];
                }
                NSDictionary *dic = resultDic[@"data"];
                NSArray *pageArray = dic[@"list"];
                
                NSInteger total = [dic[@"total"] integerValue];
                if (pageArray != nil && pageArray.count > 0) {
                    [_mGoodsArray addObjectsFromArray:pageArray];
                    _lastValue = [_mGoodsArray lastObject][@"createdDate"];
                }
                
                if (_mGoodsArray.count == total) {
                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [_collectionView.mj_footer endRefreshing];
                }
                [_collectionView reloadData];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

-(void)saveSearchHistory{
    
    NSDictionary *praDic = @{@"searchKey":_keywords};
    
    [JKURLSession taskWithMethod:@"goods/savesearchhistory.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) { }];
}

#pragma mark - MABrandBoardDelegate

- (void)brandBoardSelectedItemAtItem:(NSInteger)item {
    
    [_brandBoard setHidden:YES];
    
    if (item == 0) {
        
        _keywords = @"";
        _lastValue = @"";
        
        [self refresh];
    }else {
        
        NSDictionary *dic = _brandArray[item - 1];
        
        _keywords = dic[@"name"];
        _lastValue = @"";
        
        [self refresh];
    }
}


#pragma mark - UISearBarDelegate

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarShouldEndEditing %@",[searchBar text]);
    NSString *searchStr = [searchBar text];
    _keywords = searchStr;
    if(![JKTool isNilStrOrSpace:searchStr]){
        //_pageIndex = 1;
        [MobClick event:@"goodsSearch" label:@"商品搜索"];
        
        _keywords = searchStr;
        
        if (_keywords == nil) {
            _keywords = @"";
        }
        _lastValue = @"";
        [self loadMoreGoods];
        
        //查询当前查询条件下服务店铺商品结果集合里涉及的品牌
        [self requestBrands];
        //保存搜索记录到服务器
        [self saveSearchHistory];
    }
    return YES;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //NSString *searchString = [searchController.searchBar text];
    [_mGoodsArray removeAllObjects];
    [_collectionView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _mGoodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *goodInfoDic = _mGoodsArray[indexPath.item];
    
    static NSString *cellID = @"cellID";
    MAGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
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
    [self.fatherController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
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
    
    
    return CGSizeMake(SCREEN_WIDTH, 0.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 0);
}

@end