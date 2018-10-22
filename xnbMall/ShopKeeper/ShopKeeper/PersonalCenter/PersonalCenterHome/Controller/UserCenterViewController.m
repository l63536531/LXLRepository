//
//  UserCenterViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/5/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "UserCenterViewController.h"


#import "ViewController.h"

#import "MyAccountViewController.h"//个人信息
#import "SettingViewController.h"
#import "ShareUnity.h"
#import "TransDataProxyCenter.h"

//我的钱包
#import "MyWalletTableViewCtrl.h"
//收货地址
#import "ShippingAddressViewCtr.h"
//视频
#import "VideoTeachingViewCtrl.h"
//现金券
#import "CashCouponViewCtr.h"
//我的礼券
#import "GiftVouchersViewCtr.h"
//会员卡
#import "MembershipCardViewCtr.h"
//我的积分
#import "MyPointsViewCtr.h"
//问题反馈
#import "ProblemFeedbackCtr.h"

#import "GetAddressViewCtr.h"
//我的订单
#import "MAMyOrdersViewController.h"
//我服务的订单
#import "MyServiceOrdersCtr.h"
//辖区订单
#import "JurisdictionOrdersCtr.h"
//上报定位
#import "ToLocateViewCtr.h"

#import "TransDataProxyCenter.h"

//最新上架
#import "NewShelvesCtr.h"
//分享
#import "ShareWithFriendsViewCtr.h"

#import "MyWalletViewCtrTwo.h"
#import "SKOrderMenuBtn.h"
#import "JKURLSession.h"

@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UserTabButtonCellDelegate,UserSecondCelloneDelegate,UserSecondCelltwoDelegate>{
    
    UIView *_orderSection;                              //各类订单菜单按钮区

    ShareWithFriendsViewCtr* lacationVC;

    UIImageView* selfImageView ;
    UILabel *selflab ;
    
    CGFloat totalAmount;//礼券总额
    NSInteger integral;//积分
    
    NSDictionary* getdiction;
}

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation UserCenterViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
    [self setNavigationItemview];
    [self createTopRedView];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userReLogin) name:@"userReLogin" object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;

    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0){
        return;
    }
    
    [self getuserInformation];
    [self giftcardBalance];
    [self getData];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark -- Create UI

-(void)createTableView{
    
    CGFloat topRedViewH = 70.f;
    CGFloat tableViewH = SCREEN_HEIGHT - 64.f - topRedViewH;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,topRedViewH,self.view.frame.size.width, tableViewH) style:UITableViewStylePlain];
    self.tableView.scrollEnabled = YES;
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
    self.tableView.separatorStyle = UITableViewScrollPositionNone;
    
    [self.view addSubview:self.tableView];
    
    
    _orderSection = [self createFooterView];
}


-(void)setNavigationItemview{
    
    UIButton* settingbtn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [settingbtn setBackgroundColor:[UIColor clearColor]];
    [settingbtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    [settingbtn addTarget:self action:@selector(rightBarbutton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:settingbtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createTopRedView {
    
    CGFloat topRedViewH = 70.f;
    UIView *headerBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , topRedViewH)];
    
    UIColor *color =ColorFromHex(0xec584c);
    [headerBgview setBackgroundColor:color];
    
    CGFloat imageW = 60;
    
    //    头像
    selfImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0.f, imageW, imageW)];
    [selfImageView setContentMode:UIViewContentModeScaleAspectFill];
    [selfImageView.layer setCornerRadius:imageW/2];
    [selfImageView setClipsToBounds:YES];
    [selfImageView setBackgroundColor:[UIColor whiteColor]];
    
    NSString * userurl = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGOURL];
    if (userurl == nil) {
        userurl = @"13";
    }
    NSURL * url = [NSURL URLWithString:userurl];
    [selfImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
    [headerBgview addSubview:selfImageView];
    
    UIButton* headBtn = [[UIButton alloc] initWithFrame:selfImageView.frame];
    [headBtn setBackgroundColor:[UIColor clearColor]];
    [headBtn addTarget:self action:@selector(doClickheaderAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerBgview addSubview:headBtn];
    //    姓名和手机号
    selflab = [[UILabel alloc] init];
    [selflab setBackgroundColor:[UIColor clearColor]];
    [selflab setFrame:CGRectMake(imageW + 20, 0,SCREEN_WIDTH - 140,imageW)];
    [selflab setTextColor:[UIColor whiteColor]];
    NSString * username = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:NETWORKNAME];
    NSString * userphone = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_PHONE];
    if (username==nil||!(username.length>0)) {
        username = @"";
    }
    if (userphone==nil||!(userphone.length>0)) {
        userphone = @"";
    }
    
    NSString *safePhone0 = [JKTool noNilOrSpaceStringForStr:userphone];
    NSString *safePhone = safePhone0;
    if (safePhone0.length >= 11) {
        NSString *segment0 = [safePhone0 substringToIndex:safePhone0.length - 8];//可能包含 +86头部
        NSString *segment1 = [safePhone0 substringFromIndex:safePhone0.length - 4];
        
        safePhone = [NSString stringWithFormat:@"%@****%@",segment0,segment1];
    }
    
    [selflab setText:[NSString stringWithFormat:@"%@\n%@",username,safePhone]];
    [selflab setTextAlignment:NSTextAlignmentLeft];
    [selflab setNumberOfLines:0];
    [selflab setFont:[UIFont systemFontOfSize:14]];
    selflab.adjustsFontSizeToFitWidth = YES;
    
    [headerBgview addSubview:selflab];
    [self.view addSubview: headerBgview];
}

-(UIView*)createFooterView{
    
    CGFloat btnw = SCREEN_WIDTH/5;
    
    UIView * bgview = [[UIView alloc] init];
    [bgview setBackgroundColor:[UIColor whiteColor]];
    [bgview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, btnw+42)];
    
    UILabel *titlelab = [[UILabel alloc] init];
    [titlelab setFrame:CGRectMake(0, 0,SCREEN_WIDTH , 40)];
    [titlelab setTextColor:ColorFromHex(0x646464)];
    
    [titlelab setText:@"    商城订单"];
    [titlelab setTextAlignment:NSTextAlignmentLeft];
    [titlelab setNumberOfLines:0];
    [titlelab setFont:[UIFont systemFontOfSize:14]];
    [bgview addSubview:titlelab];
    
    NSArray * getimagearray = @[@"order_all",@"wait_pay",@"wait_send",@"wait_get",@"has_over"];;
    NSArray* titletwo = @[@"所有",@"待付款",@"待发货",@"待签收",@"已完成"];
    
    
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
    [bgview addSubview:line];
    
    UIView* line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 41+btnw, SCREEN_WIDTH, 1)];
    [line1 setBackgroundColor:ColorFromRGB(240, 240, 240)];
    [bgview addSubview:line1];
    
    for (int i = 0; i < 5; i++) {
        
        NSString * iamgename = [getimagearray objectAtIndex:i];
        
        SKOrderMenuBtn *menuBtn = [[SKOrderMenuBtn alloc] initWithTitle:[titletwo objectAtIndex:i] icon:iamgename];
        menuBtn.orgX = btnw * i;
        menuBtn.orgY = 41.f;
        menuBtn.tag = 700 + i;
        [menuBtn addTarget:self action:@selector(doButtonclick:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:menuBtn];
        
    }
    return bgview;
}

#pragma mark -- Touch events

-(void)doClickheaderAction:(id)sender{
    
    MyAccountViewController* vc = [[MyAccountViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"头像");
}

/**
 *  @author 黎国基, 16-10-31 20:10
 *
 *  去【设置】
 */
-(void)rightBarbutton
{
    SettingViewController *setvc = [[SettingViewController alloc] init];
    setvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setvc animated:YES];
}

-(void)clickButton:(NSInteger)tag title:(NSString *)title{
    NSLog(@"点击  %d  %@",(int)tag,title);
    
    if ([title hasPrefix:@"我的钱包"]) {//我的钱包
        NSLog(@"1");
        
        MyWalletViewCtrTwo * wallettwo = [[MyWalletViewCtrTwo alloc] init];
        wallettwo.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:wallettwo animated:YES];
        
    }else if ([title hasPrefix:@"收货地址"]){//收货地址
        
        NSLog(@"11");
        
        ShippingAddressViewCtr * addressvc = [[ShippingAddressViewCtr alloc] init];
        addressvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressvc animated:YES];
        
    }else if ([title hasPrefix:@"推荐新农宝"]){//推荐新农宝
        NSLog(@"12");
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"请求中..."];
        [[TransDataProxyCenter shareController] xnbspreadblock:^(NSDictionary *dic, NSError *error) {
            NSNumber* code0 = dic[@"code"];
            NSString* msg0 = [error localizedDescription];
            if ([code0 intValue]  == 200) {
                
                [SVProgressHUD dismiss];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //                "content":"手机家电样样省，快来帮我捧捧场吧！",
                    //                "title":"新农宝",
                    //                "link":"http:\/\/m.51xnb.cn\/SL?sid=2300996902",
                    //                "imgLink":"http:\/\/m.51xnb.cn\/mall\/lib\/images\/service_center.png"
                    NSDictionary* getdic= dic[@"data"];
                    
                    
                    
                    lacationVC = [[ShareWithFriendsViewCtr alloc] init];
                    
                    lacationVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    lacationVC.preferredContentSize = CGSizeMake(SCREEN_WIDTH/6*4, SCREEN_WIDTH*5/6+50);
                    
                    lacationVC.gettitle = getdic[@"title"];
                    lacationVC.geturl = getdic[@"link"];
                    lacationVC.getimage = getdic[@"imgUrl"];
                    lacationVC.getdescription = getdic[@"content"];
                    
                    UIPopoverPresentationController *pop = lacationVC.popoverPresentationController;
                    pop.delegate = self;
                    pop.permittedArrowDirections = UIPopoverArrowDirectionAny;
                    
                    [self presentViewController:lacationVC animated:YES completion:nil];
                    
                });
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                             message:msg0  preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler:nil]];
                    
                    
                    [self presentViewController: alertController animated: YES completion: nil];
                    
                });
            }
        }];
    }else if ([title hasPrefix:@"推荐农掌柜"] ){//推荐农掌柜
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"请求中..."];
        [[TransDataProxyCenter shareController] xnbzgspreadblock:^(NSDictionary *dic, NSError *error) {
            NSNumber* code0 = dic[@"code"];
            NSString* msg0 = [error localizedDescription];
            if ([code0 intValue]  == 200) {
                
                [SVProgressHUD dismiss];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //                "content":"手机家电样样省，快来帮我捧捧场吧！",
                    //                "title":"新农宝",
                    //                "link":"http:\/\/m.51xnb.cn\/SL?sid=2300996902",
                    //                "imgLink":"http:\/\/m.51xnb.cn\/mall\/lib\/images\/service_center.png"
                    NSDictionary* getdic= dic[@"data"];
                    
                    
                    
                    lacationVC = [[ShareWithFriendsViewCtr alloc] init];
                    
                    lacationVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    lacationVC.preferredContentSize = CGSizeMake(SCREEN_WIDTH/6*4, SCREEN_WIDTH*5/6+50);
                    
                    lacationVC.gettitle = getdic[@"title"];
                    lacationVC.geturl = getdic[@"link"];
                    lacationVC.getimage = getdic[@"imgUrl"];
                    lacationVC.getdescription = getdic[@"content"];
                    
                    UIPopoverPresentationController *pop = lacationVC.popoverPresentationController;
                    pop.delegate = self;
                    pop.permittedArrowDirections = UIPopoverArrowDirectionAny;
                    
                    [self presentViewController:lacationVC animated:YES completion:nil];
                });
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                             message:msg0  preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler:nil]];
                    
                    
                    [self presentViewController: alertController animated: YES completion: nil];
                });
            }
        }];
        NSLog(@"13");
    }else if ([title hasPrefix:@"视频教学"]){//视频教学
        NSLog(@"14");
        VideoTeachingViewCtrl * addressvc = [[VideoTeachingViewCtrl alloc] init];
        addressvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressvc animated:YES];
        
    }else if ([title hasPrefix:@"问题反馈"]){//问题反馈
        ProblemFeedbackCtr * problemvc = [[ProblemFeedbackCtr alloc] init];
        problemvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:problemvc animated:YES];
        NSLog(@"15");
        
    }else if ([title hasPrefix:@"最新上架"]){//最新上架
        NSLog(@"16");
        NewShelvesCtr * vc = [[NewShelvesCtr alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([title hasPrefix:@"上报定位"]){//上报定位
        NSLog(@"17");
        ToLocateViewCtr* lacatevc = [[ToLocateViewCtr alloc] init];
        lacatevc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lacatevc animated:YES];
        
    }else if ([title hasPrefix:@"会员卡"]){//会员卡
        MembershipCardViewCtr *membervc = [[MembershipCardViewCtr alloc] init];
        membervc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:membervc animated:YES];
        
        NSLog(@"18");
        
    }else if ([title hasPrefix:@"辖区订单"]){//辖区订单
        NSLog(@"19");
        JurisdictionOrdersCtr *vc = [[JurisdictionOrdersCtr alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([title hasPrefix:@"积分"]){//积分
        MyPointsViewCtr * mypoint = [[MyPointsViewCtr alloc] init];
        mypoint.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mypoint animated:YES];
        NSLog(@"120");
        
    }else if ([title hasPrefix:@"现金券"]){//现金券。
        CashCouponViewCtr * cashvc = [[CashCouponViewCtr alloc] init];
        cashvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cashvc animated:YES];
        NSLog(@"130");
        
    }else if ([title hasPrefix:@"礼券"]){//礼券
        GiftVouchersViewCtr * cashvc = [[GiftVouchersViewCtr alloc] init];
        cashvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cashvc animated:YES];
        NSLog(@"140");
        
    }else if ([title hasPrefix:@"我服务的订单"]){//我服务的订单
        MyServiceOrdersCtr *vc = [[MyServiceOrdersCtr alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        NSLog(@"150");
    }
}

-(void)doButtonclick:(id)sender{
    
    UIButton * btn = sender;
    NSLog(@"=== %d",(int)btn.tag);
    
    MAMyOrdersViewController *vc = [[MAMyOrdersViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.shouldGoBackToRootController = NO;
    vc.preSelectedHeaderBtnTag = btn.tag - 700;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Custom task

- (void)refreshOrderSection {
    
    NSInteger waitForPayOrderCount =  0;
    NSInteger waitForShippingOrderCount = 0;
    NSInteger deliveringOrderCount = 0;
    
    NSNumber * waitForPayOrderCountNumber = getdiction[@"waitForPayOrderCount"];
    NSNumber * waitForShippingOrderCountNumber = getdiction[@"waitForShippingOrderCount"];
    NSNumber * deliveringOrderCountNumber = getdiction[@"deliveringOrderCount"];
    
    if (waitForPayOrderCountNumber != nil) {
        waitForPayOrderCount = [waitForPayOrderCountNumber integerValue];
    }
    
    if (waitForShippingOrderCountNumber != nil) {
        waitForShippingOrderCount = [waitForShippingOrderCountNumber integerValue];
    }
    
    if (deliveringOrderCountNumber != nil) {
        deliveringOrderCount = [deliveringOrderCountNumber integerValue];
    }
    
    SKOrderMenuBtn *menuBtn1 = (SKOrderMenuBtn *)[_orderSection viewWithTag:701];
    menuBtn1.batNumber = waitForPayOrderCount;
    
    SKOrderMenuBtn *menuBtn2 = (SKOrderMenuBtn *)[_orderSection viewWithTag:702];
    menuBtn2.batNumber = waitForShippingOrderCount;
    
    SKOrderMenuBtn *menuBtn3 = (SKOrderMenuBtn *)[_orderSection viewWithTag:703];
    menuBtn3.batNumber = deliveringOrderCount;
}

#pragma mark --  Http request

-(void)getuserInformation {

    [JKURLSession taskWithMethod:@"user/info.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        
        NSDictionary *infoDic = resultDic[@"data"];
        
        NSString * logourl = infoDic[@"logoUrl"];
        NSString * networkName = infoDic[@"networkName"];
        
        
        [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:LOGOURL object:logourl];
        [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:NETWORKNAME object:networkName];
        
        NSString * userphone = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_PHONE];
        if (networkName==nil||!(networkName.length>0)) {
            networkName = @"";
        }
        if (userphone==nil||!(userphone.length>0)) {
            userphone = @"";
        }
        
        NSString *safePhone0 = [JKTool noNilOrSpaceStringForStr:userphone];
        NSString *safePhone = safePhone0;
        if (safePhone0.length >= 11) {
            NSString *segment0 = [safePhone0 substringToIndex:safePhone0.length - 8];//可能包含 +86头部
            NSString *segment1 = [safePhone0 substringFromIndex:safePhone0.length - 4];
            
            safePhone = [NSString stringWithFormat:@"%@****%@",segment0,segment1];
        }
        
        [selflab setText:[NSString stringWithFormat:@"%@\n%@",networkName,safePhone]];
        
        NSString * userurl = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGOURL];
        NSURL * url = [NSURL URLWithString:userurl];
        [selfImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
    }];
}

/**
 *  @author 黎国基, 16-10-31 20:10
 *
 *  各种订单的数量
 */
-(void)getData{
    
    [JKURLSession taskWithMethod:@"order/mallordercount.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                getdiction = resultDic[@"data"];
                [self.tableView reloadData];
            }
        });
    }];
}

//礼券余额，积分
-(void)giftcardBalance{
    //礼券余额
    
    [JKURLSession taskWithMethod:@"giftcard/balance.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                
                NSNumber * total = resultDic[@"data"][@"balance"];
                totalAmount =[total floatValue];

                [self.tableView reloadData];
            }
        });
    }];
    
    //    积分
    [JKURLSession taskWithMethod:@"points/balance.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                
                NSNumber * total = resultDic[@"data"][@"balance"];
                integral =[total floatValue];
                
                [self.tableView reloadData];
            }
        });
    }];
}

#pragma mark - notification

/**
 *  @author 黎国基, 16-10-31 20:10
 *
 *  退出登录了
 */
- (void)userReLogin {
    [selflab setText:[NSString stringWithFormat:@""]];
    
    [selfImageView setImage:[UIImage imageNamed:@"commonPlaceHolderIcon"]];
    
    totalAmount = 0;
    
    integral = 0;
    
    getdiction = nil;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        NSArray *imagearray = @[@"myCurrentWallet",@"shoppingAddress",@"showXNB",@"feed_Back",@"teach_viedo",@"Integral_num",@"cash_balance",@"balance_price"];
        NSArray *titlearray = @[@"我的钱包",@"收货地址",@"推荐新农宝",@"问题反馈",@"视频教学",[NSString stringWithFormat:@"积分%zd",integral],@"现金券",[NSString stringWithFormat:@"礼券¥%.2f",totalAmount]];
        
        static NSString *section0CellID = @"section0CellID";
        
        UserTabButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:section0CellID];
        if (cell == nil) {
            cell = [[UserTabButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section0CellID ];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            cell.delegate = self;
        }
        
        cell.imagearray  = imagearray;
        cell.titlearray = titlearray;
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        static NSString *section1CellID = @"section1CellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section1CellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section1CellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:_orderSection];
        }
        
        [self refreshOrderSection];
        
        return cell;
    }else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_WIDTH/6+90;
    }else if (indexPath.section == 1){
        return 42+SCREEN_WIDTH/5;
        
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 ) {
        return 10;
    }else
        return 0;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
