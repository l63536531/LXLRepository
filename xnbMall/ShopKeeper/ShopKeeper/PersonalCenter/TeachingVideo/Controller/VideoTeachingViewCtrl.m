//
//  VideoTeachingViewCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "VideoTeachingViewCtrl.h"
#import "VideoTeachingCell.h"

#import "AppDelegate.h"

#import "TransDataProxyCenter.h"
#import "MAWebViewController.h"

@interface VideoTeachingViewCtrl ()

@end

@implementation VideoTeachingViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"视频教学"];
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
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
    [self getdata];

    [self makefootview];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return getVideolist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;

}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    VideoTeachingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[VideoTeachingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }

    NSDictionary * dic = getVideolist[indexPath.row];
    [cell update:getimageUrl title:dic[@"title"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
            return nil;

}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"获取url");
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
    NSDictionary * dic = getVideolist[indexPath.row];
//    NSString * urlstring = dic[@"vurl"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstring]];
    
    MAWebViewController *vc = [[MAWebViewController alloc] init];
    vc.urlStr = dic[@"vurl"];
    vc.titleStr = dic[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)makefootview{

    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [bgview setBackgroundColor:[UIColor clearColor]];
    mianTableView.tableFooterView = bgview;
    
    
    UILabel * lab = [[UILabel alloc] init];
    [lab setFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 40)];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setFont:[UIFont systemFontOfSize:12]];
    [lab setText:@"温馨提示：您也可以在浏览器输入新农宝网址y.51xnb.cn进入个人中心观看视频。"];
    [lab setTextColor:ColorFromHex(0x646464)];
    [lab setAdjustsFontSizeToFitWidth:YES];
    [lab setNumberOfLines:0];
    [bgview addSubview:lab];



}

-(void)getdata{
    
    
//    {
//        "pwd": "xyds666",
//        "module": "服务中心学习视频",
//        "videls": [
//                   {
//                       "title": "服务中心钱包",
//                       "vurl": "http://v.youku.com/v_show/id_XMTQ1NzAyNDAyOA==.html?from=y1.7-2"
//                   }
//                   ]
//    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求中..."];
    
    [[TransDataProxyCenter shareController] queryLearnVideoblock:^(NSDictionary *dic, NSError *error) {
        
        NSNumber* code = dic[@"code"];
        NSString * geterror = [error localizedDescription];
        NSLog(@"视频教学：%@",dic);
        
        if (dic) {
            NSString * msg = dic[@"msg"];
            if ([code intValue] == 200 ) {
                
                getVideolist = dic[@"data"];
                getimageUrl = dic[@"defImg"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    [mianTableView reloadData];

                });
                
                
            }else{
                
                [SVProgressHUD showWithStatus:msg];
                
                [SVProgressHUD dismissWithDelay:1];
                
            }
            
            
            
            
        }else{
            
            
            [SVProgressHUD showWithStatus:geterror];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
        
        
        
    }];
    
    [mianTableView.mj_header endRefreshing];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
