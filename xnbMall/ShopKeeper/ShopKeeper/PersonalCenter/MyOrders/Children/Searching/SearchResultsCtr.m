//
//  SearchResultsCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/15.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SearchResultsCtr.h"
#import "OrderDetailsCtr.h"
#import "SearchViewCtr.h"
#import "MAGoodsCommentViewController.h"

#import "TransDataProxyCenter.h"
#import "OrderTrackingCtr.h"

#import "JKURLSession.h"
#import "MAMyOrderCell.h"
#import "OrderDetailsCtr.h"
#import "OrderTrackingCtr.h"
#import "SKYiextremelyPayController.h"
#import "SearchViewCtr.h"

@interface SearchResultsCtr ()<UITableViewDelegate,UITableViewDataSource, MAMyOrderCellDelegate>{

    UITableView *_maintableview;
    
    UIView * bgview;
    
    NSString *_pageIndex;
    
    NSMutableArray *_mSearchOrderArray;
}

@end

@implementation SearchResultsCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"搜索结果"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFinishedOrders) name:@"OrderCommentStateChanged" object:nil];
    
    _mSearchOrderArray = [[NSMutableArray alloc] init];

    _pageIndex = @"0";
    if (_state == nil) {
        _state = @"1,2,3,4,5,6,7,8,99";
    }
    if (_searchKeyWord == nil) {
        _searchKeyWord = @"";
    }
    
    [self maketableview];
    [self makemianview];
    
    [self loadMoreOrders];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)maketableview{
    
    _maintableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _maintableview.dataSource = self;
    _maintableview.bounces = YES;
    _maintableview.delegate = self;
    _maintableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _maintableview.backgroundColor = ColorFromRGB(230, 230, 230);
    
    [self.view addSubview:_maintableview];
    _maintableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _maintableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

#pragma mark - 

- (void)refresh {
    
    _pageIndex = @"0";
    [_mSearchOrderArray removeAllObjects];
    [_maintableview reloadData];
    
    [self loadMoreOrders];
}

- (void)loadMore {
    [self loadMoreOrders];
}

/**
 *  @author 黎国基, 16-11-28 15:11
 *
 *  评价返回来，要刷新订单列表
 */
- (void)refreshFinishedOrders {
    [self refresh];//
}

#pragma mark - Http request

/**
 *  @author 黎国基, 16-11-09 15:11
 *
 *  加载更多订单；订单状态由 clickHeaderBtnOnTag:方法确定；数据源、pageIndex根据当前所选的tableView/headerBtn确定
 */
- (void)loadMoreOrders {
    
    NSMutableDictionary *mPraDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [mPraDic setObject:_searchKeyWord forKey:@"searchKey"];
    [mPraDic setObject:_state forKey:@"state"];
    [mPraDic setObject:_pageIndex forKey:@"pageIndex"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [JKURLSession taskWithMethod:@"order/mallorders.do" parameter:mPraDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            if (error == nil) {
                
                NSDictionary *dic = resultDic[@"data"];
                
                _pageIndex = dic[@"pageIndex"];
                NSInteger rowCount = [dic[@"rowCount"] integerValue];
                
                NSArray *pageArray = dic[@"list"];
                
                if (pageArray.count > 0) {
                    [_mSearchOrderArray addObjectsFromArray:pageArray];
                }
                
                [_maintableview.mj_header endRefreshing];
                if (_mSearchOrderArray.count == rowCount) {
                    [_maintableview.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [_maintableview.mj_footer endRefreshing];
                }
                
                [_maintableview reloadData];
                
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
    
    NSDictionary *orderInfoDic = _mSearchOrderArray[row];
    
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
                [MobClick event:@"searorders_pay" label:@"搜索订单付款"];
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
                    [MobClick event:@"searchorders_delay_recieve" label:@"搜索订单延迟收货"];
                    [self requestDeliveryDelay:orderInfoDic[@"orderId"]];
                }
            }else if (operation == 2) {
                //订单追踪
                tracingOrderStateDesc = @"订单追踪";
            }else if (operation == 3) {
                //确认收货
                [MobClick event:@"searchorders_completeorder" label:@"搜索订单确认收货"];
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
                    MAGoodsCommentViewController * vc = [[MAGoodsCommentViewController alloc] init];
                    vc.orderId = orderInfoDic[@"orderId"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    MAGoodsCommentViewController * vc = [[MAGoodsCommentViewController alloc] init];
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

#pragma mark - Table View Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_mSearchOrderArray.count>0) {
        [bgview setHidden:YES];
    }else{
        
        [bgview setHidden:NO];
    }
    return _mSearchOrderArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [MAMyOrderCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    MAMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MAMyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    
    NSDictionary *orderInfoDic = _mSearchOrderArray[indexPath.row];
    
    cell.tableViewTag = tableView.tag;
    cell.row = indexPath.row;
    cell.orderInfoDic = orderInfoDic;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *orderInfoDic = _mSearchOrderArray[indexPath.row];
    OrderDetailsCtr * vc = [[OrderDetailsCtr alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.getorderId = orderInfoDic[@"orderId"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)makemianview{
    
    bgview = [[UIView alloc] init];
    [bgview setBackgroundColor:[UIColor clearColor]];
    [bgview setFrame:CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    //    [bgview setHidden:YES];
    [self.view addSubview:bgview];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame= CGRectMake(SCREEN_WIDTH/3, 0,SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    [logoImageView setContentMode:UIViewContentModeScaleAspectFill];
    [logoImageView setClipsToBounds:YES];
    [logoImageView setImage:[UIImage imageNamed:@"quan5"]];
    [logoImageView.layer setCornerRadius:SCREEN_WIDTH/6];
    [bgview addSubview:logoImageView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, SCREEN_WIDTH/3+10, SCREEN_WIDTH , 30);
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setText:@"暂时没有相关订单"];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [bgview addSubview:titleLabel];
}

@end
