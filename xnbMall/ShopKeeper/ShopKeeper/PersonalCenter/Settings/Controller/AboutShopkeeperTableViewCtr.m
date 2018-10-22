//
//  AboutShopkeeperTableViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/5/29.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "AboutShopkeeperTableViewCtr.h"
#import "WebViewController.h"
@interface AboutShopkeeperTableViewCtr ()<UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *_tableView;
}

@end

@implementation AboutShopkeeperTableViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *versioinStr = [JKTool appVersion];
    titlearray = @[@"功能介绍",@"使用条款和隐私政策",[NSString stringWithFormat:@"当前版本：V%@",versioinStr]];
    
    _tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.f)];
    [self.view addSubview:_tableView];

    _tableView.scrollEnabled = YES;
    _tableView.bounces = NO;
    _tableView.delegate = (id<UITableViewDelegate>)self;
    _tableView.dataSource = (id<UITableViewDataSource>)self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.allowsSelection = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
    [self makefootview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setTitle:@"关于新农宝商城"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setTitle:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlearray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"CellIdentifier2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = ColorFromHex(0x646464);
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = [titlearray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 2) {
        //版本
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    使用条款：http://testm.51xnb.cn/api/about/clause.html
//    使用帮助：http://testm.51xnb.cn/api/about/helpcenter.html
//    使用条款：http://testm.51xnb.cn/mall/about/clause.html
//    使用帮助：http://testm.51xnb.cn/mall/about/helpcenter.htm
    
    NSString * url  = nil;
    
    if (indexPath.row == 0) {
        url =[NSString stringWithFormat:@"%@/about/clause.html",SERVER_ADDR_XNBMALL]; //@"http://testm.51xnb.cn/api/about/clause.html";
    }else if (indexPath.row == 1){
    
       url =[NSString stringWithFormat:@"%@/about/helpcenter.html",SERVER_ADDR_XNBMALL]; // @"http://testm.51xnb.cn/api/about/helpcenter.html";
    }
    
    if (url.length>0) {
        WebViewController * vc = [[WebViewController alloc] init];
        vc.url = url;
        vc.titleString =titlearray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)makefootview{

    UIView * bgview= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [bgview setBackgroundColor:[UIColor clearColor]];
    _tableView.tableFooterView = bgview;
    
    
    UILabel * lab = [[UILabel alloc] init];
    
    lab.frame = CGRectMake(20, 10, SCREEN_WIDTH - 40,30);
    [lab setFont:[UIFont systemFontOfSize:14]];
    [lab setText:@"深圳市新农宝科技有限公司 版权所有"];
    [lab setTextColor:ColorFromHex(0x646464)];
    [lab setTextAlignment:NSTextAlignmentCenter];
    lab.adjustsFontSizeToFitWidth = YES;

    [bgview addSubview:lab];


    UILabel * lab_1 = [[UILabel alloc] init];
    
    lab_1.frame = CGRectMake(20, 40, SCREEN_WIDTH - 40,30);
    [lab_1 setFont:[UIFont systemFontOfSize:12]];
    [lab_1 setText:@"Copyright@ www.51xnb.cn\nAll Rights Reserved"];
    [lab_1 setTextColor:ColorFromHex(0x646464)];
    [lab_1 setTextAlignment:NSTextAlignmentCenter];
    lab_1.adjustsFontSizeToFitWidth = YES;
    [lab_1 setNumberOfLines:0];
    [bgview addSubview:lab_1];
}

@end
