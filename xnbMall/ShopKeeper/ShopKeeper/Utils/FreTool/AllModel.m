//
//  SaleActivityController.m
//  ShopKeeper
//
//  Created by frechai on 16/10/19.
//  Copyright © 2016年 51xnb. All rights reserved.
//

#import "AllModel.h"
#import "MyUtile.h"
@implementation AllModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSString *msg = [NSString stringWithFormat:@"接口数据Model类:%@ 未发现:%@字段，需要检查接口定义", [self class], key];
   // DebugLog(@"%@", msg);
    
}
@end

@implementation Model_Req_Empty

@end
@implementation Model_Req
//-(NSString*)token
//{
//    _token=[MyUtile get]
//
//}
//- (void)setToken:(NSString *)token
//{
//
//
//}
@end
@implementation Model_Rsp@end
@implementation Model_Interface@end
/////////////////////////////////////////////////////////////////////////////////
@implementation Model_goods_ysttopcategory_Req@end
@implementation Model_goods_ysttopcategory_data@end
@implementation Model_goods_ysttopcategory_Rsp@end
/////////////////////////////////////////////////////////////////////////////
@implementation Model_goods_ystthirdcategorybyfid_data@end
//请求
@implementation Model_goods_ystthirdcategorybyfid_Req@end
//响应
@implementation Model_goods_ystthirdcategorybyfid_Rsp@end

///////////////////////////////////////////////////////////////////////////////
@implementation Model_pricing_centerPricingList_data @end
//请求
@implementation Model_pricing_centerPricingList_Req@end
//响应
@implementation Model_pricing_centerPricingList_Rsp@end
/////////////////////////////////////////////////////////////////////////////////
#pragma mark 1.1.1、检查上架或下架的商品中有无漏选规格

@implementation Model_pricing_checkReleaseGoods_goods@end
//请求
@implementation Model_pricing_checkReleaseGoods_Req@end
//响应
@implementation Model_pricing_checkReleaseGoods_Rsp@end
///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 1.1.2、定价的发布/下架接口
@implementation Model_pricing_releaseGoods_goods@end
//请求
@implementation Model_pricing_releaseGoods_Req@end
//响应
@implementation Model_pricing_releaseGoods_Rsp@end

/////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 1.1.3、店铺定价查询接口
@implementation Model_pricing_shopPricingList_data@end
//请求
@implementation Model_pricing_shopPricingList_Req@end
//响应
@implementation Model_pricing_shopPricingList_Rsp@end
///////////////////////////////////////////////////////////////////////////////////
#pragma mark    7.1.0 农掌柜店铺首页
@implementation Model_keeper_keeperindex_data_shopList@end
@implementation Model_keeper_keeperindex_data_orderStatistics@end
@implementation Model_keeper_keeperindex_data@end
//请求
@implementation Model_keeper_keeperindex_Req@end
//响应
@implementation Model_keeper_keeperindex_Rsp@end
////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 2.1.0获取首页banner广告

@implementation Model_ad_banner_data@end

//请求
@implementation Model_ad_banner_Req@end
//响应
@implementation Model_ad_banner_Rsp@end


//////////////////////////////////////////////////////////////////////////
#pragma mark 7.4.0 查询我负责的服务店铺列表

@implementation Model_keeper_myshops_data@end
//请求
@implementation Model_keeper_myshops_Req@end
//响应
@implementation Model_keeper_myshops_Rsp@end

#pragma  NSString *surl = [NSString stringWithFormat:@"%@/login/login.do",SERVER_ADDR_XNBZG];用户登录

@implementation Model_login_login_data_uiyp@end
@implementation Model_login_login_data@end
//请求
@implementation Model_login_login_Req@end
//响应
@implementation Model_login_login_Rsp@end

#pragma 2.1.3、查询当前查询条件下商品结果集合里涉及的品牌
@implementation Model_goods_searchbrands_data@end
//请求
@implementation Model_goods_searchbrands_Req@end
//响应
@implementation Model_goods_searchbrands_Rsp@end

#pragma 2.2.0、商品信息综合查询
@implementation Model_goods_ystsearch_data_list_goodsPrice @end
@implementation Model_goods_ystsearch_data_list @end
@implementation Model_goods_ystsearch_data@end
//请求
@implementation Model_goods_ystsearch_Req@end
//响应
@implementation Model_goods_ystsearch_Rsp@end
///////////////////////////////////////////////////////////////
#pragma  蛙宝金融
//请求
@implementation Model_supplychainfinance_addApply_Req@end
//响应
@implementation Model_supplychainfinance_addApply_Rsp@end
////////////////////////////////////////////////////////////
#pragma 个人中心订单个数
@implementation Model_order_ystordercount_data @end
//请求
@implementation Model_order_ystordercount_Req@end
//响应
@implementation Model_order_ystordercount_Rsp@end
///////////////////////////////////////////////////////////////
#pragma 退出登录
//请求
@implementation Model_login_logout_Req@end
//响应
@implementation  Model_login_logout_Rsp@end
/////////////////////////////////////////////////////////////////
#pragma 清空历史记录
@implementation Model_goods_clearsearchhistory_Req@end
//响应
@implementation  Model_goods_clearsearchhistory_Rsp@end
//////////////////////////////////////////////////////////////////
#pragma 查询历史记录
@implementation Model_goods_searchhistory_data@end
//请求
@implementation Model_goods_searchhistory_Req@end
//响应
@implementation  Model_goods_searchhistory_Rsp@end
////////////////////////////////////////////////////////////////////////
#pragma 保存历史记录
//请求
@implementation Model_goods_savesearchhistory_Req@end
//响应
@implementation  Model_goods_savesearchhistory_Rsp@end
/////////////////////////////////////////////////////////////////////////////
#pragma 9.1.2消息详细
@implementation Model_message_messageDetail_data
@end
//请求
@implementation Model_message_messageDetail_Req@end
//响应
@implementation  Model_message_messageDetail_Rsp@end
////////////////////////////////////////////////////////////////////////////
#pragma 2.4.2、使用商品规格ID获取云商通商品详情
@implementation Model_goods_ystspec_data_goodsPrice@end
@implementation Model_goods_ystspec_data @end
//请求
@implementation Model_goods_ystspec_Req@end
//响应
@implementation  Model_goods_ystspec_Rsp@end
/////////////////////////////////////////////////////////////////////////////////
#pragma 2.5.3、将规格加入购物车
//请求
@implementation Model_goods_addystcartitem_Req@end
//响应
@implementation  Model_goods_addystcartitem_Rsp@end
/////////////////////////////////////////////////////////////////////////////
#pragma 2.5.8、获取当前用户云商通购物车商品数量
//请求
@implementation Model_goods_ystcartcount_Req@end
//响应
@implementation  Model_goods_ystcartcount_Rsp@end
/////////////////////////////////////////////////////////////////////////////////////
#pragma 2.6.0、查询支持混批模式的所有商品规格
//请求
@implementation Model_goods_ystitemsmixedpacking_Req @end
//响应
@implementation  Model_goods_ystitemsmixedpacking_Rsp@end
//////////////////////////////////////////////////////////////////////////////////////
#pragma 2.10.0、查询商品评价列表
@implementation Model_comment_listappraisal_data_list @end
@implementation Model_comment_listappraisal_data @end
//请求
@implementation Model_comment_listappraisal_Req@end
//响应
@implementation  Model_comment_listappraisal_Rsp@end
/////////////////////////////////////////////////////////////////////////////////////////
#pragma 2.10.1、提交商品评价

@implementation Model_comment_appraise_comments@end
//请求
@implementation Model_comment_appraise_Req@end
//响应
@implementation  Model_comment_appraise_Rsp @end
////////////////////////////////////////////////////////////////////////////////////////////
#pragma 2.10.2、查询商品评价星标统计
@implementation Model_comment_appraisemark_data@end
//请求
@implementation Model_comment_appraisemark_Req@end
//响应
@implementation  Model_comment_appraisemark_Rsp@end
/////////////////////////////////////////////////////////////////////////////////////////////
#pragma 2.10.3、查询商品评价详细
//请求
@implementation Model_comment_appraisedetail_Req@end
//响应
@implementation  Model_comment_appraisedetail_Rsp@end
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma 3.1.0、云商通订单结算

@implementation  Model_order_ystsettle_data_templateGoodsList_goodsList @end
@implementation  Model_order_ystsettle_data_templateGoodsList@end
@implementation  Model_order_ystsettle_data@end
//请求
@implementation Model_order_ystsettle_Req @end
//响应
@implementation  Model_order_ystsettle_Rsp@end
///////////////////////////////////////////////////////////////////////////////////////
#pragma 8.11.0 问题反馈
//请求
@implementation Model_user_feedback_Req@end
//响应
@implementation  Model_user_feedback_Rsp@end
//////////////////////////////////////////////////////////////////////////////////////
#pragma 5.2.0、资金账户列表
@implementation Model_money_myaccounts_data_account @end
@implementation Model_money_myaccounts_data@end
//请求
@implementation Model_money_myaccounts_Req@end
//响应
@implementation  Model_money_myaccounts_Rsp@end
////////////////////////////////////////////////////////////////////////////////

#pragma 1.1.2 获取用户权限信息
@implementation Model_login_userauth_data_uiyp@end

@implementation Model_login_userauth_data@end
//请求
@implementation Model_login_userauth_Req@end
//响应
@implementation  Model_login_userauth_Rsp@end
/////////////////////////////////////////////////////////////////////////////
@implementation ListModel@end
//////////////////////////////////////////////////////////////////////////////
#pragma 2.9.0、分段查询商城首页商品
@implementation Model_goods_apphotsale_data_goods_goodsPrice@end
@implementation Model_goods_apphotsale_data_goods@end
@implementation Model_goods_apphotsale_data
-(NSMutableArray *)goods
{
    if (_goods==nil) {
        _goods =[[NSMutableArray<Model_goods_apphotsale_data_goods> alloc] init];
    }
    return _goods;
    
}
@end
//请求
@implementation Model_goods_apphotsale_Req@end
//响应
@implementation  Model_goods_apphotsale_Rsp@end
//////////////////////////////////////////////////////////////////////////////
#pragma  8.1.0 查询用户积分余额
@implementation Model_points_balance_data@end
//请求
@implementation Model_points_balance_Req @end
//响应
@implementation  Model_points_balance_Rsp@end