/**
 * MAMainViewController.m 16/11/11
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAMainViewController.h"

#import "SDCycleScrollView.h"
#import "SKLocationViewController.h"
#import "UIButton+ExtCenter.h"

#import "MAGoodsCell.h"
#import "MAGoodsReusableHeader.h"

#import "MAGiftCertificateViewController.h"
#import "MAHotGoodsViewController.h"

#import "SKGoodsClassViewController.h"
#import "MACreditsGoodsMallViewController.h"
#import "MemberCardViewCtr.h"
#import "MAMyOrdersViewController.h"

#import "SKSearchViewController.h"
#import "MsgCenterViewController.h"
#import "MAGoodsDetailsViewController.h"

#import "SKLocationViewController.h"
#import "LoginViewController.h"
#import "MAGoodsListViewController.h"

#import "SKBaseH5ViewController.h"
#import "Utils.h"
#import "CacheUtils.h"
#import "UserInfo.h"
#import "NSString+Utils.h"
#import "ShareWithFriendsViewCtr.h"

#import "SKHtmlTabbarController.h"
#import "MAKnowWorldViewController.h"  //知天下
#import "SKShopChosenViewController.h"
#import "MsgDetailViewController.h"

@interface MAMainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, SDCycleScrollViewDelegate,SkChangeLocationAddressDelegate,SKShopChosenViewControllerDelegate, MAGoodsReusableHeaderDelegate> {
    
    SKLocationViewController *_locationVC;                              //弹出的定位/地区选择控制器
    UIButton *_titleBtn;                                               //控制器titleview的customview
    
    UICollectionView *_collectionView;
    
    NSMutableArray *_mBannerListArray;
    NSMutableArray *_mBannerImageListArray;
    NSMutableArray *_mGoodsArray;
    
    SDCycleScrollView *_cycleScrollView;
    JKView *_menuBtnSection;
    JKButton *_scrollToTopBtn;
    UIButton *_locationBtn;
    
    JKButton *_goTopBtn;
    
    NSInteger _lastIndex;
    
    UserInfo *_userInfo;
    NSString *_areaId;
    NSString *_shopId;
    NSString *_shopName;
    NSArray *_shopListArray;
    
    NSDictionary *_streetInfoDic;
    
    //刷新条件
    BOOL _isLoading;                                        //判断网络请求是否结束。
    
    BOOL _needToPopAreaSelectorWhenAppear;
}

@end

@implementation MAMainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
    
    [self requestInitHomePageInfo];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getuiNotificationOnLine:) name:@"GetuiNotificationOnLine" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getuiNotificationOffLine:) name:@"GetuiNotificationOffLine" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSignal) name:@"userReLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSignal) name:@"USERLOGIN" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_needToPopAreaSelectorWhenAppear) {
        _needToPopAreaSelectorWhenAppear = NO;
        [self showAreaSelectionView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/**
 *  @author 黎国基, 16/11/11
 *
 *  初始化数据
 */
- (void)initData {
    _lastIndex = 0;
    
    _areaId = nil;
    _shopId = nil;
    _shopName = @"";
    
    _mGoodsArray = [NSMutableArray array];
    _mBannerListArray = [NSMutableArray array];
    _mBannerImageListArray = [NSMutableArray array];
    
    //获取店铺权限
    _userInfo  = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"]];
    if(_userInfo == nil){
        _userInfo = [ UserInfo new];
    }
    //
    _isLoading = NO;
    
    _needToPopAreaSelectorWhenAppear = NO;
}

- (void)resetDataForDiffrentUser {
    _lastIndex = 0;
    
    _areaId = nil;
    _shopId = nil;
    _shopName = @"";
    
    [_mGoodsArray removeAllObjects];
    
    _cycleScrollView.imageURLStringsGroup = nil;
    
    [_mBannerListArray removeAllObjects];
    [_mBannerImageListArray removeAllObjects];
    
    //获取店铺权限
    _userInfo  = [UserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"]];
    if(_userInfo == nil){
        _userInfo = [ UserInfo new];
    }
    //
    _isLoading = NO;
    
    [_collectionView reloadData];//_mGoodsArray越界了，崩溃
}

#pragma mark - UI
/**
 *  @author 黎国基, 16/11/11
 *
 *  创建UI界面
 */
- (void)createUI {
    
    [self initViewControllerTitileBtn];
    
    [self initLocationBtn];
    
    [self initNavigationBar];
    
    [self initCollectionView];
    
    [self initBanner];
    
    [self initMenuBtnSection];
    
    [self initGoTopBtn];
}

- (void)initViewControllerTitileBtn {
    
    CGFloat btnH = 44.f;
    CGFloat btnW = SCREEN_WIDTH - 60.f * 2.f;//左右buttonitem宽度分别预留60
    
    _titleBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleBtn setFrame:CGRectMake(0.f, 0.f, btnW, btnH)];
    _titleBtn.titleLabel.font = FONT_HEL(16);
    _titleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleBtn setTitle:@"新农宝" forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(titleBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleBtn;
    _titleBtn.clipsToBounds = YES;
}

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGFloat collectionViewH = SCREEN_HEIGHT - 64 - self.tabBarController.tabBar.frame.size.height;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, collectionViewH) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.alwaysBounceVertical = YES;          //保证数据不足时也能滚动！
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = RGBGRAY(245.f);
    _collectionView = collectionView;
    
    [collectionView registerClass:[MAGoodsCell class] forCellWithReuseIdentifier:@"cellID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderID"];
    [collectionView registerClass:[MAGoodsReusableHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerID"];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _collectionView.mj_footer.automaticallyHidden = YES;
}

/**
 *  @author 黎国基, 16-11-02 20:11
 *
 *  右边搜索按钮
 */
- (void)initNavigationBar {
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seach_right"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  @author 黎国基, 16-11-02 20:11
 *
 *  定位按钮
 */
-(void)initLocationBtn{
    
    _locationBtn = [JKButton buttonWithType:UIButtonTypeCustom];
    [_locationBtn setImage:[UIImage imageNamed:@"pin"] forState:UIControlStateNormal];
    [_locationBtn setTitle:@"" forState:UIControlStateNormal];
    _locationBtn.frame =  CGRectMake(0,0,44,44);
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [_locationBtn sizeToFit];
    [_locationBtn verticalImageAndTitle:1];
    //
    SKLocationViewController *vc = [[SKLocationViewController alloc] init];
    
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.preferredContentSize = CGSizeMake(300, 300);
    vc.popoverPresentationController.sourceView = _locationBtn;//self.button;
    vc.popoverPresentationController.sourceRect = _locationBtn.bounds;
    vc.delegate = self;
    _locationVC = vc;
    
    [_locationBtn addTarget:self action:@selector(locationBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:_locationBtn];
    self.navigationItem.leftBarButtonItem=menuButton;
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

/**
 *  @author 黎国基, 16-11-02 20:11
 *
 *  banner下面的功能模块按钮
 */
-(void)initMenuBtnSection{
    
    CGFloat lwidth = self.view.frame.size.width;
    CGFloat btwidth  = lwidth/5;
    CGFloat bthight  = lwidth/4;
    
    CGFloat btnX = 0.f;
    CGFloat btnY = 0.f;
    
    _menuBtnSection = [[JKView alloc] initWithFrame:CGRectMake(0, 0, lwidth, bthight * 2.f)];
    _menuBtnSection.backgroundColor = RGBGRAY(250.f);
    //    NSArray *titleArray = @[];
    
    
    for( int i = 0 ; i < 10 ; i++ ){
        btnX = btwidth * (i % 5);
        btnY = i < 5 ? 0.f : bthight;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(btnX,btnY, btwidth, bthight);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:RGBGRAY(100.f) forState:UIControlStateNormal];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(menuBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (i) {
            case 0:{
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_category"] forState:UIControlStateNormal];
                [btn setTitle:@"全部商品" forState:UIControlStateNormal];
                
                break;
            }case 1:{
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_checkorder"] forState:UIControlStateNormal];
                [btn setTitle:@"查单" forState:UIControlStateNormal];
                
                break;
            }case 2:{
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_hot"] forState:UIControlStateNormal];
                [btn setTitle:@"爆款" forState:UIControlStateNormal];
                
                
                break;
            }case 3:{
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_gift"] forState:UIControlStateNormal];
                [btn setTitle:@"礼券" forState:UIControlStateNormal];
                
                break;
            }
            case 4:{
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_share"] forState:UIControlStateNormal];
                [btn setTitle:@"分享" forState:UIControlStateNormal];
                
                break;
            }
            case 5:{
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_farming"] forState:UIControlStateNormal];
                [btn setTitle:@"农业120" forState:UIControlStateNormal];
                
                break;
            }
            case 6:{
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_foison"] forState:UIControlStateNormal];
                [btn setTitle:@"乐丰收" forState:UIControlStateNormal];
                
                break;
            }case 7:{
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_career"] forState:UIControlStateNormal];
                [btn setTitle:@"民生信息" forState:UIControlStateNormal];
                
                break;
            }case 8:{
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_knowledge"] forState:UIControlStateNormal];
                [btn setTitle:@"知天下" forState:UIControlStateNormal];
                
                break;
            }case 9:{
                //积分商城
                [btn setImage:[UIImage imageNamed:@"shortcuts_icon_integral"] forState:UIControlStateNormal];
                [btn setTitle:@"积分商城" forState:UIControlStateNormal];
                
                break;
            }
            default:
                break;
        }
        
        [btn verticalImageAndTitle:5];
        [_menuBtnSection addSubview:btn];
    }
}

- (void)initGoTopBtn {
    
    CGFloat collectionViewH = SCREEN_HEIGHT - 64 - self.tabBarController.tabBar.frame.size.height;
    
    CGFloat goTopBtnD = 50.f;
    CGFloat goTopBtnX = SCREEN_WIDTH - goTopBtnD - 10.f;
    CGFloat goTopBtnY = collectionViewH - goTopBtnD - 20.f;
    
    _goTopBtn = [JKButton buttonWithType:UIButtonTypeCustom];
    [_goTopBtn setFrame:CGRectMake(goTopBtnX, goTopBtnY, goTopBtnD, goTopBtnD)];
    [_goTopBtn setBackgroundImage:[UIImage imageNamed:@"gotop"] forState:UIControlStateNormal];
    [_goTopBtn addTarget:self action:@selector(goTopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_goTopBtn];
    _goTopBtn.hidden = YES;
}

#pragma mark - Touch events

- (void)refresh {
    
    _lastIndex = 0;
    
    [self requestInitHomePageInfo];
}

- (void)loadMoreData {
    [self loadMoreHotGoods];
}

- (void)rightItem {
    [MobClick event:@"mainPageSearchItem" label:@"首页搜索"];
    
    SKSearchViewController* vc = [[SKSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goTopBtn:(JKButton *)btn {
    
    [_collectionView setContentOffset:CGPointZero animated:YES];
}

/**
 *  @author 黎国基, 16-11-03 10:11
 *
 *  点击vc标题，如果有多个店铺，则跳转到切换店铺页面
 *
 */
- (void)titleBtn:(id)sender {
    
    if (_shopListArray!= nil && _shopListArray.count > 1) {
        NSLog(@"hello,kilos");
        
        SKShopChosenViewController *vc = [[SKShopChosenViewController alloc] init];
        vc.currentShop = _shopName;
        vc.shopArray = _shopListArray;
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 *  @author 黎国基, 16-11-03 10:11
 *
 *  地区切换、定位
 *
 */
- (void)locationBtn:(id)sender {
    [self showAreaSelectionView];
}

/**
 *  @author 黎国基, 16-11-03 10:11
 *
 *  点中部菜单，去到不同的模块
 *
 */
- (void)menuBtn:(UIButton *)btn {
    
    NSString *menuBtnEvent = [NSString stringWithFormat:@"menuBtn_tag_%zd",btn.tag];
    [MobClick event:menuBtnEvent label:btn.titleLabel.text];
    
    switch (btn.tag) {
        case 0:{
            //全部商品
            SKGoodsClassViewController* vc = [[SKGoodsClassViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }case 1:{
            //查单
            NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
            
            NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
            if(isLoginStr == nil || isLoginStr.length == 0){
                
                LoginViewController* vc = [[LoginViewController alloc]init];
                vc.loginResultBlock = ^(BOOL success){
                    if(success) {
                        MAMyOrdersViewController* vc = [[MAMyOrdersViewController alloc] init];
                        vc.preSelectedHeaderBtnTag = 0;
                        vc.shouldGoBackToRootController = NO;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                };
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
                navi.navigationBar.translucent = NO;
                [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                
                [self presentViewController:navi animated:YES completion:nil];
            }else {
                MAMyOrdersViewController* vc = [[MAMyOrdersViewController alloc] init];
                vc.preSelectedHeaderBtnTag = 0;
                vc.shouldGoBackToRootController = NO;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }case 2:{
            //爆款
            MAHotGoodsViewController* vc = [[MAHotGoodsViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }case 3:{
            //礼券
            MAGiftCertificateViewController* vc = [[MAGiftCertificateViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 4:{
            //分享
            [self requestShopInfoForShare];
            
            break;
        }
        case 5:{
            //农业120
            SKHtmlTabbarController *vc = [[SKHtmlTabbarController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 6:{
            //了丰收
            [MyUtile showAlertViewByMsg:@"该功能还未上线，敬请期待！" vc:self];
            
            break;
        }case 7:{
            //民生信息
            [MyUtile showAlertViewByMsg:@"该功能还未上线，敬请期待！" vc:self];
            
            break;
        }case 8:{
            //知天下
            MAKnowWorldViewController *vc = [[MAKnowWorldViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }case 9:{
            //积分商城
            NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
            
            NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
            if(isLoginStr == nil || isLoginStr.length == 0){
                
                LoginViewController* vc = [[LoginViewController alloc]init];
                vc.loginResultBlock = ^(BOOL success){
                    if(success) {
                        MACreditsGoodsMallViewController* vc = [[MACreditsGoodsMallViewController alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                };
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
                navi.navigationBar.translucent = NO;
                [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                
                [self presentViewController:navi animated:YES completion:nil];
            }else {
                MACreditsGoodsMallViewController* vc = [[MACreditsGoodsMallViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Custom tasks

- (void)refreshViewControllerTitle {
    
//    _titleBtn.hidden = YES;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _titleBtn.hidden = NO;
//    });
    
    [_titleBtn setTitle:_shopName forState:UIControlStateNormal];
    [_titleBtn setImage:nil forState:UIControlStateNormal];
    
    [_titleBtn setImageEdgeInsets:UIEdgeInsetsZero];
    [_titleBtn setTitleEdgeInsets:UIEdgeInsetsZero];
    
    if (_shopListArray != nil && _shopListArray.count > 1) {
        
        [_titleBtn setImage:[UIImage imageNamed:@"arrowWhiteDown"] forState:UIControlStateNormal];//@"tick1"
        
        UIImageView *imageView = _titleBtn.imageView;
        UILabel *titleLabel = _titleBtn.titleLabel;
        
        CGFloat imageInset = titleLabel.frame.size.width;
        CGFloat titleInset = imageView.frame.size.width + 2.f;
        
        [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, imageInset, 0.f, -imageInset)];
        [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -titleInset, 0.f, titleInset)];
        
    }else {
        
    }
}

/**
 *  @author 黎国基, 16-11-02 20:11
 *
 *  弹出地区选择/定位界面
 */
- (void)showAreaSelectionView {
    
    if (_locationVC.presentingViewController == nil) {
        [self presentViewController:_locationVC animated:YES completion:nil];
    }
}

#pragma mark - Http request

//2.9.1、初始化新农宝APP商城首页店铺信息以及返回第一页商品
-(void)requestInitHomePageInfo{
    
    if (!_isLoading) {
        
        _isLoading = YES;
        _lastIndex = 0;
        
        NSMutableDictionary *prameterDic = [[NSMutableDictionary alloc] initWithCapacity:4];
        
        if (_shopId != nil) {
            [prameterDic setObject:_shopId forKey:@"shopId"];
        }
        
        if (_areaId != nil) {
            [prameterDic setObject:_areaId forKey:@"areaId"];
        }
        
        [JKURLSession taskWithMethod:@"goods/initshophome.do" parameter:prameterDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            
            _isLoading = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
                
                if (error == nil) {
                    [self requestBannerList];
                    
                    [_mGoodsArray removeAllObjects];
                    
                    if([resultDic[@"data"] count] > 0){
                        [_mGoodsArray addObjectsFromArray:resultDic[@"data"][@"goods"]];
                        if(_lastIndex == 0){
                            NSString *surl = [NSString stringWithFormat:@"%@/goods/initshophome.do",SERVER_ADDR_XNBMALL];
                            [CacheUtils setCacheData:surl withPost:prameterDic withData:resultDic[@"data"]];
                        }
                        
                        NSArray *arr = [_mGoodsArray lastObject][@"goods"];
                        for(NSDictionary *dic in arr){
                            _lastIndex = [dic[@"templateIndex"] integerValue];
                        }
                    }
                    [_collectionView reloadData];
                    
                    _streetInfoDic = resultDic[@"data"][@"street"];
                    
                    [_locationBtn setTitle:_streetInfoDic[@"street"][@"name"] forState:UIControlStateNormal];
                    [_locationBtn sizeToFit];
                    [_locationBtn verticalImageAndTitle:1];
                    
                    _locationVC.shopInitAddressDic = _streetInfoDic;
                    
                    //是否主动弹出地址选择view
                    if([resultDic[@"data"][@"showAreaSelector"] boolValue]){
                        
                        UITabBarController *tabCtroller = self.tabBarController;
                        NSInteger selectedIndex = tabCtroller.selectedIndex;
                        
                        if (selectedIndex == 0 && self.navigationController.viewControllers.count == 1) {
                            //当前在首页
                            [self showAreaSelectionView];
                        }else {
                            _needToPopAreaSelectorWhenAppear = YES;
                        }
                    }
                    
                    _shopName = resultDic[@"data"][@"shopName"];
                    if(![NSString isBlankString:_shopName]){
                        
                        _shopId = resultDic[@"data"][@"shopId"];
                        _areaId = _streetInfoDic[@"street"][@"id"];
                        
                        [self refreshViewControllerTitle];
                        
                        [self requestServiceShopsNearby];
                    }
                }else {
                    [self showAutoDissmissHud:error.localizedDescription];
                }
            });
        }];
    }
}


//2.9.2、分段查询商城首页商品
-(void)loadMoreHotGoods{
    //上次加载的最后一个商品的模板序号templateIndex的值，首次加载时传0
    
    if (!_isLoading) {
        
        _isLoading = YES;
        NSDictionary *prameterDic = @{@"lastIndex":[NSString stringWithFormat:@"%zd",_lastIndex]};
        NSString *surl = [NSString stringWithFormat:@"%@/goods/shophotsale.do",SERVER_ADDR_XNBMALL];
        
        [JKURLSession taskWithMethod:@"goods/shophotsale.do" parameter:prameterDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            
            _isLoading = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    if(_lastIndex == 0) [_mGoodsArray removeAllObjects];//多余，理论永不执行
                    
                    id arrayExpected = resultDic[@"data"];
                    if([arrayExpected isKindOfClass:[NSArray class]] && [arrayExpected count] > 0){
                        //坑爹啊，这个接口。。。有数据时,{"data":[...]...}没数据时，{"data":{}...}，
                        
                        /**
                         *  @author 黎国基, 16-11-24 21:11
                         *
                         *  上一次获取的数据，比如类别是手机，没有获取全部，要把本次获取的手机拼接到同一个section里面
                         */
                        
                        NSArray *pageArray = resultDic[@"data"];
                        
                        NSDictionary *lastSectionDic = [_mGoodsArray lastObject];
                        NSDictionary *nextSectionDic = pageArray[0];
                        
                        if (nextSectionDic[@"catogeryId"] == nil || [nextSectionDic[@"catogeryId"] isEqualToString:@""] || [nextSectionDic[@"catogeryId"] isEqualToString:lastSectionDic[@"catogeryId"]]) {
                            //把这次获取的第一个section数据，拼到上一个section
                            NSMutableDictionary *mLastSectionDic = [[NSMutableDictionary alloc] initWithDictionary:lastSectionDic];
                            NSArray *lastSectionArray = mLastSectionDic[@"goods"];
                            NSMutableArray *mLastSectionArray = [[NSMutableArray alloc] initWithArray:lastSectionArray];
                            [mLastSectionArray addObjectsFromArray:nextSectionDic[@"goods"]];
                            [mLastSectionDic setObject:mLastSectionArray forKey:@"goods"];
                            [_mGoodsArray removeLastObject];
                            [_mGoodsArray addObject:mLastSectionDic];
                            //再把剩余的section加进来
                            NSMutableArray *remainSectionsArray = [[NSMutableArray alloc] initWithArray:pageArray];
                            [remainSectionsArray removeObjectAtIndex:0];//移除第一个section,
                            [_mGoodsArray addObjectsFromArray:remainSectionsArray];//加入剩余的section
                        }else {
                            [_mGoodsArray addObjectsFromArray:pageArray];
                        }
                        
                        if(_lastIndex == 0){
                            [CacheUtils setCacheData:surl withPost:prameterDic withData:resultDic[@"data"]];
                        }
                        
                        NSArray *arr = [_mGoodsArray lastObject][@"goods"];
                        for(NSDictionary *dic in arr){
                            _lastIndex = [dic[@"templateIndex"] integerValue];
                        }
                        [_collectionView.mj_footer endRefreshing];
                    }else {
                        [_collectionView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                    [_collectionView reloadData];
                }else {
                    [_collectionView.mj_footer endRefreshing];
                    [self showAutoDissmissHud:error.localizedDescription];
                }
            });
        }];
    }
}

//2.1.0、获取首页banner广告

- (void)requestBannerList {
    
    //其中location的参数值根据具体使用场景约定。农掌柜APP首页上面的banner位置值为：11；农掌柜礼券列表页的banner位置值为：15；农掌柜订单管理首页的banner位置值为：16，新农宝商城的banner位置值为1
    NSMutableDictionary *prameterDic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [prameterDic setObject:@"1" forKey:@"location"];
    if (_areaId != nil) {
        [prameterDic setObject:_areaId forKey:@"areaId"];
    }
    
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

//10.1.0 分享店铺 (可先对接好，上线需屏蔽分享功能)
-(void)requestShopInfoForShare{
    
    NSMutableDictionary *prameterDic = [[NSMutableDictionary alloc] init];
    if (_shopId != nil) {
        [prameterDic setObject:_shopId forKey:@"shopId"];
    }
    if (_areaId != nil) {
        [prameterDic setObject:_areaId forKey:@"areaId"];
    }
    
    [JKURLSession taskWithMethod:@"share/shareshop.do" parameter:prameterDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                
                NSDictionary *dic = resultDic[@"data"];
                ShareWithFriendsViewCtr *lacationVC = [[ShareWithFriendsViewCtr alloc] init];
                
                lacationVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                lacationVC.preferredContentSize = CGSizeMake(SCREEN_WIDTH/6*4, SCREEN_WIDTH*5/6+50);
                
                lacationVC.gettitle = dic[@"title"];
                lacationVC.geturl = dic[@"link"];
                lacationVC.getimage = dic[@"imgLink"];
                lacationVC.getdescription = dic[@"content"];
                
                [self presentViewController:lacationVC animated:YES completion:nil];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

- (void)requestServiceShopsNearby {
    
    if (_areaId != nil) {
        //@{@"areaId":_areaId}
        [JKURLSession taskWithMethod:@"serviceshop/parseNearbyitem.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    
                    _shopListArray = resultDic[@"data"][@"list"];
                    
                    [self refreshViewControllerTitle];
                    //
                }else {
                }
            });
        }];
    }
}

#pragma mark - Notifications

//用户退出
- (void)logoutSignal {
    
    [self resetDataForDiffrentUser];
    
    [self requestInitHomePageInfo];
}
//用户登录
- (void)loginSignal {
    [self resetDataForDiffrentUser];
    
    [self requestInitHomePageInfo];
}

#pragma mark - remote Notification

/**
 *  @author 黎国基, 17-01-03 20:01
 *
 *  离线推送
 *
 *  @param aNotification
 */
-(void)getuiNotificationOffLine:(NSNotification*)aNotification
{
    NSLog(@"推送通知详情");
    UITabBarController *tabVC = self.tabBarController;
    [tabVC setSelectedIndex:1];
    
    UINavigationController *msgNav = tabVC.viewControllers[1];
    [msgNav popToRootViewControllerAnimated:NO];
    
    NSDictionary * contentDic = [aNotification object];
    NSInteger msgType = [contentDic[@"msgType"] integerValue];
    //消息类型：0是下载url，1是网页跳转url，2是文本消息
    if (msgType == 0) {
        //丢弃
    }else if (msgType == 1){
        //H5详情
        SKBaseH5ViewController* vc = [[SKBaseH5ViewController alloc]init];
        vc.showFloatBtn = YES;
        vc.dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"link":contentDic[@"content"]}];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (msgType == 2){
        MsgDetailViewController *iv  = [[MsgDetailViewController alloc] init];
        iv.getmessgeid = contentDic[@"content"];
        iv.hidesBottomBarWhenPushed = YES;
        
        [msgNav pushViewController:iv animated:NO];
    }
    //
    NSDictionary *postdata = @{@"msgId":contentDic[@"content"]};
    [JKURLSession taskWithMethod:@"message/reportRead.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {}];//上报通知的阅读状态
}

/**
 *  @author 黎国基, 17-01-03 20:01
 *
 *  在线推送
 *
 *  @param aNotification
 */
-(void)getuiNotificationOnLine:(NSNotification*)aNotification
{
    UITabBarController *tabVC = self.tabBarController;
    
    UIViewController *vc = tabVC.viewControllers[1];
    [vc.tabBarItem setBadgeValue:@""];//message vc nav
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您有新消息"  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction: [UIAlertAction actionWithTitle: @"立即查看" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [tabVC setSelectedIndex:1];
        
        UINavigationController *msgNav = tabVC.viewControllers[1];
        [msgNav popToRootViewControllerAnimated:NO];
        
        NSDictionary * contentDic = [aNotification object];
        NSInteger msgType = [contentDic[@"msgType"] integerValue];
        //消息类型：0是下载url，1是网页跳转url，2是文本消息
        if (msgType == 0) {
            //丢弃
        }else if (msgType == 1){
            //H5详情
            SKBaseH5ViewController* vc = [[SKBaseH5ViewController alloc]init];
            vc.showFloatBtn = YES;
            vc.dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"link":contentDic[@"content"]}];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (msgType == 2){
            MsgDetailViewController *iv  = [[MsgDetailViewController alloc] init];
            iv.getmessgeid = contentDic[@"content"];
            iv.hidesBottomBarWhenPushed = YES;
            
            [msgNav pushViewController:iv animated:NO];
        }
        //
        NSDictionary *postdata = @{@"msgId":contentDic[@"content"]};
        [JKURLSession taskWithMethod:@"message/reportRead.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {}];//上报通知的阅读状态
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}

#pragma mark - SkChangeLocationAddressDelegate

- (void)changeLocationAddress:(NSDictionary *)value{
    
    [MobClick event:@"getLocation" label:@"定位地址"];
    
    [_locationBtn setTitle:value[@"street"][@"name"] forState:UIControlStateNormal];
    [_locationBtn sizeToFit];
    [_locationBtn verticalImageAndTitle:1];
    
    _areaId = value[@"street"][@"id"];
    
    _shopListArray = nil;
    _shopId = nil;
    _shopName = @"新农宝";
    
    [self refreshViewControllerTitle];
    
    [self requestInitHomePageInfo];
}

#pragma mark - SKShopChosenViewControllerDelegate

- (void)shopChosen:(NSDictionary *)shopDic {
    
    _shopName = shopDic[@"name"];
    _shopId = shopDic[@"id"];
    
    [self refreshViewControllerTitle];
    [self requestInitHomePageInfo];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [MobClick event:@"bannerAdClick" label:@"首页广告点击"];
    
    SKBaseH5ViewController* vc = [[SKBaseH5ViewController alloc]init];
    vc.dic = _mBannerListArray[index];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - MAGoodsReusableHeaderDelegate

- (void)goodsHeaderSeeMoreGoodsAtSection:(NSInteger)section {
    
    NSDictionary *secitonDic = _mGoodsArray[section - 2];
    
    MAGoodsListViewController* vc = [[MAGoodsListViewController alloc]init];
    vc.categoryId = secitonDic[@"catogeryId"];
    vc.categoryName = secitonDic[@"catogeryName"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _mGoodsArray.count + 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section < 2) {
        return 0;
    }
    NSDictionary *secitonDic = _mGoodsArray[section - 2];
    NSArray *sectionArray = secitonDic[@"goods"];
    return sectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *secitonDic = _mGoodsArray[indexPath.section - 2];
    NSArray *sectionArray = secitonDic[@"goods"];
    
    static NSString *cellID = @"cellID";
    MAGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSDictionary *goodInfoDic = sectionArray[indexPath.item];
    
    cell.imageUrlStr = goodInfoDic[@"thumbnailUrl"];
    cell.titleStr = goodInfoDic[@"title"];
    cell.price = [goodInfoDic[@"goodsPrice"][@"retailPrice"] floatValue];
    cell.sellCount = [goodInfoDic[@"saleNumber"] floatValue];
    
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
        
        if (indexPath.section == 0) {
            //banner
            view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderID" forIndexPath:indexPath];
            
            [view addSubview:_cycleScrollView];
            
        }else if (indexPath.section == 1) {
            //menu btn
            view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderID" forIndexPath:indexPath];
            
            [view addSubview:_menuBtnSection];
        }else {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
            
            NSDictionary *secitonDic = _mGoodsArray[indexPath.section - 2];
            
            MAGoodsReusableHeader *header = (MAGoodsReusableHeader *)view;
            header.title = secitonDic[@"catogeryName"];
            header.section = indexPath.section;
            header.delegate = self;
        }
    }else {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerID" forIndexPath:indexPath];
    }
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *secitonDic = _mGoodsArray[indexPath.section - 2];
    NSArray *sectionArray = secitonDic[@"goods"];
    NSDictionary *itemDic = sectionArray[indexPath.item];
    
    MAGoodsDetailsViewController* vc = [[MAGoodsDetailsViewController alloc]init];
    vc.goodsSpecId = itemDic[@"goodsSpecId"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 0 || section == 1) {
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
    
    return CGSizeMake(cellW, imageH + 75.f);
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
    
    CGFloat headerH = 0.f;
    if (section == 0) {
        headerH = _cycleScrollView.frame.size.height;//banner
    }else if (section == 1) {
        headerH = _menuBtnSection.fHeight;
    }else {
        headerH = 48.f;//与MAGoodsReusableHeader初始化方法的assumeHeaderH一致
    }
    
    return CGSizeMake(SCREEN_WIDTH, headerH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGFloat footerH = 0.f;
    
    return CGSizeMake(SCREEN_WIDTH, footerH);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat collectionViewH = SCREEN_HEIGHT - 64 - 49.f;
    
    if (scrollView.contentOffset.y > collectionViewH) {
        _goTopBtn.hidden = NO;
    }else {
        _goTopBtn.hidden = YES;
    }
}

@end
