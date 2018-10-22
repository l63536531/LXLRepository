/**
 * MAMyOrdersViewController.m 16/11/8
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAMyOrdersViewController.h"

#import "MAMyOrderCell.h"

#import "OrderDetailsCtr.h"
#import "OrderTrackingCtr.h"
#import "SKYiextremelyPayController.h"
#import "SearchViewCtr.h"
#import "MAGoodsCommentViewController.h"
#import "UITableView+Placeholder.h"  //占位视图

@interface MAMyOrdersViewController ()<MAMyOrderCellDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    
    JKView *_header;
    JKView *_redUnderLine;
    
    JKScrollView *_scrollBgView;            //容纳5个tableview
    
    JKTableView *_tableView1;
    JKTableView *_tableView2;
    JKTableView *_tableView3;
    JKTableView *_tableView4;
    JKTableView *_tableView5;
    
    NSInteger _selectedHeaderBtnTag;         //当前选的是哪个header btn [0-4]
    
    NSInteger _pageIndex1;
    NSInteger _pageIndex2;
    NSInteger _pageIndex3;
    NSInteger _pageIndex4;
    NSInteger _pageIndex5;
    
    NSString *_stateStr;                    //查询订单列表时需要的参数
    
    NSMutableArray *_mOrderArray1;          //数据源
    NSMutableArray *_mOrderArray2;
    NSMutableArray *_mOrderArray3;
    NSMutableArray *_mOrderArray4;
    NSMutableArray *_mOrderArray5;
    
    BOOL _isFirstShow1;
    BOOL _isFirstShow2;                     //第一次显示_tableView2
    BOOL _isFirstShow3;
    BOOL _isFirstShow4;
    BOOL _isFirstShow5;
}

@end

@implementation MAMyOrdersViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"我的订单"];
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFinishedOrders) name:@"OrderCommentStateChanged" object:nil];
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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  @author 黎国基, 16/11/8
 *
 *  初始化数据
 */
- (void)initData {
    
    _pageIndex1 = 0;
    _pageIndex2 = 0;
    _pageIndex3 = 0;
    _pageIndex4 = 0;
    _pageIndex5 = 0;
    
    _stateStr = @"";
    
    _mOrderArray1 = [[NSMutableArray alloc] initWithCapacity:10];
    _mOrderArray2 = [[NSMutableArray alloc] initWithCapacity:10];
    _mOrderArray3 = [[NSMutableArray alloc] initWithCapacity:10];
    _mOrderArray4 = [[NSMutableArray alloc] initWithCapacity:10];
    _mOrderArray5 = [[NSMutableArray alloc] initWithCapacity:10];
    
    _isFirstShow1 = YES;
    _isFirstShow2 = YES;
    _isFirstShow3 = YES;
    _isFirstShow4 = YES;
    _isFirstShow5 = YES;
}

/**
 *  @author 黎国基, 16/11/8
 *
 *  创建UI界面
 */
- (void)createUI {
    
    if (_shouldGoBackToRootController) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 30);
        [button addTarget:self action:@selector(goBackToRootController:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        UIBarButtonItem *left =[[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = left;
    }
    
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"f-0"] style:UIBarButtonItemStylePlain target:self action:@selector(homeItem)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seach_right"] style:UIBarButtonItemStylePlain target:self action:@selector(searchItem)];
    
    self.navigationItem.rightBarButtonItems = @[homeItem,searchItem];
    
    [self createHeader];
    
    CGFloat scrollBgViewH = SCREEN_HEIGHT - 64.f - _header.fHeight;
    
    _scrollBgView = [[JKScrollView alloc] initWithFrame:CGRectMake(0.f, _header.fHeight, SCREEN_WIDTH, scrollBgViewH)];
    [_scrollBgView setContentSize:CGSizeMake(SCREEN_WIDTH * 5.f, scrollBgViewH)];
    _scrollBgView.pagingEnabled = YES;
    _scrollBgView.showsHorizontalScrollIndicator = NO;
    _scrollBgView.delegate = self;
    [self.view addSubview:_scrollBgView];
    
    [self createTableViews];
    
    if (_preSelectedHeaderBtnTag >= 0 && _preSelectedHeaderBtnTag < 5) {
        [self clickHeaderBtnOnTag:_preSelectedHeaderBtnTag];
    }else {
        [self clickHeaderBtnOnTag:0];
    }
}

- (void)createHeader {
    
    _header = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 44.f)];
    _header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_header];
    
    NSArray *btnTitleArray = @[@"全部",@"待支付",@"待发货",@"待签收",@"已完成"];
    
    CGFloat btnW = SCREEN_WIDTH / 5.f;
    CGFloat btnH = _header.fHeight;
    
    
    for (int i = 0; i < 5; i++) {
        JKButton *headerBtn = [JKButton buttonWithType:UIButtonTypeCustom];
        [headerBtn setFrame:CGRectMake(btnW * i, 0.f, btnW, btnH)];
        [headerBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [headerBtn setTitleColor:RGBGRAY(100.f) forState:UIControlStateNormal];
        [headerBtn setTitleColor:THEMECOLOR forState:UIControlStateSelected];
        headerBtn.titleLabel.font = FONT_HEL(14.f);
        headerBtn.tag = i;
        [headerBtn addTarget:self action:@selector(headerBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:headerBtn];
    }
    
    JKView *separator = [[JKView alloc] initWithFrame:CGRectMake(0.f, btnH - 1.f, SCREEN_WIDTH, 1.f)];
    separator.backgroundColor = RGBGRAY(240.f);
    [_header addSubview:separator];
    
    _redUnderLine = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, btnW, 1.f)];
    _redUnderLine.backgroundColor = THEMECOLOR;
    [separator addSubview:_redUnderLine];
}

- (void)createTableViews {
    
    CGFloat tableViewW = SCREEN_WIDTH;
    CGFloat tableViewH = _scrollBgView.fHeight;
    
    for (int i = 0; i < 5; i++) {
        
        JKTableView *tableView = [[JKTableView alloc] initWithFrame:CGRectMake(tableViewW * i, 0.f, tableViewW, tableViewH) style:UITableViewStylePlain];
        tableView.tag = i;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        tableView.mj_header.automaticallyChangeAlpha = YES;
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        tableView.mj_footer.automaticallyHidden = YES;
        
        [_scrollBgView addSubview:tableView];
        
        switch (i) {
            case 0:
                _tableView1 = tableView;
                _tableView1.loading = YES;
                break;
            case 1:
                _tableView2 = tableView;
                _tableView2.loading = YES;
                break;
            case 2:
                _tableView3 = tableView;
                  _tableView3.loading = YES;
                break;
            case 3:
                _tableView4 = tableView;
                _tableView4.loading = YES;
                break;
            case 4:
                _tableView5 = tableView;
                _tableView5.loading = YES;
                break;
            default:
                break;
        }
    }
}

#pragma mark - Touch events

- (void)goBackToRootController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)searchItem {
    
    SearchViewCtr* vc = [[SearchViewCtr alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.state = _stateStr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)homeItem {
    
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refresh {
    
    NSMutableArray *mTempArray = nil;
    JKTableView *temTableView = nil;
    
    NSInteger pageIndex = 0;
    
    switch (_selectedHeaderBtnTag) {
        case 0:
            _pageIndex1 = pageIndex;
            mTempArray = _mOrderArray1;
            temTableView = _tableView1;
            break;
        case 1:
            _pageIndex2 = pageIndex;
            mTempArray = _mOrderArray2;
            temTableView = _tableView2;
            break;
        case 2:
            _pageIndex3 = pageIndex;
            mTempArray = _mOrderArray3;
            temTableView = _tableView3;
            break;
        case 3:
            _pageIndex4 = pageIndex;
            mTempArray = _mOrderArray4;
            temTableView = _tableView4;
            break;
        case 4:
            _pageIndex5 = pageIndex;
            mTempArray = _mOrderArray5;
            temTableView = _tableView5;
            break;
        default:
            break;
    }
    
    [mTempArray removeAllObjects];
    [temTableView reloadData];
    
    [self loadMoreOrders];
}

- (void)loadMore {
    
    [self loadMoreOrders];
}

- (void)headerBtn:(JKButton *)btn {
    
    [self clickHeaderBtnOnTag:btn.tag];
}

#pragma mark - Custom tasks

- (void)clickHeaderBtnOnTag:(NSInteger)btnTag {
    
    _selectedHeaderBtnTag = btnTag;
    
    for (UIView *view in _header.subviews) {
        if ([view isKindOfClass:[JKButton class]]) {
            JKButton *headerBtn = (JKButton *)view;
            
            if (headerBtn.tag == btnTag) {
                headerBtn.selected = YES;//改变字体颜色
            }else {
                headerBtn.selected = NO;//改变字体颜色
            }
        }
    }
    
    CGFloat btnW = SCREEN_WIDTH / 5.f;
    _redUnderLine.orgX = btnW * btnTag;
    [_scrollBgView setContentOffset:CGPointMake(_scrollBgView.fWidth * btnTag, 0.f)];
    
    switch (btnTag) {
        case 0:
            _stateStr = @"1,2,3,4,5,6,7,8,99";//全部
            if (_isFirstShow1) {
                _isFirstShow1 = NO;
                [self loadMoreOrders];
            }
            break;
        case 1:
            _stateStr = @"1";//待支付：1
            if (_isFirstShow2) {
                _isFirstShow2 = NO;
                [self loadMoreOrders];
            }
            break;
        case 2:
            _stateStr = @"2,7";//待发货：2,7
            if (_isFirstShow3) {
                _isFirstShow3 = NO;
                [self loadMoreOrders];
            }
            break;
        case 3:
            _stateStr = @"3,8";//待签收：3,8
            if (_isFirstShow4) {
                _isFirstShow4 = NO;
                [self loadMoreOrders];
            }
            break;
        case 4:
            _stateStr = @"4,5,6,99";//已完成：4,5,6,99
            if (_isFirstShow5) {
                _isFirstShow5 = NO;
                [self loadMoreOrders];
            }
            break;
        default:
            break;
    }
}

- (NSString *)appropriatePageIndex {
    
    NSInteger pageIndex = 0;
    
    switch (_selectedHeaderBtnTag) {
        case 0:
            pageIndex = _pageIndex1;
            break;
        case 1:
            pageIndex = _pageIndex2;
            break;
        case 2:
            pageIndex = _pageIndex3;
            break;
        case 3:
            pageIndex = _pageIndex4;
            break;
        case 4:
            pageIndex = _pageIndex5;
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%zd",pageIndex];
}

- (NSMutableArray *)mArrayForTableViewTag:(NSInteger)tableviewTag {
    
    return [self mOrderArrayWithTableViewTag:tableviewTag];
}

- (NSMutableArray *)mOrderArrayWithTableViewTag:(NSInteger)tag {
    NSMutableArray *mTempArray = nil;
    switch (tag) {
        case 0:
            mTempArray = _mOrderArray1;
            break;
        case 1:
            mTempArray = _mOrderArray2;
            break;
        case 2:
            mTempArray = _mOrderArray3;
            break;
        case 3:
            mTempArray = _mOrderArray4;
            break;
        case 4:
            mTempArray = _mOrderArray5;
            break;
        default:
            break;
    }
    return mTempArray;
}

/**
 *  @author 黎国基, 16-11-28 15:11
 *
 *  评价返回来，要刷新订单列表
 */
- (void)refreshFinishedOrders {
    [self refresh];//理论上，当前选中的就一定是 ‘已完成订单’，只需刷新就可以了。即使刷新的不是已完成订单，问题也不大。
}

#pragma mark - Http request

/**
 *  @author 黎国基, 16-11-09 15:11
 *
 *  加载更多订单；订单状态由 clickHeaderBtnOnTag:方法确定；数据源、pageIndex根据当前所选的tableView/headerBtn确定
 */
- (void)loadMoreOrders {
    
    NSMutableDictionary *mPraDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [mPraDic setObject:@"" forKey:@"searchKey"];
    [mPraDic setObject:_stateStr forKey:@"state"];
    [mPraDic setObject:[self appropriatePageIndex] forKey:@"pageIndex"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [JKURLSession taskWithMethod:@"order/mallorders.do" parameter:mPraDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            if (error == nil) {
                
                NSDictionary *dic = resultDic[@"data"];
                
                NSInteger pageIndex = [dic[@"pageIndex"] integerValue];
                NSInteger rowCount = [dic[@"rowCount"] integerValue];
                
                NSArray *pageArray = dic[@"list"];
                
                NSMutableArray *mTempArray = nil;
                JKTableView *temTableView = nil;
                
                switch (_selectedHeaderBtnTag) {
                    case 0:
                        _pageIndex1 = pageIndex;
                        mTempArray = _mOrderArray1;
                        temTableView = _tableView1;
                        break;
                    case 1:
                        _pageIndex2 = pageIndex;
                        mTempArray = _mOrderArray2;
                        temTableView = _tableView2;
                        break;
                    case 2:
                        _pageIndex3 = pageIndex;
                        mTempArray = _mOrderArray3;
                        temTableView = _tableView3;
                        break;
                    case 3:
                        _pageIndex4 = pageIndex;
                        mTempArray = _mOrderArray4;
                        temTableView = _tableView4;
                        break;
                    case 4:
                        _pageIndex5 = pageIndex;
                        mTempArray = _mOrderArray5;
                        temTableView = _tableView5;
                        break;
                    default:
                        break;
                }
                
                if (pageArray.count > 0) {
                    [mTempArray addObjectsFromArray:pageArray];
                }
                
                [temTableView.mj_header endRefreshing];
                if (mTempArray.count == rowCount) {
                    [temTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [temTableView.mj_footer endRefreshing];
                }
                
                [temTableView reloadData];
                
            }else {
                
               
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

/**
 *  @author 黎国基, 16-11-09 15:11
 *
 *  启动订单支付
 *
 *  @param orderId 订单 ID
 */
- (void)requestStartOrderPay:(NSString *)orderId {
    
    NSMutableDictionary *mPraDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [mPraDic setObject:orderId forKey:@"orderId"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [JKURLSession taskWithMethod:@"order/pay.do" parameter:mPraDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            if (error == nil) {
                
                SKYiextremelyPayController *vc = [[SKYiextremelyPayController alloc]init];
                vc.payCode =  resultDic[@"data"];
                vc.orderId = orderId;
                vc.productName = @"新农宝商城";
                vc.productDescription = @"新农宝商城";
                [self.navigationController pushViewController:vc animated:YES];
                
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        });
    }];
}

/**
 *  @author 黎国基, 16-11-09 15:11
 *
 *  延迟收货
 *
 *  @param orderId 订单 ID
 */
- (void)requestDeliveryDelay:(NSString *)orderId {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil                                                                             message:@"系统自动收货时间将为您延迟5天，如果5天之内没有收到货请致电新农宝"  preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSMutableDictionary *mPraDic = [[NSMutableDictionary alloc] initWithCapacity:3];
        [mPraDic setObject:orderId forKey:@"orderId"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [JKURLSession taskWithMethod:@"order/delayreceive.do" parameter:mPraDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                if (error == nil) {
                    [self refresh];
                }else {
                    [self showAutoDissmissHud:error.localizedDescription];
                }
            });
        }];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController: alertController animated: YES completion: nil];
}

/**
 *  @author 黎国基, 16-11-09 15:11
 *
 *  确认收货
 *
 *  @param orderId 订单 ID
 */
- (void)requestCompleteOrder:(NSString *)orderId {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil                                                                             message:@"您确定已经收到货物了吗？"  preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSMutableDictionary *mPraDic = [[NSMutableDictionary alloc] initWithCapacity:3];
        [mPraDic setObject:orderId forKey:@"orderId"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [JKURLSession taskWithMethod:@"order/receive.do" parameter:mPraDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                if (error == nil) {
                    [self refresh];
                    
                    UIAlertController * alertController2 = [UIAlertController alertControllerWithTitle:nil                                                                             message:@"主动确认收货，赠送100积分！"  preferredStyle:UIAlertControllerStyleAlert];
                    [alertController2 addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
                    [self presentViewController: alertController2 animated: YES completion: nil];
                }else {
                    [self showAutoDissmissHud:error.localizedDescription];
                }
            });
        }];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController: alertController animated: YES completion: nil];
}

/**
 *  @author 黎国基, 16-11-09 16:11
 *
 *  删除订单
 *
 *  @param orderId 订单 ID
 */
- (void)requestDeleteOrder:(NSString *)orderId {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您确定要删除此订单吗？"  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSMutableDictionary *mPraDic = [[NSMutableDictionary alloc] initWithCapacity:3];
        [mPraDic setObject:orderId forKey:@"orderId"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [JKURLSession taskWithMethod:@"order/delete.do" parameter:mPraDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                if (error == nil) {
                    [self refresh];
                }else {
                    [self showAutoDissmissHud:error.localizedDescription];
                }
            });
        }];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController: alertController animated: YES completion: nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self mArrayForTableViewTag:tableView.tag].count;
    if (count == 0) {
        _tableView1.loading = NO;
        _tableView2.loading = NO;
        _tableView3.loading = NO;
        _tableView4.loading = NO;
        _tableView5.loading = NO;

    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    MAMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MAMyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    
    NSMutableArray *theMArray = [self mArrayForTableViewTag:tableView.tag];
    NSDictionary *orderInfoDic = theMArray[indexPath.row];
    
    cell.tableViewTag = tableView.tag;
    cell.row = indexPath.row;
    cell.orderInfoDic = orderInfoDic;
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [MAMyOrderCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *theMArray = [self mArrayForTableViewTag:tableView.tag];
    NSDictionary *orderInfoDic = theMArray[indexPath.row];
    
    OrderDetailsCtr * vc = [[OrderDetailsCtr alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.getorderId = orderInfoDic[@"orderId"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MAMyOrderCellDelegate

/**
 *  @author 黎国基, 16-11-08 14:11
 *
 *  cell的按钮操作
 *
 *  @param tableViewTag tableview tag   [0-4]
 *  @param row          indexPath.row
 *  @param operation    区分操作类型：-1是删除按钮，【0，1，2，3】分别是底部4个按钮
 *  @param state        订单当前状态 待支付：1     待发货：2,7    待签收：3,8   已完成：4,5,6,99
 */
- (void)tableViewTag:(NSInteger)tableViewTag row:(NSInteger)row operation:(NSInteger)operation state:(NSInteger)state isdelay:(BOOL)isdelay isCommented:(BOOL)isCommented{
    
    NSMutableArray *theMArray = [self mOrderArrayWithTableViewTag:tableViewTag];
    NSDictionary *orderInfoDic = theMArray[row];
    
    if (operation == -1) {
        //删除
        [self requestDeleteOrder:orderInfoDic[@"orderId"]];
    }else {
        
        NSString *tracingOrderStateDesc = nil;
        
        if (state == 1) {//待支付
            if (operation == 2) {
                //订单追踪
                tracingOrderStateDesc = @"待支付";
            }else if (operation == 3) {
                //付款
                [MobClick event:@"myorders_pay" label:@"我的订单付款"];
                [self requestStartOrderPay:orderInfoDic[@"orderId"]];
            }
        }else if (state == 2 || state == 7) {//待发货
            if (operation == 3) {
                //订单追踪
                tracingOrderStateDesc = @"待发货";
            }
        }else if (state == 3 || state == 8) {//待签收
            if (operation == 1) {
                //延迟收货
                if (isdelay) {
                    //已经点击过了 【延迟收货】，按钮已经是 灰色
                }else {
                    [MobClick event:@"myorders_delay_recieve" label:@"我的订单延迟收货"];
                    [self requestDeliveryDelay:orderInfoDic[@"orderId"]];
                }
            }else if (operation == 2) {
                //订单追踪
                tracingOrderStateDesc = @"订单追踪";
            }else if (operation == 3) {
                //确认收货
                [MobClick event:@"myorders_completeorder" label:@"我的订单确认收货"];
                [self requestCompleteOrder:orderInfoDic[@"orderId"]];
            }
        }else if (state == 4 || state == 5 || state == 6 || state == 99) {//已完成
            if (operation == 2) {
                //订单追踪
                tracingOrderStateDesc = @"已完成";
            }else if (operation == 3) {
                //评价，已评价
                if (isCommented) {
                    //已经完全评论过了
                    MAGoodsCommentViewController *vc = [[MAGoodsCommentViewController alloc] init];
                    vc.orderId = orderInfoDic[@"orderId"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else {
                    MAGoodsCommentViewController *vc = [[MAGoodsCommentViewController alloc] init];
                    vc.orderId = orderInfoDic[@"orderId"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
        
        if (tracingOrderStateDesc != nil) {
            
            OrderTrackingCtr * vc = [[OrderTrackingCtr alloc] init];
            vc.getOrderState = tracingOrderStateDesc;
            vc.getOrderNumber = orderInfoDic[@"code"];
            vc.getorderID = orderInfoDic[@"orderId"];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (![scrollView isKindOfClass:[UITableView class]]) {
        CGFloat headerWidth = _header.fWidth;
        CGFloat scrollCotentWidth = _scrollBgView.contentSize.width;
        
        _redUnderLine.orgX = scrollView.contentOffset.x * (headerWidth / scrollCotentWidth);
        CGFloat screenW = SCREEN_WIDTH;
        
        if (scrollView.contentOffset.x == 0) {
            _selectedHeaderBtnTag = 0;
            [self clickHeaderBtnOnTag:_selectedHeaderBtnTag];
        }else if(scrollView.contentOffset.x == screenW) {
            _selectedHeaderBtnTag = 1;
            [self clickHeaderBtnOnTag:_selectedHeaderBtnTag];
        }else if(scrollView.contentOffset.x == screenW * 2) {
            _selectedHeaderBtnTag = 2;
            [self clickHeaderBtnOnTag:_selectedHeaderBtnTag];
        }else if(scrollView.contentOffset.x == screenW * 3) {
            _selectedHeaderBtnTag = 3;
            [self clickHeaderBtnOnTag:_selectedHeaderBtnTag];
        }else if(scrollView.contentOffset.x == screenW * 4) {
            _selectedHeaderBtnTag = 4;
            [self clickHeaderBtnOnTag:_selectedHeaderBtnTag];
        }
    }
}

@end
