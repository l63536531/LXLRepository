//
//  MyOrderModel.h
//  ShopKeeper
//
//  Created by zhough on 16/6/23.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

//@property (nonatomic ) NSInteger pageIndex;
//@property (nonatomic ) NSInteger pageSize;
//@property (nonatomic ) BOOL pageSizeResetAble;
//@property (nonatomic ) NSInteger pageCount;
//@property (nonatomic ) NSInteger rowCount;
//@property (nonatomic ) NSInteger maxRowCount;
//@property (nonatomic ,copy) NSString* paramEncoding;
//@property (nonatomic ,copy) NSString* pageIndexKey;
//@property (nonatomic ,copy) NSString* pageIndexKeyStr;
//@property (nonatomic ) NSArray*  paramList;



//订单块
@property (nonatomic ,copy) NSString* orderId;
@property (nonatomic ,copy) NSString* userId;
@property (nonatomic ) CGFloat paidAmount;
@property (nonatomic ,copy) NSString*  code;
@property (nonatomic ) NSInteger  state;
@property (nonatomic ,copy) NSString*  orderStateDes;
@property (nonatomic ,copy) NSString*  orderPayMethodDes;
@property (nonatomic ,copy) NSString*  settleDate;
@property (nonatomic ,copy) NSString*  lastUpdatedDate;
@property (nonatomic ) NSInteger activityType;
@property (nonatomic ) NSInteger bonus;

@property (nonatomic ) NSInteger isdelay;

@property (nonatomic ) NSInteger allGoodsComment;
@property (nonatomic ) NSArray*  goodsList;



+(MyOrderModel*)create:(NSDictionary*)dic;
@end


//"isdelay":***,  // 1，已延迟；0，没有延迟,
//"deliveryDate":***,  // 发货时间
//"activityType":****,  // 订单类型  6为积分支付
//"allGoodsComment":****，所有商品是否都已评价
//
//
//
//
//
//"activityType":0,
//"allGoodsComment":true,
//"pageIndex":1,
//"pageSize":2,
//"pageSizeResetAble":false,
//"maxPageSize":5000,
//"pageCount":86,
//"rowCount":172,
//"maxRowCount":0,
//"list":[
//        {
//            "orderId":"bbe9dd58-45cf-430b-a82f-01f1e387546b",
//            "userId":"aa3eab7e-ec59-4fbc-be62-969bfbe65395",
//            "paidAmount":999,
//            "code":"55755746012",
//            "state":102,
//            "orderStateDes":"超期未支付",
//            "orderPayMethodDes":"",
//            "settleDate":"2016-06-02 16:22:36",
//            "lastUpdatedDate":"2016-06-02 16:22:36",
//            "goodsList":[
//                         {
//                             "goodsSpecificationId":"28e9bd1e-54db-4e5a-ba78-cf38c19128e3",
//                             "goodsId":"51f5532a-f338-41ba-b49f-d073ffdce7c4",
//                             "shopId":"92c1cdd8-fd6b-4b5d-a0e9-f3b210cdf92e",
//                             "logoId":"66010efd-5f68-4c21-bb20-810cf140b785",     // 图片id
//                             "specPrice":950,
//                             "title":"小米 智能手机 红米note3公开版 双卡双待 屏幕5.5寸 内存2GB+16G",
//                             "subTitle":"支持移动4G 4000毫安超长待机 !性价比之王！",
//                             "specificationDesc":"套餐: 官方标配; 颜色: 白色; 快递: 申通"
//                         }
//                         ]
//        }        ],
//"paramEncoding":"utf-8",
//"paramList":[
//
//],
//"pageIndexKey":"pageHolder.pageIndex",
//"pageIndexKeyStr":"pageHolder.pageIndexStr"