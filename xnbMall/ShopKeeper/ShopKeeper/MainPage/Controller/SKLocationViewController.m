//
//  SKLocationViewController.m
//  ShopKeeper
//
//  Created by zzheron on 16/6/3.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "SKLocationViewController.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "NSString+Utils.h"

@interface SKLocationViewController () {
    
    //    MBProgressHUD *_hud;
    
    NSArray *_tempAddrArray;        //省、市、区、街道
    NSArray *_proviceArray;         //省份只需要获取一次，缓存优化性能；市、区、街道每次点击一行重新请求
    
    NSString *_tempProIdStr;
    NSString *_tempCityIdStr;
    NSString *_tempCountyIdStr;
    NSString *_tempStreetIdStr;
    
    NSString *_proIdStr;
    NSString *_cityIdStr;
    NSString *_countyIdStr;
    NSString *_streetIdStr;
    ////////////////////////////////////////////////
    NSString *_tempProName;
    NSString *_tempCityName;
    NSString *_tempCountyName;
    NSString *_tempStreetName;
    
    NSString *_proName;
    NSString *_cityName;
    NSString *_countyName;
    NSString *_streetName;
}

@property (nonatomic) UITableView *tableView;

@property (nonatomic) UIView *headerview;
@property (nonatomic) UIView *footerview;

@property (nonatomic) UIButton *locationbtn;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLGeocoder *geocoder;

@end

@implementation SKLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //    不要在此初始化，会覆盖 传进来的值shopInitAddressDic
    //    _tempProIdStr = @"";
    //    _tempCityIdStr = @"";
    //    _tempCountyIdStr = @"";
    //    _tempStreetIdStr = @"";
    //
    //    _proIdStr = @"";
    //    _cityIdStr = @"";
    //    _countyIdStr = @"";
    //    _streetIdStr = @"";
    //    ////////////////////////////////////////////////
    //    _tempProName = @"";
    //    _tempCityName = @"";
    //    _tempCountyName = @"";
    //    _tempStreetName = @"";
    //
    //    _proName = @"";
    //    _cityName = @"";
    //    _countyName = @"";
    //    _streetName = @"";
    
    ////////////////////////////////////////////////
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    WS(ws);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    [self makeFooterView];
    [self makeHeaderView];
    
    self.tableView.tableHeaderView = _headerview;
    self.tableView.tableFooterView = _footerview;
    
    
    _locationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=10;
    
    if (IOS8_OR_LATER) {
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
    }
    
    if (_shopInitAddressDic == nil) {//_jack,add if 2016.11.28
        [self getprovince:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) makeHeaderView{
    _headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"选择地区或自动定位";
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = NSTextAlignmentCenter;
    [_headerview addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_headerview);
        make.size.mas_equalTo(CGSizeMake(300, 30));
    }];
    
}

-(void) makeFooterView{
    _footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 66)];
    
    _locationbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationbtn setTitle:@"自动定位" forState:UIControlStateNormal];
    [_locationbtn setTitle:@"定位中" forState:UIControlStateSelected];
    _locationbtn.backgroundColor = HEXCOLOR(0xEE2C2Cff);
    
    UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _locationbtn.layer.cornerRadius = 3;
    btn_1.layer.cornerRadius = 3;
    btn_2.layer.cornerRadius = 3;
    
    [_footerview addSubview:_locationbtn];
    [_footerview addSubview:btn_1];
    [_footerview addSubview:btn_2];
    
    [btn_1 setTitle:@"确定" forState:UIControlStateNormal];
    btn_1.backgroundColor = HEXCOLOR(0xEE2C2Cff);
    
    [btn_2 setTitle:@"取消" forState:UIControlStateNormal];
    btn_2.backgroundColor = [UIColor lightGrayColor];
    
    [btn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_footerview);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [_locationbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_footerview.mas_centerY);
        make.right.equalTo(btn_1.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [btn_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_footerview.mas_centerY);
        make.left.equalTo(btn_1.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [btn_1 addTarget:self action:@selector(OKBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_2 addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_locationbtn addTarget:self action:@selector(locationBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Touch events

- (void)locationBtn:(id)sender {
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
        [UIAlertView showWithMessage:@"定位服务当前可能尚未打开，请设置打开!" cancelButtonTitle:@"确定"];
        return;
        
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){//定位服务授权状态是用户没有决定是否使用定位服务。
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){//定位服务授权状态仅被允许在使用应用程序的时
        if(!_locationbtn.selected ){
            _locationbtn.selected = YES;
            if (IOS8_OR_LATER) {
                [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
            }
            [_locationManager startUpdatingLocation];
        }
    }
}

- (void)OKBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self confirmAddress];
        
        if (_proIdStr != nil && _cityIdStr != nil && _countyIdStr != nil && _streetIdStr != nil) {
            
            NSDictionary *val = @{
                                  @"province":@{
                                          @"id":_proIdStr,
                                          @"name":_proName,
                                          },
                                  @"city":@{
                                          @"id":_cityIdStr,
                                          @"name":_cityName,
                                          },
                                  @"county":@{
                                          @"id":_countyIdStr,
                                          @"name":_countyName,
                                          },
                                  @"street":@{
                                          @"id":_streetIdStr,
                                          @"name":_streetName,
                                          }
                                  };
            [_delegate changeLocationAddress:val];
        }
    }];
}

- (void)cancelBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - custom tasks

- (void)confirmAddress {
    
    _proIdStr = _tempProIdStr;
    _cityIdStr = _tempCityIdStr;//_jack,fix 2016.11.28
    _countyIdStr = _tempCountyIdStr;
    _streetIdStr = _tempStreetIdStr;
    
    _proName = _tempProName;
    _cityName = _tempCityName;
    _countyName = _tempCountyName;
    _streetName = _tempStreetName;
}


#pragma mark -

- (void)setShopInitAddressDic:(NSDictionary *)shopInitAddressDic {
    
    _shopInitAddressDic = shopInitAddressDic;
    
    if (shopInitAddressDic != nil) {
        
        _tempProIdStr = shopInitAddressDic[@"province"][@"id"];
        _tempCityIdStr = shopInitAddressDic[@"city"][@"id"];
        _tempCountyIdStr = shopInitAddressDic[@"county"][@"id"];
        _tempStreetIdStr = shopInitAddressDic[@"street"][@"id"];
        
        _tempProName = shopInitAddressDic[@"province"][@"name"];
        _tempCityName = shopInitAddressDic[@"city"][@"name"];
        _tempCountyName = shopInitAddressDic[@"county"][@"name"];
        _tempStreetName = shopInitAddressDic[@"street"][@"name"];
        
        [self confirmAddress];
        
        [_tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.textColor = RGBGRAY(100.f);
    }
    
    if(indexPath.row == 0){
        cell.textLabel.text = _tempProName;
        if(![NSString isBlankString:_proIdStr]){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
    }else if(indexPath.row == 1){
        cell.textLabel.text = _tempCityName;
        if(![NSString isBlankString:_cityIdStr]){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
    }else if(indexPath.row == 2){
        cell.textLabel.text = _tempCountyName;
        if(![NSString isBlankString:_countyIdStr]){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
    }else if(indexPath.row == 3){
        cell.textLabel.text = _tempStreetName;
        if(![NSString isBlankString:_streetIdStr]){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0){
        [self getprovince:YES];
    }else if(indexPath.row == 1){
        [self getcitysInProvince:_tempProIdStr isSelected:YES];
    }else if(indexPath.row == 2){
        [self getcountysInCity:_tempCityIdStr isSelected:YES];
    }else if(indexPath.row == 3){
        [self getstreetsInCounty:_tempCountyIdStr isSelected:YES];
    }
}

#pragma mark - pickerView
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (_tempAddrArray != nil) {
        return _tempAddrArray.count;
    }
    
    return 0;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger itag = pickerView.tag;
    
    NSLog(@"didSelectRow : %ld",itag);
    if(itag == 1){
        _tempProIdStr = [_tempAddrArray objectAtIndex:row][@"id"];
        _tempProName = [_tempAddrArray objectAtIndex:row][@"name"];
    }else if(itag == 2){
        _tempCityIdStr = [_tempAddrArray objectAtIndex:row][@"id"];
        _tempCityName = [_tempAddrArray objectAtIndex:row][@"name"];
    }else if(itag == 3){
        _tempCountyIdStr = [_tempAddrArray objectAtIndex:row][@"id"];
        _tempCountyName = [_tempAddrArray objectAtIndex:row][@"name"];
    }else if(itag == 4){
        _tempStreetIdStr = [_tempAddrArray objectAtIndex:row][@"id"];
        _tempStreetName = [_tempAddrArray objectAtIndex:row][@"name"];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_tempAddrArray objectAtIndex:row][@"name"];
    
    return nil;
}

#pragma mark - Location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code]==kCLErrorDenied) {
        //NSLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        //NSLog(@"无法获取位置信息");
    }
    [self getprovince:NO];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [_locationManager stopUpdatingLocation];
    
    NSString *strLatitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *strLongitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    _locationbtn.selected = YES;//恢复文案：定位中-->自动定位
    [self parseaddress:strLongitude lat:strLatitude];
}

-(void)getprovince:(BOOL)isSelect{
    
    if (_proviceArray == nil || _proviceArray.count == 0) {
        //省份只需要获取一次！！！
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [JKURLSession taskWithMethod:@"area/province.do" parameter:nil token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
            [hud hideAnimated:YES];
            if (error == nil) {
                _proviceArray = resultDic[@"data"];
                [self setProvinceInfo:isSelect];
            }else {
                [self showAutoDissmissHud:error.localizedDescription];
            }
        }];
    }else {
        [self setProvinceInfo:isSelect];
    }
}

- (void)setProvinceInfo:(BOOL)isSelect {
    _tempAddrArray = _proviceArray;
    
    NSInteger indexd = 0;
    for(int i=0;i<_proviceArray.count;i++){
        NSDictionary *dic = _proviceArray[i];
        NSString *strId = dic[@"id"];
        if(strId != nil && [strId isEqualToString:_proIdStr]){
            indexd = i;
            break;
        }
    }
    NSDictionary *dic = _proviceArray[indexd];
    _tempProIdStr =  dic[@"id"];
    _tempProName = dic[@"name"];
    
    if(isSelect &&[_proviceArray count] > 0){
        //弹出 pickerview
        UIPickerView *selectPicker = [UIPickerView new];
        
        selectPicker.frame = CGRectMake(0, 44, SCREEN_WIDTH-20, 200);
        selectPicker.showsSelectionIndicator=YES;
        selectPicker.dataSource = self;
        selectPicker.delegate = self;
        selectPicker.tag =1;
        [selectPicker selectRow:indexd inComponent:0 animated:YES];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"省份" message:@"\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:selectPicker];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self getcitysInProvince:_tempProIdStr isSelected:NO];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{}];
    }else{
        if([_proviceArray count] > 0){
            
            [self getcitysInProvince:_tempProIdStr isSelected:NO];
        }
    }
}

-(void)getcitysInProvince:(NSString *)provinceId isSelected:(BOOL)isSelect{
    
    NSDictionary *postdata = @{@"provinceId":provinceId};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"area/city.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        [hud hideAnimated:YES];
        if (error == nil) {
            _tempAddrArray = resultDic[@"data"];
            
            NSInteger indexd = 0;
            
            for(int i=0;i<_tempAddrArray.count;i++){
                NSDictionary *dic = _tempAddrArray[i];
                NSString *strId = dic[@"id"];
                if(strId != nil && [strId isEqualToString:_cityIdStr]){
                    indexd = i;
                    break;
                }
            }
            
            NSDictionary *dic = _tempAddrArray[indexd];
            _tempCityIdStr =  dic[@"id"];
            _tempCityName = dic[@"name"];
            
            if(isSelect && [_tempAddrArray count] > 0){
                
                UIPickerView *selectPicker = [UIPickerView new];
                selectPicker.frame = CGRectMake(0, 44, SCREEN_WIDTH-20, 200);
                selectPicker.showsSelectionIndicator=YES;
                selectPicker.dataSource = self;
                selectPicker.delegate = self;
                selectPicker.tag =2;
                [selectPicker selectRow:indexd inComponent:0 animated:YES];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"城市" message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
                [alert.view addSubview:selectPicker];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    
                    [self getcountysInCity:_tempCityIdStr isSelected:NO];
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
                
                [alert addAction:ok];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:^{}];
            }else{
                if([_tempAddrArray count]>0){
                    
                    [self getcountysInCity:_tempCityIdStr isSelected:NO];
                }
            }
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

-(void)getcountysInCity:(NSString *)cityId isSelected:(BOOL)isSelect{
    
    NSDictionary *postdata = @{@"cityId":cityId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"area/county.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        [hud hideAnimated:YES];
        if (error == nil) {
            _tempAddrArray = resultDic[@"data"];
            
            NSInteger indexd = 0;
            for(int i=0;i<_tempAddrArray.count;i++){
                NSDictionary *dic = _tempAddrArray[i];
                NSString *strId = dic[@"id"];
                if(strId != nil && [strId isEqualToString:_countyIdStr]){
                    indexd = i;
                    break;
                }
            }
            NSDictionary *dic = _tempAddrArray[indexd];
            _tempCountyIdStr =   dic[@"id"];
            _tempCountyName = dic[@"name"];
            
            if(isSelect && [_tempAddrArray count] > 0){
                
                UIPickerView *selectPicker = [UIPickerView new];
                selectPicker.frame = CGRectMake(0, 44, SCREEN_WIDTH-20, 200);
                selectPicker.showsSelectionIndicator=YES;
                selectPicker.dataSource = self;
                selectPicker.delegate = self;
                selectPicker.tag =3;
                [selectPicker selectRow:indexd inComponent:0 animated:YES];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"区／县" message:@"\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
                [alert.view addSubview:selectPicker];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self getstreetsInCounty:_tempCountyIdStr isSelected:NO];
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
                
                [alert addAction:ok];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:^{}];
            }else{
                if([_tempAddrArray count]>0){
                    
                    [self getstreetsInCounty:_tempCountyIdStr isSelected:NO];
                }
            }
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}


-(void)getstreetsInCounty:(NSString *)countyId isSelected:(BOOL)isSelect{
    NSDictionary *postdata = @{@"countyId":countyId};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"area/street.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        [hud hideAnimated:YES];
        if (error == nil) {
            
            _tempAddrArray = resultDic[@"data"];
            if([_tempAddrArray count] == 0){
                _streetIdStr = @"";
                _tempStreetName = @"";
                [self.tableView reloadData];
            }
            
            if(isSelect && [_tempAddrArray count] > 0){
                
                NSInteger indexd = 0;
                for(int i=0;i<_tempAddrArray.count;i++){
                    NSDictionary *dic = _tempAddrArray[i];
                    NSString *strId = dic[@"id"];
                    if(strId != nil && [strId isEqualToString:_streetIdStr]){
                        indexd = i;
                        break;
                    }
                }
                NSDictionary *dic = _tempAddrArray[indexd];
                _tempStreetIdStr =  countyId;
                _tempStreetName = dic[@"name"];
                
                UIPickerView *selectPicker = [UIPickerView new];
                selectPicker.frame = CGRectMake(0, 44, SCREEN_WIDTH-20, 200);
                selectPicker.showsSelectionIndicator=YES;
                selectPicker.dataSource = self;
                selectPicker.delegate = self;
                selectPicker.tag =4;
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"街道／村镇" message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
                [alert.view addSubview:selectPicker];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self.tableView reloadData];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
                
                [alert addAction:ok];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:^{}];
            }else{
                if([_tempAddrArray count]>0){
                    _tempStreetIdStr = [_tempAddrArray objectAtIndex:0][@"id"];
                    _tempStreetName = [_tempAddrArray objectAtIndex:0][@"name"];
                    [self.tableView reloadData];
                }
            }
        }else {
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}

-(void)parseaddress:(NSString*) longitude lat:(NSString*)latitude{
    
    NSDictionary *postdata = @{@"longitude":longitude,
                               @"latitude":latitude};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JKURLSession taskWithMethod:@"area/parseaddress.do" parameter:postdata token:YES resultBlock:^(NSDictionary *resultDic, NSError *error) {
        [hud hideAnimated:YES];
        if (error == nil) {
            _locationbtn.selected = NO;
            
            _tempProName = resultDic[@"data"][@"province"][@"name"];
            _tempCityName = resultDic[@"data"][@"city"][@"name"];
            _tempCountyName = resultDic[@"data"][@"county"][@"name"];
            _tempStreetName = resultDic[@"data"][@"street"][@"name"];
            
            _tempProIdStr = resultDic[@"data"][@"province"][@"id"];
            _tempCityIdStr = resultDic[@"data"][@"city"][@"id"];
            _tempCountyIdStr = resultDic[@"data"][@"county"][@"id"];
            _tempStreetIdStr = resultDic[@"data"][@"street"][@"id"];
            
            [self.tableView reloadData];
            
            if([NSString isBlankString:_cityIdStr] && ![NSString isBlankString:_proIdStr]){
                [self getcitysInProvince:_proIdStr isSelected:NO];
            }
        }else {
            [self getprovince:NO];
            _locationbtn.selected = NO;
            
            [self showAutoDissmissHud:error.localizedDescription];
        }
    }];
}
@end
