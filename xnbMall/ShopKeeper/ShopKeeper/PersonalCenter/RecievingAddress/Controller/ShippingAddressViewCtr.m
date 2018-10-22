//
//  ShippingAddressViewCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/1.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ShippingAddressViewCtr.h"
#import "ShippingAddressCell.h"
#import "ShipingAdderssModel.h"

#import "ChangeAddressViewCtr.h"
#import "TransDataProxyCenter.h"
#import "MJRefresh.h"



@interface ShippingAddressViewCtr ()<UITableViewDelegate,UITableViewDataSource,ShippingAddressCellDelegate>{
    
    UITableView * mianTableView;
    NSMutableArray * addresslist;
 
    NSMutableArray * getstartList;//获取原始数据
 
}

@property(nonatomic, strong)UIView *bgview;

@end

static NSString *const shippingAddressCellIdentifier = @"ShippingAddressCell";
@implementation ShippingAddressViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"收货地址"];
    addresslist  =  [[NSMutableArray alloc]init];
    getstartList  =  [[NSMutableArray alloc]init];
    
    [self.view setBackgroundColor:KFontColor(@"#e5e5e5")];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"　"
                                                                             style:(UIBarButtonItemStylePlain)
                                                                            target:nil
                                                                            action:nil];
    [self setUpTableView];
    
    //无数据视图
    [self makemianview];
    
    mianTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshingRemoveRow:-1];
    }];
    [mianTableView.mj_header setAutomaticallyChangeAlpha:YES];
    //无数据视图
    [self makemianview];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbutton)];
}


- (void)setUpTableView {
    CGRect rect = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    
    mianTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    mianTableView.delegate = (id<UITableViewDelegate>)self;
    mianTableView.dataSource = (id<UITableViewDataSource>)self;
    [mianTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mianTableView.allowsSelection = YES;
    mianTableView.showsVerticalScrollIndicator = NO;
    [mianTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mianTableView];
    
    //注册cell
    [mianTableView registerClass:[ShippingAddressCell class] forCellReuseIdentifier:shippingAddressCellIdentifier];
    
    
    
}


-(void)makemianview{
    
    
    self.bgview = [[UIView alloc] init];
    [self.bgview setBackgroundColor:[UIColor clearColor]];
    [self.bgview setFrame:CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    [self.bgview setHidden:YES];
    [self.view addSubview:self.bgview];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame= CGRectMake(SCREEN_WIDTH/3, 0,SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    [logoImageView setContentMode:UIViewContentModeScaleAspectFill];
    [logoImageView setClipsToBounds:YES];
    [logoImageView setImage:[UIImage imageNamed:@"quan5"]];
    [logoImageView.layer setCornerRadius:SCREEN_WIDTH/6];
    
    [self.bgview addSubview:logoImageView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, SCREEN_WIDTH/3+10, SCREEN_WIDTH , 30);
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setText:@"暂无收货地址"];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.bgview addSubview:titleLabel];
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [self headerRereshingRemoveRow:-1];

}

#pragma mark -- 添加银行卡
-(void)rightBarbutton{
    ChangeAddressViewCtr * changevc = [[ChangeAddressViewCtr alloc] init];
    changevc.title = @"添加收货地址";
    [self.navigationController pushViewController:changevc animated:YES];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (addresslist.count > 0) {
        self.bgview.hidden = YES;
    }else {
        
        self.bgview.hidden = NO;
        
    }
    return addresslist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShippingAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:shippingAddressCellIdentifier];
    ShipingAdderssModel * model = addresslist[indexPath.row];
    
    [cell update:model];
    cell.isdefault = indexPath.row;
    cell.index = indexPath.row;
    cell.delegate = self;
    
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ShipingAdderssModel * model = addresslist[indexPath.row];
    NSDictionary *postdata = @{@"rid":model.idD};
    
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"user/setdefaultaddress.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        
        if(fail_success){ //网络成功
            
            
            if ([dicStr[@"code"] intValue] == 200) {
                [MBProgressHUD showSuccess:@"设置成功" ToView:self.view];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self headerRereshingRemoveRow:-1];
                });
                
            }else  {
                
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
            }
            
        }else{
            
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view];
        }
    }];
   
}

#pragma  - mark ShippingAddressCellDelegate

-(void)clickButton:(NSInteger)tag index:(NSInteger)index{
    
    if (tag == 101) {//编辑
        ChangeAddressViewCtr * changevc = [[ChangeAddressViewCtr alloc] init];
        changevc.borneTitle = @"编辑收货地址";
        
        changevc.getAreaDic = getstartList[index];
        [self.navigationController pushViewController:changevc animated:YES];
        
    }else if (tag == 102){//删除
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil                                                                            message:@"确认删除"  preferredStyle:UIAlertControllerStyleAlert];
        //添加Button
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            ShipingAdderssModel * model = addresslist[index];
            NSDictionary *postdata = @{@"rid":model.idD};
            
            
            [[NetWorkManager shareManager]netWWorkWithReqUrl:@"user/deleteaddress.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
                if(fail_success){ //网络成功
                    
                    if ([dicStr[@"code"] intValue] == 200) {
                        
                        [MBProgressHUD showSuccess:@"删除成功" ToView:self.view];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self headerRereshingRemoveRow:index];
                        });
                        
                    }else  {
                        
                        [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
                    }
                    
                }else{
                    
                    [MBProgressHUD showError:@"网络加载失败!" ToView:self.view];
                }
            }];
            
        }]];
        [self presentViewController: alertController animated: YES completion: nil];
        
    }
    
}






#pragma mark - Http request
//查询当前用户的收获地址清单 user/myaddress.do
/**
 *  @author chenxinju
 *
 *  如果row >= 0,移除该行
 *
 *  @param row
 */
-(void)headerRereshingRemoveRow:(NSInteger)row{
    
    if (row >= 0) {
        
        [addresslist removeObjectAtIndex:row];
        [getstartList removeObjectAtIndex:row];
        
        [mianTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    NSDictionary *postdata = @{};
    
    [MBProgressHUD showMessage:@"加载中..." ToView:self.view];
    [[NetWorkManager shareManager]netWWorkWithReqUrl:@"user/myaddress.do" ReqParam:postdata BoolForTooken:YES PresentLogionController:self CallBack:^(NetResult result, NSDictionary *dicStr, BOOL fail_success) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [mianTableView.mj_header endRefreshing];
        
        NSLog(@"收货地址%@",dicStr);
        if(fail_success){ //网络成功
            
            if ([dicStr[@"code"] intValue] == 200) {
                
                [addresslist removeAllObjects];
                [getstartList removeAllObjects];
                
                NSArray* array = dicStr[@"addrs"];
                
                if (array != nil && [array count] > 0) {
                    
                    [getstartList addObjectsFromArray:dicStr[@"addrs"]];
                    
                    for (NSDictionary* getdic in array) {
                        
                        ShipingAdderssModel* model = [ShipingAdderssModel create:getdic];
                        [addresslist addObject:model];
                    }
                }
                
                [mianTableView reloadData];
                
            }else {
                
                [MBProgressHUD showWarn:dicStr[@"msg"] ToView:self.view];
                [mianTableView.mj_header endRefreshing];
            }
            
        }else{
            [MBProgressHUD showError:@"网络加载失败!" ToView:self.view];
            [mianTableView.mj_header endRefreshing];
        }
    }];
    
}




@end
