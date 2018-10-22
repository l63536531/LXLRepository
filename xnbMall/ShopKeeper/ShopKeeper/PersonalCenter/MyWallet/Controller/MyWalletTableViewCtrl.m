//
//  MyWalletTableViewCtrl.m
//  ShopKeeper
//
//  Created by zhough on 16/5/30.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MyWalletTableViewCtrl.h"
#import "MyWalletCell.h"
#import "MyWalletViewCtrlOne.h"

#import "TransDataProxyCenter.h"
#import "MyWallelistModel.h"
#import "ShareUnity.h"

@interface MyWalletTableViewCtrl ()

@end

@implementation MyWalletTableViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的钱包"];
    [self.view setBackgroundColor:ColorFromRGB(240, 240, 240)];
    
    walletArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
//    mianTableView.scrollEnabled = YES;
//    mianTableView.bounces = NO;
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
    mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getdata)];
    //        _tableview.header = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [mianTableView.mj_header beginRefreshing];
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return walletArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    MyWalletCell * cell = [[MyWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
    
    MyWallelistModel* getmodel = walletArray[indexPath.row];
    [cell update:getmodel];
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
    
    MyWalletViewCtrlOne * walletone = [[MyWalletViewCtrlOne alloc] init];
    
    MyWallelistModel* model = walletArray[indexPath.row];
    walletone.getid = model.idD;
    walletone.title =[ShareUnity getwalletType:model.walletType];
    [self.navigationController pushViewController:walletone animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)getdata{

    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求中..."];

    [[TransDataProxyCenter shareController] querymyaccountsblock:^(NSDictionary *dic, NSError *error) {
        
        NSNumber* code = dic[@"code"];
        NSString* msg = [error localizedDescription];
        [walletArray removeAllObjects];
        if ([code intValue]  == 200) {
            NSLog(@"成功");
            
            NSArray* array = dic[@"data"];
            
            
         
            if (array != nil && [array count] > 0) {
                
                for (NSDictionary* getdic in array) {
                    
                    
                    MyWallelistModel* model = [MyWallelistModel create:getdic];
                    
                    [walletArray addObject:model];
                    

                }
                
                
                NSLog(@"%ld",walletArray.count);
                
                
            }

            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [mianTableView reloadData];
                [SVProgressHUD dismiss];
                
            });
            
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [mianTableView reloadData];
                
                [SVProgressHUD showWithStatus:msg];
 
                [SVProgressHUD dismissWithDelay:1];
                
            });
            
        }
        
        

        
    }];

    [mianTableView.mj_header endRefreshing];


}



@end
