//
//  MsgpushViewController.m
//  ShopKeeper
//
//  Created by zhough on 16/8/8.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MsgpushViewController.h"
#import "ShareUnity.h"
#import "TransDataProxyCenter.h"
#import "WebViewController.h"

@interface MsgpushViewController ()

@end

@implementation MsgpushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chacha"] style:UIBarButtonItemStylePlain target:self action:@selector(leftbar)];
    
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT );
    
    
    
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    mianTableView.scrollEnabled = YES;
    mianTableView.bounces = NO;
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mianTableView];
    
    
    
    
    [self getdata];
    
    
}
-(void)leftbar{

    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark -- 添加银行卡

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    
    
    
    
    UIView * line = [[UIView alloc] init];
    [line setBackgroundColor:ColorFromRGB(240, 240, 240)];
    //    [cell.contentView addSubview:line];
    
    
    
    UILabel * titlename = [[UILabel alloc] init];
    
    
    [titlename setFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, getheight+10)];
    [titlename setBackgroundColor:[UIColor clearColor]];
    [titlename setTextColor:ColorFromHex(0x959595)];
    [titlename setTextAlignment:NSTextAlignmentLeft];
    [titlename setFont:[UIFont systemFontOfSize:16]];
    [titlename setNumberOfLines:0];
    [titlename setText:_dicdata[@"summary"]];
    [cell addSubview:titlename];
    
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(SCREEN_WIDTH/4, getheight+30, SCREEN_WIDTH/2, 40)];
    btn.backgroundColor = ColorFromRGB(235, 90, 83);
    
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点此查看详情" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:5];
    [btn setHidden:YES];
    NSString * url =  _dicdata[@"link"];
    if (url.length>0) {
        [btn setHidden:NO];
    }
    
    
    [cell addSubview:btn];
    
    
    UILabel * time = [[UILabel alloc] init];
    
    
    [time setFrame:CGRectMake(10,getheight+ 75, SCREEN_WIDTH-20, 20)];
    [time setBackgroundColor:[UIColor clearColor]];
    [time setTextColor:ColorFromHex(0x959595)];
    [time setTextAlignment:NSTextAlignmentRight];
    [time setFont:[UIFont systemFontOfSize:14]];
    [time setNumberOfLines:0];
    [time setText:_dicdata[@"createTime"]];
    [cell addSubview:time];
    
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
    
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * summary = _dicdata[@"summary"];
    [self setTitle:_dicdata[@"title"]];
    if (summary.length>0) {
        summary = @"";
    }
    
    getheight =[ShareUnity labeltext:summary sizewidth:SCREEN_WIDTH-20 systemfont:16] ;
    return getheight+110;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cell");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(UIView*)makefootview{
    
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [bgview setBackgroundColor:[UIColor whiteColor]];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(SCREEN_WIDTH/4, 10, SCREEN_WIDTH/2, 40)];
    btn.backgroundColor = ColorFromRGB(235, 90, 83);
    
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"激活" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:5];
    [btn setHidden:YES];
    
    
    
    [bgview addSubview:btn];
    
    
    UILabel * titlename = [[UILabel alloc] init];
    
    
    [titlename setFrame:CGRectMake(10, 55, SCREEN_WIDTH-20, 20)];
    [titlename setBackgroundColor:[UIColor clearColor]];
    [titlename setTextColor:[UIColor blackColor]];
    [titlename setTextAlignment:NSTextAlignmentRight];
    [titlename setFont:[UIFont systemFontOfSize:14]];
    [titlename setNumberOfLines:0];
    [titlename setText:_dicdata[@"createTimeFmt"]];
    [bgview addSubview:titlename];
    
    
    
    return bgview;
    
}

-(void)buttonclick:(id)sender{
    
    WebViewController * vc = [[WebViewController alloc] init];
    vc.url = _dicdata[@"link"];
    vc.title = _dicdata[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)getdata{
    
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求数据中..."];
    
    
    
    
    [[TransDataProxyCenter shareController] messageMessageDetail:_getmessgeid block:^(NSDictionary *dic1, NSError *error) {
        
        
        NSNumber * code = dic1[@"code"];
        NSString * msg = dic1[@"msg"];
        if ([code intValue]==200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _dicdata = dic1[@"data"];
                [SVProgressHUD showWithStatus:msg];
                
                [SVProgressHUD dismissWithDelay:1];
                
                [mianTableView reloadData];
                
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showWithStatus:msg];
                
                [SVProgressHUD dismissWithDelay:1];
                
            });
            
            
        }
        
    }];
    
    
    
    
    
}


@end
