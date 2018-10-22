//
//  JKLocationTool.m
//  ScrollTouch
//
//  Created by IOS－001 on 15/5/13.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import "JKLocationTool.h"
#import "JKTool.h"

#import <UIKit/UIKit.h>

@interface JKLocationTool ()
{
    CLLocationManager   *_locationManager;
}
@end

@implementation JKLocationTool

+(JKLocationTool *)sharedInstance
{
    static JKLocationTool *locationToll = nil;
    @synchronized(self){
        if (!locationToll) {
            locationToll = [[JKLocationTool alloc]init];
        }
    }
    return locationToll;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initLocationManager];
    }
    return self;
}

-(void)dealloc
{
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

-(void)initLocationManager
{
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 500.f;
    
    if ([JKTool iOSVersion] >= 8.0f)
    {
        [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
}



-(BOOL)JKStartUpdatingLocation
{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            [_locationManager startUpdatingLocation];
            
            return YES;
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        return NO;
    }
    
    return NO;
}

-(void)JKStopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(JKLocationToolDidGetLatitude:longitude:)]) {
        [self.delegate JKLocationToolDidGetLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(JKLocationToolDidGetCoordinate:placemark:)]) {
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];//ios version>6.0
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                if (self.delegate&&[self.delegate respondsToSelector:@selector(JKLocationToolDidFailToReverseCoordinate:withError:)])
                {
                    [self.delegate JKLocationToolDidFailToReverseCoordinate:newLocation.coordinate withError:error];
                }
            }else
            {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                [self.delegate JKLocationToolDidGetCoordinate:newLocation.coordinate placemark:placemark];
            }
        }];
    };
    
    
//    NSString *latitudeStr = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.latitude];
//    NSString *longitudeStr = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.longitude];
    
//    NSLog(@"latitudeStr:%@\nlongitudeStr:%@",latitudeStr,longitudeStr);
//    NSLog(@"location ok");
    
}

/*
 
CLPlacemark 属性
 
@property (nonatomic, readonly, copy) NSString *name; // eg. Apple Inc.
@property (nonatomic, readonly, copy) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
@property (nonatomic, readonly, copy) NSString *subThoroughfare; // eg. 1
@property (nonatomic, readonly, copy) NSString *locality; // city, eg. Cupertino
@property (nonatomic, readonly, copy) NSString *subLocality; // neighborhood, common name, eg. Mission District
@property (nonatomic, readonly, copy) NSString *administrativeArea; // state, eg. CA
@property (nonatomic, readonly, copy) NSString *subAdministrativeArea; // county, eg. Santa Clara
@property (nonatomic, readonly, copy) NSString *postalCode; // zip code, eg. 95014
@property (nonatomic, readonly, copy) NSString *ISOcountryCode; // eg. US
@property (nonatomic, readonly, copy) NSString *country; // eg. United States
@property (nonatomic, readonly, copy) NSString *inlandWater; // eg. Lake Tahoe
@property (nonatomic, readonly, copy) NSString *ocean; // eg. Pacific Ocean
@property (nonatomic, readonly, copy) NSArray *areasOfInterest;
*/


/*CLPlacemark 具体内容注解*/
/*
 NSString *name = placemark.name;//高新区综合服务楼(深圳)
 NSString *thoroughfare = placemark.thoroughfare;//高新南四道
 NSString *subThoroughfare = placemark.subThoroughfare;//30北门
 
 NSString *locality = placemark.locality;//深圳市
 NSString *subLocality = placemark.subLocality;//南山区
 NSString *administrativeArea = placemark.administrativeArea;//广东省
 
 NSString *subAdministrativeArea = placemark.subAdministrativeArea;//nil
 NSString *postalCode = placemark.postalCode;//nil
 
 NSString *ISOcountryCode = placemark.ISOcountryCode;//CN
 NSString *country = placemark.country;//中国
 
 NSString *inlandWater = placemark.inlandWater;//nil
 NSString *ocean = placemark.ocean;//nil
 
 //            NSArray *areasOfInterest = placemark.areasOfInterest;//nil
 */

@end
