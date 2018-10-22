//
//  PayRecordsViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "PayRecordsViewCtr.h"
#import "PayRecordsCell.h"
#import "TransDataProxyCenter.h"

@interface PayRecordsViewCtr ()

@end

@implementation PayRecordsViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"充值记录"];
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    pageIndex = 1 ;
    getdataList = [[NSMutableArray alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    [self makemianview];

    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];

    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
    
    mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getdata)];
    mianTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [mianTableView.mj_header beginRefreshing];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (getdataList.count>0) {
        [bgview setHidden:YES];

    }else{
        [bgview setHidden:NO];

    }
    return getdataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    PayRecordsCell *cell = [[PayRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
    
    NSArray * titlearray =@[@"2343214123412",@"2016-02-01 14:12:12",@"30",@"49",@"支付订单"];
    
    [cell update:titlearray];
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
    [logoImageView setImage:[UIImage imageNamed:@"quan5"]];
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


-(void)getdata{
//    "notes":"备注",
//    "statusDesc":"状态显示",
//    "amount":"充值金额",
//    "process_date":"处理时间",
//    "submit_date":"创建时间",
//    "id":"充值记录id",
//    "url":"转账凭证图片路径",
//    "pageIndex":"当前页"
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据上传中..."];
    
    
    [[TransDataProxyCenter shareController] ystmemberrechargerecordsaId:_aid pageIndex:@"1" pageSize:@"10" block:^(NSDictionary *dic, NSError *error) {
        
        NSNumber * code = dic[@"code"];
        NSString * msg = dic[@"msg"];
        if ([code intValue] == 200) {
            [SVProgressHUD dismiss];
            [getdataList removeAllObjects];

            pageIndex = 2;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray * array = dic[@"data"];
                
                if (array.count>0) {
                    for (NSDictionary * dic in array) {
                        [getdataList addObject:dic];
                    }
                }

                [mianTableView reloadData];
                [mianTableView.mj_header endRefreshing];
            });
            
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [mianTableView.mj_header endRefreshing];
            });

            [SVProgressHUD showWithStatus:msg];
            [SVProgressHUD dismissWithDelay:1];
        }
        
        
        
        
        
    }];
    





}

-(void)footerRereshing{

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据上传中..."];
    
    
    [[TransDataProxyCenter shareController] ystmemberrechargerecordsaId:_aid pageIndex:[NSString stringWithFormat:@"%d",(int)pageIndex] pageSize:@"10" block:^(NSDictionary *dic, NSError *error) {
        
        NSNumber * code = dic[@"code"];
        NSString * msg = dic[@"msg"];
        if ([code intValue] == 200) {
            [SVProgressHUD dismiss];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray * array = dic[@"data"];
                
                if (array.count>0) {
                    pageIndex++;
                    for (NSDictionary * dic in array) {
                        [getdataList addObject:dic];
                    }
                }
                
                [mianTableView reloadData];
                [mianTableView.mj_footer endRefreshing];
            });
            
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [mianTableView.mj_footer endRefreshing];
            });
            
            [SVProgressHUD showWithStatus:msg];
            [SVProgressHUD dismissWithDelay:1];
        }
        
        
        
        
        
    }];


}


@end
