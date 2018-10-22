//
//  PreferentialRecordCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "PreferentialRecordCtr.h"
#import "PreferentialRecordCell.h"
#import "TransDataProxyCenter.h"

@interface PreferentialRecordCtr ()

@end

@implementation PreferentialRecordCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"优惠记录"];
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    getlistarray = [[NSMutableArray alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
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
//    mianTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [mianTableView.mj_header beginRefreshing];
    [self makemianview];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (getlist.count>0) {
        [bgview setHidden:YES];
    }else{
        [bgview setHidden:NO];
    }
    return getlist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    id : id;
//    orderCode : 订单编号;
//    createTime ： "日志时间";
//    amount ： "使用金额";
//    userId ： "用户id";
//    giftCartId = "礼券id";
//    balance = "余额";
//    remark = “备注”;
//    useType :"使用类型";
//    
//    
//    "amount":50.00,
//    "balance":50.00,
//    "createTime":"2016-07-28T19:00:28",
//    "giftCartId":"9c43cf47-feee-4dd8-b9c2-7298363bb3a3",
//    "id":"ee90b9ba-956d-4f1d-a6eb-3149497cf73b",
//    "remark":"激活",
//    "useType":"激活 0892644603",
//    "userId":"ae0c4e77-91be-4aa4-a399-91900edd3179"
//    
    PreferentialRecordCell *cell = [[PreferentialRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
    NSString *orderCode,*createTime,*amount,*balance,*remark;
    NSDictionary* dic = getlist[indexPath.row];
    NSNumber * namount = dic[@"amount"];
    NSNumber * nbalance = dic[@"balance"];

    
    
    orderCode = dic[@"orderCode"];//订单号
    if (!(orderCode.length>0)) {
        orderCode = @"";
    }
    createTime = dic[@"createTime"];//时间
    amount = [NSString stringWithFormat:@"%.2f",[namount floatValue]];
    balance = [NSString stringWithFormat:@"%.2f",[nbalance floatValue]];
    remark = dic[@"remark"];
    if (!(createTime.length>0)) {
        createTime = @"";
    }
    if (!(remark.length>0)) {
        remark = @"";
    }

    

    NSArray * titlearray =@[orderCode,createTime,amount,balance,remark];
    
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
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求数据中..."];
    
    [[TransDataProxyCenter shareController] giftcardmyGiftCardLogsblock:^(NSDictionary *dic, NSError *error) {
        NSNumber * code = dic[@"code"];
        NSString * msg = dic[@"msg"];
        if ([code intValue]==200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                getlist = dic[@"data"];
                [SVProgressHUD showWithStatus:msg];
                
                [SVProgressHUD dismissWithDelay:1];
                
                [mianTableView reloadData];
                [mianTableView.mj_header endRefreshing];
                
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
@end
