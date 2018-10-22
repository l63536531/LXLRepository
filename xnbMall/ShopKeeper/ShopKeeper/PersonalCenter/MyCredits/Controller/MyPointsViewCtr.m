//
//  MyPointsViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyPointsViewCtr.h"
#import "MypointsCell.h"
#import "TriangleView.h"
#import "TransDataProxyCenter.h"
#import "MACreditsGoodsMallViewController.h"

@interface MyPointsViewCtr ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    
    UIView * bgview;
    
    NSInteger integral;//积分
    
    NSInteger btntag;
    
    TriangleView* triangview_1;
}


@property(nonatomic, copy)NSString *lastDate;

@property (nonatomic, strong)NSMutableArray *getlist;
/** 区分点击按钮的状态 */
@property (nonatomic, getter=isSeclectbtn)BOOL seclectbtn;

@end

static NSString *const mypointsCellIdentifier = @"MypointsCell";

@implementation MyPointsViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的积分"];
    integral = 0;
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    btntag = 0;
    
    self.getlist = [[NSMutableArray alloc] init];
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"积分商城" style:UIBarButtonItemStylePlain target:self action:@selector(rightButton)];
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
    
    mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.lastDate = nil;
        [self getdata];
    }];
    mianTableView.mj_header.automaticallyChangeAlpha = YES;
    
    mianTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getdata];
    }];
    [mianTableView.mj_footer setAutomaticallyHidden:YES];
    
    
    //注册cell
    [mianTableView registerClass:[MypointsCell class] forCellReuseIdentifier:mypointsCellIdentifier];
    [self getdata];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //获取积分
    [self getLoadIntegralBalance];
    
}

-(void)rightButton{
    
    MACreditsGoodsMallViewController* vc = [[MACreditsGoodsMallViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 ) {
        return 1;
    }else if(section == 1){
        
        if (btntag == 0) {
            return 1;
            
        }else return 0;
        
        
        
    }else{
        if (btntag == 0) {
            return 0;
            
        }else{
            
            return self.getlist.count;
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        
        
        [cell.contentView addSubview:[self makefootview]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }else if (indexPath.section == 1){
        
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        NSString* detialstring = @"\n＊积分如何获取\n1、新用户：新用户注册+500积分\n2、推荐新用户：每推荐一个新用户注册+500积分\n3、确认收货：每笔订单主动签收+100积分\n4、农业120:您回答的问题被采纳之后，会获得该问题的积分\n\n*积分如何使用\n可以在积分商城兑换商品、农业120中提问\n\n＊积分有效期\n您获得的每一笔积分，都会在当年的年底（当年的12月31日23:59:59）过期，您需要在过期前尽快使用！\n\n＊违规积分的处理\n您如果通过各种方式，作弊获取积分，我们会扣除作弊积分；对于作弊情节严重的，我们会清空全部积分，封禁账户，并保留追究相应法律责任的权利。\n积分规则解释权，归深圳市新农宝科技有限公司所有。";
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15.f, 0.f, SCREEN_WIDTH - 30.f, 400.f)];
        textView.font = FONT_HEL(13.f);
        textView.editable = NO;
        [cell.contentView addSubview:textView];
        
        NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:detialstring];
        NSLog(@"-- %ld",detialstring.length);
        
        NSString *title0 = @"＊积分如何获取";
        NSString *title1 = @"*积分如何使用";
        NSString *title2 = @"＊积分有效期";
        NSString *title3 = @"＊违规积分的处理";
        
        NSRange range0 = [detialstring rangeOfString:title0];
        NSRange range1 = [detialstring rangeOfString:title1];
        NSRange range2 = [detialstring rangeOfString:title2];
        NSRange range3 = [detialstring rangeOfString:title3];
        
        [typeStr addAttribute:NSForegroundColorAttributeName value:RGBGRAY(100.f) range:NSMakeRange(0, detialstring.length)];
        
        [typeStr addAttribute:NSForegroundColorAttributeName value:ColorFromHex(0xec584e) range:range0];
        [typeStr addAttribute:NSForegroundColorAttributeName value:ColorFromHex(0xec584e) range:range1];
        [typeStr addAttribute:NSForegroundColorAttributeName value:ColorFromHex(0xec584e) range:range2];
        [typeStr addAttribute:NSForegroundColorAttributeName value:ColorFromHex(0xec584e) range:range3];
        textView.attributedText=typeStr;
        
        return cell;
        
    }
    
    else{
        
        MypointsCell *cell = [tableView dequeueReusableCellWithIdentifier:mypointsCellIdentifier];
        
        NSDictionary * dic  = self.getlist[indexPath.row];
        NSString * notes = dic[@"notes"];
        NSString * createdDate = dic[@"createdDate"];
        NSNumber * getpoints = dic[@"points"];
        NSInteger points = [getpoints integerValue];
        
        
        if (!(notes.length>0)) {
            notes = @"未知";
        }
        if (!(createdDate.length>0)) {
            createdDate = @"时间";
        }
        
        NSString * getPoints;
        if (points<= 0) {
            getPoints = [NSString stringWithFormat:@"%ld",points];
        }else{
            getPoints = [NSString stringWithFormat:@"+%ld",points];
        }
        
        NSArray * titlearray =@[notes,createdDate,getPoints,@"49",@"支付订单"];
        
        [cell update:titlearray];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 ) {
        return 450;
    }else if (indexPath.section ==0){
        return 120;
        
    }else
        return 60;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UIView*)makefootview{
    
    
    bgview = [[UIView alloc] init];
    [bgview setBackgroundColor:[UIColor whiteColor]];
    [bgview setFrame:CGRectMake(0,0, SCREEN_WIDTH, 120)];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame= CGRectMake(SCREEN_WIDTH/2-50, 10,30, 30);
    [logoImageView setContentMode:UIViewContentModeScaleToFill];
    [logoImageView setClipsToBounds:YES];
    [logoImageView setImage:[UIImage imageNamed:@"积分"]];
    [bgview addSubview:logoImageView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(SCREEN_WIDTH/2-70, 40, 70 , 30);
    [titleLabel setFont:[UIFont systemFontOfSize:13]];
    [titleLabel setText:@"剩余积分"];
    [titleLabel setTextColor:ColorFromHex(0x646464)];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [bgview addSubview:titleLabel];
    
    UIView * line_1 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+10, 10, 1, 40)];
    [line_1 setBackgroundColor:[UIColor lightGrayColor]];
    [bgview addSubview:line_1];
    
    
    UILabel * pointLabel = [[UILabel alloc] init];
    pointLabel.frame = CGRectMake(SCREEN_WIDTH/2+30, 10, SCREEN_WIDTH/2 - 50 , 50);
    [pointLabel setFont:[UIFont systemFontOfSize:30]];
    [pointLabel setText:@"1000分"];
    [pointLabel setTextColor:ColorFromHex(0xec584e)];
    [pointLabel setNumberOfLines:0];
    pointLabel.adjustsFontSizeToFitWidth = YES;
    [pointLabel setTextAlignment:NSTextAlignmentLeft];
    [bgview addSubview:pointLabel];
    
    NSString* labtext =[NSString stringWithFormat:@"%zd分",integral];//self.point
    NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:labtext];
    [typeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(labtext.length -1, 1)];
    [typeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20]range:NSMakeRange(labtext.length-1, 1)];
    pointLabel.attributedText=typeStr;
    
    UIView* bgviewone = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 40)];
    [bgviewone setBackgroundColor:ColorFromRGB(238, 238, 238)];
    [bgview addSubview:bgviewone];
    
    triangview_1 = [[TriangleView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 - 10+SCREEN_WIDTH/2*btntag, 30, 20, 10)];
    [triangview_1 setBackgroundColor:[UIColor clearColor]];
    [bgviewone addSubview:triangview_1];
    
    
    UIButton * btnone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnone setFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 40)];
    [btnone setBackgroundColor:[UIColor clearColor]];
    //    [btnone setImage:[UIImage imageNamed:@"wodelan"] forState:UIControlStateNormal];
    [btnone setTitle:@"积分规则" forState:UIControlStateNormal];
    [btnone setTitleColor:ColorFromHex(0x646464) forState:UIControlStateNormal];
    [btnone.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnone addTarget:self action:@selector(btnClickrRgulation) forControlEvents:UIControlEventTouchUpInside];
    
    [bgviewone addSubview:btnone];
    
    UILabel * titleLabelone= [[UILabel alloc] init];
    titleLabelone.frame = CGRectMake(0, 40, 80 , 20);
    [titleLabelone setFont:[UIFont systemFontOfSize:16]];
    [titleLabelone setText:@"积分规则"];
    [titleLabelone setTextColor:[UIColor grayColor]];
    titleLabelone.adjustsFontSizeToFitWidth = YES;
    [titleLabelone setTextAlignment:NSTextAlignmentCenter];
    //    [bgviewone addSubview:titleLabelone];
    
    
    UIButton * btntwo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btntwo setFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40)];
    [btntwo setBackgroundColor:[UIColor clearColor]];
    [btntwo setTitle:@"积分记录" forState:UIControlStateNormal];
    [btntwo setTitleColor:ColorFromHex(0x646464) forState:UIControlStateNormal];
    [btntwo.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btntwo addTarget:self action:@selector(btnClickCreditslog) forControlEvents:UIControlEventTouchUpInside];
    
    [bgviewone addSubview:btntwo];
    
    UILabel * titleLabeltwo = [[UILabel alloc] init];
    titleLabeltwo.frame = CGRectMake(80, 40, 80 , 20);
    [titleLabeltwo setFont:[UIFont systemFontOfSize:16]];
    [titleLabeltwo setText:@"积分记录"];
    [titleLabeltwo setTextColor:[UIColor grayColor]];
    titleLabeltwo.adjustsFontSizeToFitWidth = YES;
    [titleLabeltwo setTextAlignment:NSTextAlignmentCenter];
    
    
    
    return bgview;
}



#pragma mark - Touch events

- (void)btnClickrRgulation {
    btntag = 0;
    if (_seclectbtn) {
        [triangview_1 setFrame:CGRectMake(SCREEN_WIDTH*3/4 - 10, 30, 20, 10)];
        mianTableView.mj_header.hidden = YES;
        mianTableView.mj_footer.hidden = YES;
    }
    
    [mianTableView reloadData];
    
}


//积分记录点击
- (void)btnClickCreditslog {
    
    btntag = 1;
    
    if (self.seclectbtn) { //避免重复点击出现
        
        [triangview_1 setFrame:CGRectMake(SCREEN_WIDTH/4 - 10, 30, 20, 10)];
    }
    
    [self getdata];
    
    
}

#pragma mark - Http request


-(void)getdata{
    
    if (btntag == 0) {
        
        [mianTableView.mj_footer endRefreshing];
        [mianTableView.mj_header endRefreshing];
        return;
    }
    
    if (btntag == 1) {  //点击积分记录才请求
        if (self.lastDate == nil) {
            self.lastDate = @"";
        }
        
        NSDictionary *postdata = @{@"lastDate":self.lastDate};
        
        [[NetWorkManager shareManager]netWWorkWithReqUrl:@"points/flow.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
            [mianTableView.mj_header endRefreshing];
            [mianTableView.mj_footer endRefreshing];
            
            NSLog(@"积分流水%@",dicStr);
            
            if(fail_success){ //网络成功
                
                if ([dicStr[@"code"] intValue] == 200) {
                    NSArray * array = dicStr[@"data"];
                    
                    if ([_lastDate isEqual: @""]) {
                        [self.getlist removeAllObjects];
                    }
                    if (array.count>0) {
                        for (NSDictionary * dic in array) {
                            [self.getlist addObject:dic];
                            
                        }
                    }
                    //保存最后一个时间
                    NSDictionary *dic2 = [self.getlist lastObject];
                    _lastDate = dic2[@"createdDate"];
                    [mianTableView reloadData];
                    
                }else {
                    [mianTableView.mj_footer endRefreshing];
                    [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
                }
                
            }else{
                [mianTableView.mj_footer endRefreshing];
                [MBProgressHUD showError:@"网络错误!" ToView:self.view];
            }
        }];
        
    }
}

- (void)getLoadIntegralBalance {
    
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"points/balance.do" ReqParam:@{} BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        [mianTableView.mj_header endRefreshing];
        if(fail_success){ //网络成功
            
            if ([dicStr[@"code"] intValue] == 200) {
                
                NSDictionary *dic = dicStr[@"data"];
                NSNumber * total =dic [@"balance"];
                integral =[total floatValue];
                
                [mianTableView reloadData];
                
            }else {
                
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
            }
            
        }else{
            
            [MBProgressHUD showError:@"网络错误!" ToView:self.view];
        }
    }];
    
}


@end
