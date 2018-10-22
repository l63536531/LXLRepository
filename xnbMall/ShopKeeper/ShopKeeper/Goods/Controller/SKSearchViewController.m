//
//  SKSearchViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKSearchViewController.h"
#import "MAGoodsListViewController.h"

@interface SKSearchViewController ()<UITextFieldDelegate> {

    JKTextField *_searchField;
}

@property(nonatomic) NSArray *hisdata;

@end

@implementation SKSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [tableView reloadData];
                               [tableView.mj_header endRefreshing];
                           });
                           
                       });
    }];
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
    //跳转到搜索控制器
    
    _searchField = [[JKTextField alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH - 80.f, 30.f)];
    _searchField.backgroundColor = RGBGRAY(255.f);
    _searchField.font = FONT_HEL(14.f);
    _searchField.textColor = RGBGRAY(100.f);
    _searchField.placeholder = @"寻找你喜欢的商品";
    _searchField.delegate = self;
    _searchField.layer.cornerRadius = 4.f;
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.tintColor = RGBGRAY(200.f);
    
    JKView *leftView = [[JKView alloc] initWithFrame:CGRectMake(0.f, 0.f, 8.f, 30.f)];
    _searchField.leftView = leftView;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    
    self.navigationItem.titleView = _searchField;
    
    //查找搜索记录
    [self searchhistory];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_searchField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_searchField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (textField.text != nil && textField.text.length > 0) {
        MAGoodsListViewController* vc = [[MAGoodsListViewController alloc]init];//这里需要直接active textfield
        vc.categoryId = @"";
        vc.categoryName = @"";
        vc.keywords = _searchField.text;
        vc.brandId = @"";
        vc.avtiveSearchField = NO;
        
        [self.navigationController pushViewController:vc animated:YES];
    }

    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return _hisdata.count;
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) return 44;
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0 ){
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, 44)];
        customView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.0, SCREEN_WIDTH/2 - 10, 44)];
        if(_hisdata.count>0){
            label_1.text = @"搜索历史记录";
        }else{
            label_1.text = @"暂无历史搜索记录";
        }
        label_1.textColor  = [UIColor lightGrayColor];
        label_1.font = [UIFont systemFontOfSize:14];
        [customView addSubview:label_1];
        
        return customView;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"SkSerrchCell_%ld_%ld",indexPath.section,indexPath.row];
    //static NSString *ID = @"mainviewcell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if(indexPath.section == 0){
        UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(34, 0.0, SCREEN_WIDTH - 120, 44)];
        label_1.text = _hisdata[indexPath.row][@"searchKey"];
        label_1.textColor = [UIColor grayColor];
        [cell.contentView addSubview:label_1];
        
        UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_1.frame =CGRectMake(SCREEN_WIDTH - 74, 0.0, 70, 44);
        [btn_1 setImage:[UIImage imageNamed:@"zhoushangjiao"] forState:UIControlStateNormal];
        
        [btn_1 bk_addEventHandler:^(id sender) {
            MAGoodsListViewController* vc = [[MAGoodsListViewController alloc]init];
            vc.categoryId = @"";
            vc.categoryName = @"";
            vc.keywords = _hisdata[indexPath.row][@"searchKey"];;
            vc.brandId = @"";
            [self.navigationController pushViewController:vc animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:btn_1];
        
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(_hisdata.count>0){
            UIButton *btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_2.frame =CGRectMake(SCREEN_WIDTH/2-75, 3, 150, 38);
            [btn_2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn_2 setTitle:@"清空历史记录" forState:UIControlStateNormal];
            btn_2.layer.cornerRadius = 5.0;
            btn_2.imageView.layer.cornerRadius = 5.0;
            btn_2.layer.borderWidth = 0.2;
            btn_2.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [btn_2 bk_addEventHandler:^(id sender) {
                [self clearsearchhistory];
            } forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn_2];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_searchField resignFirstResponder];
    
    if(indexPath.section == 0){
        MAGoodsListViewController* vc = [[MAGoodsListViewController alloc]init];
        vc.categoryId = @"";
        vc.categoryName = @"";
        vc.keywords = _hisdata[indexPath.row][@"searchKey"];;
        vc.brandId = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_searchField resignFirstResponder];
}


//查询历史搜索记录
-(void)searchhistory{
    NSString *surl = [NSString stringWithFormat:@"%@/goods/searchhistory.do",SERVER_ADDR_XNBMALL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    
    [manager POST:surl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSLog(@"searchhistory:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _hisdata = retdata[@"data"];
            [self.tableView reloadData];
        }else{
            //[MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


//清除历史搜索记录
-(void)clearsearchhistory{
    NSString *surl = [NSString stringWithFormat:@"%@/goods/clearsearchhistory.do",SERVER_ADDR_XNBMALL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    
    [manager POST:surl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _hisdata = @[];
            [self.tableView reloadData];
        }else{
            //[MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

@end
