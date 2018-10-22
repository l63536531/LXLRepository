//
//  NewShelvesCtr.m
//  ShopKeeper
//
//  Created by zhough on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "NewShelvesCtr.h"
#import "NewShelvesCell.h"
#import "TransDataProxyCenter.h"
#import "NewShelvesModel.h"
#import "MAGoodsDetailsViewController.h"


@interface NewShelvesCtr ()

@property (nonatomic ,strong) UIButton * btn;

@end

@implementation NewShelvesCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    [self setTitle:@"最新上架"];
    [self.view addSubview:self.collectionView];
    
//       NSArray *imgArray = [NSArray arrayWithObjects:@"china",@"cat.png",@"china",@"cat.png",@"china",@"cat.png", nil];

    _cellArray = [[NSMutableArray alloc] init];
    [self makemianview];
    
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setImage:[UIImage imageNamed:@"店小二"] forState:UIControlStateNormal];
    _btn.layer.cornerRadius = 25.0;
    _btn.imageView.layer.cornerRadius = 25.0;
    _btn.layer.borderWidth = 0;
    _btn.alpha = 0.6;
    _btn.frame = CGRectMake(self.view.frame.size.width - 70, self.view.frame.size.height /3*2, 50, 50);
    
    [_btn addTarget:self action:@selector(totopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
//    [_btn setHidden:YES];

    
    
}

-(void)totopButton{
    [_collectionView setContentOffset:CGPointMake(0, 0) animated:YES];

}

#pragma mark - 创建collectionView并设置代理
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //        flowLayout.headerReferenceSize = CGSizeMake(fDeviceWidth, AD_height+10);//头部大小
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 4)/2, (SCREEN_WIDTH - 4)/2+90);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 2;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 0;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);//上左下右
        
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[NewShelvesCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //背景颜色
        _collectionView.backgroundColor = ColorFromRGB(230, 230, 230);
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getdata)];
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        //        _tableview.header = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [_collectionView.mj_header beginRefreshing];
    }
    return _collectionView;
}



#pragma mark - UICollectionView delegate dataSource
#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_cellArray.count>0) {
        [bgview setHidden:YES];
    }else{
        
        [bgview setHidden:NO];
    }

    return [_cellArray count];
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    NewShelvesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    NewShelvesModel* model = _cellArray[indexPath.item];
    
    cell.imgViewtap.image = [UIImage imageNamed:@"限时特惠"];
    
    NSURL * url = [NSURL URLWithString:model.thumbnailUrl];
    [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"guidancePageImage2"]];
    cell.text.text = model.title;
    cell.text1.text = model.subTitle;
    cell.text2.text = [NSString stringWithFormat:@"进货价¥%.2f",[model.costPrice floatValue]];
    cell.text3.text =[NSString stringWithFormat:@"建议售价¥%.2f",[model.retailPrice floatValue]];
    cell.text4.text = [NSString stringWithFormat:@"已售：%@",model.saleNumber];

    //按钮事件就不实现了……
    return cell;
}

#pragma mark 头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    
    //    [headerView addSubview:_headerView];//头部广告栏
    return headerView;
}

#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择%ld",indexPath.item);
    
    NewShelvesModel* model = _cellArray[indexPath.item];

    MAGoodsDetailsViewController* vc = [[MAGoodsDetailsViewController alloc]init];
    vc.goodsSpecId = model.goodsSpecificationId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
        CGFloat height = _collectionView.frame.size.height;
        CGFloat distanceFromButton = _collectionView.contentSize.height - _collectionView.contentOffset.y;
        
        if(_collectionView.contentOffset.y > height){
            NSLog(@"===== %lf %lf",distanceFromButton , height);
            
            [_btn setHidden:NO];

        }
    
        
        if (distanceFromButton < height)
        {
        }
        
        if (_collectionView.contentOffset.y < 100)
        {
            [_btn setHidden:YES];
        }
}

-(void)getdata{
    
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求数据中..."];
    
    [[TransDataProxyCenter shareController] queryYstnewarrival:@"1" pageSize:@"10" block:^(NSDictionary *dic, NSError *error) {
        NSNumber* code = dic[@"code"];
        
        NSLog(@"最新上架 = %@",dic);
        NSString* msg = [error localizedDescription];
        if (dic) {
            
            
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_cellArray removeAllObjects];
                    page++;

                    NSArray* array =dic[@"data"][@"list"];
                    if (array != nil && [array count] > 0) {
                        for (NSDictionary* getdic in array) {
                            
                            
                            NewShelvesModel* model = [NewShelvesModel create:getdic];
                            
                            [_cellArray addObject:model];
                            
                            
                        }
                        
                        
                        NSLog(@"%ld",_cellArray.count);
                        
                        
                    }
                    
                    
                    
                    [_collectionView reloadData];
                    [SVProgressHUD dismiss];
                    
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    
                });
                
            }
            
            
        }else{
            
            [SVProgressHUD showWithStatus:@"请检查网络"];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
        

    }];
    
     [_collectionView.mj_header endRefreshing];
    
    
    
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
    [logoImageView setImage:[UIImage imageNamed:@"quan5"]];
    [logoImageView.layer setCornerRadius:SCREEN_WIDTH/6];
    [bgview addSubview:logoImageView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, SCREEN_WIDTH/3+10, SCREEN_WIDTH , 30);
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setText:@"暂时没有最新上架相关产品"];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [bgview addSubview:titleLabel];
    
}
-(void)footerRereshing{

    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请求数据中..."];
    
    [[TransDataProxyCenter shareController] queryYstnewarrival:[NSString stringWithFormat:@"%ld",page] pageSize:@"10" block:^(NSDictionary *dic, NSError *error) {
        NSNumber* code = dic[@"code"];
        
        NSLog(@"最新上架 = %@",dic);
        NSString* msg = [error localizedDescription];
        if (dic) {
            
            
            if ([code intValue]  == 200) {
                NSLog(@"成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    NSArray* array =dic[@"data"][@"list"];
                    if (array != nil && [array count] > 0) {
                        
                        for (NSDictionary* getdic in array) {
                            
                            
                            NewShelvesModel* model = [NewShelvesModel create:getdic];
                            
                            [_cellArray addObject:model];
                            
                            
                        }
                        
                        
                        NSLog(@"%ld",_cellArray.count);
                        
                        
                    }
                    
                    
                    
                    [_collectionView reloadData];
                    [SVProgressHUD dismiss];
                    
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
                    
                    [SVProgressHUD showWithStatus:msg];
                    
                    [SVProgressHUD dismissWithDelay:1];
                    
                });
                
            }
            
            
        }else{
            
            [SVProgressHUD showWithStatus:@"请检查网络"];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
        
        
    }];
    
    [_collectionView.mj_footer endRefreshing];
    

}

@end
