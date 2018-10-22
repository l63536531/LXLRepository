//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "JSONModel.h"

@interface AllModel : JSONModel

@end
/////////////////////////////////////////////////////////////////////////////////
//不带用户参数
@interface Model_Req_Empty : AllModel
@end
//带用户参数
@interface Model_Req : AllModel
@property(nonatomic, copy)NSString *token;//校验的token

@end
/////////////////////////////////////////////////////////////////////////////////
@interface Model_Rsp : AllModel
@property(nonatomic,assign)  int code;//返回代码
@property(nonatomic, copy)NSString<Optional> *msg;//提示信息
@end
/////////////////////////////////////////////////////////////////////////////////////
@interface Model_Interface : AllModel

@end
/////////////////////////////////////////////////////////////////////////////////
#pragma mark 一级目录
@protocol Model_goods_ysttopcategory_data
@end
@interface Model_goods_ysttopcategory_data:Model_Interface

@property(nonatomic, copy)NSString <Optional>*id;//提示信息
@property(nonatomic, copy)NSString <Optional>*code;//提示信息
@property(nonatomic, copy)NSString <Optional>*name;//提示信息
//@property(nonatomic, copy)NSString *logoImg;//提示信息
//@property(nonatomic, copy)NSString *parentId;//提示信息
@end
//请求
@interface Model_goods_ysttopcategory_Req : Model_Req
@end
//响应
@interface Model_goods_ysttopcategory_Rsp : Model_Rsp

@property (nonatomic,strong)NSArray<Model_goods_ysttopcategory_data> *data;
@end
///////////////////////////////////////////////////////////////////
#pragma mark 3级目录

@protocol Model_goods_ystthirdcategorybyfid_data @end

@interface Model_goods_ystthirdcategorybyfid_data : Model_Interface
@property(nonatomic, copy)NSString <Optional>*id;
@property(nonatomic, copy)NSString <Optional>*code;
@property(nonatomic, copy)NSString <Optional>*name;
@property(nonatomic, copy)NSString <Optional>*parentId;
@end
//请求
@interface Model_goods_ystthirdcategorybyfid_Req : Model_Req
@property (nonatomic,copy) NSString *firstCid;
@end
//响应
@interface Model_goods_ystthirdcategorybyfid_Rsp : Model_Rsp

@property (nonatomic,strong)NSArray<Model_goods_ystthirdcategorybyfid_data> *data;
@end
/////////////////////////////////////////////////////////////////////////////////////////

#pragma mark 服务站定价查询接口1.1.0
@protocol Model_pricing_centerPricingList_data
@end
@interface Model_pricing_centerPricingList_data :Model_Interface
@property(nonatomic, copy)NSString <Optional>*goodsId;
@property(nonatomic, copy)NSString <Optional>*goodsSpecificationId;
@property(nonatomic, copy)NSString <Optional>*specificationDesc;
@property(nonatomic, copy)NSString <Optional>*logoId;
@property(nonatomic, copy)NSString <Optional>*goodsTitle;
@property(nonatomic, copy)NSString <Optional>*goodsSubTitle;
@property(nonatomic, assign)BOOL isExplosiveGoods;
@property(nonatomic, copy)NSString <Optional>*pc;
@property(nonatomic, copy)NSString <Optional>*ps;
@property(nonatomic, copy)NSString <Optional>*pb;
@property(nonatomic, copy)NSString <Optional>*pricingPB;
@property(nonatomic, copy)NSString <Optional>*profit;
@property(nonatomic, copy)NSString <Optional>*sortDate;
@property(nonatomic, copy)NSString <Optional>*centerPS;
@property(nonatomic, copy)NSString <Optional>*state;//上/下架状态 :1、上架；0：下架
@property(nonatomic, copy)NSString <Optional>*unshelveType;//下架类型:0，中心下架；1，厂家下架；2，厂家价格变动自动下架
@property(nonatomic, copy)NSString <Optional>*pcTrend;//进货价变化趋势：-1、下降；0：没变；1：上升
@property(nonatomic, copy)NSString <Optional>*psTrend; //批发价变化趋势：-1、下降；0：没变；1：上升
@property(nonatomic, copy)NSString <Optional>*pbTrend; //零售价变化趋势：-1、下降；0：没变；1：上升
@property(nonatomic, copy)NSString <Optional>*profitTrend; //利润变化趋势：-1、下降；0：没变；1：上升
@property (nonatomic,copy)NSString <Optional>*coule_Choose;//是否可以搞
@end
//请求
@interface Model_pricing_centerPricingList_Req : Model_Req
@property(nonatomic, copy)NSString *searchKey;
@property(nonatomic, copy)NSString *firstCategory;
@property(nonatomic, copy)NSString *threeCategory;
@property(nonatomic, copy)NSString *flag;
@property(nonatomic, copy)NSString *sortDate;
@property(nonatomic, copy)NSString *operationType;
@end
//响应
@interface Model_pricing_centerPricingList_Rsp : Model_Rsp
@property (nonatomic,strong)NSArray<Model_pricing_centerPricingList_data> *data;
@end
///////////////////////////////////////////////////////////////////////////////////////////

#pragma mark 1.1.1、检查上架或下架的商品中有无漏选规格
@protocol Model_pricing_checkReleaseGoods_goods @end
@interface Model_pricing_checkReleaseGoods_goods :Model_Interface
@property(nonatomic, copy)NSString *goodsId;
@property(nonatomic, copy)NSString *specId;
@end
//请求
@interface Model_pricing_checkReleaseGoods_Req :Model_Req
@property(nonatomic, copy)NSString *pricingType;
@property(nonatomic, copy)NSString *operationType;
@property(nonatomic, copy)NSString *state;
@property (nonatomic,strong)NSArray<Model_pricing_checkReleaseGoods_goods> *goods;
@end
//响应
@interface Model_pricing_checkReleaseGoods_Rsp :Model_Rsp
@end
///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 1.1.2、定价的发布/下架接口
@protocol Model_pricing_releaseGoods_goods @end
@interface Model_pricing_releaseGoods_goods :Model_Interface
@property(nonatomic, copy)NSString *goodsId;
@property(nonatomic, copy)NSString *specId;
@property(nonatomic, copy)NSString *prices;
@end

//请求
@interface Model_pricing_releaseGoods_Req:Model_Req
@property(nonatomic, copy)NSString *pricingType;
@property(nonatomic, copy)NSString *operationType;
@property(nonatomic, copy)NSString *state;
@property (nonatomic,strong)NSMutableArray<Model_pricing_releaseGoods_goods> *goods;
@end
//响应
@interface Model_pricing_releaseGoods_Rsp:Model_Rsp
@end
///////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark 1.1.3、店铺定价查询接口

@protocol Model_pricing_shopPricingList_data
@end
@interface Model_pricing_shopPricingList_data :Model_Interface
@property(nonatomic, copy)NSString <Optional>*goodsId;
@property(nonatomic, copy)NSString <Optional>*goodsSpecificationId;
@property(nonatomic, copy)NSString <Optional>*specificationDesc;
@property(nonatomic, copy)NSString <Optional> *logoId;
@property(nonatomic, copy)NSString <Optional>*goodsTitle;
@property(nonatomic, copy)NSString <Optional>*goodsSubTitle;
@property(nonatomic, assign)BOOL  isExplosiveGoods;
@property(nonatomic, copy)NSString <Optional>*pc;
@property(nonatomic, copy)NSString <Optional>*ps;
@property(nonatomic, copy)NSString <Optional>*pb;
@property(nonatomic, copy)NSString <Optional>*pricingPB;
@property(nonatomic, copy)NSString <Optional>*profit;
@property(nonatomic, copy)NSString <Optional>*sortDate;

@property(nonatomic, copy)NSString <Optional>*state;//上/下架状态 :1、上架；0：下架
@property(nonatomic, copy)NSString <Optional>*unshelveType;//下架类型:0，中心下架；1，厂家下架；2，厂家价格变动自动下架
@property(nonatomic, copy)NSString <Optional>*pcTrend;//进货价变化趋势：-1、下降；0：没变；1：上升
@property(nonatomic, copy)NSString <Optional>*psTrend; //批发价变化趋势：-1、下降；0：没变；1：上升
@property(nonatomic, copy)NSString <Optional>*pbTrend; //零售价变化趋势：-1、下降；0：没变；1：上升
@property(nonatomic, copy)NSString <Optional>*profitTrend; //利润变化趋势：-1、下降；0：没变；1：上升
@property (nonatomic,copy)NSString  <Optional>*coule_Choose;//是否可以搞
@end

//请求
@interface Model_pricing_shopPricingList_Req : Model_Req
@property(nonatomic, copy)NSString *searchKey;
@property(nonatomic, copy)NSString *firstCategory;
@property(nonatomic, copy)NSString *threeCategory;
@property(nonatomic, copy)NSString *flag;
@property(nonatomic, copy)NSString *sortDate;
@property(nonatomic, copy)NSString *operationType;
@end
//响应
@interface Model_pricing_shopPricingList_Rsp : Model_Rsp
@property (nonatomic,strong)NSArray<Model_pricing_shopPricingList_data> *data;
@end
///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark    7.1.0 农掌柜店铺首页
@protocol Model_keeper_keeperindex_data_shopList
@end
@interface Model_keeper_keeperindex_data_shopList:Model_Interface
@property(nonatomic, copy)NSString <Optional>*createTime;
@property(nonatomic, copy)NSString <Optional>*createUserid;
@property(nonatomic, copy)NSString <Optional>*id;
@property(nonatomic, copy)NSString <Optional>*latitude;
@property(nonatomic, copy)NSString <Optional>*longitude;
@property(nonatomic, copy)NSString <Optional>*nickName;
@property(nonatomic, copy)NSString <Optional>*shopName;
@property(nonatomic, copy)NSString <Optional>*state;
@property(nonatomic, copy)NSString <Optional>*title;
@end
@interface Model_keeper_keeperindex_data_orderStatistics :Model_Interface
@property (nonatomic,copy)NSString <Optional>*completedCount;
@property (nonatomic,copy)NSString <Optional>* earningsToday;
@property (nonatomic,copy)NSString <Optional>* earningsYesterday;
@property (nonatomic,copy)NSString <Optional>* waitForPaymentCount;
@property (nonatomic,copy)NSString <Optional>* waitForReceivedCount;
@property (nonatomic,copy)NSString <Optional>* waitForShippingCount;
@end
@interface Model_keeper_keeperindex_data :Model_Interface
@property (nonatomic,strong) NSArray<Model_keeper_keeperindex_data_shopList> *shopList;
@property (nonatomic,strong) Model_keeper_keeperindex_data_orderStatistics *orderStatistics;
@property (nonatomic,strong)NSString *defaultShopId;
@property (nonatomic,assign)BOOL shopsetprice;
@property (nonatomic,assign)BOOL selfsetprice;
@end
//请求
@interface Model_keeper_keeperindex_Req : Model_Req
@property (nonatomic,strong)NSString *shopId;
@end
//响应
@interface Model_keeper_keeperindex_Rsp : Model_Rsp
@property (nonatomic,strong)Model_keeper_keeperindex_data <Optional>*data;
@end
///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 2.1.0获取首页banner广告


@protocol Model_ad_banner_data@end
@interface Model_ad_banner_data : Model_Interface
@property (nonatomic,copy)NSString *imgUrl;
@property (nonatomic,copy)NSString *link;
@property (nonatomic,copy)NSString *mainImageFileId;
//@property (nonatomic,copy)NSString *location;
@end

//请求
@interface Model_ad_banner_Req : Model_Req_Empty
@property (nonatomic,copy)NSString *areaId;
@property (nonatomic,copy)NSString *location;
@end
//响应
@interface Model_ad_banner_Rsp : Model_Rsp
@property (nonatomic,strong)NSArray <Model_ad_banner_data> *data;
@end
//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 7.4.0 查询我负责的服务店铺列表

@protocol Model_keeper_myshops_data@end
@interface Model_keeper_myshops_data : Model_Interface
@property(nonatomic, copy)NSString *createTime;
@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString <Optional>*lastupdateTime;
@property(nonatomic, copy)NSString *nickName;
@property(nonatomic, copy)NSString *shopName;
@property(nonatomic, copy)NSString *state;
@property(nonatomic, copy)NSString *title;
@end
//请求
@interface Model_keeper_myshops_Req : Model_Req
@property (nonatomic,strong)NSString *shopId;
@end
//响应
@interface Model_keeper_myshops_Rsp : Model_Rsp
@property (nonatomic,strong)NSArray <Model_keeper_myshops_data> *data;
@end

#pragma  NSString *surl = [NSString stringWithFormat:@"%@/login/login.do",SERVER_ADDR_XNBZG];用户登录

//@protocol Model_login_login_data_uiyp_areaIds@end
//
//@interface Model_login_login_data_uiyp_areaIds : Model_Interface
//
//@end
//@protocol Model_login_login_data_uiyp_areaNames@end

@protocol Model_login_login_data_uiyp_memberShipsMap@end

@interface Model_login_login_data_uiyp : Model_Interface
@property (nonatomic,strong)NSArray *areaIds;
@property (nonatomic,strong)NSArray *areaNames;
@property (nonatomic,strong)NSString *currentMembershopId;
@property (nonatomic,assign)BOOL managerPermission;
@property (nonatomic,strong)NSDictionary *memberShipsMap;
@property (nonatomic,assign)BOOL operationPermission;
@property (nonatomic,assign)BOOL serviceCenterPermission;
@property (nonatomic,assign)BOOL serviceStationPermission;
@property (nonatomic,assign)BOOL shopMemberPermission;
@property (nonatomic,assign)BOOL ystPermission;
@property (nonatomic,strong)NSString *preferredAreaId;
@property (nonatomic,strong)NSString *serviceStationId;
@property (nonatomic,strong)NSString *stationOrCenterId;

@end

@interface Model_login_login_data : Model_Interface
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *userid;
@property (nonatomic,strong)Model_login_login_data_uiyp *uiyp;
@end
//请求
@interface Model_login_login_Req : Model_Req_Empty
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *appType;
@end
//响应
@interface Model_login_login_Rsp : Model_Rsp
@property (nonatomic,strong)Model_login_login_data *data;
@end
/////////////////////////////////////////////////////////////////////////////////////
#pragma 2.1.3、查询当前查询条件下商品结果集合里涉及的品牌
@protocol Model_goods_searchbrands_data @end

@interface Model_goods_searchbrands_data: Model_Interface
@property (nonatomic,strong)NSString <Optional>*createdDate;
@property (nonatomic,strong)NSString <Optional>*createdUserId;
@property (nonatomic,strong)NSString <Optional>*id;
@property (nonatomic,strong)NSString <Optional>*name;
@property (nonatomic,strong)NSString <Optional>*ownerShopId;
@property (nonatomic,strong)NSString <Optional>*state;

@end
//请求
@interface Model_goods_searchbrands_Req : Model_Req
@property (nonatomic,strong)NSString *keywords;
@property (nonatomic,strong)NSString *categoryId;
@end
//响应
@interface Model_goods_searchbrands_Rsp : Model_Rsp
@property (nonatomic,strong)NSArray <Model_goods_searchbrands_data> *data;
@end
///////////////////////////////////////////////////////////////////////////////////////////
#pragma 2.2.0、商品信息综合查询
@interface Model_goods_ystsearch_data_list_goodsPrice : Model_Interface
@property (nonatomic,strong)NSString <Optional>*centerPrice;
@property (nonatomic,strong)NSString <Optional>*stationPrice;
@property (nonatomic,strong)NSString <Optional>*retailPrice;
@property (nonatomic,strong)NSString <Optional>*memberPrice;
@property (nonatomic,strong)NSString <Optional>*costPrice;
@end
@protocol Model_goods_ystsearch_data_list@end
@interface Model_goods_ystsearch_data_list : Model_Interface
@property (nonatomic,strong)NSString <Optional>*goodsId;
@property (nonatomic,strong)NSString <Optional>*goodsSpecId;
@property (nonatomic,strong)NSString <Optional>*subTitle;
@property (nonatomic,strong)NSString <Optional>*thumbnailUrl;
@property (nonatomic,strong)NSString <Optional>*saleNumber;
@property (nonatomic,strong)NSString <Optional>*title;
@property (nonatomic,assign)BOOL freeShipping;
@property (nonatomic,strong)Model_goods_ystsearch_data_list_goodsPrice <Optional>*goodsPrice;

@end
@interface Model_goods_ystsearch_data:Model_Interface
@property (nonatomic,strong)NSString *total;
@property (nonatomic,strong)NSArray<Model_goods_ystsearch_data_list> *list;
@end
//请求
@interface Model_goods_ystsearch_Req : Model_Req
@property (nonatomic,strong)NSString *keywords;
@property (nonatomic,strong)NSString *categoryId;
@property (nonatomic,strong)NSString *brandId;
@property (nonatomic,strong)NSString *pageIndex;
@property (nonatomic,strong)NSString *pageSize;
@end
//响应
@interface Model_goods_ystsearch_Rsp : Model_Rsp
@property (nonatomic,strong)Model_goods_ystsearch_data <Optional>*data;
@end
////////////////////////////////////////////////////////////////////////////////////////
#pragma 挖宝金融
//请求
@interface Model_supplychainfinance_addApply_Req : Model_Req
@property (nonatomic,strong)NSString *borrowerPhone;
@property (nonatomic,strong)NSString *borrowerName;
@property (nonatomic,strong)NSString *borrowPurpose;
@property (nonatomic,strong)NSString *amount;
@end
//响应
@interface Model_supplychainfinance_addApply_Rsp : Model_Rsp
@end
////////////////////////////////////////////////////////////
#pragma 个人中心订单个数
@interface Model_order_ystordercount_data : Model_Interface
@property (nonatomic,copy)NSString *waitForPayOrderCount;
@property (nonatomic,copy)NSString *deliveringOrderCount;
@property (nonatomic,copy)NSString *waitForShippingOrderCount;
@end
//请求
@interface Model_order_ystordercount_Req : Model_Req
@end
//响应
@interface Model_order_ystordercount_Rsp : Model_Rsp
@property (nonatomic,strong)Model_order_ystordercount_data *data;
@end
////////////////////////////////////////////////////////////////////////////////
#pragma 退出登录
//请求
@interface Model_login_logout_Req : Model_Req
@end
//响应
@interface  Model_login_logout_Rsp : Model_Rsp
@end
////////////////////////////////////////////////////////////////////////////////
#pragma 清空历史记录
//请求
@interface Model_goods_clearsearchhistory_Req : Model_Req
@end
//响应
@interface  Model_goods_clearsearchhistory_Rsp : Model_Rsp
@end
////////////////////////////////////////////////////////////////////////////////
//@/goods/searchhistory.do"
#pragma 查询历史记录
@protocol Model_goods_searchhistory_data@end
@interface Model_goods_searchhistory_data :Model_Interface
@property (nonatomic,copy)NSString <Optional>*id;
@property (nonatomic,copy)NSString <Optional>*num;
@property (nonatomic,copy)NSString <Optional>*searchDate;
@property (nonatomic,copy)NSString <Optional>*type;
@property (nonatomic,copy)NSString <Optional>*searchKey;
@property (nonatomic,copy)NSString <Optional>*userId;
@end
//请求
@interface Model_goods_searchhistory_Req : Model_Req
@end
//响应
@interface  Model_goods_searchhistory_Rsp : Model_Rsp
@property (nonatomic,strong)NSArray <Model_goods_searchhistory_data> *data;
@end
///////////////////////////////////////////////////////////////////////////////////
#pragma 保存历史记录
//请求
@interface Model_goods_savesearchhistory_Req : Model_Req
@property (nonatomic,copy)NSString *searchKey;
@end
//响应
@interface  Model_goods_savesearchhistory_Rsp : Model_Rsp
@end
////////////////////////////////////////////////////////////////////////////////////////
#pragma 9.1.2消息详细
@interface Model_message_messageDetail_data: Model_Interface
@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *messageType;
@property (nonatomic,copy)NSString <Optional> *notify;
@property (nonatomic,copy)NSString <Optional> *title;
@property (nonatomic,copy)NSString <Optional> *link;
@property (nonatomic,copy)NSString <Optional> *summary;
@property (nonatomic,copy)NSString <Optional> *content;
@property (nonatomic,copy)NSString <Optional> *sendObject;
@property (nonatomic,copy)NSString <Optional> *orderId;
@property (nonatomic,copy)NSString <Optional> *messageMemberDetailId;
@property (nonatomic,copy)NSString <Optional> *state;
@property (nonatomic,copy)NSString <Optional> *source;
@property (nonatomic,copy)NSString <Optional> *createBy;
@property (nonatomic,copy)NSString <Optional> *createTime;

@end
//请求
@interface Model_message_messageDetail_Req : Model_Req
@property (nonatomic,copy)NSString *messageMemberDetailId;
@end
//响应
@interface  Model_message_messageDetail_Rsp : Model_Rsp
@property (nonatomic,strong)Model_message_messageDetail_data *data;
@end
/////////////////////////////////////////////////////////////////////////////////
#pragma 2.4.2、使用商品规格ID获取云商通商品详情
@interface Model_goods_ystspec_data_goodsPrice:Model_Interface
@property (nonatomic,copy)NSString <Optional>*centerPrice;//服务中心价格
@property (nonatomic,copy)NSString <Optional>*costPrice;//进货价"
@property (nonatomic,copy)NSString <Optional>*retailPrice;//零售价
@property (nonatomic,copy)NSString <Optional>*stationPrice;//服务站价格
@end
@interface Model_goods_ystspec_data :Model_Interface
@property (nonatomic,copy)NSString <Optional>*arrivalFreightFee;//到付运费"
@property (nonatomic,copy)NSString <Optional>*arrivalFreightFeeNotes;//到付运费备注
@property (nonatomic,copy)NSString <Optional>*deliveryTime;//发货时间
@property (nonatomic,copy)NSString <Optional>*detailsMobile;//商品详情
@property (nonatomic,copy)NSString <Optional>*goodsId;//商品ID
@property (nonatomic,copy)NSString <Optional>*goodsLogoId;//主图ID
@property (nonatomic,copy)NSString <Optional>*goodsPhotoIdList;//图片ID列表
@property (nonatomic,strong)Model_goods_ystspec_data_goodsPrice <Optional>*goodsPrice;
@property (nonatomic,copy)NSString <Optional>*goodsSpecId;//规格Id
@property (nonatomic,copy)NSString <Optional>*ioq;//增订量2
@property (nonatomic,assign)BOOL  mixBuy;//mixBuy yes NO
@property (nonatomic,copy)NSString <Optional>*templateId;//起订增订模板id
@property (nonatomic,copy)NSString <Optional>*factoryId;//商品的厂家id
@property (nonatomic,copy)NSString <Optional>*logoImg;//http://fs.51xnb.cn/a4,
@property (nonatomic,copy)NSString <Optional>*moq;//起订量
@property (nonatomic,copy)NSString <Optional>*ioqDesc ;
@property (nonatomic,copy)NSString <Optional>*moqDesc ;
//@property (nonatomic,copy)NSString <Optional>*ioq ;
//"ioqDesc": "2件",
//"logoImg": "http://fs.51xnb.cn/85cc6d1f-1f8d-4ed0-9a02-35ef1e35ecce.jpg",
//"mixBuy": true,
//"moq": 1,
//"moqDesc": "5件",


@property (nonatomic,strong)NSDictionary <Optional>*photoList;//图片列表组
@property (nonatomic,copy)NSString <Optional>*salesService;//包装售后
@property (nonatomic,copy)NSString <Optional>*shipAddress;//发货地
@property (nonatomic,copy)NSString <Optional>*shopId;//店铺ID
@property (nonatomic,copy)NSString <Optional>*shopName;//店铺名称
@property (nonatomic,strong)NSDictionary <Optional>*specDescMap;
@property (nonatomic,strong)NSDictionary <Optional>*specTypeMap;
@property (nonatomic,copy)NSString <Optional>*specParams;//规格参数
@property (nonatomic,copy)NSString <Optional>*subTitle;//副标题
@property (nonatomic,copy)NSString <Optional>*title;//标题
@property (nonatomic,copy)NSString <Optional>*saleNumber;//标题
@end
//请求
@interface Model_goods_ystspec_Req : Model_Req
@property (nonatomic,copy)NSString *goodsSpecId;//商品规格ID"
@end
//响应
@interface  Model_goods_ystspec_Rsp : Model_Rsp
@property (nonatomic,strong)Model_goods_ystspec_data *data;
@end
/////////////////////////////////////////////////////////////////////////////
#pragma 2.5.3、将规格加入购物车
//请求
@interface Model_goods_addystcartitem_Req : Model_Req
@property (nonatomic,copy)NSString *goodsSpecificationId;
@property (nonatomic,copy)NSString *number;
@end
//响应
@interface  Model_goods_addystcartitem_Rsp : Model_Rsp
@end
/////////////////////////////////////////////////////////////////////////////
#pragma 2.5.8、获取当前用户云商通购物车商品数量
//请求
@interface Model_goods_ystcartcount_Req : Model_Req
@end
//响应
@interface  Model_goods_ystcartcount_Rsp : Model_Rsp
@property (nonatomic,copy)NSString *data;
@end
/////////////////////////////////////////////////////////////////////////////////////
#pragma 2.6.0、查询支持混批模式的所有商品规格
//请求
@interface Model_goods_ystitemsmixedpacking_Req : Model_Req
@property (nonatomic,copy)NSString *templateId;
@property (nonatomic,copy)NSString *goodsFactoryId;
@property (nonatomic,copy)NSString *lastDate;
@end
//响应
@interface  Model_goods_ystitemsmixedpacking_Rsp : Model_Rsp
@end
//////////////////////////////////////////////////////////////////////////////////////
#pragma 2.10.0、查询商品评价列表
@protocol Model_comment_listappraisal_data_list@end
@interface Model_comment_listappraisal_data_list : Model_Interface
@property (nonatomic,copy)NSString <Optional>*id;
@property (nonatomic,copy)NSString <Optional>*starnum;
@property (nonatomic,copy)NSString <Optional>*mark;
@property (nonatomic,copy)NSString <Optional>*content;
@property (nonatomic,copy)NSString <Optional>*images;
@property (nonatomic,copy)NSString <Optional>*imagesUrl;
@property (nonatomic,copy)NSString <Optional>*orderId;
@property (nonatomic,copy)NSString <Optional>*goodsId;
@property (nonatomic,copy)NSString <Optional>*goodsSpecId;
@property (nonatomic,copy)NSString <Optional>*goodsSpecName;
@property (nonatomic,copy)NSString <Optional>*createUserId;
@property (nonatomic,copy)NSString <Optional>*createUserPhone;
@property (nonatomic,copy)NSString <Optional>*createTime;
@end

@interface Model_comment_listappraisal_data : Model_Interface
@property (nonatomic,copy)NSString <Optional>*maxPageSize;
@property (nonatomic,copy)NSString <Optional>*pageSize;
@property (nonatomic,copy)NSString <Optional>*orderCol;
@property (nonatomic,copy)NSString <Optional>*seq;
@property (nonatomic,copy)NSString <Optional>*orderColSign;
@property (nonatomic,strong)NSArray <Model_comment_listappraisal_data_list,Optional> *list;
@property (nonatomic,assign) BOOL nofresh;
@end
//请求
@interface Model_comment_listappraisal_Req : Model_Req
@property (nonatomic,copy)NSString *goodsId;
@property (nonatomic,copy)NSString *mark;
@property (nonatomic,copy)NSString *lastValue;
@end
//响应
@interface  Model_comment_listappraisal_Rsp : Model_Rsp
@property (nonatomic,strong)Model_comment_listappraisal_data *data;
@end
/////////////////////////////////////////////////////////////////////////////////////////
#pragma 2.10.1、提交商品评价
@protocol Model_comment_appraise_comments @end
@interface Model_comment_appraise_comments : Model_Interface
@property (nonatomic,copy)NSString *starnum;
@property (nonatomic,copy)NSString *mark;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *images;
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,copy)NSString *goodsId;
@property (nonatomic,copy)NSString *goodsSpecId;
@end
//请求
@interface Model_comment_appraise_Req : Model_Req
@property (nonatomic,strong)NSArray<Model_comment_appraise_comments> *comments;
@end
//响应
@interface  Model_comment_appraise_Rsp : Model_Rsp
@end
////////////////////////////////////////////////////////////////////////////////////////////
#pragma 2.10.2、查询商品评价星标统计

@interface Model_comment_appraisemark_data : Model_Interface
@property (nonatomic,copy)NSString <Optional>*goodsId;
@property (nonatomic,copy)NSString <Optional>*qualityGood;
@property (nonatomic,copy)NSString <Optional>*priceGood;
@property (nonatomic,copy)NSString <Optional>*logisticeGood;
@property (nonatomic,copy)NSString <Optional>*serviceGood;
@property (nonatomic,copy)NSString <Optional>*packGood;
@property (nonatomic,copy)NSString <Optional>*qualityBad;
@property (nonatomic,copy)NSString <Optional>*priceBad;
@property (nonatomic,copy)NSString <Optional>*logisticeBad;
@property (nonatomic,copy)NSString <Optional>*serviceBad;
@property (nonatomic,copy)NSString <Optional>*packBad;
@property (nonatomic,copy)NSString <Optional>*allNum;
@end
//请求
@interface Model_comment_appraisemark_Req : Model_Req
@property (nonatomic,strong)NSString *goodsId;
@end
//响应
@interface  Model_comment_appraisemark_Rsp : Model_Rsp
@property(nonatomic,strong)Model_comment_appraisemark_data *data;
@end
/////////////////////////////////////////////////////////////////////////////////////////////
#pragma 2.10.3、查询商品评价详细
//请求
@interface Model_comment_appraisedetail_Req : Model_Req
@property (nonatomic,strong)NSString *goodsId;
@property (nonatomic,strong)NSString *goodsSpecId;
@end
//响应
@interface  Model_comment_appraisedetail_Rsp : Model_Rsp
@end
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma 3.1.0、云商通订单结算
@protocol Model_order_ystsettle_data_templateGoodsList_goodsList @end
@interface  Model_order_ystsettle_data_templateGoodsList_goodsList : Model_Interface
@property (nonatomic,copy)NSString <Optional>*freightFee;
@property (nonatomic,copy)NSString <Optional>*freightPrice;
@property (nonatomic,copy)NSString <Optional>*goodsId;
@property (nonatomic,copy)NSString <Optional>*goodsTitle;
@property (nonatomic,copy)NSString <Optional>*logoId;
@property (nonatomic,copy)NSString <Optional>*logoUrl;
@property (nonatomic,copy)NSString <Optional>*mergePrice;
@property (nonatomic,copy)NSString <Optional>*number;
@property (nonatomic,copy)NSString <Optional>*price;
@property (nonatomic,copy)NSString <Optional>*specDesc;
@property (nonatomic,copy)NSString <Optional>*specId;
@end
@protocol Model_order_ystsettle_data_templateGoodsList @end
@interface  Model_order_ystsettle_data_templateGoodsList : Model_Interface
@property (nonatomic,copy)NSArray <Model_order_ystsettle_data_templateGoodsList_goodsList>*goodsList;
@property (nonatomic,assign)BOOL mixBuy;
@property (nonatomic,copy)NSString <Optional>*templateDescription;
@end
@interface  Model_order_ystsettle_data : Model_Interface
@property (nonatomic,copy)NSString <Optional>*amount;
@property (nonatomic,copy)NSString <Optional>*arriveFreightFeeDesc;
@property (nonatomic,copy)NSString <Optional>*arriveFreightFeeMax;
@property (nonatomic,copy)NSString <Optional>*arriveFreightFeeMin;
@property (nonatomic,copy)NSString <Optional>*freightFee;
@property (nonatomic,copy)NSString <Optional>*giftCardAmount;
@property (nonatomic,assign)BOOL isArrive;
@property (nonatomic,strong)NSArray <Model_order_ystsettle_data_templateGoodsList> *templateGoodsList;
@property (nonatomic,copy)NSString <Optional>*totalAmount;
@property (nonatomic,copy)NSString <Optional>*totalGiftCardAmount;
@end
//请求
@interface Model_order_ystsettle_Req : Model_Req
@property (nonatomic,strong)NSDictionary *goods;
@property (nonatomic,strong)NSString *areaId;
@property (nonatomic,assign)BOOL usedGiftCard;
@end
//响应
@interface  Model_order_ystsettle_Rsp : Model_Rsp
@property (nonatomic,strong)Model_order_ystsettle_data <Optional> *data;
@end
//////////////////////////////////////////////////////////////////////////////////////
#pragma 8.11.0 问题反馈
//请求
@interface Model_user_feedback_Req : Model_Req
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *photoList;
@end
//响应
@interface  Model_user_feedback_Rsp : Model_Rsp
@end
////////////////////////////////////////////////////////////////////////////////////
#pragma 5.2.0、资金账户列表

@interface Model_money_myaccounts_data_account : Model_Interface
@property (nonatomic,copy)NSString <Optional>*balance;
@property (nonatomic,copy)NSString <Optional>*bank;
@property (nonatomic,copy)NSString <Optional>*bankAccount;
@property (nonatomic,copy)NSString <Optional>*bankAccountName;
@property (nonatomic,copy)NSString <Optional>*code;
@property (nonatomic,copy)NSString <Optional>*createdBy;
@property (nonatomic,copy)NSString <Optional>*createdDate;
@property (nonatomic,copy)NSString <Optional>*id;
@property (nonatomic,copy)NSString <Optional>*lastUpdatedBy;
@property (nonatomic,copy)NSString <Optional>*lastUpdatedDate;
@property (nonatomic,copy)NSString <Optional>*nationalidNumber;
@property (nonatomic,copy)NSString <Optional>*ownerId;
@property (nonatomic,copy)NSString <Optional>*status;
@property (nonatomic,copy)NSString <Optional>*type;
@property (nonatomic,copy)NSString <Optional>*withdrawBalance;
@property (nonatomic,copy)NSString <Optional>*yijifuPayerUserId;
@end
@protocol Model_money_myaccounts_data @end
@interface Model_money_myaccounts_data :Model_Interface
@property (nonatomic,copy)NSString *walletType;
@property (nonatomic,strong)Model_money_myaccounts_data_account *account;
@end
//请求
@interface Model_money_myaccounts_Req : Model_Req
@end
//响应
@interface  Model_money_myaccounts_Rsp : Model_Rsp
@property (nonatomic,strong)NSArray <Model_money_myaccounts_data> *data;
@end
////////////////////////////////////////////////////////////////////////////////////

#pragma 1.1.2 获取用户权限信息
@interface Model_login_userauth_data_uiyp : Model_Interface
@property (nonatomic,strong) NSArray *areaIds;
@property (nonatomic,strong) NSArray *areaNames;
@property (nonatomic,copy)NSString <Optional>*currentMembershopId;
@property (nonatomic,assign)BOOL managerPermission;
@property (nonatomic,strong)NSDictionary <Optional>*memberShipsMap;
@property (nonatomic,assign)BOOL operationPermission;
@property (nonatomic,copy)NSString <Optional>*preferredAreaId;
@property (nonatomic,assign)BOOL serviceCenterPermission;
@property (nonatomic,assign)BOOL serviceStationPermission;
@property (nonatomic,assign)BOOL shopMemberPermission;
@property (nonatomic,assign)BOOL ystPermission;
@end

@interface Model_login_userauth_data : Model_Interface
@property (nonatomic,copy)NSString <Optional>*token;
@property (nonatomic,copy)NSString <Optional>*userid;
@property (nonatomic,assign)BOOL jmember;
@property (nonatomic,copy)Model_login_userauth_data_uiyp <Optional>*uiyp;
@end
//请求
@interface Model_login_userauth_Req : Model_Req
@end
//响应
@interface  Model_login_userauth_Rsp : Model_Rsp
@property (nonatomic,strong)Model_login_userauth_data *data;
@end
/////////////////////////////////////////////////////////////////////////////
#pragma 临时的
@interface ListModel:JSONModel
@property (nonatomic, strong) NSString<Optional> *memberAreaId;
@property (nonatomic, strong) NSString<Optional> *memberId;
@property (nonatomic, strong) NSString<Optional> *memberShipName;
@property (nonatomic, strong) NSString<Optional> *membershipId;
@property (nonatomic, strong) NSString<Optional> *shopId;
@property (nonatomic, strong) NSString<Optional> *shopName;
@property (nonatomic, strong) NSString<Optional> *memberAreaName;
@end
///////////////////////////////////////////////////////////////////////////////
#pragma 2.9.0、分段查询商城首页商品

@interface Model_goods_apphotsale_data_goods_goodsPrice :Model_Interface
@property (nonatomic, copy) NSString<Optional> *costPrice;
@property (nonatomic, copy) NSString<Optional> *retailPrice;
@property (nonatomic, copy) NSString<Optional> *stationPrice;
@end
@protocol Model_goods_apphotsale_data_goods @end
@interface Model_goods_apphotsale_data_goods :Model_Interface
@property (nonatomic, assign) BOOL freeShipping;
@property (nonatomic, copy) NSString<Optional> *goodsId;
@property (nonatomic, copy) NSString<Optional> *goodsSpecId;
@property (nonatomic, copy) NSString<Optional> *saleNumber;
@property (nonatomic, copy) NSString<Optional> *subTitle;
@property (nonatomic, copy) NSString<Optional> *templateIndex;
@property (nonatomic, copy) NSString<Optional> *thumbnailUrl;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, strong) Model_goods_apphotsale_data_goods_goodsPrice *goodsPrice;
@end
@protocol Model_goods_apphotsale_data @end
@interface Model_goods_apphotsale_data :Model_Interface
@property (nonatomic, copy) NSString<Optional> *catogeryId;
@property (nonatomic, copy) NSString<Optional> *catogeryName;
@property (nonatomic, copy) NSString<Optional> *contentIndex;
@property (nonatomic,strong)NSMutableArray <Model_goods_apphotsale_data_goods> *goods;
@end
//请求
@interface Model_goods_apphotsale_Req : Model_Req
@property (nonatomic, strong) NSString *lastIndex;
@end
//响应
@interface  Model_goods_apphotsale_Rsp : Model_Rsp
@property (nonatomic,strong)NSArray <Model_goods_apphotsale_data> *data;
@end
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma  8.1.0 查询用户积分余额

@interface Model_points_balance_data : Model_Interface
@property (nonatomic, strong) NSString <Optional>*balance;
@end
//请求
@interface Model_points_balance_Req : Model_Req
@end
//响应
@interface  Model_points_balance_Rsp : Model_Rsp
@property (nonatomic,strong)Model_points_balance_data *data;
@end
//////////////////////////////////////////////////////////////////////////////








