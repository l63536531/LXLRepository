//
//  ShipingAdderssModel.h
//  ShopKeeper
//
//  Created by zhough on 16/6/17.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipingAdderssModel : NSObject
//id : "唯一编号",
//userId : "用户id",
//areaId : "地区id",
//address : "详细地址",
//contactName : "联系人名字",
//contactPhone : "联系人电话",
//isDefault : "是否默认",
//lastUseDate : "上次时间使用",
//createdDate : "创建时间",



//"id": "唯一编号",
//"contactName" : "联系人名字",
//"contactPhone" : "联系人电话",
//"address" : "详细地址",
//"isDefault" : 1,
//"street":
//{
//    "street":
//    {
//        "id":"411330300000",
//        "name":"城郊乡",
//        "parentId":"411330000000"
//    },
//    "county":
//    {
//        "id":"411330000000",
//        "name":"桐柏县",
//        "parentId":"411300000000"
//    },
//    "city":
//    {
//        "id":"411300000000",
//        "name":"南阳市",
//        "parentId":"410000000000"
//    },
//    "province":
//    {
//        "id":"410000000000",
//        "name":"河南省",
//        "parentId":"000000000000"
//    }
//}


@property (nonatomic , copy) NSString * idD;
@property (nonatomic , copy) NSString * userId;
@property (nonatomic , copy) NSString * areaId;
@property (nonatomic , copy) NSString * address;
@property (nonatomic , copy) NSString * contactName;
@property (nonatomic , copy) NSString * contactPhone;
@property (nonatomic , copy) NSString * isDefault;
@property (nonatomic , copy) NSString * lastUseDate;
@property (nonatomic , copy) NSString * createdDate;

@property (nonatomic , copy) NSString * provinceid;
@property (nonatomic , copy) NSString * provincename;
@property (nonatomic , copy) NSString * provinceparentId;

@property (nonatomic , copy) NSString * cityid;
@property (nonatomic , copy) NSString * cityname;
@property (nonatomic , copy) NSString * cityparentId;

@property (nonatomic , copy) NSString * countyid;
@property (nonatomic , copy) NSString * countyname;
@property (nonatomic , copy) NSString * countyparentId;



@property (nonatomic , copy) NSString * streetid;
@property (nonatomic , copy) NSString * streetname;
@property (nonatomic , copy) NSString * streetparentId;


+(ShipingAdderssModel*)create:(NSDictionary*)dic;

@end
