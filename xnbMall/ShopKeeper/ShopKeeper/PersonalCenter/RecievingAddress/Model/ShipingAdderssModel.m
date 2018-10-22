//
//  ShipingAdderssModel.m
//  ShopKeeper
//
//  Created by zhough on 16/6/17.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "ShipingAdderssModel.h"

@implementation ShipingAdderssModel
+(ShipingAdderssModel*)create:(NSDictionary*)dic{
    
    ShipingAdderssModel* model = [[ShipingAdderssModel alloc] init];
    model.idD = dic[@"id"];
    model.userId = dic[@"userId"];
    model.areaId = dic[@"areaId"];
    model.address = dic[@"address"];
    model.contactName = dic[@"contactName"];
    model.contactPhone = dic[@"contactPhone"];
    model.isDefault = dic[@"isDefault"];
    model.lastUseDate = dic[@"lastUseDate"];
    model.createdDate = dic[@"createdDate"];
    
    
    
    model.provinceid = dic[@"street"][@"province"][@"id"];
    model.provincename = dic[@"street"][@"province"][@"name"];
    model.provinceparentId = dic[@"street"][@"province"][@"parentId"];
    
    
    model.cityid = dic[@"street"][@"city"][@"id"];
    model.cityname = dic[@"street"][@"city"][@"name"];
    model.cityparentId = dic[@"street"][@"city"][@"parentId"];
    
    model.countyid = dic[@"street"][@"county"][@"id"];
    model.countyname = dic[@"street"][@"county"][@"name"];
    model.countyparentId = dic[@"street"][@"county"][@"parentId"];
    
    model.streetid = dic[@"street"][@"street"][@"id"];
    model.streetname = dic[@"street"][@"street"][@"name"];
    model.streetparentId = dic[@"street"][@"street"][@"parentId"];
    
    
 
    
    
    return model;
}

@end
