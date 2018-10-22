/**
 * MAGoodsDetailsViewController.m 16/11/18
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAGoodsDetailsViewController.h"

#import "SDCycleScrollView.h"
#import "MWPhotoBrowser.h"
#import "MAGoodsDetailsTitleView.h"
#import "MALogisticsView.h"
#import "MASpecificationView.h"
#import "MAGoodsCountCellContent.h"
#import "MACommentInfoView.h"
#import "SKGoodsCommentViewController.h"
#import "MAGoodsDetailWebHeader.h"
#import "MAShoppingCartViewController.h"
#import "LoginViewController.h"
#import "SKSettleViewController.h"
#import "SKMixBuyGoodsViewController.h"
#import "ShareWithFriendsViewCtr.h"

#import "UIButton+ExtCenter.h"
#import "UIButton+Badge.h"

@interface MAGoodsDetailsViewController ()<SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate ,MWPhotoBrowserDelegate, MAGoodsCountCellContentDelegate, MACommentInfoViewDelegate, MAGoodsDetailWebHeaderDelegate, MAGoodsDetailsTitleViewDelegate, MASpecificationViewDelegate> {
    
    JKTableView *_tableView;                        //最外层容器
    SDCycleScrollView *_cycleScrollView;
    MAGoodsDetailsTitleView *_goodsDetailsTitleView;  //title desc price
    MALogisticsView *_logisticsView;
    MASpecificationView *_specificationView;          //规格选项
    MAGoodsCountCellContent *_goodsCountCellContent; //商品数量
    MACommentInfoView *_commentInfoView;            //评论信息
    MAGoodsDetailWebHeader *_header;
    JKView *_emptyHeader0;
    
    UIButton *_addToShoppingCartBtn;
    
    JKView *_mask;                  //弹出键盘时，遮住scrollview禁止滚动
    
    JKWebView *_webView0;                            //
    JKWebView *_webView1;
    JKWebView *_webView2;
    NSArray *_webViewArray;
    NSInteger _headerBtnTag;                        //初始1
    
    NSString *_goodsId;                              //商品id，在请求requestGoodsDetails后获得
    
    NSDictionary *_goodsDetailsDic;                 //商品基本信息
    NSDictionary *_commemtSumDic;                   //评价信息汇总
    NSDictionary *_commentDic;                      //从获取的商品列表中，获取第一个值
    NSDictionary *_imagesDic;                       //图片列表
    
    NSInteger _goodsCount;
    CGFloat _tfBottom;                              //输入框底部 在tableview中的坐标
    CGSize _tempTableViewContentSize;
    
    BOOL _isFirstRequest;
}

@end

@implementation MAGoodsDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"商品详情"];
    
    
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
    
    [self requestGoodsDetails];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self requestCartCount];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self.navigationItem.backBarButtonItem setTitle:@" "];
//    
//    NSArray *itemsArray = self.navigationController.navigationBar.items;
//    if (itemsArray.count > 1) {
//        
////        UIBarButtonItem *navBarButtonAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
////        
////        [navBarButtonAppearance setTitleTextAttributes:@{
////                                                         NSFontAttributeName:            [UIFont systemFontOfSize:0.1],
////                                                         NSForegroundColorAttributeName: [UIColor clearColor] }
////                                              forState:UIControlStateNormal];
//        
//        UINavigationItem *item = itemsArray[itemsArray.count - 1];
//        UIBarButtonItem *backItem = item.backBarButtonItem;
//        
//        [backItem setTitle:@""];
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  @author 黎国基, 16/11/18
 *
 *  初始化数据
 */
- (void)initData {
    
    _goodsCount = 0.f;
    _headerBtnTag = 1;
    _isFirstRequest = YES;
}

#pragma mark - UI
/**
 *  @author 黎国基, 16/11/18
 *
 *  创建UI界面
 */
- (void)createUI {
    
    CGFloat bottomH = 49.f;
    
    CGFloat tableViewH = SCREEN_HEIGHT - 64.f - bottomH;
    
    _tableView = [[JKTableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, tableViewH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    _webView0 = [[JKWebView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 200.f)];
    _webView0.delegate = self;
    _webView0.scrollView.bounces = NO;
    _webView0.scrollView.showsHorizontalScrollIndicator = NO;
    _webView0.scrollView.scrollEnabled = NO;
    _webView0.scalesPageToFit = YES;
    
    _webView1 = [[JKWebView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 200.f)];
    _webView1.delegate = self;
    _webView1.scrollView.bounces = NO;
    _webView1.scrollView.showsHorizontalScrollIndicator = NO;
    _webView1.scrollView.scrollEnabled = NO;
    _webView1.scalesPageToFit = YES;
    
    _webView2 = [[JKWebView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 200.f)];
    _webView2.delegate = self;
    _webView2.scrollView.bounces = NO;
    _webView2.scrollView.showsHorizontalScrollIndicator = NO;
    _webView2.scrollView.scrollEnabled = NO;
    _webView2.scalesPageToFit = YES;
    _webViewArray = @[_webView0,_webView1,_webView2];
    
    
    _goodsDetailsTitleView = [[MAGoodsDetailsTitleView alloc] initWithFrame:CGRectZero];
    _goodsDetailsTitleView.delegate = self;
    
    _logisticsView = [[MALogisticsView alloc] initWithFrame:CGRectZero];
    
    _specificationView = [[MASpecificationView alloc] initWithFrame:CGRectZero];
    _specificationView.delegate = self;
    
    _commentInfoView = [[MACommentInfoView alloc] initWithFrame:CGRectZero];
    _commentInfoView.delegate = self;
    
    _goodsCountCellContent = [[MAGoodsCountCellContent alloc] initWithFrame:CGRectZero];
    _goodsCountCellContent.delegate = self;
    _goodsCountCellContent.count = _goodsCount;
    [_goodsCountCellContent setIsMixBuy:NO mixBuyDesc:nil];
    
    _header = [[MAGoodsDetailWebHeader alloc] initWithFrame:CGRectZero];
    _header.delegate = self;
    
    _emptyHeader0 = [[JKView alloc] initWithFrame:CGRectZero];
    
    [self initBanner];
    
    _mask = [[JKView alloc] initWithFrame:_tableView.frame];
    [_mask addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)]];
    [self.view addSubview:_mask];
    _mask.hidden = YES;
    //
    [self createBttomView];
}

-(void)createBttomView{
    
    CGFloat bottomH = 49.f;
    
    JKView *bottomView = [[JKView alloc] initWithFrame:CGRectMake(0.f, _tableView.maxY, SCREEN_WIDTH, bottomH)];
    
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *bottomBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *bottomBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *bottomBtn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *bottomBtn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _addToShoppingCartBtn = bottomBtn2;
    
    [bottomView addSubview:bottomBtn1];
    [bottomView addSubview:bottomBtn2];
    [bottomView addSubview:bottomBtn3];
    [bottomView addSubview:bottomBtn4];
    
    [bottomBtn1 setImage:[UIImage imageNamed:@"CustomerService"] forState:UIControlStateNormal];
    [bottomBtn2 setImage:[UIImage imageNamed:@"f-2"] forState:UIControlStateNormal];
    [bottomBtn1 setTitle:@"客服" forState:UIControlStateNormal];
    [bottomBtn2 setTitle:@"购物车" forState:UIControlStateNormal];
    [bottomBtn3 setTitle:@"加入购物车" forState:UIControlStateNormal];
    [bottomBtn4 setTitle:@"立即购买" forState:UIControlStateNormal];
    
    float lwth = SCREEN_WIDTH/4;
    
    bottomBtn1.frame  = CGRectMake(0, 0, lwth, bottomH);
    bottomBtn2.frame  = CGRectMake(lwth, 0, lwth, bottomH);
    bottomBtn3.frame  = CGRectMake(2*lwth, 0, lwth, bottomH);
    bottomBtn4.frame  = CGRectMake(3*lwth, 0, lwth, bottomH);
    //客服
    [bottomBtn1 setTitleColor:RGBGRAY(100.f) forState:UIControlStateNormal];
    [bottomBtn2 setTitleColor:RGBGRAY(100.f) forState:UIControlStateNormal];
    [bottomBtn3 setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [bottomBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
    bottomBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
    bottomBtn3.titleLabel.font = [UIFont systemFontOfSize:14];
    bottomBtn4.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    bottomBtn3.backgroundColor = RGBGRAY(245.f);
    bottomBtn4.backgroundColor = HEXCOLOR(0xEE2C2Cff);
    [bottomBtn1 setTintColor:[UIColor grayColor]];
    [bottomBtn2 setTintColor:[UIColor grayColor]];
    [bottomBtn1 verticalImageAndTitle:5];
    [bottomBtn2 verticalImageAndTitle:1];
    
    bottomBtn2.badgeValue = @"0";
    bottomBtn2.badgeOriginX = lwth*0.6;
    bottomBtn2.badgeOriginY = 6;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.2)];
    line.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:line];
    
    bottomBtn1.tag = 1;
    bottomBtn2.tag = 2;
    bottomBtn3.tag = 3;
    bottomBtn4.tag = 4;
    
    [bottomBtn1 addTarget:self action:@selector(bottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn2 addTarget:self action:@selector(bottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn3 addTarget:self action:@selector(bottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn4 addTarget:self action:@selector(bottomBtn:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  @author 黎国基, 16-11-02 20:11
 *
 *  banner
 */
-(void)initBanner{
    CGFloat lwidth = self.view.frame.size.width;
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0.f, lwidth, lwidth) delegate:self placeholderImage:[UIImage imageNamed:@"goods_placeHolder_large"]];
    _cycleScrollView.tag = 1;
    
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.autoScrollTimeInterval = 3.0;
}


#pragma mark - Touch events

- (void)maskTap:(id)sender {
    
    [_tableView endEditing:YES];
}

- (void)bottomBtn:(UIButton *)btn {
    
    if (btn.tag == 1) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请拨打客服热线"                                                                            message:@"4000-456-115"  preferredStyle:UIAlertControllerStyleAlert];
        //添加Button
        [alertController addAction: [UIAlertAction actionWithTitle:@"拨打" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000-456-115"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            [MobClick event:@"call_service_center" label:@"拨打客服"];
        }]];
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController: alertController animated: YES completion: nil];
    }else if (btn.tag == 2) {
        MAShoppingCartViewController *vc = [[MAShoppingCartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 3) {
        [MobClick event:@"goods_detail_add_goods_tocart" label:@"商品详情加入购物车"];
        [self requestAddGoodsToCart];
    }else if (btn.tag == 4) {
        
        NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
        NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
        if(isLoginStr == nil || isLoginStr.length == 0){
            
            LoginViewController* vc = [[LoginViewController alloc]init];
            vc.loginResultBlock = ^(BOOL success) {
                [self requestSettle];
            };
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
            navi.navigationBar.translucent = NO;
            [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            [self presentViewController:navi animated:YES completion:nil];
        }else {
            [self requestSettle];
        }
    }
}

#pragma mark - Custom tasks


#pragma mark - Http request

- (void)requestGoodsDetails {
    
    NSDictionary *praDic = @{@"goodsSpecId":_goodsSpecId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"goods/spec.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        [hud hideAnimated:YES];
        
        if (error == nil) {
            
            if (_isFirstRequest) {
                _isFirstRequest = NO;
                
                _goodsDetailsDic = resultDic[@"data"];
                
                _goodsId = _goodsDetailsDic[@"goodsId"];
                
                [self requestCommentSum];
                
                _imagesDic = _goodsDetailsDic[@"photoList"];
                NSArray *imageKeys = [_imagesDic allKeys];
                NSMutableArray *mImageUrlsArray = [[NSMutableArray alloc] init];
                for (NSString *key in imageKeys) {
                    [mImageUrlsArray addObject:_imagesDic[key]];
                }
                [_cycleScrollView setImageURLStringsGroup:mImageUrlsArray];
                //title && price
                _goodsDetailsTitleView.title = _goodsDetailsDic[@"title"];
                _goodsDetailsTitleView.desc = _goodsDetailsDic[@"subTitle"];
                if (_goodsDetailsDic[@"goodsPrice"][@"retailPrice"] != nil) {
                    _goodsDetailsTitleView.price = [_goodsDetailsDic[@"goodsPrice"][@"retailPrice"] floatValue];
                }else {
                    _goodsDetailsTitleView.price = -1.f;
                }
                
                //地址、物流信息
                _logisticsView.address = _goodsDetailsDic[@"shipAddress"];
                _logisticsView.company = _goodsDetailsDic[@"shopName"];
                _logisticsView.dateStr = _goodsDetailsDic[@"deliveryTime"];
                //规格
                NSDictionary *specTypeMapDic = _goodsDetailsDic[@"specTypeMap"];
                NSDictionary *specDescMapDic = _goodsDetailsDic[@"specDescMap"];
                
                if (specTypeMapDic != nil && specTypeMapDic.count > 0 && specDescMapDic != nil && specDescMapDic.count > 0) {
                    _specificationView.specTypeMapDic = specTypeMapDic;//警告，这个属性值只能设置一次！
                    _specificationView.specDescMapDic = specDescMapDic;
                    [_specificationView setSpecId:_goodsSpecId];
                }
                //数量
                _goodsCount = [_goodsDetailsDic[@"moq"] integerValue];
                _goodsCountCellContent.count = _goodsCount;
                
                if ([_goodsDetailsDic[@"mixBuy"] boolValue]) {
                    NSString *moqDesc = [JKTool noNilOrSpaceStringForStr:_goodsDetailsDic[@"moqDesc"]];
                    NSString *ioqDesc = [JKTool noNilOrSpaceStringForStr:_goodsDetailsDic[@"ioqDesc"]];
                    
                    NSString *desc = [NSString stringWithFormat:@"起订%@，增订%@",moqDesc,ioqDesc];
                    [_goodsCountCellContent setIsMixBuy:YES mixBuyDesc:desc];
                }else {
                    [_goodsCountCellContent setIsMixBuy:NO mixBuyDesc:nil];
                }
                //
                [_tableView reloadData];
                
                [self goodsDetailsWebHeaderBtnClicked:0];
            }else {
                //修改 规格，重新刷新 价格
                _goodsDetailsTitleView.price = [_goodsDetailsDic[@"goodsPrice"][@"retailPrice"] floatValue];
            }
            
        }else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:^{}];
        }
    }];
}

- (void)requestCartCount {
    
    [JKURLSession taskWithMethod:@"goods/cartcount.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        
        if (error == nil) {
            
            _addToShoppingCartBtn.badgeValue = [NSString stringWithFormat:@"%@",resultDic[@"data"]];
            float lwth = SCREEN_WIDTH/4;
            _addToShoppingCartBtn.badgeOriginX = lwth*0.6;
            _addToShoppingCartBtn.badgeOriginY = 6;
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

- (void)requestAddGoodsToCart {
    
    NSDictionary *postdata = @{@"goodsSpecificationId":_goodsSpecId,
                               @"number":[NSString stringWithFormat:@"%zd",_goodsCount]};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"goods/addcartitem.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        [hud hideAnimated:YES];
        
        if (error == nil) {
            [self requestCartCount];
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

- (void)requestCommentSum {
    
    [JKURLSession taskWithMethod:@"comment/appraisemark.do" parameter:@{@"goodsId":_goodsId} token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        
        if (error == nil) {
            
            _commemtSumDic = resultDic[@"data"];
            if (_commemtSumDic != nil) {
                NSInteger allNum = [_commemtSumDic[@"allNum"] integerValue];
                if (allNum > 0) {
                    //包含评价信息
                    [self requestCommentList];
                }
            }
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

- (void)requestCommentList {
    
    [JKURLSession taskWithMethod:@"comment/listappraisal.do" parameter:@{@"goodsId":_goodsId} token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        
        if (error == nil) {
            
            NSDictionary *commentListDic = resultDic[@"data"];
            NSArray *commentListArray = commentListDic[@"list"];
            
            if (commentListArray != nil && commentListArray.count > 0) {
                _commentDic = commentListArray[0];
                
                _commentInfoView.commentSumDic = _commemtSumDic;
                _commentInfoView.commentDic = _commentDic;
                
                [_tableView reloadData];
            }
        }
    }];
}

-(void)requestSettle{
    
    NSMutableDictionary *goods = [[NSMutableDictionary alloc] init];
    [goods setValue:[NSString stringWithFormat:@"%zd",_goodsCount] forKey:_goodsSpecId];
    
    NSDictionary *praDic = @{@"goods":goods,
                               @"usedGiftCard":@"true",
                               @"areaId":@""};
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"order/settle.do" parameter:praDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        [hud hideAnimated:YES];
        if (error == nil) {
            [MobClick event:@"goods_detail_buy_success" label:@"商品详情立即购买成功"];
            SKSettleViewController *vc = [[SKSettleViewController alloc] init];
            vc.data = resultDic[@"data"];
            vc.goods = goods;
            vc.areaId = @"";
            vc.usedGiftCard = @"false";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [MobClick event:@"goods_detail_buy_failed" label:@"商品详情立即购买失败"];
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

//10.1.0 分享店铺 (可先对接好，上线需屏蔽分享功能)
-(void)requestGoodsInfoForShare{
    
    NSMutableDictionary *prameterDic = [[NSMutableDictionary alloc] init];
    if (_goodsSpecId != nil) {
        [prameterDic setObject:_goodsSpecId forKey:@"specId"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [JKURLSession taskWithMethod:@"share/sharegoods.do" parameter:prameterDic token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            [hud hideAnimated:YES];
            
            if (error == nil) {
                
                NSDictionary *dic = resultDic[@"data"];
                ShareWithFriendsViewCtr *lacationVC = [[ShareWithFriendsViewCtr alloc] init];
                
                lacationVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                lacationVC.preferredContentSize = CGSizeMake(SCREEN_WIDTH/6*4, SCREEN_WIDTH*5/6+50);
                
                lacationVC.gettitle = dic[@"title"];
                lacationVC.geturl = dic[@"link"];
                lacationVC.getimage = dic[@"imgLink"];
                //葛日德，content竟然是 number!!!Ca0
                NSString *content = dic[@"content"];
                if ([content isKindOfClass:[NSNumber class]]) {
                    content = [NSString stringWithFormat:@"%@",content];
                }
                
                if (![content isKindOfClass:[NSString class]]) {
                    content = @"";
                }
                
                lacationVC.getdescription = [JKTool NoNilStringForString:content];
                
                [self presentViewController:lacationVC animated:YES completion:nil];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        }];
    }else {
        [self showAutoDissmissHud:@"未获取到商品规格id"];
    }
}

#pragma mark - keyboard notification

- (void)keboardShow:(NSNotification *)notification{
    
    _mask.hidden = NO;
    
    _tempTableViewContentSize = _tableView.contentSize;
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
            
            CGSize size = _tempTableViewContentSize;
            size.height = size.height + indent;
            [_tableView setContentSize:size];
            
            [_tableView setContentOffset:CGPointMake(0.f, indent) animated:YES];
        });
    }
}

- (void)keboardHide:(NSNotification *)notification{
    
    _mask.hidden = YES;
    
    CGSize size = _tempTableViewContentSize;
    [_tableView setContentSize:size];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            CGRect tableFrame = _tableView.frame;
            tableFrame.origin.y = 0;
            [_tableView setFrame:tableFrame];
        }];
    });
}
#pragma mark - MASpecificationViewDelegate

- (void)specificationViewDidChangeSpecification:(NSString *)specId {
    
    _goodsSpecId = specId;
    [self requestGoodsDetails];
}

#pragma mark - MAGoodsDetailWebHeaderDelegate

- (void)goodsDetailsWebHeaderBtnClicked:(NSInteger)btnTag {
    
    _headerBtnTag = btnTag;
    
    //webview
    NSString *detailsMobile = [JKTool NoNilStringForString:_goodsDetailsDic[@"detailsMobile"]];//详情
    NSString *specParams = [JKTool NoNilStringForString:_goodsDetailsDic[@"specParams"]];//规格
    NSString *salesService = [JKTool NoNilStringForString:_goodsDetailsDic[@"salesService"]];//售后
    
    NSArray *array = @[detailsMobile,specParams,salesService];
    
    NSString *htmlStr = array[btnTag];
    
    htmlStr = [htmlStr stringByAppendingString:@"<img src=\"http://fs.51xnb.cn/d5524664-5f91-4d6d-8c22-811af8107089.jpg\"  /><img src=\"http://fs.51xnb.cn/1490d094-fa07-43de-8753-1fa88a1be840.jpg\" />"];
    
    JKWebView *webView = _webViewArray[_headerBtnTag];
    
    [webView loadHTMLString:htmlStr baseURL:nil];
}

#pragma mark - MAGoodsDetailsTitleViewDelegate

- (void)titleViewShare {
    //分享
    [self requestGoodsInfoForShare];
}

#pragma mark - MAGoodsCountCellContentDelegate

//参见 购物车 MAShoppingCartViewController
- (void)goodsCountCellContentOpration:(NSInteger)opration {
    
    [MobClick event:@"goods_detail_modify_number" label:@"商品详情修改数量"];
    
    NSInteger moq = [_goodsDetailsDic[@"moq"] integerValue];        //起订量
    NSInteger ioq = [_goodsDetailsDic[@"ioq"] integerValue];        //增订量
    
    if (opration == 1) {
        //-
        _goodsCount = _goodsCount - ioq;
    }else if (opration == 2) {
        //+
        _goodsCount = _goodsCount + ioq;
    }
    
    if (_goodsCount < moq) {
        _goodsCount = moq;
    }else {
        if ((_goodsCount - moq) % ioq == 0) {
            //符合增订量模板
        }else {
            _goodsCount = moq;
        }
    }
    
    _goodsCountCellContent.count = _goodsCount;
}

- (void)setGoodsCountByTextField:(NSInteger)count {
    
    [MobClick event:@"goods_detail_modify_number" label:@"商品详情修改数量"];
    
    if (count == -1) {
        //输入错误，reload直接恢复原数据
        _goodsCountCellContent.count = _goodsCount;
    }else {
        BOOL isMinBuy = [_goodsDetailsDic[@"mixBuy"] boolValue];
        NSInteger finalCount = 0;
        
        if (isMinBuy) {
            //支持混批的组：商品起订量、增订量都为1，也可手动输入数量
            finalCount = count;
        }else {
            //不支持混批的组：修改商品数量必须符合起订增订规则，不符合自动跳转数字为起订量；点“+”为增加增订量
            NSInteger moq = [_goodsDetailsDic[@"moq"] integerValue];        //起订量
            NSInteger ioq = [_goodsDetailsDic[@"ioq"] integerValue];        //增订量
            
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
        _goodsCount = finalCount;
        _goodsCountCellContent.count = _goodsCount;
    }
}

- (void)goodsCountCellContentShowInfo {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支持混批" message:@"例如：肥料需要40吨起订，同一个厂家的多款肥料一起购买满40吨即可" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {}];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)goodsCountCellContentSeeMoreMixGoods {
    
    [MobClick event:@"goods_detail_see_more_mixgoods" label:@"商品详情查看混批商品表"];
    
    SKMixBuyGoodsViewController *vc = [SKMixBuyGoodsViewController new];
    vc.templateId = _goodsDetailsDic[@"templateId"];
    vc.goodsFactoryId = _goodsDetailsDic[@"factoryId"];
    vc.lastDate = @"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)activeTextFieldBottomPoint:(CGPoint)origin {
    
    CGPoint point = [_goodsCountCellContent.superview convertPoint:origin toView:_tableView];
    
    _tfBottom =  point.y + 30.f + 5;
}

#pragma mark - MACommentInfoViewDelegate

- (void)seeMoreComments {
    
    [MobClick event:@"goods_detail_see_more_comments" label:@"商品详情查看更多评论"];
    
    SKGoodsCommentViewController *vc = [[SKGoodsCommentViewController alloc] init];
    vc.goodsId = _goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = NO;
    browser.alwaysShowControls = NO;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:index];
    
    // Present
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    _imagesDic = _goodsDetailsDic[@"photoList"];
    NSArray *imageKeys = [_imagesDic allKeys];
    
    return imageKeys.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    NSArray *imageKeys = [_imagesDic allKeys];
    NSMutableArray *mImageUrlsArray = [[NSMutableArray alloc] init];
    for (NSString *key in imageKeys) {
        [mImageUrlsArray addObject:_imagesDic[key]];
    }
    
    if (index < mImageUrlsArray.count) {
        NSString *urlStr = [mImageUrlsArray objectAtIndex:index];
        return [MWPhoto photoWithURL:[NSURL URLWithString:urlStr]];
    }
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSInteger rowCount = 4;//固定4行，图片、标题价格、地址物流信息、商品数量
        
        if (_specificationView.specTypeMapDic != nil) {
            rowCount ++ ;
        }
        
        if (_commemtSumDic != nil) {
            NSInteger allNum = [_commemtSumDic[@"allNum"] integerValue];
            if (allNum > 0) {
                //包含评价信息
                rowCount ++ ;
            }
        }
        
        return rowCount;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    static NSString *webCellID = @"webCellID";
    
    NSString *commonCellID = cellID;//webview 的cell不能复用，复用导致页面闪动
    
    if (indexPath.section == 1) {
        commonCellID = webCellID;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 1) {
        JKWebView *webView = _webViewArray[_headerBtnTag];
        
        for (JKWebView *webView in _webViewArray) {
            [webView removeFromSuperview];
        }
        [cell.contentView addSubview:webView];
    }else {
        
        if (indexPath.row == 0) {
            //广告
            [cell.contentView addSubview:_cycleScrollView];
        }else if (indexPath.row == 1) {
            //标题价格
            [cell.contentView addSubview:_goodsDetailsTitleView];
        }else if (indexPath.row == 2) {
            //地址物流信息
            [cell.contentView addSubview:_logisticsView];
        }else if (indexPath.row == 3) {
            //可能是规格，也可能是数量
            if (_specificationView.specDescMapDic != nil) {
                [cell.contentView addSubview:_specificationView];                 //3：【规格】【数量】【评论】
            }else {
                [cell.contentView addSubview:_goodsCountCellContent];
            }
        }else if (indexPath.row == 4){
            //有可能是数量，也有可能是评论
            if (_specificationView.specDescMapDic != nil) {
                [cell.contentView addSubview:_goodsCountCellContent];//有规格，则row == 4是数量
            }else {
                [cell.contentView addSubview:_commentInfoView];//无规格，则row == 4是评论
            }
        }else {
            //row == 5 必然是有规格且有评论
            [cell.contentView addSubview:_commentInfoView];
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        JKWebView *webView = _webViewArray[_headerBtnTag];
        return webView.fHeight;
    }else {
        
        if (indexPath.row == 0) {
            //广告
            return _cycleScrollView.frame.size.height;
        }else if (indexPath.row == 1) {
            //标题价格
            return _goodsDetailsTitleView.fHeight;
        }else if (indexPath.row == 2) {
            //地址物流信息
            return _logisticsView.fHeight;
        }else if (indexPath.row == 3) {
            //可能是规格，也可能是数量
            if (_specificationView.specDescMapDic != nil) {
                return _specificationView.fHeight;                  //3：【规格】【数量】【评论】
            }else {
                return _goodsCountCellContent.fHeight;
            }
        }else if (indexPath.row == 4){
            //有可能是数量，也有可能是评论
            if (_specificationView.specDescMapDic != nil) {
                return _goodsCountCellContent.fHeight;//有规格，则row == 4是数量
            }else {
                return _commentInfoView.fHeight;//无规格，则row == 4是评论
            }
        }else {
            //row == 5 必然是有规格且有评论
            return _commentInfoView.fHeight;
        }
        
        return 80.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.f;
    }
    return _header.fHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return _emptyHeader0;
    }else {
        return _header;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //下面代码 把网页宽度限制 为屏幕宽度，高度自适应
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagStyle = document.createElement(\"style\");"
     "tagStyle.setAttribute(\"type\", \"text/css\");"
     "tagStyle.appendChild(document.createTextNode(\"BODY{padding: 20pt 15pt}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
    
    for(int i=0;i<50;i++){
        NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].style.width = '100%%'",i];
        [webView stringByEvaluatingJavaScriptFromString:str];
    }
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //先获取网页的实际宽、高，再转换成屏幕的宽度，自适应高度
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    CGFloat width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"] floatValue];
    
    CGFloat realWidth = self.view.frame.size.width;
    CGFloat realHeight = realWidth * height / width;
    
    webView.frame=CGRectMake(0, 0, realWidth,realHeight);
    
    
    [_tableView reloadData];
}

@end
