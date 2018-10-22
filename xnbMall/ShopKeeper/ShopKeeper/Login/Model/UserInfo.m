//
//  UserInfo.m
//  ShopKeeper
//
//  Created by zzheron on 16/7/26.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo




//managerPermission是否有服务经理权限，
//operationPermission是否有运营中心权限，
//serviceCenterPermission是否有服务中心权限，
//serviceStationPermission是否有服务站权限，
//shopMemberPermission是否有店铺会员权限
//ystPermission云商通会员权限
-(NSInteger)GetPermissionType{
    if(self.uiyp.managerPermission && self.uiyp.serviceStationPermission) return 1;
    if(self.uiyp.managerPermission && self.uiyp.serviceCenterPermission) return 2;
    if(self.uiyp.managerPermission && self.uiyp.operationPermission) return 3;
    if(self.uiyp.managerPermission && self.uiyp.shopMemberPermission) return 4;
    if(self.uiyp.operationPermission && self.uiyp.serviceStationPermission) return 5;
    if(self.uiyp.operationPermission && self.uiyp.serviceCenterPermission) return 6;
    if(self.uiyp.operationPermission && self.uiyp.shopMemberPermission) return 7;
    if(self.uiyp.serviceCenterPermission && self.uiyp.shopMemberPermission) return 8;
    if(self.uiyp.serviceStationPermission && self.uiyp.shopMemberPermission) return 9;
    if(self.uiyp.shopMemberPermission) return 4;
    
    
    return 0;
}


-(NSInteger) GetIndexType{
    NSInteger pp = [self GetPermissionType];
    if(pp == 1 || pp == 2 || pp == 3 || pp == 5 || pp == 6 || pp == 7 || pp == 8 || pp == 9){
        return 1;
    }
    
    if(pp == 4){
        return 2;//图三首页
    }
   
    return 0;
}


//"centerPrice":"服务中心价格",
//"stationPrice":"服务站价格",
//"retailsPrice":"零售价",
//"memberPrice":"会员价",
//"costPrice":"进货价"
//1 进货价、建议售价，进货价即服务站价格
//2 进货价、服务站价、建议售价，进货价即服务中心价格；
//3 进货价、建议售价，进货价即云商通会员价格；
//4 进货价、服务站价、建议售价，进货价即会员价格
//5 进货价、建议售价，进货价即会员价格
-(NSInteger) GetPriceType:(NSDictionary*)goodsprice{
    NSInteger pp = [self GetPermissionType];
    if(pp == 1) return 1;
    if(pp == 2) return 2;
    if(pp == 3) return 2;
    if(pp == 4) return 3;
    if(pp == 5) return 2;
    if(pp == 6) return 2;
    if(pp == 7) return 3;
    
    if(pp == 8){
        //商品对其服务中心身份可售，对会员身份可售
        if(goodsprice[@"centerPrice"] != nil && goodsprice[@"memberPrice"] != nil)
            return 4;
        //商品对其服务中心身份可售，对会员身份不可售
        if(goodsprice[@"centerPrice"] != nil && goodsprice[@"memberPrice"] == nil)
            return 2;
        //商品对其服务中心身份不可售，对会员身份可售
        if(goodsprice[@"centerPrice"] == nil && goodsprice[@"memberPrice"] != nil)
            return 5;
        
        return 5;
        
    }
    if(pp == 9){
        //商品对其服务站身份可售，对会员身份可售
        if(goodsprice[@"stationPrice"] != nil && goodsprice[@"memberPrice"] != nil)
            return 5;
        //商品对其服务站身份可售，对会员身份不可售
        if(goodsprice[@"stationPrice"] != nil && goodsprice[@"memberPrice"] == nil)
            return 1;
        //商品对其服务站身份不可售，对会员身份可售
        if(goodsprice[@"stationPrice"] != nil && goodsprice[@"memberPrice"] != nil)
            return 5;
        
        return 5;
    }
    return 5;
}


@end
