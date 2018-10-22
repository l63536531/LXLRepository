//
//  OrderTrackingCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/14.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "OrderTrackingCtr.h"
#import "OrderTrackingCell.h"
#import "TransDataProxyCenter.h"
#import "OrderTrackingModel.h"

@interface OrderTrackingCtr ()<UITableViewDelegate,UITableViewDataSource, OrderTrackingdelegate>{
    
    NSMutableArray * getlistArray;
    NSMutableArray * explistarray;//快递公司
    
    NSString * getSetion;
    
}
@property (nonatomic,strong) UITableView* maintableview;

@property (nonatomic, strong) UILabel * ordernumberlab;

@property (nonatomic, strong) UILabel * orderstatelab;

@end

@implementation OrderTrackingCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"订单追踪"];
    getlistArray = [[NSMutableArray alloc] init];
    explistarray = [[NSMutableArray alloc] init];
    
    [self maketableview];
    [self makeHeaderView];
    
    [self getData];
}
-(void)makeHeaderView{
    
    UIImage* image = [UIImage imageNamed:@""];
    UIImageView * iamgeview=[[UIImageView alloc] initWithImage:image];
    [iamgeview setFrame:CGRectMake(40, 50, 20, 20)];
    [self.view addSubview:iamgeview];
    
    UIView* headerbgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    [headerbgview setBackgroundColor:[UIColor whiteColor]];
    _maintableview.tableHeaderView = headerbgview;
    
    _ordernumberlab = [[UILabel alloc] init];
    _ordernumberlab.frame = CGRectMake(15, 0, SCREEN_WIDTH -15, 30);
    [_ordernumberlab setFont:[UIFont systemFontOfSize:14]];
    [_ordernumberlab setTextColor:[UIColor blackColor]];
    [_ordernumberlab setBackgroundColor:[UIColor clearColor]];
    [_ordernumberlab setNumberOfLines:0];
    [_ordernumberlab setTextAlignment:NSTextAlignmentLeft];
    [_ordernumberlab setText:[NSString stringWithFormat:@"订单号：%@",_getOrderNumber]];
    [headerbgview addSubview:_ordernumberlab];
    
    _orderstatelab = [[UILabel alloc] init];
    
    _orderstatelab.frame = CGRectMake(15, 30, SCREEN_WIDTH -15, 30);
    [_orderstatelab setFont:[UIFont systemFontOfSize:14]];
    [_orderstatelab setTextColor:[UIColor blackColor]];
    [_orderstatelab setBackgroundColor:[UIColor clearColor]];
    [_orderstatelab setTextColor:ColorFromRGB(233, 43, 43)];
    [_orderstatelab setNumberOfLines:0];
    [_orderstatelab setTextAlignment:NSTextAlignmentLeft];
    
    NSString* labtext1 =[NSString stringWithFormat:@"状态：%@",_getOrderState] ;
    NSMutableAttributedString *typeStr1 = [[NSMutableAttributedString alloc] initWithString:labtext1];
    [typeStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    _orderstatelab.attributedText=typeStr1;
    [headerbgview addSubview:_orderstatelab];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 10)];
    [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
    [headerbgview addSubview:line];
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
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return getlistArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (getSetion.length>0) {
        NSLog(@"-- %@",getSetion);
        
        if (section == [getSetion integerValue]) {
            return 1+explistarray.count;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        OrderTrackingModel* model = getlistArray[indexPath.section];
        
        OrderTrackingCell *cell = [[OrderTrackingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
        
        NSArray * titlearray =@[model.log,model.logDate];
        
        [cell update:titlearray];
        cell.delegate = self;
        cell.getsetion  =  indexPath.section;
        NSString * expNum= model.expNum;
        if (expNum.length>0) {
            cell.isbtnshow = YES;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        
    }else if(indexPath.row>0){
        
        if (getSetion.length>0) {
            
            if (indexPath.section == [getSetion integerValue]) {
                
                OrderTrackingCell *cell = [[OrderTrackingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
                NSDictionary * dic = explistarray[indexPath.row - 1];
                
                NSArray * titlearray =@[dic[@"logisticsInfo"],dic[@"logisticsDate"]];
                
                [cell update:titlearray];
                cell.delegate = nil;
                cell.isbtnshow = NO;
                cell.getsetion  = 444;//是 红色 或 灰色？，只要不是0，就可以
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = ColorFromRGB(240, 240, 240);
                return cell;
            }
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"选择%ld",indexPath.row);
}

-(void)getData{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求中..."];
    [[TransDataProxyCenter shareController] querytrackorderId:_getorderID block:^(NSDictionary *dic, NSError *error) {
        if (dic) {
            NSNumber* code = dic[@"code"];
            NSString* msg = [error localizedDescription];
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                NSArray* array = dic[@"data"];
                NSLog(@"%ld",array.count);
                
                if (array != nil && [array count] > 0) {
                    
                    [getlistArray removeAllObjects];
                    for (NSDictionary* getdic in array) {
                        
                        OrderTrackingModel* model = [OrderTrackingModel create:getdic];
                        [getlistArray addObject:model];
                    }
                    NSLog(@"%ld",getlistArray.count);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
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
    [SVProgressHUD dismiss];
    [_maintableview reloadData];
    [_maintableview.mj_header endRefreshing];
}

//订单追踪点击代理回调
-(void)clickButton:(NSInteger)tag{
    
    NSLog(@"d点击订单");
    if (getSetion.length>0) {
        if ([getSetion integerValue] == tag) {
            
            getSetion= nil;
        }else{
            getSetion = [NSString stringWithFormat:@"%ld",tag];
        }
    }else{
        getSetion = [NSString stringWithFormat:@"%ld",tag];
    }
    
    NSLog(@" ==  %@",getSetion);
    OrderTrackingModel* model = getlistArray[tag];
    
    [self logistictrackorderLogId:model.logId];
    [_maintableview reloadData];
}


-(void)logistictrackorderLogId:(NSString*)getlogId{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求中..."];
    
    [[TransDataProxyCenter shareController] logistictrackorderLogId:getlogId block:^(NSDictionary *dic, NSError *error) {
        if (dic) {
            NSNumber* code = dic[@"code"];
            NSString* msg = [error localizedDescription];
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                if (explistarray.count>0) {
                    [explistarray removeAllObjects];
                }
                NSArray * array = dic[@"data"];
                if (array.count>0) {
                    for (NSDictionary * dic in array) {
                        [explistarray addObject:dic];
                    }
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD showWithStatus:@"无法查询物流信息"];
                        
                        [SVProgressHUD dismissWithDelay:1];
                        
                    });
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
}
@end
