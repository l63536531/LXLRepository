//
//  JurisdictionSearchEndCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/7/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "JurisdictionSearchEndCtr.h"
#import "Billsummaryview.h"
#import "OrderTrackingCtr.h"
#import "TransDataProxyCenter.h"
#import "MyServiceOrderDetailCtr.h"

@interface JurisdictionSearchEndCtr ()

@end

@implementation JurisdictionSearchEndCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"搜索结果"];
    
    pageindex = 0;
    _allorderArray = [[NSMutableArray alloc] init];
    
    [self maketableview];
    [self makemianview];
    
}
-(void)maketableview{
    
    
    _maintableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _maintableview.dataSource = self;
    _maintableview.bounces = YES;
    _maintableview.delegate = self;
    _maintableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _maintableview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_maintableview];
    _maintableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    _maintableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_maintableview.mj_header beginRefreshing];
    
   
    
}


#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_allorderArray.count>0) {
        [bgview setHidden:YES];
    }else{
        
        [bgview setHidden:NO];
    }
    
    return _allorderArray.count;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 195;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MyServiceOrdersCell *cell = [[MyServiceOrdersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
    
    //    NSArray * titlearray =@[@"2016-02-01 14:12:12",@"尚未处理",@"＋8615989150934",@"中国农业银行",@"68237827317797979797",@"32",@"备注问题"];
    MyOrderModel * model = _allorderArray[indexPath.row];
    
    [cell update:model];
    cell.delegate = self;
    cell.getindex = _getindid;
    cell.getindexrow = indexPath.row;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderModel * model = _allorderArray[indexPath.row];
    
    MyServiceOrderDetailCtr * vc = [[MyServiceOrderDetailCtr alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.getorderId = model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"选择%ld",indexPath.row);
    
}
-(void)clickButton:(NSInteger)tag row:(NSInteger)indexrow{
    
    MyOrderModel * model = _allorderArray[indexrow];
    
    NSLog(@"点击 %ld",tag);
    
    if (tag == 400) {
        OrderTrackingCtr * vc = [[OrderTrackingCtr alloc] init];
        //    待支付：1     待发货：2,7    待签收：3,8   已完成：4,5,6,99
        if (model.state == 1) {//待支付
            vc.getOrderState = @"待支付";
        }else if (model.state == 2||model.state==7){// 待发货：2,7
            
            vc.getOrderState = @"待发货";
        }else if (model.state == 3||model.state == 8){//待签收：3,8
            vc.getOrderState = @"待签收";
            
        }else if (model.state == 4||model.state == 5||model.state == 6||model.state == 99){//已完成：4,5,6,99
            vc.getOrderState = @"已完成";
        }else{
            vc.getOrderState = @"";
        }
        
        vc.getOrderNumber = model.code;
        vc.hidesBottomBarWhenPushed = YES;
        vc.getorderID = model.orderId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)getData{
    
    [_allorderArray removeAllObjects];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求中..."];
    
    [[TransDataProxyCenter shareController] queryYtorders:(int)_getindid  searchKey:_getkeyString pageIndex:@"0" block:^(NSDictionary *dic, NSError *error) {
        if (dic) {
            NSNumber* code = dic[@"code"];
            NSString* msg = [error localizedDescription];
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                
                NSArray* array = dic[@"data"][@"list"];
                NSLog(@"%ld",array.count);
                
                pageindex++;
                
                if (array != nil && [array count] > 0) {
                    
                    for (NSDictionary* getdic in array) {
                        
                        
                        MyOrderModel* model = [MyOrderModel create:getdic];
                        
                        [_allorderArray addObject:model];
                        
                        
                    }
                    
                    
                    NSLog(@"%ld",_allorderArray.count);
                    
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                    [_maintableview reloadData];
                    
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_maintableview reloadData];
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    
                });
                
            }
            
            
        }else{
            
            [SVProgressHUD showWithStatus:@"请检查网络"];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
        
        
    }];
    [_maintableview reloadData];
    [_maintableview.mj_header endRefreshing];
    
    
}



-(void)footerRereshing{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [[TransDataProxyCenter shareController] queryYtorders:(int)_getindid  searchKey:_getkeyString pageIndex:[NSString stringWithFormat:@"%ld",pageindex] block:^(NSDictionary *dic, NSError *error) {
        if (dic) {
            NSNumber* code = dic[@"code"];
            NSString* msg = [error localizedDescription];
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                
                NSArray* array = dic[@"data"][@"list"];
                NSLog(@"%ld",array.count);
                
                pageindex++;
                if (array != nil && [array count] > 0) {
                    
                    for (NSDictionary* getdic in array) {
                        
                        
                        MyOrderModel* model = [MyOrderModel create:getdic];
                        
                        [_allorderArray addObject:model];
                        
                        
                    }
                    
                    
                    NSLog(@"%ld",_allorderArray.count);
                    
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                    [_maintableview reloadData];
                    
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_maintableview reloadData];
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    
                });
                
            }
            
            
        }else{
            
            [SVProgressHUD showWithStatus:@"请检查网络"];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
        
        
    }];
    [_maintableview reloadData];
    [_maintableview.mj_footer endRefreshing];
    
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
