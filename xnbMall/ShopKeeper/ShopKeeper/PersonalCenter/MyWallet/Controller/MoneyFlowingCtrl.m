//
//  MoneyFlowingCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MoneyFlowingCtrl.h"
#import "MoneyFlowingCell.h"
#import "TransDataProxyCenter.h"
#import "MoneyFlowingModel.h"

@interface MoneyFlowingCtrl ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    
    UIView * bgview;
    
    NSMutableArray* moneyflowingArray;
 
}

@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign)NSInteger pageSize;

@end


static NSString *const moneyFlowingCellIdentifier = @"MoneyFlowingCell";

@implementation MoneyFlowingCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"资金流水"];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    _pageIndex = 1;
    _pageSize = 10;
    moneyflowingArray = [[NSMutableArray alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    

    [self getData];
    
    
    [self setUpTableView];

    
    [self makemianview];
}



- (void)setUpTableView {
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
   
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
    // 注册cell
    [mianTableView registerClass:[MoneyFlowingCell class] forCellReuseIdentifier:moneyFlowingCellIdentifier];
    
    [self setUpRefresh];
}

- (void)setUpRefresh {
    
    mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        
        [self getData];
    }];
    
    mianTableView.mj_header.automaticallyChangeAlpha = YES;
    
    mianTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (moneyflowingArray.count>0) {
        bgview.hidden = YES;
    }else{
        bgview.hidden = NO;
        
    }

    return moneyflowingArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
MoneyFlowingCell *cell = [tableView dequeueReusableCellWithIdentifier:moneyFlowingCellIdentifier];
    
    MoneyFlowingModel* getmodel = moneyflowingArray[indexPath.row];
    [cell update:getmodel];
   
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)makemianview{
    
    bgview = [[UIView alloc] init];
    [bgview setBackgroundColor:[UIColor clearColor]];
    [bgview setFrame:CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    [bgview setHidden:YES];
    [self.view addSubview:bgview];
    
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame= CGRectMake(SCREEN_WIDTH/3, 0,SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    [logoImageView setContentMode:UIViewContentModeScaleAspectFill];
    [logoImageView setClipsToBounds:YES];
    [logoImageView setImage:[UIImage imageNamed:@"quan3"]];
    [logoImageView.layer setCornerRadius:SCREEN_WIDTH/6];
    
    [bgview addSubview:logoImageView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, SCREEN_WIDTH/3+10, SCREEN_WIDTH , 30);
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setText:@"没有资金明细"];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [bgview addSubview:titleLabel];
    
}

-(void)getData{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_getid forKey:@"aid"];
    dic[@"pageIndex"] = [NSString stringWithFormat:@"%zd",self.pageIndex];
    dic[@"pageSize"] = [NSString stringWithFormat:@"%zd",self.pageSize];
    
    [MBProgressHUD showMessage:@"请求中..." ToView:nil];
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"money/flow.do" ReqParam:dic BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        
        [mianTableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSLog(@"资金流水%@",dicStr);
        if (fail_success) { //网络成功
            
            NSNumber* code = dicStr[@"code"];
            if ([code intValue]  == 200) {
                
                if (_pageIndex == 1) {
                    [moneyflowingArray removeAllObjects];
                }
                NSArray* array = dicStr[@"data"][@"list"];
                _pageIndex =2;
                if (array != nil && [array count] > 0) {
                    
                    for (NSDictionary* getdic in array) {
                        MoneyFlowingModel* model = [MoneyFlowingModel create:getdic];
                        [moneyflowingArray addObject:model];
                    }
                }
                [mianTableView reloadData];
            } else {
                
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
            }
            
        }else{
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view ];
        }
    }];

    
}

-(void)footerRereshing{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_getid forKey:@"aid"];
    dic[@"pageIndex"] = [NSString stringWithFormat:@"%zd",self.pageIndex];
    dic[@"pageSize"] = [NSString stringWithFormat:@"%zd",self.pageSize];
    
    [MBProgressHUD showMessage:@"请求中..." ToView:nil];
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"money/flow.do" ReqParam:dic BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        
        
        [MBProgressHUD hideHUD];
        [mianTableView.mj_footer endRefreshing];
        
        if (fail_success) {
            
            NSNumber* code = dicStr[@"code"];
            if ([code intValue]  == 200) {
                NSArray* array = dicStr[@"data"][@"list"];
                
                _pageIndex ++;
                
                if (array != nil && [array count] > 0) {
                    
                    for (NSDictionary* getdic in array) {
                        
                        MoneyFlowingModel* model = [MoneyFlowingModel create:getdic];
                        
                        [moneyflowingArray addObject:model];
                    }
                }
                
                [mianTableView reloadData];
            }
            else {
                //需添加在window上 因为有弹框会遮住
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
            }
            
        }else{
            [mianTableView.mj_footer endRefreshing];
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view ];
        }
        
    } ];
 
}

@end
