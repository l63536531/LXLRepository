//
//  CouponValidViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "CouponValidViewCtr.h"
#import "CouponValidCell.h"
#import "TransDataProxyCenter.h"
#import "ShareUnity.h"

@interface CouponValidViewCtr ()

@end

@implementation CouponValidViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"余额有效期"];
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    getlistarray = [[NSMutableArray alloc] init];
    pageIndex = 1;
    
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
    
    [self makemianview];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (getlistarray.count>0) {
        [bgview setHidden:YES];

    }else{
        [bgview setHidden:NO];

    }
    NSLog(@"getlistarray.count%d",getlistarray.count);
    
    return getlistarray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    CouponValidCell *cell = [[CouponValidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
    
    NSDictionary * dic = getlistarray[indexPath.row];
    
    NSString * cardNumber = dic[@"cardNumber"];
    NSString * createTime = dic[@"validTimeBegin"];
    NSString * lastUpdateTime = dic[@"validTimeEnd"];

    NSNumber * amount = dic[@"availableAmount"];
    NSString* getamount = [NSString stringWithFormat:@"%.2f",[amount floatValue]];
    
    if (createTime.length>10) {
        createTime =[createTime substringWithRange:NSMakeRange(0,10)];

    }
    
    if (lastUpdateTime.length>10) {
        lastUpdateTime =[lastUpdateTime substringWithRange:NSMakeRange(0,10)];
        
    }
    
    if (!(cardNumber.length>0)) {
        cardNumber = @"未知";
        
    }
    if (!(cardNumber.length>0)) {
        cardNumber = @"未知";
        
    }
    
    NSString * time = [NSString stringWithFormat:@"有效期：%@至%@",createTime,lastUpdateTime];
    NSString * money ;
    
    
    NSNumber * state = dic[@"state"];
    int getstate = [state intValue];
    
    NSString * endtime = dic[@"validTimeEnd"];

    NSInteger boolstate = [ShareUnity compareDate:endtime withDate:[ShareUnity getTheCurrentTime]];
    NSLog(@"boolstate = %ld",boolstate);
    if (boolstate == 1) {
        money = [NSString stringWithFormat:@"%@ 已过期",getamount];

    }else{
    
        money = [NSString stringWithFormat:@"%@ 可用",getamount];

    
    }
    
    NSArray * titlearray =@[cardNumber,time,money,@"49",@"支付订单"];
    
    [cell update:titlearray];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
    [logoImageView setImage:[UIImage imageNamed:@"wodelan"]];
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
    pageIndex =1;

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求数据中..."];
    [[TransDataProxyCenter shareController] giftcardmyGiftCards:@"1" block:^(NSDictionary *dic, NSError *error) {
        NSNumber * code = dic[@"code"];
        NSString * msg = dic[@"msg"];

        NSLog(@"%@",dic);
        if ([code intValue]==200) {
          
            
            pageIndex++;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray* array = dic[@"data"][@"list"];
                [getlistarray removeAllObjects];
                
                if (array.count>0) {
                    
                    
                    for (NSDictionary * dic in array) {
                        [getlistarray addObject:dic];
                    }
                }

                
                
                [SVProgressHUD showWithStatus:msg];
                
                [SVProgressHUD dismissWithDelay:1];
                [mianTableView.mj_header endRefreshing];
                [mianTableView reloadData];

            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showWithStatus:msg];
                
                [SVProgressHUD dismissWithDelay:1];
                [mianTableView.mj_header endRefreshing];

            });
            
            
        }
        

    }];
    

}

-(void)footerRereshing{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求数据中..."];
    [[TransDataProxyCenter shareController] giftcardmyGiftCards:[NSString stringWithFormat:@"%ld",pageIndex] block:^(NSDictionary *dic, NSError *error) {
        NSNumber * code = dic[@"code"];
        NSString * msg = dic[@"msg"];
        if ([code intValue]==200) {
            NSArray* array = dic[@"data"][@"list"];
            if (array.count>0) {
               
                for (NSDictionary * dic in array) {
                    [getlistarray addObject:dic];
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                pageIndex ++;
                
                
                
                [SVProgressHUD showWithStatus:msg];
                
                [SVProgressHUD dismissWithDelay:1];
                [mianTableView.mj_footer endRefreshing];
                [mianTableView reloadData];
                
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showWithStatus:msg];
                
                [SVProgressHUD dismissWithDelay:1];
                [mianTableView.mj_footer endRefreshing];
                
            });
            
            
        }
        
        
    }];



}

@end
