//
//  SearchViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/15.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SearchViewCtr.h"
#import "SearchResultsCtr.h"

@interface SearchViewCtr ()

@property(nonatomic , strong)UISearchBar * bar;

@end

@implementation SearchViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self makeSearch];
}

-(void)makeSearch{
    
    _bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_bar setPlaceholder:@"请输入商品名称/订单号"];
    [_bar setBackgroundColor:[UIColor clearColor]];
    _bar.delegate = self;
    _bar.tintColor=[UIColor grayColor];
    _bar.returnKeyType =  UIReturnKeyGo;
    
    self.navigationItem.titleView = _bar;
    
    UIImage* image = [UIImage imageNamed:@""];
    UIImageView * iamgeview=[[UIImageView alloc] initWithImage:image];
    [iamgeview setFrame:CGRectMake(40, 50, 20, 20)];
    [self.view addSubview:iamgeview];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbutton)];
    [_bar becomeFirstResponder];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_bar becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_bar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    SearchResultsCtr *vc = [[SearchResultsCtr alloc] init];
    vc.searchKeyWord = _bar.text;
    vc.state =_state;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightBarbutton{

    SearchResultsCtr *vc = [[SearchResultsCtr alloc] init];
    vc.searchKeyWord = _bar.text;
    vc.state =_state;

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
