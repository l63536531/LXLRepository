//
//  SKUserAddressViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/8/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKUserAddressViewController.h"
#import "ChangeAddressViewCtr.h"

@interface SKUserAddressViewController ()
@property (nonatomic) NSArray *data;

@end

@implementation SKUserAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择收获地址";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    __weak UITableView *tableView = self.tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //[self.tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                           [self myaddress];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               //[tableView reloadData];
                               [tableView.mj_header endRefreshing];
                           });
                           
                       });
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbutton11:)];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self myaddress];

}
-(void)rightBarbutton11:(id)sender{
    ChangeAddressViewCtr * changevc = [[ChangeAddressViewCtr alloc] init];
    changevc.title = @"添加收货地址";
    [self.navigationController pushViewController:changevc animated:YES];
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    NSString *ID = [NSString stringWithFormat:@"MyAddressCell_%ld_%ld",indexPath.section,indexPath.row];
    //static NSString *ID = @"mainviewcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    NSDictionary *dic = _data[indexPath.row];
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5, SCREEN_WIDTH-100, 25)];
    userLabel.text = [NSString stringWithFormat:@"%@  %@",dic[@"contactName"],dic[@"contactPhone"]];
    userLabel.font = [UIFont systemFontOfSize:14];
    userLabel.textColor = KFontColor(@"#646464");
    [cell.contentView addSubview:userLabel];
    
    UIButton *editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.frame = CGRectMake(SCREEN_WIDTH-90,5, 25, 25);
    [editbtn setImage:[UIImage imageNamed:@"fankui"] forState:UIControlStateNormal];
    [cell.contentView addSubview:editbtn];
    
    [editbtn bk_addEventHandler:^(id sender) {
        ChangeAddressViewCtr * changevc = [[ChangeAddressViewCtr alloc] init];
        changevc.getAreaDic = dic;
        [self.navigationController pushViewController:changevc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *bbLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55,5, 1, 25)];
    bbLabel.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:bbLabel];
    
    
    UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletebtn.frame = CGRectMake(SCREEN_WIDTH-45,5, 25, 25);
    [deletebtn setImage:[UIImage imageNamed:@"notick"] forState:UIControlStateNormal];
    [cell.contentView addSubview:deletebtn];
    [deletebtn bk_addEventHandler:^(id sender) {
        [self deleteaddress:dic[@"id"]];
    } forControlEvents:UIControlEventTouchUpInside];

    
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@_%@"
                         ,dic[@"street"][@"province"][@"name"]
                         ,dic[@"street"][@"city"][@"name"]
                         ,dic[@"street"][@"county"][@"name"]
                         ,dic[@"street"][@"street"][@"name"]
                         ,dic[@"address"]];
    UILabel *addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,31, SCREEN_WIDTH-100, 25)];
    addrLabel.text = address;
    addrLabel.font = [UIFont systemFontOfSize:12];
    addrLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:addrLabel];

    NSInteger isDefault = [dic[@"isDefault"] integerValue];
    if(isDefault == 1){
        UILabel *defauleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90,31, 60, 25)];
        defauleLabel.text = @"默认";
        defauleLabel.font = [UIFont systemFontOfSize:14];
        defauleLabel.textColor = KFontColor(@"#ec584c");
        [cell.contentView addSubview:defauleLabel];
    }

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [_delegate changeAddress:_data[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)myaddress{

    NSString *surl = [NSString stringWithFormat:@"%@/user/myaddress.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"myaddress:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _data = retdata[@"addrs"];
            [self.tableView reloadData];
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}


-(void)deleteaddress:(NSString*)indexId{
    
    NSDictionary *postdata = @{@"rid":indexId};
    
    NSString *surl = [NSString stringWithFormat:@"%@/user/deleteaddress.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"deleteaddress:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            [self myaddress];
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}



@end
