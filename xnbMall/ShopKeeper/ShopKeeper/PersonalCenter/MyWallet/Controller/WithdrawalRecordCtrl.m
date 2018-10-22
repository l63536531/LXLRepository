//
//  WithdrawalRecordCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "WithdrawalRecordCtrl.h"
#import "WithdrawalRecordCell.h"
#import "TransDataProxyCenter.h"
#import "WithdrawalRecordModel.h"

@interface WithdrawalRecordCtrl ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * mianTableView;
    UIView * bgview;
    NSMutableArray * witharray;
    
}

@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign)NSInteger pageSize;

@end

static NSString *const withdrawalRecordCellIdentifier = @"WithdrawalRecordCell";

@implementation WithdrawalRecordCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"提现记录"];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    _pageIndex = 1;
    _pageSize = 10;
    witharray = [[NSMutableArray alloc] init];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    [self setUpTableView];
     [self getData];
    
    [self setUpRefresh];
   
    [self makemianview];
}



- (void)setUpTableView {
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:BACKGROUND_COLOR];
    [self.view addSubview:mianTableView];
    
    //注册cell
    [mianTableView registerClass:[WithdrawalRecordCell class] forCellReuseIdentifier:withdrawalRecordCellIdentifier];
    
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
    mianTableView.mj_footer.automaticallyHidden = YES;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (witharray.count>0) {
        bgview.hidden = YES;
    }else{
        bgview.hidden = NO;
    
    }
    
    return witharray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    WithdrawalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:withdrawalRecordCellIdentifier];
    WithdrawalRecordModel* model = witharray[indexPath.row];
    [cell update:model];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
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
    [titleLabel setText:@"没有提现记录"];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [bgview addSubview:titleLabel];
    
}


//查询提现请求
-(void)getData{
    
 
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_getid forKey:@"aid"];
    dic[@"pageIndex"] = [NSString stringWithFormat:@"%zd",self.pageIndex];
    dic[@"pageSize"] = [NSString stringWithFormat:@"%zd",self.pageSize];
    
    
    [MBProgressHUD showMessage:@"请求中..." ToView:nil];  //处理状态 processResult
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"money/listwithdraw.do" ReqParam:dic BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        
        [mianTableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if (fail_success) {
            NSLog(@"提现记录%@",dicStr);
            if (_pageIndex == 1){ [witharray removeAllObjects];}
            
            NSNumber* code = dicStr[@"code"];
            if ([code intValue]  == 200) {
                NSInteger total = [dicStr[@"data"][@"total"] integerValue];
                NSInteger totalpage = (total/_pageSize) + (total%_pageSize>0?1:0);
                if(_pageIndex >= totalpage){
                    [mianTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [mianTableView.mj_footer endRefreshing];
                }
                
                NSArray* array =dicStr[@"data"][@"list"];
                if (array != nil && [array count] > 0) {
                    
                    _pageIndex = 2;
                    for (NSDictionary* getdic in array) {
                        
                        WithdrawalRecordModel* model = [WithdrawalRecordModel create:getdic];
                        [witharray addObject:model];
                    }
                    
                }
                [mianTableView reloadData];
            }
            else{
                [mianTableView.mj_footer endRefreshing];
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
    [dic setValue:[NSString stringWithFormat:@"%ld",_pageIndex] forKey:@"pageIndex"];
    [dic setValue:@"10" forKey:@"pageSize"];
    
    
    [MBProgressHUD showMessage:@"加载中,请稍候..." ToView:nil];
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"money/listwithdraw.do" ReqParam:dic BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        
        [MBProgressHUD hideHUD];
        [mianTableView.mj_footer endRefreshing];
        if (fail_success) {
            
            NSNumber* code = dicStr[@"code"];
            if ([code intValue]  == 200) {
                NSArray* array =dicStr[@"data"][@"list"];
                if (array != nil && [array count] > 0) {
                    NSInteger total = [dicStr[@"data"][@"total"] integerValue];
                    NSInteger totalpage = (total/_pageSize) + (total%_pageSize>0?1:0);
                    if(_pageIndex >= totalpage){
                        [mianTableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        [mianTableView.mj_footer endRefreshing];
                    }
                    _pageIndex ++;
                    for (NSDictionary* getdic in array) {
                        
                        WithdrawalRecordModel* model = [WithdrawalRecordModel create:getdic];
                        
                        [witharray addObject:model];
                        
                    }
                }
                [mianTableView reloadData];
            }
            else{
                
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
            }
            
        }else{
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view ];
        }
        
    }];
 
}

@end
