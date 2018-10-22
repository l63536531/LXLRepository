//
//  LocationManager.m
//  ShopKeeper
//
//  Created by zhough on 16/6/6.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager
+ (LocationManager *)sharedInstance
{
    static LocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LocationManager alloc] initWithLocationManager];
        
    });
    return instance;
}

- (id)initWithLocationManager{
    self = [super init];
    if (!self) {
        return nil;
        
    }
    
    
    return self;
}


-(void)startUpdatingLocation{

    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
        
        [UIAlertView showWithMessage:@"定位服务当前可能尚未打开，请设置打开!" cancelButtonTitle:@"确定"];

        return;
        
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){//定位服务授权状态是用户没有决定是否使用定位服务。
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){//定位服务授权状态仅被允许在使用应用程序的时候。
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        
        [_locationManager startUpdatingLocation];

    }

}

#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）

//处理定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *curLocation = [locations lastObject];
    
    //将经度显示到label上
    _longitude =   [NSString stringWithFormat:@"%lf", curLocation.coordinate.longitude];
    //将纬度现实到label上
    _latitude =   [NSString stringWithFormat:@"%lf", curLocation.coordinate.latitude];
    NSLog(@"latitude =  %@  - %@",_longitude,_latitude);
    //定位城市通过CLGeocoder
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:curLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error && [placemarks count] > 0)
        {
            //            for (CLPlacemark * placemark in placemarks) {
            CLPlacemark * placemark = [placemarks lastObject];
            _country = [placemark country];//国家
            _province = [placemark administrativeArea];//广东省
            _city = [placemark locality];//广州城市
            _district = [placemark subLocality];//天河 区
            _street = [placemark thoroughfare];//林和西路
            NSString *subThoroughfare = [placemark subThoroughfare];//161号a座 具体门号
            
            NSString *CountryCode = [placemark ISOcountryCode];//国家码CN
            
            _DetailedAddress = [placemark name];//详细地址
            
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"city" object:nil];

            NSLog(@"定位获取的位置   %@ -- %@- %@-%@-%@-%@- %@-%@ ", _country,_city,CountryCode,_DetailedAddress,_street,subThoroughfare,_district,_province);
            //            }
            
        } else
        {
            NSLog(@"ERROR: %@", error);
            
        }
    }];
    //    如果不需要实时定位，使用完即使关闭定位服务
    _locationManager = manager;
    [_locationManager stopUpdatingLocation];
    
}




-(void)stopUpdatingLocation{

    [_locationManager stopUpdatingHeading];
}

//处理定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"定位处理失败");
    if(error.code == kCLErrorLocationUnknown)
    {
        NSLog(@"Currently unable to retrieve location.");
    }
    else if(error.code == kCLErrorNetwork)
    {
        NSLog(@"Network used to retrieve location is unavailable.");
    }
    else if(error.code == kCLErrorDenied)
    {
        
        NSLog(@"Permission to retrieve location is denied.");
        
        [_locationManager stopUpdatingLocation];
        
    }
}





@end
