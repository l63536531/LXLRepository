//
//  JKLocationTool.h
//  ScrollTouch
//
//  Created by IOS－001 on 15/5/13.
//  Copyright (c) 2015年 E-Techco Information Technologies Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol JKLocationDelegate <NSObject>

@optional
-(void)JKLocationToolDidGetLatitude:(CGFloat) latitude longitude:(CGFloat)longitude;

-(void)JKLocationToolDidGetCoordinate:(CLLocationCoordinate2D)coordinate placemark:(CLPlacemark *)placemark;

-(void)JKLocationToolDidFailToReverseCoordinate:(CLLocationCoordinate2D)coordinate withError:(NSError *)error;

@end

@interface JKLocationTool : NSObject<CLLocationManagerDelegate>

@property(nonatomic,unsafe_unretained)id <JKLocationDelegate> delegate;//在delegate销毁前要赋值nil

+(JKLocationTool *)sharedInstance;

-(BOOL)JKStartUpdatingLocation;
-(void)JKStopUpdatingLocation;

@end
