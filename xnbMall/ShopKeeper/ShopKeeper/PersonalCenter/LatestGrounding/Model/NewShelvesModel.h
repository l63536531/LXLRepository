//
//  NewShelvesModel.h
//  ShopKeeper
//
//  Created by zhough on 16/6/21.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewShelvesModel : NSObject

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

@property(nonatomic , copy) NSString * goodsId;
@property(nonatomic , copy) NSString * goodsSpecificationId;
@property(nonatomic , copy) NSString * title;
@property(nonatomic , copy) NSString * subTitle;
@property(nonatomic , copy) NSString * thumbnailUrl;
@property(nonatomic , copy) NSString * centerPrice;
@property(nonatomic , copy) NSString * stationPrice;
@property(nonatomic , copy) NSString * retailPrice;
@property(nonatomic , copy) NSString * memberPrice;
@property(nonatomic , copy) NSString * costPrice;
@property(nonatomic , copy) NSString * saleNumber;



+(NewShelvesModel*)create:(NSDictionary*)dic;
@end
