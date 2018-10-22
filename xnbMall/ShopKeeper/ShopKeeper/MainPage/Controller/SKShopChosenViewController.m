/**
 * SKShopChosenViewController.m 16/11/3
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "SKShopChosenViewController.h"

@interface SKShopChosenViewController ()

@end

@implementation SKShopChosenViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"选择新农宝服务站"];
    //初始化数据
    [self initData];
    //创建UI界面
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

/**
 *  @author 黎国基, 16/11/3
 *
 *  初始化数据
 */
- (void)initData {
    
}

/**
 *  @author 黎国基, 16/11/3
 *
 *  创建UI界面
 */
- (void)createUI {
    
    CGFloat cellH = 38.f;
    CGFloat cellW = SCREEN_WIDTH;
    
    JKLabel *cell0Label = [[JKLabel alloc] initWithFrame:CGRectMake(0, 0.f, cellW, cellH)];
    cell0Label.backgroundColor = RGBGRAY(240.f);
    cell0Label.textColor = RGBGRAY(50.f);
    cell0Label.font = FONT_HEL(14.f);
    cell0Label.text = @"   当前选中店铺";
    [self.view addSubview:cell0Label];
    //
    JKLabel *cell1Label = [[JKLabel alloc] initWithFrame:CGRectMake(0, cell0Label.maxY, cellW, cellH)];
    cell1Label.backgroundColor = [UIColor whiteColor];
    cell1Label.textColor = RGBGRAY(50.f);
    cell1Label.font = FONT_HEL(14.f);
    cell1Label.text = [NSString stringWithFormat:@"   %@",_currentShop];
    [self.view addSubview:cell1Label];
    
    JKImageView *selectedIconView = [[JKImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
    selectedIconView.centerY = cell1Label.orgY + cellH / 2.f;
    selectedIconView.orgX = cellW - 20.f - 10.f;
    [selectedIconView setImage:[UIImage imageNamed:@"tick"]];
    [self.view addSubview:selectedIconView];
    
    //
    JKView *cell2 = [[JKView alloc] initWithFrame:cell1Label.bounds];
    cell2.orgY = cell1Label.maxY;
    cell2.backgroundColor = RGBGRAY(240.f);
    [self.view addSubview:cell2];
    
    [self addTableView:UITableViewStylePlain SeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableViews setFrame:CGRectMake(0.f, cell2.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - 64.f - cellH * 3.f)];
}

#pragma mark - Touch events

#pragma mark - Custom tasks

#pragma mark - Http request

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shopArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.font = FONT_HEL(12.f);
        cell.textLabel.textColor = RGBGRAY(100.f);
        
        UIView *sp = [[UIView alloc] initWithFrame:CGRectMake(0.f, 43.f, SCREEN_WIDTH, 1.f)];
        sp.backgroundColor = RGBGRAY(240.f);
        [cell.contentView addSubview:sp];
    }
    
    NSDictionary *shopDic = _shopArray[indexPath.row];
    cell.textLabel.text = shopDic[@"shopName"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shopChosen:)]) {
        NSDictionary *shopDic = _shopArray[indexPath.row];
        [_delegate shopChosen:shopDic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
