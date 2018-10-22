//
//  NewShelvesModel.m
//  ShopKeeper
//
//  Created by zhough on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import "NewShelvesModel.h"

@implementation NewShelvesModel

+(NewShelvesModel*)create:(NSDictionary*)dic{
    
    NewShelvesModel * model = [[NewShelvesModel alloc] init];
    //"goodsId":"商品ID",
    //"goodsSpecificationId":"商品规格ID",
    //"title":"商品标题",
    //"subTitle":"副标题",
    //"thumbnailUrl":"图片地址",
    //"goodsPrice":{
    //    "centerPrice":"服务中心价格",
    //    "stationPrice":"服务站价格",
    //    "retailsPrice":"零售价",
    //    "memberPrice":"会员价",
    //    "costPrice":"进货价"
    //},
    //"saleNumber"："销量"
    model.goodsId = dic[@"goodsId"];
    model.goodsSpecificationId = dic[@"goodsSpecificationId"];
    model.title = dic[@"title"];
    model.subTitle = dic[@"subTitle"];
    model.thumbnailUrl = dic[@"thumbnailUrl"];
    model.saleNumber = dic[@"saleNumber"];
    model.centerPrice = dic[@"goodsPrice"][@"centerPrice"];
    model.stationPrice = dic[@"goodsPrice"][@"stationPrice"];
    model.retailPrice = dic[@"goodsPrice"][@"retailPrice"];
    model.memberPrice = dic[@"goodsPrice"][@"memberPrice"];
    model.costPrice = dic[@"goodsPrice"][@"costPrice"];

    
    return model;


}

@end
