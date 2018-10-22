/**
 * MAShoppingCartViewController.m 16/11/14
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAShoppingCartViewController.h"

#import "MAShoppingCartCell.h"
#import "MAShoppingCartHeader.h"
#import "MAShoppingCartInfoHandler.h"
#import "SKMixBuyGoodsViewController.h"
#import "SKSettleViewController.h"
#import "MAGoodsDetailsViewController.h"
#import "LoginViewController.h"

@interface MAShoppingCartViewController ()<UITableViewDataSource, UITableViewDelegate, MAShoppingCartHeaderDelegate, MAShoppingCartCellDelegate> {
    
    JKTableView *_tableView;
    
    JKButton *_checkAllBtn;         //底部全选按钮
    JKLabel *_totalAmountLabel;
    
    JKView *_mask;                  //弹出键盘时，遮住scrollview禁止滚动
    JKView *_emptyExceptionView;
    
    NSMutableArray *_mGoodsArray;       //购物车商品
    
    CGFloat _tfBottom;
    
    NSString *_dfAddressId;             //默认收货地址
}
@end

@implementation MAShoppingCartViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"购物车"];
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self refresh];
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr != nil && isLoginStr.length > 0){
        [self requestDefaultAddess];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  @author 黎国基, 16/11/14
 *
 *  初始化数据
 */
- (void)initData {
 
    _mGoodsArray = [[NSMutableArray alloc] initWithCapacity:10];
    
}

/**
 *  @author 黎国基, 16/11/14
 *
 *  创建UI界面
 */
- (void)createUI {
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"垃圾桶"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    CGFloat bottomH = 56.f;
    CGFloat tabbarH = 0.f;
    if (!self.tabBarController.tabBar.hidden) {
        tabbarH = self.tabBarController.tabBar.frame.size.height;
    }
    
    CGFloat tableViewH = SCREEN_HEIGHT - 64.f - bottomH - tabbarH;
    
    _tableView = [[JKTableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, tableViewH) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
//    bottom view
    JKView *bottomView = [[JKView alloc] initWithFrame:CGRectMake(0.f, _tableView.maxY, SCREEN_WIDTH, bottomH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    CGFloat checkBtnW = 30.f;
    
    _checkAllBtn = [JKButton buttonWithType:UIButtonTypeCustom];
    [_checkAllBtn setFrame:CGRectMake(4.f, 0.f, checkBtnW, checkBtnW)];
    _checkAllBtn.centerY = bottomH / 2.f;
    [_checkAllBtn setImage:[UIImage imageNamed:@"uncheckedCircle"] forState:UIControlStateNormal];
    [_checkAllBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateSelected];
    [_checkAllBtn addTarget:self action:@selector(checkAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_checkAllBtn];
    
    JKAutoFitsWidthLabel *selectAllLabel = [[JKAutoFitsWidthLabel alloc] initWithFrame:CGRectMake(_checkAllBtn.maxX + 4.f, 0.f, 0.f, 21.f)];
    selectAllLabel.centerY = _checkAllBtn.centerY;
    selectAllLabel.font = FONT_HEL(13.f);
    selectAllLabel.textColor = RGBGRAY(100.f);
    selectAllLabel.text = @"全选";
    [bottomView addSubview:selectAllLabel];
    
    CGFloat settleBtnW = 80.f;
    CGFloat settleBtnX = bottomView.fWidth - 5.f - settleBtnW;
    JKButton *settleBtn = [JKButton buttonWithType:UIButtonTypeCustom];
    [settleBtn setFrame:CGRectMake(settleBtnX + 5.f, 0.f, settleBtnW,bottomH)];
    settleBtn .centerY = bottomH / 2.f;
    settleBtn.titleLabel.font = FONT_HEL(15.f);
    [settleBtn setTitle:@"结算" forState:UIControlStateNormal];
    [settleBtn setTitleColor:RGBGRAY(255.f) forState:UIControlStateNormal];
    settleBtn.backgroundColor = KBackColor(@"#ec584c");  //红色;
    
   
    [settleBtn addTarget:self action:@selector(settleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:settleBtn];
    
    CGFloat totalAmountLabelW = settleBtn.orgX - selectAllLabel.maxX - 10.f;
    
    _totalAmountLabel = [[JKLabel alloc] initWithFrame:CGRectMake(selectAllLabel.maxX + 5.f, selectAllLabel.orgY, totalAmountLabelW, 21.f)];
    _totalAmountLabel.font = FONT_HEL(13.f);
    _totalAmountLabel.textColor = RGBGRAY(100.f);
    _totalAmountLabel.text = @"";
    [bottomView addSubview:_totalAmountLabel];
    
    JKView *bottomSp = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 1.f)];
    bottomSp.backgroundColor = RGBGRAY(240.f);
    [bottomView addSubview:bottomSp];
    //
    [self createEmptyExceptionView];
    //
    _mask = [[JKView alloc] initWithFrame:_tableView.frame];
    [_mask addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)]];
    [self.view addSubview:_mask];
    _mask.hidden = YES;
}

- (void)createEmptyExceptionView {
    
    _emptyExceptionView = [[JKView alloc] initWithFrame:_tableView.frame];
    [self.view addSubview:_emptyExceptionView];
    _emptyExceptionView.backgroundColor = RGBGRAY(245.f);
    
    CGFloat exeptionImageViewD = 100.f;
    JKImageView *exeptionImageView = [[JKImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, exeptionImageViewD, exeptionImageViewD)];
    exeptionImageView.centerX = SCREEN_WIDTH / 2.f;
    exeptionImageView.centerY = SCREEN_HEIGHT / 2.f - 120.f;
    [exeptionImageView setImage:[UIImage imageNamed:@"yuan1"]];
    [_emptyExceptionView addSubview:exeptionImageView];
    
    JKLabel *tipLabel0 = [[JKLabel alloc] initWithFrame:CGRectMake(0.f, exeptionImageView.maxY + 5.f, SCREEN_WIDTH, 21.f)];
    tipLabel0.font = FONT_HEL(15.f);
    tipLabel0.textColor = RGBGRAY(200.f);
    tipLabel0.textAlignment = NSTextAlignmentCenter;
    tipLabel0.text = @"您的购物车还是空的";
    [_emptyExceptionView addSubview:tipLabel0];
    
    JKLabel *tipLabel1 = [[JKLabel alloc] initWithFrame:CGRectMake(0.f, tipLabel0.maxY + 5.f, SCREEN_WIDTH, 21.f)];
    tipLabel1.font = FONT_HEL(15.f);
    tipLabel1.textColor = RGBGRAY(100.f);
    tipLabel1.textAlignment = NSTextAlignmentCenter;
    tipLabel1.text = @"去挑几件中意的商品吧";
    [_emptyExceptionView addSubview:tipLabel1];
    
    CGFloat goBuySomeGoodsBtnW = 100.f;
    JKButton *goBuySomeGoodsBtn = [JKButton buttonWithType:UIButtonTypeCustom];
    [goBuySomeGoodsBtn setFrame:CGRectMake(0.f, tipLabel1.maxY + 10.f, goBuySomeGoodsBtnW, 35.f)];
    goBuySomeGoodsBtn.centerX = tipLabel1.centerX;
    [goBuySomeGoodsBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
    [goBuySomeGoodsBtn setTitleColor:RGBGRAY(100.f) forState:UIControlStateNormal];
    [goBuySomeGoodsBtn addTarget:self action:@selector(goBuySomeGoodsBtn) forControlEvents:UIControlEventTouchUpInside];
    [_emptyExceptionView addSubview:goBuySomeGoodsBtn];
    
    goBuySomeGoodsBtn.layer.borderColor = RGBGRAY(200.f).CGColor;
    goBuySomeGoodsBtn.layer.borderWidth = 1.f;
    goBuySomeGoodsBtn.layer.cornerRadius = 5.f;
    goBuySomeGoodsBtn.clipsToBounds = YES;
}

#pragma mark - Touch events

- (void)goBuySomeGoodsBtn {
    
    if(self.navigationController.viewControllers.count > 1){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)rightItem {
    
    if (_mGoodsArray.count > 0) {
        
        NSString *cartIds = @"";
        
        for(NSDictionary *sectionDic in _mGoodsArray){
            
            NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
            
            for(NSDictionary *goodsDic in sectionGoodsArray){
                NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
                if ([MAShoppingCartInfoHandler isGoodsSelected:goodsSpecificationId]) {
                    
                    NSString *cartId = goodsDic[@"cartId"];
                    
                    cartIds = [cartIds stringByAppendingString:cartId];
                    cartIds = [cartIds stringByAppendingString:@","];
                }
            }
        }
        if(cartIds.length > 0){
            NSInteger cartIdsLen = cartIds.length;
            cartIds = [cartIds substringToIndex:cartIdsLen-1];
        }
        
        if (cartIds.length == 0) {
            [self showAutoDissmissHud:@"未选中任何商品"];
        }else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除已选中的购物车商品？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [MobClick event:@"ClearShoppingCartGoodsThatSelected" label:@"删除选中的购物车商品"];
                
                [self removeAllSelectedShoppingCartGoods:cartIds];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            
            [alert addAction:ok];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:^{}];
        }
    }else {
        [self showAutoDissmissHud:@"购物车没有商品"];
    }
}

- (void)maskTap:(id)sender {
    
    [_tableView endEditing:YES];
}

/**
 *  @author 黎国基, 16-11-14 22:11
 *
 *  全选
 *
 *  @param sender
 */
- (void)checkAllBtn:(JKButton *)btn {
    
    BOOL checkState = !btn.selected;
    
    btn.selected = checkState;
    
    for (NSDictionary *sectionDic in _mGoodsArray) {
        NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
        
        for (NSDictionary *goodsDic in sectionGoodsArray) {
            NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
            
            [MAShoppingCartInfoHandler setGoods:goodsSpecificationId selected:checkState];
        }
    }
    
    [_tableView reloadData];
    
    [self refreshTotalAmountText];
}

- (void)settleBtn:(JKButton *)btn {
    
    NSInteger selectedGoodsCount = 0;
    for (int section = 0; section < _mGoodsArray.count; section++) {
        selectedGoodsCount = selectedGoodsCount + [self selectedGoodsCountForSection:section];
    }
    if (selectedGoodsCount == 0) {
        [self showAutoDissmissHud:@"未选中任何商品"];
        return;
    }
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    if(isLoginStr == nil || isLoginStr.length == 0){
        //强制登录
        
        NSMutableDictionary *mGoodsDic = [[NSMutableDictionary alloc] init];
        
        for (NSDictionary *sectionDic in _mGoodsArray) {
            NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
            
            for (NSDictionary *goodsDic in sectionGoodsArray) {
                
                NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
                if ([MAShoppingCartInfoHandler isGoodsSelected:goodsSpecificationId]) {
                    
                    NSString *numberStr = [NSString stringWithFormat:@"%zd",[goodsDic[@"number"] integerValue]];
                    [mGoodsDic setObject:numberStr forKey:goodsSpecificationId];
                }
            }
        }
        
        LoginViewController* vc = [[LoginViewController alloc]init];
        vc.loginResultBlockBeforeDissmiss = ^(BOOL success){
            //block执行0.1s后，loginVC被dismiss,self执行viewwillappear,刷新_mGoodsArray
            if(success) {
                [MobClick event:@"cart_settle_after_login" label:@"购物车先登录后结算"];
                //把当前购物车的商品加入购物车，
                [self requestAddGostCartGoodsToUserCart];
                //结算当前购物车选中的商品（不包括用户自己购物车的商品）
                [self requestSettleGoods:mGoodsDic];//[MAShoppingCartInfoHandler isGoodsSelected:goodsSpecificationId]token已变，必须在登录前把mGoodsDic准备好
            }
        };
        
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        navi.navigationBar.translucent = NO;
        [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [self presentViewController:navi animated:YES completion:nil];
    }else {
        [MobClick event:@"cart_settle_already_login" label:@"购物车已登录结算"];
        //直接结算当前购物车选中商品
        [self requestSettle];
    }
}

#pragma mark - Custom tasks

- (void)refresh {
    
    [_mGoodsArray removeAllObjects];
    [_tableView reloadData];
    
    [self requestShopppingCartGoods];
}

/**
 *  @author 黎国基, 16-11-15 17:11
 *
 *  根据每个section中每个cell是否选中来判断 这个 section是否选中
 *
 *  @param setction
 *
 *  @return 这个section是否要选中
 */
- (BOOL)isHeaderShouldBeSelectedAtSection:(NSInteger)section {
    
    NSDictionary *sectionDic = _mGoodsArray[section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    
    BOOL isHeaderShouldBeSelected = YES;
    
    for (NSDictionary *goodsDic in sectionGoodsArray) {
        NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
        
        if (![MAShoppingCartInfoHandler isGoodsSelected:goodsSpecificationId]) {
            isHeaderShouldBeSelected = NO;//section中只要有一个cell未选中，header就为 未选中
            break;
        }
    }
    
    return isHeaderShouldBeSelected;
}

/**
 *  @author 黎国基, 16-11-15 17:11
 *
 *  整个页面是否全选
 *
 *  @return 只要有一个 section header没有选上，就返回NO，否则返回YES
 */
- (BOOL)isCheckAllBtnShouldBeSelected {
    
    BOOL isCheckAllBtnShouldBeSelected = YES;
    
    if (_mGoodsArray.count == 0) {
        return NO;
    }
    for (int section = 0; section < _mGoodsArray.count; section++) {
        
        if (![self isHeaderShouldBeSelectedAtSection:section]) {
            isCheckAllBtnShouldBeSelected = NO;
            break;
        }
    }
    
    return isCheckAllBtnShouldBeSelected;
}

/**
 *  @author 黎国基, 16-11-15 18:11
 *
 *  计算 总金额
 *
 *  @return 总金额
 */
- (CGFloat)caculateTotalAmount {
    
    CGFloat totalAmount = 0.f;
    
    for (NSDictionary *sectionDic in _mGoodsArray) {
        NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
        
        for (NSDictionary *goodsDic in sectionGoodsArray) {
            
            NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
            if ([MAShoppingCartInfoHandler isGoodsSelected:goodsSpecificationId]) {
                totalAmount = totalAmount + [goodsDic[@"price"] floatValue] * [goodsDic[@"number"] integerValue];
            }
        }
    }
    return totalAmount;
}

/**
 *  @author 黎国基, 16-11-15 19:11
 *
 *  计算此 section 已选商品的数量
 *
 *  @param section section
 *
 *  @return 已选商品数量
 */
- (NSInteger)selectedGoodsCountForSection:(NSInteger)section {
    
    NSDictionary *sectionDic = _mGoodsArray[section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    
    NSInteger sectionGoodsCount = 0;
    for (NSDictionary *goodsDic in sectionGoodsArray) {

        NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
        if ([MAShoppingCartInfoHandler isGoodsSelected:goodsSpecificationId]) {
            sectionGoodsCount = sectionGoodsCount + [goodsDic[@"number"] integerValue];
        }
    }
    return sectionGoodsCount;
}

- (NSInteger)goodsCountForSection:(NSInteger)section {
    
    NSDictionary *sectionDic = _mGoodsArray[section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    
    NSInteger sectionGoodsCount = 0;
    for (NSDictionary *goodsDic in sectionGoodsArray) {
        sectionGoodsCount = sectionGoodsCount + [goodsDic[@"number"] integerValue];
    }
    return sectionGoodsCount;
}

- (void)refreshTotalAmountText {
    
    CGFloat totalAmount = [self caculateTotalAmount];
    UIColor *grayColor = RGBGRAY(100.f);
    UIFont *font1 = FONT_HEL(14.f);
    UIFont *font2 = FONT_HEL(12.f);
    
    NSString *text0 = @"合计：";
    NSString *text1 = [NSString stringWithFormat:@"￥%.2f",totalAmount];
    NSString *text2 = @"（含运费）";
    
    NSString *combinedStr = [NSString stringWithFormat:@"%@%@%@",text0,text1,text2];
    
    NSMutableAttributedString *mAtr = [[NSMutableAttributedString alloc] initWithString:combinedStr];
    [mAtr setAttributes:@{NSForegroundColorAttributeName:grayColor,NSFontAttributeName:font1} range:NSMakeRange(0, text0.length)];
    [mAtr setAttributes:@{NSForegroundColorAttributeName:THEMECOLOR,NSFontAttributeName:font1} range:NSMakeRange(text0.length, text1.length)];
    [mAtr setAttributes:@{NSForegroundColorAttributeName:grayColor,NSFontAttributeName:font2} range:NSMakeRange(text0.length + text1.length, text2.length)];
    
    _totalAmountLabel.attributedText = mAtr;
}

- (void)setGoodsCount:(NSInteger)count atIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *sectionDic = _mGoodsArray[indexPath.section];
    NSMutableDictionary *mSectionDic = [[NSMutableDictionary alloc] initWithDictionary:sectionDic];
    
    NSArray *sectionGoodsArray = mSectionDic[@"cartGoodsList"];
    NSMutableArray *mSectionGoodsArray = [[NSMutableArray alloc] initWithArray:sectionGoodsArray];
    
    NSDictionary *goodsDic = mSectionGoodsArray[indexPath.row];
    NSMutableDictionary *mGoodsDic = [[NSMutableDictionary alloc] initWithDictionary:goodsDic];
    
    [mGoodsDic setObject:@(count) forKey:@"number"];
    //
    [mSectionGoodsArray replaceObjectAtIndex:indexPath.row withObject:mGoodsDic];
    
    [mSectionDic setObject:mSectionGoodsArray forKey:@"cartGoodsList"];
    
    [_mGoodsArray replaceObjectAtIndex:indexPath.section withObject:mSectionDic];
}

- (void)removeGoodsAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *sectionDic = _mGoodsArray[indexPath.section];
    NSMutableDictionary *mSectionDic = [[NSMutableDictionary alloc] initWithDictionary:sectionDic];
    
    NSArray *sectionGoodsArray = mSectionDic[@"cartGoodsList"];
    NSMutableArray *mSectionGoodsArray = [[NSMutableArray alloc] initWithArray:sectionGoodsArray];
    
    [mSectionGoodsArray removeObjectAtIndex:indexPath.row];
    //
    if (mSectionGoodsArray.count == 0) {
        [_mGoodsArray removeObjectAtIndex:indexPath.section];
    }else {
        [mSectionDic setObject:mSectionGoodsArray forKey:@"cartGoodsList"];
        [_mGoodsArray replaceObjectAtIndex:indexPath.section withObject:mSectionDic];
    }
}

/**
 *  @author 黎国基, 16-11-16 20:11
 *
 *  起订量
 *
 *  @param indexPath 对应 Index的商品
 *
 *  @return 该商品的起订量
 */
- (NSInteger)MOQAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *sectionDic = _mGoodsArray[indexPath.section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    NSDictionary *goodsDic = sectionGoodsArray[indexPath.row];
    
    return [goodsDic[@"moq"] integerValue];
}

/**
 *  @author 黎国基, 16-11-16 20:11
 *
 *  增定量
 *
 *  @param indexPath
 *
 *  @return 增订量
 */
- (NSInteger)IOQAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *sectionDic = _mGoodsArray[indexPath.section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    NSDictionary *goodsDic = sectionGoodsArray[indexPath.row];
    
    return [goodsDic[@"ioq"] integerValue];
}

/**
 *  @author 黎国基, 16-11-16 20:11
 *
 *  这个section组是不是支持混批
 *
 *  @param section 组号
 *
 *  @return 是否支持混批
 */
- (BOOL)isMinBuySection:(NSInteger)section {
    
    NSDictionary *sectionDic = _mGoodsArray[section];
    
    BOOL isMinBuy = NO;
    if (sectionDic[@"mixBuy"] != nil && [sectionDic[@"mixBuy"] boolValue]) {
        isMinBuy = YES;
    }
    
    return isMinBuy;
}

#pragma mark - Http request

/**
 *  @author 黎国基, 16-11-15 23:11
 *
 *  获取收货默认地址
 */
- (void)requestDefaultAddess {
    
    [JKURLSession taskWithMethod:@"user/defaultaddress.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error == nil) {
                
                NSDictionary *addressDic = resultDic[@"addr"];
                _dfAddressId =  addressDic[@"id"];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

/**
 *  @author 黎国基, 16-11-15 23:11
 *
 *  获取购物车 商品
 */
- (void)requestShopppingCartGoods {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"goods/cart.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if (error == nil) {

                [_mGoodsArray addObjectsFromArray:resultDic[@"data"]];
                [_tableView reloadData];
                
                _checkAllBtn.selected = [self isCheckAllBtnShouldBeSelected];
                
                [self refreshTotalAmountText];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

/**
 *  @author 黎国基, 16-11-17 11:11
 *
 *  把游魂野鬼的购物车的商品 加入到 当前用户的 购物车
 */
- (void)requestAddGostCartGoodsToUserCart {
    
    NSString *cartIds = @"";
    NSString *numbers = @"";
    
    for(NSDictionary *sectionDic in _mGoodsArray){
        
        NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
        
        for(NSDictionary *goodsDic in sectionGoodsArray){
            
            NSString *cartId = goodsDic[@"cartId"];
            NSString *number = [NSString stringWithFormat:@"%zd",[goodsDic[@"number"] integerValue]];
            
            cartIds = [cartIds stringByAppendingString:cartId];
            cartIds = [cartIds stringByAppendingString:@","];
            
            numbers = [numbers stringByAppendingString:number];
            numbers = [numbers stringByAppendingString:@","];
        }
    }
    if(cartIds.length > 0){
        NSInteger cartIdsLen = cartIds.length;
        cartIds = [cartIds substringToIndex:cartIdsLen-1];
    }
    if(numbers.length > 0){
        NSInteger numbersLen = numbers.length;
        numbers = [numbers substringToIndex:numbersLen-1];
    }

    NSDictionary *praDic = @{@"cartId":cartIds,@"number":numbers};
    
    //当调这个接口的时候，用户已经登录了，有了新的token，把本地的_mGoodsArray商品，添加到token所属用户购物车
    //为了保留_mGoodsArray暂时不变，登陆后先执行了这个block回调，再dissmiss，防止viewwillappear重新请求篡改_mGoodsArray
    [JKURLSession taskWithMethod:@"goods/addcartitem.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
            }else {
            }
        });
    }];
}

/**
 *  @author 黎国基, 16-11-15 22:11
 *
 *  把本地购物车的商品更新到服务器
 *  thenSettle 更新后是否结算
 */
- (void)requestUploadShopppingCartGoodsAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *sectionDic = _mGoodsArray[indexPath.section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    NSDictionary *goodsDic = sectionGoodsArray[indexPath.row];
    
    NSString *cartId = goodsDic[@"cartId"];
    NSString *number = [NSString stringWithFormat:@"%zd",[goodsDic[@"number"] integerValue]];//本地(可能)已经修改过的数据，还没上传
    
    NSDictionary *praDic = @{@"cartId":cartId,@"number":number};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
    
    [JKURLSession taskWithMethod:@"goods/recountcartitem.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if (error == nil) {
                [self setGoodsCount:[resultDic[@"data"] integerValue] atIndexPath:indexPath];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];//影响包括本section的header
                
                [self refreshTotalAmountText];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

/**
 *  @author 黎国基, 16-11-16 09:11
 *
 *  删除一个商品
 *
 *  @param indexPath
 */
- (void)requestRemoveShopppingCartGoodsAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *sectionDic = _mGoodsArray[indexPath.section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    NSDictionary *goodsDic = sectionGoodsArray[indexPath.row];
    
    NSString *cartId = goodsDic[@"cartId"];
    
    NSDictionary *praDic = @{@"cartId":cartId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
    [JKURLSession taskWithMethod:@"goods/removeystcartitems.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if (error == nil) {
                [self removeGoodsAtIndexPath:indexPath];
                [_tableView reloadData];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

- (void)removeAllSelectedShoppingCartGoods:(NSString *)cartIds {

    NSDictionary *praDic = @{@"cartId":cartIds};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
    [JKURLSession taskWithMethod:@"goods/removeystcartitems.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if (error == nil) {
                [self refresh];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

- (void)requestSettle {
    
    NSMutableDictionary *mGoodsDic = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *sectionDic in _mGoodsArray) {
        NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
        
        for (NSDictionary *goodsDic in sectionGoodsArray) {
            
            NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
            if ([MAShoppingCartInfoHandler isGoodsSelected:goodsSpecificationId]) {
                
                NSString *numberStr = [NSString stringWithFormat:@"%zd",[goodsDic[@"number"] integerValue]];
                [mGoodsDic setObject:numberStr forKey:goodsSpecificationId];
            }
        }
    }
    [self requestSettleGoods:mGoodsDic];
}

- (void)requestSettleGoods:(NSDictionary *)goodsDic {
    
    NSMutableDictionary *mPraDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [mPraDic setObject:goodsDic forKey:@"goods"];
    [mPraDic setObject:[NSNumber numberWithBool:YES] forKey:@"usedGiftCard"];
    if (_dfAddressId != nil) {
        [mPraDic setObject:_dfAddressId forKey:@"raid"];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"order/settle.do" parameter:mPraDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if (error == nil) {
                
                SKSettleViewController *vc = [[SKSettleViewController alloc] init];
                vc.data = resultDic[@"data"];
                vc.goods = goodsDic;
                vc.areaId = @"";
                vc.usedGiftCard = @"false";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

#pragma mark - keyboard notification

- (void)keboardShow:(NSNotification *)notification{
    
    _mask.hidden = NO;
    
    //键盘高度发生变化时也会被执行
    NSDictionary *userDic = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    
    CGFloat contentHeight = SCREEN_HEIGHT - 64.f;
    
    NSLog(@"tfBottom = %f,contentHeight = %f",_tfBottom,contentHeight);
    NSLog(@"keyboardF.h = %f",keyboardF.size.height);
    
    if (_tfBottom + keyboardH > contentHeight) {
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat indent = (_tfBottom + keyboardH - contentHeight);
            NSLog(@"indent = %f",indent);
            
            CGSize size = [self tableDefaultContentSize];
            size.height = size.height + indent;
            [_tableView setContentSize:size];
            
            [_tableView setContentOffset:CGPointMake(0.f, indent) animated:YES];
        });
    }
}

- (void)keboardHide:(NSNotification *)notification{
    
    _mask.hidden = YES;
    
    CGSize size = [self tableDefaultContentSize];
    [_tableView setContentSize:size];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            CGRect tableFrame = _tableView.frame;
            tableFrame.origin.y = 0;
            [_tableView setFrame:tableFrame];
        }];
    });
}

- (CGSize)tableDefaultContentSize {
    
    CGFloat rowH = [MAShoppingCartCell cellHeight];
    CGFloat headerH = 40.f;
//    CGFloat footerH = 0.f;
    CGFloat contentH = 0.f;
    
    for (NSDictionary *sectionDic in _mGoodsArray) {
        NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
        
        contentH = contentH + headerH;      //每个section 的高度
        
        contentH = contentH + rowH * sectionGoodsArray.count;         //每个cell 的高度
    }
    
    if (contentH <  _tableView.frame.size.height) {
        contentH = _tableView.frame.size.height;
    }
    
    return CGSizeMake(_tableView.frame.size.width, contentH);
}

#pragma mark - MAShoppingCartHeaderDelegate

/**
 *  @author 黎国基, 16-11-15 13:11
 *
 *  header的点击操作 勾选按钮
 *
 *  @param section
 */
- (void)shoppingCartHeaderCheckAtSection:(NSInteger)section {
    
    BOOL isHeaderShouldBeSelected = ![self isHeaderShouldBeSelectedAtSection:section];//如果原来是选中，就全改为 未选中；反之亦然
    
    
    NSDictionary *sectionDic = _mGoodsArray[section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    
    for (NSDictionary *goodsDic in sectionGoodsArray) {
        NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
        
        [MAShoppingCartInfoHandler setGoods:goodsSpecificationId selected:isHeaderShouldBeSelected];
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    
    _checkAllBtn.selected = [self isCheckAllBtnShouldBeSelected];       //影响全选按钮
    
    [self refreshTotalAmountText];
}

/**
 *  @author 黎国基, 16-11-15 15:11
 *
 *  查看更多、去凑单
 *
 *  @param section
 */
- (void)shoppingCartHeaderLookForSameGoodsAtSection:(NSInteger)section {
    
    SKMixBuyGoodsViewController *vc = [SKMixBuyGoodsViewController new];
    vc.templateId = _mGoodsArray[section][@"templateId"];
    vc.goodsFactoryId = _mGoodsArray[section][@"factoryId"];
    vc.lastDate = @"";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MAShoppingCartCellDelegate

/**
 *  @author 黎国基, 16-11-15 13:11
 *
 *  cell的点击操作
 *
 *  @param opration  [1,2,3] 1--勾选按钮，2--'-',3--'+'
 *  @param indexPath 操作的section,row
 */
- (void)shoppingCartCellOpration:(NSInteger)opration atIndexPath:(NSIndexPath *)indexPath {
    
    [MobClick event:@"modifyCartGoodsNumber" label:@"修改购物车商品数量"];
    
    if (opration == 1) {
        NSDictionary *sectionDic = _mGoodsArray[indexPath.section];
        NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
        NSDictionary *goodsDic = sectionGoodsArray[indexPath.row];
        NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
        
        [MAShoppingCartInfoHandler changeSateForGoods:goodsSpecificationId];
        
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];//影响包括本section的header
        
        _checkAllBtn.selected = [self isCheckAllBtnShouldBeSelected];   //影响全选按钮
        
        [self refreshTotalAmountText];
    }else {
        //
        NSDictionary *sectionDic = _mGoodsArray[indexPath.section];
        NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
        NSDictionary *goodsDic = sectionGoodsArray[indexPath.row];
        NSInteger goodsCount = [goodsDic[@"number"] integerValue];
        
        BOOL isMinBuy = [self isMinBuySection:indexPath.section];
        
        NSInteger finalCount = 0;
        
        if (isMinBuy) {
            //支持混批的组：商品起订量、增订量都为1，也可手动输入数量
            if (opration == 2) {
                //'-'
                goodsCount--;
            }else {
                //'+'
                goodsCount++;
            }
            
            if (goodsCount < 1) {
                goodsCount = 1;
            }
            
            finalCount = goodsCount;
        }else {
            //不支持混批的组：修改商品数量必须符合起订增订规则，不符合自动跳转数字为起订量；点“+”为增加增订量
            NSInteger moq = [self MOQAtIndexPath:indexPath];        //起订量
            NSInteger ioq = [self IOQAtIndexPath:indexPath];        //增订量
            
            if (opration == 2) {
                //'-'
                goodsCount = goodsCount - ioq;
            }else {
                //'+'
                goodsCount = goodsCount + ioq;
            }
            
            
            if (goodsCount < moq) {
                finalCount = moq;
            }else {
                
                if ((goodsCount - moq) % ioq == 0) {
                    finalCount = goodsCount;
                }else {
                    finalCount = moq;
                }
            }
        }
        [self setGoodsCount:finalCount atIndexPath:indexPath];
        [self requestUploadShopppingCartGoodsAtIndexPath:indexPath];
    }
}

/**
 *  @author 黎国基, 16-11-15 20:11
 *
 *  在cell textfield里面修改了 商品数量
 *
 *  @param count     商品数量
 *  @param indexPath
 */
- (void)setGoodsCountByTextField:(NSInteger)count atIndexPath:(NSIndexPath *)indexPath {
    
    if (count == -1) {
        //输入错误，reload直接恢复原数据
    }else {
        BOOL isMinBuy = [self isMinBuySection:indexPath.section];
        NSInteger finalCount = 0;
        
        if (isMinBuy) {
            //支持混批的组：商品起订量、增订量都为1，也可手动输入数量
            finalCount = count;
        }else {
            //不支持混批的组：修改商品数量必须符合起订增订规则，不符合自动跳转数字为起订量；点“+”为增加增订量
            NSInteger moq = [self MOQAtIndexPath:indexPath];        //起订量
            NSInteger ioq = [self IOQAtIndexPath:indexPath];        //增订量
            
            if (count < moq) {
                finalCount = moq;
            }else {
                
                if ((count - moq) % ioq == 0) {
                    finalCount = count;
                }else {
                    finalCount = moq;
                }
            }
        }
        
        [self setGoodsCount:finalCount atIndexPath:indexPath];
        [self requestUploadShopppingCartGoodsAtIndexPath:indexPath];
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];//影响包括本section的header
}

- (void)activeTextFieldBottomPoint:(CGPoint)origin forCell:(UITableViewCell *)cell {
    
    CGPoint point = [cell convertPoint:origin toView:_tableView];
    
    _tfBottom =  point.y + 30.f + 5;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    _emptyExceptionView.hidden = (_mGoodsArray.count != 0);
    
    return _mGoodsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *sectionDic = _mGoodsArray[section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    
    return sectionGoodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    MAShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MAShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    
    NSDictionary *sectionDic = _mGoodsArray[indexPath.section];
    NSArray *sectionGoodsArray = sectionDic[@"cartGoodsList"];
    NSDictionary *goodsDic = sectionGoodsArray[indexPath.row];
    NSString *goodsSpecificationId = goodsDic[@"goodsSpecificationId"];
    
    cell.isChecked = [MAShoppingCartInfoHandler isGoodsSelected:goodsSpecificationId];
    cell.count = [goodsDic[@"number"] integerValue];
    cell.price = [goodsDic[@"price"] floatValue];
    cell.titleStr = goodsDic[@"goodsTitle"];
    cell.goodsSpecificationDesc = goodsDic[@"goodsSpecificationDesc"];
    cell.imageUrlStr = goodsDic[@"url"];
    cell.indexPath = indexPath;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [self requestRemoveShopppingCartGoodsAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headerID = @"headerID";
    
    MAShoppingCartHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (header == nil) {
        header = [[MAShoppingCartHeader alloc] initWithReuseIdentifier:headerID];
        header.delegate = self;
    }
    
    header.section = section;
    header.isChecked = [self isHeaderShouldBeSelectedAtSection:section];
    
    NSDictionary *sectionDic = _mGoodsArray[section];
    
    BOOL isMinBuy = NO;
    if (sectionDic[@"mixBuy"] != nil && [sectionDic[@"mixBuy"] boolValue]) {
        isMinBuy = YES;
    }
    
    if (isMinBuy) {
        //支持混批
        NSInteger minCount = [sectionDic[@"templateMOQ"] integerValue];
        NSInteger increment = [sectionDic[@"templateIOQ"] integerValue];
        NSInteger currentCount = [self goodsCountForSection:section];
        
        NSString *unit = sectionDic[@"unit"];
        
        [header setIsMinBuy:YES minCount:minCount currentCount:currentCount increment:increment unit:unit];
        
    }else {
        [header setIsMinBuy:NO minCount:0 currentCount:0 increment:0 unit:nil];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [MAShoppingCartCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic =  _mGoodsArray[indexPath.section][@"cartGoodsList"][indexPath.row];
    
    MAGoodsDetailsViewController* vc = [[MAGoodsDetailsViewController alloc]init];
    vc.goodsSpecId = dic[@"goodsSpecificationId"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
