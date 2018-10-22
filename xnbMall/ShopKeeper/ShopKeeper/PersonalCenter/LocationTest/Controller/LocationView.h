//
//  LocationView.h
//  ShopKeeper
//
//  Created by zhough on 16/6/6.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"
#import <MapKit/MKMapView.h>

@interface LocationView : MABaseViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIPopoverPresentationControllerDelegate>


@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *headerview;
@property (nonatomic) UIView *footerview;


@property (nonatomic) UIButton *locationbtn;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLGeocoder *geocoder;

@property (nonatomic) NSArray *pro_arr;
@property (nonatomic) NSArray *city_arr;
@property (nonatomic) NSArray *area_arr;
@property (nonatomic) NSArray *street_arr;


@property (nonatomic) NSString *proNameStr;
@property (nonatomic) NSString *cityNameStr;
@property (nonatomic) NSString *areaNameStr;
@property (nonatomic) NSString *streetNameStr;

@property (nonatomic) NSString *proIdStr;
@property (nonatomic) NSString *cityIdStr;
@property (nonatomic) NSString *areaIdStr;
@property (nonatomic) NSString *streetIdStr;


@property (nonatomic,strong) NSString* DetailedAddress;//详细地址

@property (nonatomic,strong) NSString *  longitude;//经度

@property (nonatomic,strong) NSString * latitude;//纬度

@end
