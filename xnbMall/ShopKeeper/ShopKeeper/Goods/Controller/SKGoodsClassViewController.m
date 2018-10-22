//
//  SKGoodsClassViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/2.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKGoodsClassViewController.h"
#import "GoodsClassViewCell.h"
#import "SKSearchViewController.h"
#import "MAGoodsListViewController.h"
#import "CacheUtils.h"

@interface SKGoodsClassViewController ()
@property (nonatomic) NSInteger indexselect;

@property(nonatomic) UIView *mainheadv;
@property(nonatomic) NSArray *toplist;
@property(nonatomic) NSArray *sublist;

//回到首页按钮
@property(nonatomic, strong)UIButton * topBtn;

@end

@implementation SKGoodsClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分类";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //_mainheadv = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,44)];
    _searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,45)];
    _searchbar.placeholder = @"寻找你喜欢的商品";
    _searchbar.delegate = self;
    _searchbar.barTintColor = [UIColor whiteColor];

    [self.view addSubview:_searchbar];
    
    _indexselect = 8;
    self.leftTablew = [[UITableView alloc] initWithFrame:CGRectMake(0,0,0,0) style:UITableViewStylePlain];
    self.leftTablew.delegate = self;
    self.leftTablew.dataSource = self;
    [self.view addSubview:self.leftTablew];
    [self.leftTablew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(45);
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.width.mas_equalTo(@(95));
    }];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.leftTablew setTableFooterView:view];

    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 1.0f;//左右间隔
    //flowLayout.minimumLineSpacing=1.0f;
    self.rightCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:flowLayout];
    
    self.rightCollection.delegate=self;
    self.rightCollection.dataSource=self;
    [self.view addSubview:self.rightCollection];
    

    [self.rightCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(45);
        make.left.equalTo(self.leftTablew.mas_right).offset(-2);
        make.bottom.equalTo(self.view).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-2);
    }];
    
    self.leftTablew.backgroundColor = [UIColor whiteColor];
    self.rightCollection.backgroundColor = HEXCOLOR(0xDEDEDEFF);
    
    // Register cell classes
    [self.rightCollection registerClass:[GoodsClassViewCell class] forCellWithReuseIdentifier:@"rightCollectioncell"];
    [self.rightCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    self.rightCollection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;


    [self.leftTablew registerClass:[UITableViewCell class] forCellReuseIdentifier:@"leftTablewCell"];
    
    //回到顶部
    self.topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topBtn.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-100- 45, 40, 40);
    [self.topBtn setBackgroundImage:[UIImage imageNamed:@"gotop"] forState:UIControlStateNormal];
    [self.topBtn addTarget:self action:@selector(DoSomething) forControlEvents:UIControlEventTouchUpInside];
    self.topBtn.clipsToBounds = YES;
    self.topBtn.alpha = 0.6;
    self.topBtn.hidden = YES;
    [self.view addSubview:self.topBtn];
    
    [self ysttopcategory];

}

#pragma mark - Touch events
- (void)DoSomething {
    //到顶部
    [self.rightCollection setContentOffset:CGPointMake(0.f,0.f) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _toplist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"leftTablewCell"];
    
    cell.textLabel.textColor = RGBGRAY(100.f);
    cell.textLabel.text = _toplist[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    [cell.textLabel sizeToFit];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self ystsubcategory:_toplist[indexPath.row][@"id"]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sublist.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_sublist[section][@"subcate"] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsClassViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightCollectioncell" forIndexPath:indexPath];
    
    [cell.imgView sd_setImageWithURL:_sublist[indexPath.section][@"subcate"][indexPath.row][@"logoImg"] placeholderImage:[UIImage imageNamed:@"commonPlaceHolderIcon"] completed:nil];
    cell.title.textColor = RGBGRAY(100.f);
    cell.title.text = _sublist[indexPath.section][@"subcate"][indexPath.row][@"name"];
    cell.title.font = [UIFont systemFontOfSize:12];

    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake((self.view.frame.size.width - 95-8) /3, (self.view.frame.size.width - 95-8) /3+30);
   // return CGSizeMake(72, 90);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    MAGoodsListViewController* vc = [[MAGoodsListViewController alloc]init];
    vc.categoryId = _sublist[indexPath.section][@"subcate"][indexPath.row][@"id"];
    vc.categoryName = _sublist[indexPath.section][@"subcate"][indexPath.row][@"name"];

    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(375, 40);
}


#pragma  - mark 回到顶部触发

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
    if(aScrollView.tag != 2){
        CGFloat height = self.rightCollection.frame.size.height;
        CGFloat distanceFromButton = self.rightCollection.contentSize.height - self.rightCollection.contentOffset.y;
        
        if(self.rightCollection.contentOffset.y > height){
            [self.topBtn setHidden:NO];
        }
        
        
        if (distanceFromButton < height)
        {
            //NSLog(@"=====滑动到底了");
        }
        
        if (self.rightCollection.contentOffset.y < 100)
        {
          
            [self.topBtn setHidden:YES];
        }
    }else{
       
    }
}


#pragma mark 头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    UILabel* label = (UILabel *)[headerView viewWithTag:1000];
    
    if(!label)
    {
        label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
        label.tag=1000;
    }
    
    label.textColor = RGBGRAY(100.f);
    label.text = _sublist[indexPath.section][@"cate"][@"name"];
    label.font = [UIFont systemFontOfSize:16];
    //headerView.backgroundColor = [UIColor brownColor];
    [headerView addSubview:label];//头部
    return headerView;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"搜索Begin");
    SKSearchViewController* vc = [[SKSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}



-(void)ysttopcategory{
    NSDictionary *postdata = @{};
    NSString *surl = [NSString stringWithFormat:@"%@/goods/topcategory.do",SERVER_ADDR_XNBMALL];

    NSDictionary *cache = [CacheUtils getCacheData:surl withPost:postdata];
    if(cache != nil){
        _toplist = [cache copy];
        [self.leftTablew reloadData];
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
   
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            NSLog(@"ysttopcategory:%@",retdata);
            _toplist = retdata[@"data"];
            [self.leftTablew reloadData];
            [CacheUtils setCacheData:surl withPost:postdata withData:retdata[@"data"]];
            if(_toplist.count > 0){
                NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
                [self.leftTablew selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
                [self ystsubcategory:_toplist[0][@"id"]];
            }
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
}


-(void)ystsubcategory:(NSString*)parentId {
    NSDictionary *postdata = @{@"pid":parentId};
    NSString *surl = [NSString stringWithFormat:@"%@/goods/subcategory.do",SERVER_ADDR_XNBMALL];
     
    NSDictionary *cache = [CacheUtils getCacheData:surl withPost:postdata];
    if(cache != nil){
        _sublist = [cache copy];
        [self.rightCollection reloadData];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSLog(@"ystsubcategory:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            //NSLog(@"retdata:%@",retdata);
            _sublist = retdata[@"data"];
            [self.rightCollection reloadData];
            [CacheUtils setCacheData:surl withPost:postdata withData:retdata[@"data"]];
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
}

@end
