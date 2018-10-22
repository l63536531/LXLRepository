//
//  LocationManager.h
//  ShopKeeper
//
//  Created by zhough on 16/6/6.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>{


}

+ (LocationManager *)sharedInstance;



@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic,strong) NSString* country;//国家
@property (nonatomic,strong) NSString* province;//省份
@property (nonatomic,strong) NSString* city;//城市
@property (nonatomic,strong) NSString* district;//区
@property (nonatomic,strong) NSString* street;//路或街道
@property (nonatomic,strong) NSString* DetailedAddress;//详细地址

@property (nonatomic,strong) NSString *  longitude;//经度
//纬度
@property (nonatomic,strong) NSString * latitude;

-(void)startUpdatingLocation;


@end
