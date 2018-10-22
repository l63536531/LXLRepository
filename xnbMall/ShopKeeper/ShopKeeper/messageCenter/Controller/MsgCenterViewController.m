//
//  MsgCenterViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/5/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MsgCenterViewController.h"
#import "MsgViewCell.h"
#import "MsgDetailViewController.h"
#import "WebViewController.h"
#import "TransDataProxyCenter.h"

#import "UIFactory.h"
#import "UITabBar+SKDot.h"  //消息红点

@interface MsgCenterViewController () {
    
    BOOL _isRefreshing;
}
@property(nonatomic) NSMutableArray *data;
@property(nonatomic) NSInteger pageIndex;

@property (nonatomic,strong)UILabel *hasNo_lb;
@property (nonatomic,strong)UIImageView *hasNo_ImageView;

@end

@implementation MsgCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _data = [NSMutableArray new];
    _pageIndex = 0;
    _isRefreshing = NO;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.f - 49.f) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    __weak UITableView *tableView = self.tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isRefreshing = YES;
        [self requestMessageList];
    }];

    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _isRefreshing = NO;
        [self requestMessageList];
    }];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self requestMessgeCount];
    
    _isRefreshing = YES;
    [self requestMessageList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//是否有 新消息
-(void)requestMessgeCount{
    
    [JKURLSession taskWithMethod:@"message/checkunread.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        if (error == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNumber *haseNewMsg = resultDic[@"data"];
                if ([haseNewMsg boolValue]) {
                    [self.tabBarItem setBadgeValue:@""];
                    
                }else{
                    [self.tabBarItem setBadgeValue:nil];
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                }
            });
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_data.count == 0) {
        self.tableView.mj_footer.hidden = YES;
    }else {
        self.tableView.mj_footer.hidden = NO;
    }
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //if(section == 0) return 44;
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    static NSString *ID = @"cellID";

    MsgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MsgViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    NSDictionary * dic = _data[indexPath.row];
    cell.readed = [dic[@"readed"] integerValue]; //是否已读
    if ([dic[@"readed"] integerValue] == 0) {
        //有未读消息 显示红点
        [self.tabBarController.tabBar showBadgeOnItmIndex:1];
    }
    cell.data  =  dic;
   
    cell.title.text = dic[@"title"];
    cell.subtitle.text = dic[@"summary"];
    cell.datelabel.text = dic[@"createTimeFmt"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    MsgDetailViewController *iv  = [[MsgDetailViewController alloc] init];
    NSDictionary * dic =_data[indexPath.row];
    iv.getmessgeid = dic[@"id"];
    
    NSString *titleN = dic[@"title"];
    if (titleN) { //消息详情
        iv.titleName = titleN;
    }
    
    iv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:iv animated:YES];
    //
    NSDictionary *postdata = @{@"msgId":dic[@"id"]};
    //隐藏消息红点 需求需要在最新的消息点击过才隐藏 否则则不隐藏
    [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
    [JKURLSession taskWithMethod:@"message/reportRead.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {}];//上报通知的阅读状态
}

-(void)requestMessageList{
    
    if(self.hasNo_lb) //先移除占位图
    {
        [self hideNoDataImageAndlabelView];
    }
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0)
    {
        return;
    }
    
    NSInteger pageIndex = _pageIndex;
    if (_isRefreshing) {
        pageIndex = 0;
    }
        
    NSDictionary *postdata = @{@"pageIndex":[NSString stringWithFormat:@"%zd",pageIndex]};
    
    [JKURLSession taskWithMethod:@"message/messageList.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        NSLog(@"信息中心+++++++%@",resultDic);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (error == nil) {

            if (_isRefreshing) {
                [_data removeAllObjects];
                _pageIndex = 2;
            }else {
                _pageIndex++;
            }
            
            NSArray *pageArray = resultDic[@"data"][@"list"];
            if (pageArray == nil || pageArray.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_data addObjectsFromArray:pageArray];
            [self.tableView reloadData];
            
            if (_data.count == 0) {
                [self showNoDataViewImageName:@"quan10" AndLabelName:@"暂无消息" OnView:self.tableView];
            }
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

-(void)showNoDataViewImageName:(NSString *)imageName AndLabelName:(NSString *)text OnView:(UIView*)view{
    self.hasNo_lb  =[UIFactory  creatLabelWithtext:text textColor:[UIColor colorWithHexString:@"#646464"] font:14 textAlignment:NSTextAlignmentCenter];
    [view addSubview: self.hasNo_lb];
    
    self.hasNo_ImageView =[[UIImageView alloc] init];
    self.hasNo_ImageView.image =[UIImage imageNamed:imageName];
    [view addSubview:self.hasNo_ImageView];
    WS(weakSelf);
    [self.hasNo_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(-64);
        make.height.width.equalTo(@(100));
        
    }];
    
    [self.hasNo_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.right.equalTo(view).offset(-15);
        make.centerX.equalTo(view);
        make.top.equalTo(weakSelf.hasNo_ImageView.mas_bottom).offset(20);
    }];
    
    
}


-(void)hideNoDataImageAndlabelView{
    
    [self.hasNo_ImageView removeFromSuperview];
    [self.hasNo_lb removeFromSuperview];
    
}


@end
