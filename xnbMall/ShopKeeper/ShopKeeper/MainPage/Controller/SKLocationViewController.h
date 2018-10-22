//
//  SKLocationViewController.h
//  ShopKeeper
//
//  Created by zzheron on 16/6/3.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "MABaseViewController.h"
#import <MapKit/MKMapView.h>

@protocol SkChangeLocationAddressDelegate <NSObject>
- (void)changeLocationAddress:(NSDictionary *)value;
@end

@interface SKLocationViewController : MABaseViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,unsafe_unretained) id<SkChangeLocationAddressDelegate> delegate;

@property (nonatomic, strong) NSDictionary *shopInitAddressDic;

@end
