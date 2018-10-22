//
//  LocationView.m
//  ShopKeeper
//
//  Created by zhough on 16/6/6.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "LocationView.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "NSString+Utils.h"

#import "LocationManager.h"

@interface LocationView ()





@end



@implementation LocationView

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIView *becloudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    becloudView.backgroundColor = [UIColor blackColor];
    becloudView.layer.opacity = 0.3;
    [self.view addSubview:becloudView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 5;
    [self.view addSubview:self.tableView];
    WS(ws);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self makeFooterView];
    [self makeHeaderView];
    
    self.tableView.tableHeaderView = _headerview;
    self.tableView.tableFooterView = _footerview;
    
    
    _locationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=10;
    
    [self getprovince:NO];
    
    if (IOS8_OR_LATER) {
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
    }
    [_locationManager startUpdatingLocation];
   
}


-(void) makeHeaderView{
    _headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"选择地区或自动定位";
    label.font = [UIFont systemFontOfSize:20];
    [label setTextColor:ColorFromHex(0x646464)];
    label.textAlignment = NSTextAlignmentCenter;
    [_headerview addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_headerview);
        make.size.mas_equalTo(CGSizeMake(300, 30));
    }];
    
}

-(void) makeFooterView {
    _footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 66)];
    
    _locationbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationbtn setTitle:@"自动定位" forState:UIControlStateNormal];
    _locationbtn.backgroundColor = KFontColor(@"#ec584c") ;
    
    UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _locationbtn.layer.cornerRadius = 3;
    btn_1.layer.cornerRadius = 3;
    btn_2.layer.cornerRadius = 3;
    
    [_footerview addSubview:_locationbtn];
    [_footerview addSubview:btn_1];
    [_footerview addSubview:btn_2];
    
    [btn_1 setTitle:@"确定" forState:UIControlStateNormal];
    btn_1.backgroundColor = KFontColor(@"#ec584c");
    
    
    [btn_2 setTitleColor:ColorFromHex(0x646464) forState:UIControlStateNormal];
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
    
    [btn_2 bk_addEventHandler:^(id sender) {
        NSLog(@"btn_2");
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [btn_1 bk_addEventHandler:^(id sender) {
        NSLog(@"btn_1");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"determineLocation" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [MyUtile saveStringToUserDefaults:DICKEY_LOGIN key:AREA_ID object:@""];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_locationbtn bk_addEventHandler:^(id sender) {
        
        [[LocationManager sharedInstance] startUpdatingLocation];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(city_Action) name:@"city" object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
    NSString *ID = [NSString stringWithFormat:@"selectGoodsCell_%ld_%ld",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //cell.accessoryView = button;
    
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    if(indexPath.row == 0){
        cell.textLabel.text = _proNameStr;
        cell.textLabel.textColor = TEXTCURRENT_COLOR;
        if(![NSString isBlankString:_proNameStr]){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 20, 20)];
            [button setImage:[UIImage imageNamed:@"tick1"] forState:UIControlStateNormal];
            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
    }else if(indexPath.row == 1){
        cell.textLabel.text = _cityNameStr;
        cell.textLabel.textColor = TEXTCURRENT_COLOR;
        if(![NSString isBlankString:_cityNameStr]){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 20, 20)];
            [button setImage:[UIImage imageNamed:@"tick1"] forState:UIControlStateNormal];
            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
    }else if(indexPath.row == 2){
        cell.textLabel.text = _areaNameStr;
        cell.textLabel.textColor = TEXTCURRENT_COLOR;
        if(![NSString isBlankString:_areaNameStr]){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 20, 20)];
            [button setImage:[UIImage imageNamed:@"tick1"] forState:UIControlStateNormal];            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
    }else if(indexPath.row == 3){
        cell.textLabel.text = _streetNameStr;
        cell.textLabel.textColor = TEXTCURRENT_COLOR;
        if(![NSString isBlankString:_streetNameStr]){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 20, 20)];
            [button setImage:[UIImage imageNamed:@"tick1"] forState:UIControlStateNormal];
            cell.accessoryView = button;
        }else{
            cell.accessoryView = nil;
        }
    }
    [cell.textLabel setTextColor:ColorFromHex(0x646464)];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        [self getprovince:YES];
    }else if(indexPath.row == 1){
        [self getcity:YES];
    }else if(indexPath.row == 2){
        [self getcounty:YES];
    }else if(indexPath.row == 3){
        [self getstreet:YES];
    }
    
}


#pragma mark - pickerView
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger itag = pickerView.tag;
    if(itag == 1){
        return [_pro_arr count];
    }else if(itag == 2){
        return [_city_arr count];
    }else if(itag == 3){
        return [_area_arr count];
    }else if(itag == 4){
        return [_street_arr count];
    }
    return 0;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger itag = pickerView.tag;
    if(itag == 1){
        _proNameStr = [_pro_arr objectAtIndex:row][@"name"];
        _proIdStr = [_pro_arr objectAtIndex:row][@"id"];
    }else if(itag == 2){
        _cityNameStr = [_city_arr objectAtIndex:row][@"name"];
        _cityIdStr = [_city_arr objectAtIndex:row][@"id"];
    }else if(itag == 3){
        _areaNameStr = [_area_arr objectAtIndex:row][@"name"];
        _areaIdStr = [_area_arr objectAtIndex:row][@"id"];
    }else if(itag == 4){
        _streetNameStr = [_street_arr objectAtIndex:row][@"name"];
        _streetIdStr = [_street_arr objectAtIndex:row][@"id"];
    }
}


//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger itag = pickerView.tag;
    if(itag == 1){
        return [_pro_arr objectAtIndex:row][@"name"];
    }else if(itag == 2){
        return [_city_arr objectAtIndex:row][@"name"];
    }else if(itag == 3){
        return [_area_arr objectAtIndex:row][@"name"];
    }else if(itag == 4){
        return [_street_arr objectAtIndex:row][@"name"];
    }
    return nil;
}



-(void)getprovince:(BOOL)isSelect{
    
    NSDictionary *postdata = @{};
    NSString *surl = [NSString stringWithFormat:@"%@/area/province.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _pro_arr = retdata[@"data"];
            
            if(isSelect &&[_pro_arr count] > 0){
                UIPickerView *selectPicker = [UIPickerView new];
                //selectPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                selectPicker.frame = CGRectMake(0, 44, SCREEN_WIDTH-20, 200);
                selectPicker.showsSelectionIndicator=YES;
                selectPicker.dataSource = self;
                selectPicker.delegate = self;
                selectPicker.tag =1;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"省份" message:@"\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
                [alert.view addSubview:selectPicker];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self.tableView reloadData];
                    [self getcity:NO];
                }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:^{}];
            }else{
                if([_pro_arr count] > 0){
                    _proNameStr = [_pro_arr objectAtIndex:0][@"name"];
                    _proIdStr = [_pro_arr objectAtIndex:0][@"id"];
                    [self.tableView reloadData];
                    [self getcity:NO];
                }
            }
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
}

-(void)getcity:(BOOL)isSelect{
    NSDictionary *postdata = @{@"provinceId":_proIdStr};
    NSString *surl = [NSString stringWithFormat:@"%@/area/city.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _city_arr = retdata[@"data"];
            
            if(isSelect && [_city_arr count] > 0){
                UIPickerView *selectPicker = [UIPickerView new];
                selectPicker.frame = CGRectMake(0, 44, SCREEN_WIDTH-20, 200);
                selectPicker.showsSelectionIndicator=YES;
                selectPicker.dataSource = self;
                selectPicker.delegate = self;
                selectPicker.tag =2;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"城市" message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
                [alert.view addSubview:selectPicker];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self.tableView reloadData];
                    [self getcounty:NO];
                }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:^{}];
            }else{
                if([_city_arr count]>0){
                    _cityNameStr = [_city_arr objectAtIndex:0][@"name"];
                    _cityIdStr = [_city_arr objectAtIndex:0][@"id"];
                    [self.tableView reloadData];
                    [self getcounty:NO];
                }
            }
            
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
}


-(void)getcounty:(BOOL)isSelect{
    
    NSDictionary *postdata = @{@"cityId":_cityIdStr};
    NSString *surl = [NSString stringWithFormat:@"%@/area/county.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _area_arr = retdata[@"data"];
            if(isSelect && [_area_arr count] > 0){
                UIPickerView *selectPicker = [UIPickerView new];
                selectPicker.frame = CGRectMake(0, 44, SCREEN_WIDTH-20, 200);
                selectPicker.showsSelectionIndicator=YES;
                selectPicker.dataSource = self;
                selectPicker.delegate = self;
                selectPicker.tag =3;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"区／县" message:@"\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
                [alert.view addSubview:selectPicker];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self.tableView reloadData];
                    [self getstreet:NO];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:^{}];
            }else{
                if([_area_arr count]>0){
                    _areaNameStr = [_area_arr objectAtIndex:0][@"name"];
                    _areaIdStr = [_area_arr objectAtIndex:0][@"id"];
                    [self.tableView reloadData];
                    [self getstreet:NO];
                }
            }
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
}


-(void)getstreet:(BOOL)isSelect{
    NSDictionary *postdata = @{@"countyId":_areaIdStr};
    NSString *surl = [NSString stringWithFormat:@"%@/area/street.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _street_arr = retdata[@"data"];
            if([_street_arr count] == 0){
                _streetNameStr = @"";
                _streetIdStr = @"";
                [self.tableView reloadData];
            }
            
            if(isSelect && [_street_arr count] > 0){
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
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:^{}];
            }else{
                if([_street_arr count]>0){
                    _streetNameStr = [_street_arr objectAtIndex:0][@"name"];
                    _streetIdStr = [_street_arr objectAtIndex:0][@"id"];
                    [self.tableView reloadData];
                }
                
            }
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}


-(void)city_Action{
    
    
    [[LocationManager sharedInstance] addObserver:self forKeyPath:@"city" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:NULL];
    
}





-(void)parseaddress:(NSString*) longitude lat:(NSString*)latitude{
    _locationbtn.selected = YES;
    NSDictionary *postdata = @{@"longitude":longitude,
                               @"latitude":latitude};
    
    
    NSString *surl = [NSString stringWithFormat:@"%@/area/parseaddress.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    NSString* token = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_TOKEN];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x_token"];
    
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        _locationbtn.selected = NO;
        // NSLog(@"parseaddress:%@",retdata);
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            
            
            _proNameStr = retdata[@"data"][@"province"][@"name"];
            _cityNameStr = retdata[@"data"][@"city"][@"name"];
            _areaNameStr = retdata[@"data"][@"county"][@"name"];
            _streetNameStr = retdata[@"data"][@"street"][@"name"];
            
            _proIdStr = retdata[@"data"][@"province"][@"id"];
            _cityIdStr = retdata[@"data"][@"city"][@"id"];
            _areaIdStr = retdata[@"data"][@"county"][@"id"];
            _streetIdStr = retdata[@"data"][@"street"][@"id"];
            
            
            [self.tableView reloadData];
            
            if([NSString isBlankString:_cityIdStr] && ![NSString isBlankString:_proIdStr]){
                [self getcity:NO];
            }
            
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
        _locationbtn.selected = NO;
    }];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    
    if([keyPath isEqualToString:@"city"])
        
    {
        
        NSLog(@"89city");
        
        _proNameStr =[LocationManager sharedInstance].province;
        _cityNameStr = [LocationManager sharedInstance].city;
        _areaNameStr = [LocationManager sharedInstance].district;
        _streetNameStr = [LocationManager sharedInstance].street;
        _DetailedAddress = [LocationManager sharedInstance].DetailedAddress;
        
        _longitude = [LocationManager sharedInstance].longitude;
        _latitude = [LocationManager sharedInstance].latitude;
        [self parseaddress:_longitude lat:_latitude];
        
        [self getprovince0:YES];
    }
    
    
}

#pragma mark 自动定位处理
-(void)getprovince0:(BOOL)isSelect{
    
    NSDictionary *postdata = @{};
    NSString *surl = [NSString stringWithFormat:@"%@/area/province.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _pro_arr = retdata[@"data"];
            
            if(isSelect &&[_pro_arr count] > 0){
                
                for (NSDictionary * dic in _pro_arr) {
                    if ([dic[@"name"] isEqualToString:_proNameStr]) {
                        
                        _proIdStr = dic[@"id"];
                        break;
                        
                        
                    }
                    
                    
                }
                
                [self.tableView reloadData];
                [self getcity0:YES];
      
            }else{
                if([_pro_arr count] > 0){
                    _proNameStr = [_pro_arr objectAtIndex:0][@"name"];
                    _proIdStr = [_pro_arr objectAtIndex:0][@"id"];
                    [self.tableView reloadData];
                    [self getcity0:NO];
                }
            }
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
}

-(void)getcity0:(BOOL)isSelect{
    NSDictionary *postdata = @{@"provinceId":_proIdStr};
    NSString *surl = [NSString stringWithFormat:@"%@/area/city.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _city_arr = retdata[@"data"];
            
            if(isSelect && [_city_arr count] > 0){
                for (NSDictionary * dic in _city_arr) {
                    if ([dic[@"name"] isEqualToString:_cityNameStr]) {
                        
                        _cityIdStr = dic[@"id"];
                        break;
                        
                        
                    }
                    
                    
                }
                
                
                [self.tableView reloadData];
                [self getcounty0:YES];
                
            }else{
                if([_city_arr count]>0){
                    _cityNameStr = [_city_arr objectAtIndex:0][@"name"];
                    _cityIdStr = [_city_arr objectAtIndex:0][@"id"];
                    [self.tableView reloadData];
                    [self getcounty0:NO];
                }
            }
            
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
}


-(void)getcounty0:(BOOL)isSelect{
    
    NSDictionary *postdata = @{@"cityId":_cityIdStr};
    NSString *surl = [NSString stringWithFormat:@"%@/area/county.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _area_arr = retdata[@"data"];
            if(isSelect && [_area_arr count] > 0){
                for (NSDictionary * dic in _area_arr) {
                    if ([dic[@"name"] isEqualToString:_areaNameStr]) {
                        
                        _areaIdStr = dic[@"id"];
                        break;
                        
                        
                    }
                    
                    
                }
                
                
                [self.tableView reloadData];
                [self getstreet0:YES];
            }else{
                if([_area_arr count]>0){
                    _areaNameStr = [_area_arr objectAtIndex:0][@"name"];
                    _areaIdStr = [_area_arr objectAtIndex:0][@"id"];
                    [self.tableView reloadData];
                    [self getstreet0:NO];
                }
            }
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
}


-(void)getstreet0:(BOOL)isSelect{
    NSDictionary *postdata = @{@"countyId":_areaIdStr};
    NSString *surl = [NSString stringWithFormat:@"%@/area/street.do",SERVER_ADDR_XNBMALL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager RWTJsonManager];
    [manager POST:surl parameters:postdata progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable retdata) {
        NSInteger code = [[retdata objectForKey:@"code"] integerValue];
        if(code == 200){
            _street_arr = retdata[@"data"];
            if([_street_arr count] == 0){
                _streetNameStr = @"";
                _streetIdStr = @"";
                [self.tableView reloadData];
            }
            
            if(isSelect && [_street_arr count] > 0){
                for (NSDictionary * dic in _street_arr) {
                    if ([dic[@"name"] isEqualToString:_streetNameStr]) {
                        
                        _streetIdStr = dic[@"id"];
                        break;
                    }
                }
                
                [self.tableView reloadData];
                
            }else{
                if([_street_arr count]>0){
                    _streetNameStr = [_street_arr objectAtIndex:0][@"name"];
                    _streetIdStr = [_street_arr objectAtIndex:0][@"id"];
                    [self.tableView reloadData];
                }
                
            }
        }else{
            [MyUtile showAlertViewByMsg:retdata[@"msg"] vc:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MyUtile showAlertViewByMsg:@"请求数据失败！" vc:self];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"city" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
    // Dispose of any resources that can be recreated.
    
    
}

@end
