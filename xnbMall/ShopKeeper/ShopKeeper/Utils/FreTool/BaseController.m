//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//
#import "BaseController.h"

@interface BaseController () {
    
}

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.indexNumber = 0;
    
    self.view.backgroundColor =[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//添加菊花
- (void)showWaitingView:(UIView *)view {
       self.hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
     //  self.hud.mode = MBProgressHUDModeIndeterminate;
}
//隐藏菊花
- (void)hideWaitingView {
    [self.hud removeFromSuperview];
}
//添加菊花
//- (void)showWaitingView:(UIView *)view Translucent:(BOOL)translucent
//{
//    self.wait = [[WaitingView alloc] init];
//    self.hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
//    self.hud.mode = MBProgressHUDModeCustomView;
//    self.hud.customView =self.wait;
//    self.hud.xOffset =0;
//
//    if (translucent) {
//        self.hud.yOffset=0;
//    }
//    else{
//        self.hud.yOffset =-64;//CGPointMake(40, 40);
//    }
//    self.hud.color = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
//}

//添加刷新头
- (void)addReFreshHeaderWithMethod:(NSString *)method params:(NSString *)params
{
    __weak BaseController *weakSelf = self;

    self.tableViews.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.isDown = YES;
        
        [weakSelf requestDataWithMethod:method patams:params];
    }];
}

//添加刷新尾部
- (void)addReFreshFooterWithMethod:(NSString *)method params:(NSString *)params;

{
    __weak BaseController *weakSelf = self;
    self.tableViews.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        weakSelf.isDown =NO;
        [weakSelf requestDataWithMethod:method patams:params];
    }];
}

//collectionView刷新头
- (void)addCollectionViewReFreshHeaderWithMethod:(NSString *)method params:(NSString *)params
{
    
    __weak BaseController *weakSelf = self;
    
    MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{

        weakSelf.isDown =YES;
        
        [weakSelf requestDataWithMethod:method patams:params];
    }];
    
    self.collectionViews.mj_header = header;
}

//添加collectionView刷新尾部
- (void)addCollectionViewReFreshFootererWithMethod:(NSString *)method params:(NSString *)params{
    
    __weak BaseController *weakSelf = self;
    self.collectionViews.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.isDown =NO;
        
        [weakSelf requestDataWithMethod:method patams:params];
    }];
}

//网络请求的方法。子类实现时，如果有必要，请求成功时，pageIndex++
- (void) requestDataWithMethod:(NSString *)method patams:(NSString *)params {
    
    NSLog(@"开始网络请");
}

//添加tableview
- (void)addTableView:(UITableViewStyle )style SeparatorStyle:(UITableViewCellSeparatorStyle )sepStyle {
    
    self.tableViews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:style];
    self.tableViews.delegate =self;
    self.tableViews.dataSource =self;
    
    self.tableViews.separatorStyle = sepStyle;
    self.tableViews.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableViews];
}

- (void) addCollectionView:(UICollectionViewScrollDirection )layOutScrollDirection {
    
    // CollectionView自定义Layout
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    
    // UICollectionViewScrollDirectionVertical      垂直方向
    // UICollectionViewScrollDirectionHorizontal    水平方向
    layOut.scrollDirection = layOutScrollDirection;
    
    // CollectionView是用Layout来控制内容的布局的
    self.collectionViews = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layOut];
    self.collectionViews.dataSource = self;
    self.collectionViews.delegate = self;
    
    [self.view addSubview:self.collectionViews];
}

//添加滑动视图
- (void)addScrollView {
    self.scrollViews = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollViews.delegate = self;
    
    [self.view addSubview:self.scrollViews];
}

//设置标题
- (void)setCurrentTitle:(NSString *)title {
    UILabel *lbTitle =[[UILabel alloc] init];
    [lbTitle setFrame:CGRectMake(60, 20, SCREEN_WIDTH - 120, 44) ];
    lbTitle.text = title;
    lbTitle.textColor = [UIColor whiteColor];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    [lbTitle setBackgroundColor: [UIColor clearColor]];
    [lbTitle setFont:[UIFont systemFontOfSize:18]];
    
    self.navigationItem.titleView =lbTitle;
}

- (void) addNavImageViewWithBackGroundColor:(UIColor *)backGroundColor;{
    
    self.navImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.navImageView.userInteractionEnabled=YES;
    self.navImageView.backgroundColor = backGroundColor;
    [self.view addSubview:self.navImageView];
}

- (void)WhenPresentsetCurrentTitle:(NSString *)title {
    
    UILabel *lbTitle =[[UILabel alloc] init];
    [lbTitle setFrame:CGRectMake(60, 20, SCREEN_WIDTH - 120, 44) ];
    lbTitle.text = title;
    lbTitle.textColor = [UIColor whiteColor];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    [lbTitle setBackgroundColor: [UIColor clearColor]];
    [lbTitle setFont:[UIFont systemFontOfSize:18]];
    
    [self.navImageView addSubview:lbTitle];
}

//设置左侧按钮的点击事件
- (void)leftNavBtnCallBack {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (AppDelegate *)appDelegate; {
    
    UIApplication *app  =[UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)[app delegate];
    return delegate;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)dealloc {
    
}

@end
