//
//  MembershipflowCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/7/27.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MembershipflowCtr.h"
#import "MoneyFlowingCell.h"
#import "TransDataProxyCenter.h"
#import "MoneyFlowingModel.h"
@interface MembershipflowCtr ()

@end

@implementation MembershipflowCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"流水资金"];
    [self.view setBackgroundColor:ColorFromRGB(230, 230, 230)];
    
    _pageindex = 1;
    moneyflowingArray = [[NSMutableArray alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    //    mianTableView.scrollEnabled = YES;
    //    mianTableView.bounces = NO;
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
    mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    mianTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [mianTableView.mj_header beginRefreshing];
    
    
    [self makemianview];
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
    
    
    
    MoneyFlowingCell *cell = [[MoneyFlowingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
    
    
    MoneyFlowingModel* getmodel = moneyflowingArray[indexPath.row];
    [cell update:getmodel];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
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
    
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求中..."];
    
    
    
    [[TransDataProxyCenter shareController] ystmemberflowaId:_getid pageIndex:@"1" pageSize:@"10" block:^(NSDictionary *dic, NSError *error) {
        
        
        if (dic) {
            NSNumber* code = dic[@"code"];
            NSString* msg = [error localizedDescription];
            [moneyflowingArray removeAllObjects];
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                
                NSArray* array = dic[@"data"];
                
                _pageindex = 2;
                
                if (array != nil && [array count] > 0) {
                    
                    for (NSDictionary* getdic in array) {
                        
                        
                        MoneyFlowingModel* model = [MoneyFlowingModel create:getdic];
                        
                        [moneyflowingArray addObject:model];
                        
                        
                    }
                    
                    
                    NSLog(@"%ld",moneyflowingArray.count);
                    
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [mianTableView reloadData];
                    [mianTableView.mj_header endRefreshing];
                    [SVProgressHUD dismiss];
                    
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mianTableView reloadData];
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    
                });
                
            }
            
            
        }else{
            
            [SVProgressHUD showWithStatus:@"请检查网络"];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
        
        
    }];
    
    [mianTableView.mj_header endRefreshing];
    
    
}

-(void)footerRereshing{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    
    
    [[TransDataProxyCenter shareController] ystmemberflowaId:_getid pageIndex:[NSString stringWithFormat:@"%ld",_pageindex] pageSize:@"10" block:^(NSDictionary *dic, NSError *error) {
        
        
        if (dic) {
            NSNumber* code = dic[@"code"];
            NSString* msg = [error localizedDescription];
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                
                NSArray* array = dic[@"data"];
                
                _pageindex++;
                
                
                if (array != nil && [array count] > 0) {
                    
                    for (NSDictionary* getdic in array) {
                        
                        
                        MoneyFlowingModel* model = [MoneyFlowingModel create:getdic];
                        
                        [moneyflowingArray addObject:model];
                        
                        
                    }
                    
                    
                    NSLog(@"%ld",moneyflowingArray.count);
                    
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [mianTableView reloadData];
                    [mianTableView.mj_header endRefreshing];
                    [SVProgressHUD dismiss];
                    
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mianTableView reloadData];
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    
                });
                
            }
            
            
        }else{
            
            [SVProgressHUD showWithStatus:@"请检查网络"];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
        
        
    }];
    
    [mianTableView.mj_footer endRefreshing];
    
    
    
}


@end
