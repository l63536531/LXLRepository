//
//  TransDataProxyCenter.h
//  ShopKeeper
//
//  Created by zhough on 16/6/7.
//  Copyright © 2016年 zzheron. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ERROR_DOMAIN_REQUEST @"ERROR_DOMAIN_REQUEST"
#define ERROR_DOMAIN_HTTP @"ERROR_DOMAIN_HTTP"
#define ERROR_DOMAIN_BUSINESS @"ERROR_DOMAIN_BUSINESS"
#define ERROR_DOMAIN_JSON @"ERROR_DOMAIN_JSON"

@interface TransDataProxyCenter : NSObject
+(TransDataProxyCenter*) shareController;


- (void) querytexttodayblock:(void (^)(NSDictionary *dic, NSError *error))block;

//登录
- (void) login:(NSString*)username passwd:(NSString*)passwd block:(void (^)(NSDictionary *dic, NSError *error))block;
//退出登录  --
- (void) loginOut:(void (^)(NSDictionary *dic, NSError *error))block;

//性别修改  --
- (void) queryGender:(NSString*)gender block:(void (^)(NSDictionary *dic, NSError *error))block;

//修改昵称  --
- (void) queryNickName:(NSString*)nickName block:(void (^)(NSDictionary *dic, NSError *error))block;


//8.7.0 查询当前用户的个人信息
- (void) queryUserInfoblock:(void (^)(NSDictionary *dic, NSError *error))block;

//地理位置修改
- (void) queryAreaId:(NSString*)areaId block:(void (^)(NSDictionary *dic, NSError *error))block;
//8.1.0 查询用户积分余额
- (void) pointsBalanceblock:(void (^)(NSDictionary *dic, NSError *error))block;
//8.1.1 查询用户积分流水
- (void) pointsflow:(NSString*)nickName block:(void (^)(NSDictionary *dic, NSError *error))block;
//8.9.3 提交云商通会员卡充值信息
- (void) ystmemberrechargeaId:(NSString*)aid chargeAmount:(NSString*)chargeAmount PhotoId:(NSString*)PhotoId block:(void (^)(NSDictionary *dic, NSError *error))block;

//#pragma mark 8.9.4 查询云商通会员卡充值记录
- (void) ystmemberrechargerecordsaId:(NSString*)aid pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block;

//8.9.5 查询云商通会员卡的资金流水
- (void) ystmemberflowaId:(NSString*)aid pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block;


//资金账户列表 -- 已经调试
- (void) querymyaccountsblock:(void (^)(NSDictionary *dic, NSError *error))block;

//资金账户详情 --
- (void) queryAccounts:(NSString*)aid block:(void (^)(NSDictionary *dic, NSError *error))block;


//资金账户绑定的银行卡
- (void) queryBankcards:(NSString*)aid block:(void (^)(NSDictionary *dic, NSError *error))block;


//资金账户绑定银行卡 --
- (void) queryBindcard:(NSString*)aid  bankNO:(NSString*)bankNO bankName:(NSString*)bankName bankUserName:(NSString*)bankUserName IDCardNO:(NSString*)IDCardNO block:(void (^)(NSDictionary *dic, NSError *error))block;

//设置默认的银行卡
- (void) querySetDefaultCard:(NSString*)aid  cid:(NSString*)cid block:(void (^)(NSDictionary *dic, NSError *error))block;

//删除银行卡
- (void) queryDeleteCard:(NSString*)cid  pwd:(NSString*)pwd block:(void (^)(NSDictionary *dic, NSError *error))block;

//查询资金明细
- (void) queryFlow:(NSString*)aid pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block;
//查询提现请求
- (void) queryListwithdraw:(NSString*)aid pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block;

//资金账户提现请求预评估

- (void) queryAssesWithdraw:(NSString*)aid block:(void (^)(NSDictionary *dic, NSError *error))block;

//资金账户请求提现

- (void) queryWithdraw:(NSString*)aid pwd:(NSString*)pwd amount:(NSString*)amount block:(void (^)(NSDictionary *dic, NSError *error))block;

//设置用户个人头像

- (void) querySetphoto:(NSString*)logoId block:(void (^)(NSDictionary *dic, NSError *error))block;



//查询当前用户的收获地址清单

- (void) queryMyaddressblock:(void (^)(NSDictionary *dic, NSError *error))block;


//删除当前用户的收货地址

- (void) queryDeleteaddress:(NSString*)rid block:(void (^)(NSDictionary *dic, NSError *error))block;


//添加或者修改当前用户的收货地址

- (void) queryAddaddress:(NSString*)rid contactName:(NSString*)contactName contactPhone:(NSString*)contactPhone areaId:(NSString*)areaId address:(NSString*)address isDefault:(NSString*)isDefault block:(void (^)(NSDictionary *dic, NSError *error))block;

//设置当前用户的默认收货地址

- (void) querySetdefaultaddress:(NSString*)rid block:(void (^)(NSDictionary *dic, NSError *error))block;

//上报定位

- (void) queryMylocation:(NSString*)stationId latitude:(NSString*)latitude longitude:(NSString*)longitude block:(void (^)(NSDictionary *dic, NSError *error))block;

//查询最近上架的商品

- (void) queryYstnewarrival:(NSString*)pageIndex pageSize:(NSString*)pageSize block:(void (^)(NSDictionary *dic, NSError *error))block;

//查询当前用户的所有云商通会员卡列表

- (void) queryMyystmembersblock:(void (^)(NSDictionary *dic, NSError *error))block;

//问题反馈

- (void) queryfeedback:(NSString*)content photoList:(NSString*)photoList block:(void (^)(NSDictionary *dic, NSError *error))block;


//查询登录用户的云商通订单计数

- (void) queryYstordercountblock:(void (^)(NSDictionary *dic, NSError *error))block;


//视频
- (void) queryLearnVideoblock:(void (^)(NSDictionary *dic, NSError *error))block;

// 查询登录用户的云商通订单

- (void) queryYtorders:(int)state searchKey:(NSString*)searchKey pageIndex:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block;


//3.2.1、启动订单支付;

- (void) queryPayOrderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block;

//3.3.2、查询订单详情

- (void) querydetailorderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block;
//3.3.3、查询订单追踪信息

- (void) querytrackorderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block;

//3.4.0、查询我服务的订单

- (void) querymyserviceorders:(int)state searchKey:(NSString*)searchKey pageIndex:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block;

//3.4.0、查询辖区订单

- (void) queryMyruleorders:(int)state searchKey:(NSString*)searchKey pageIndex:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block;
//3.7.0 确认收货
- (void) queryReceiveorderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block;

//3.8.0 延迟收货
- (void) querydelayreceiveorderId:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block;

//查询指定id的用户最新的云商通会员卡信息
- (void) queryMyystmember:(NSString*)aid block:(void (^)(NSDictionary *dic, NSError *error))block;

//3.2.1、启动订单支付
- (void) queryorderpay:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block;

//3.6.0 删除订单
- (void) queryOrderBelete:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block;
//4.2.2 查询当前用户的礼券余额

- (void) queryGiftcardBalanceblock:(void (^)(NSDictionary *dic, NSError *error))block;
//4.2.3 激活礼券

- (void) giftcardactivatecode:(NSString*)code block:(void (^)(NSDictionary *dic, NSError *error))block;
//4.2.4 礼券优惠记录

- (void) giftcardmyGiftCardLogsblock:(void (^)(NSDictionary *dic, NSError *error))block;
//4.2.5 我的礼券有效期

- (void) giftcardmyGiftCards:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block;

// 4.4.1 激活现金券
- (void) cashcouponActivate:(NSString*)code block:(void (^)(NSDictionary *dic, NSError *error))block;

//3.3.4、查询订单物流信息

- (void) logistictrackorderLogId:(NSString*)orderLogId block:(void (^)(NSDictionary *dic, NSError *error))block;

//2.1.0、获取首页banner广告

- (void) banner:(NSString*)areaId location:(NSString*)location block:(void (^)(NSDictionary *dic, NSError *error))block;

/************农掌柜模块下************/

//7.1.0 查询服务店铺的订单列表
- (void) querykeeperOrdersState:(int)state serviceShopId:(NSString*)serviceShopId pageIndex:(NSString*)pageIndex block:(void (^)(NSDictionary *dic, NSError *error))block;

//7.1.1 统计服务店铺的订单计数
- (void) querykeeperOrdercountblock:(void (^)(NSDictionary *dic, NSError *error))block;

//7.4.0 查询我负责的服务店铺列表
- (void) querykeeperearningblock:(void (^)(NSDictionary *dic, NSError *error))block;

//7.6.0、查询订单详情

- (void) querykeeperorderdetail:(NSString*)orderId serviceShopId:(NSString*)shopId block:(void (^)(NSDictionary *dic, NSError *error))block;

//7.6.1、查询订单追踪信息
- (void) querykeepertrackorderId:(NSString*)orderId shopId:(NSString*)shopId block:(void (^)(NSDictionary *dic, NSError *error))block;

//7.2.0 订单发货

- (void) querykeeperDelivery:(NSString*)orderId shopId:(NSString*)shopId  Company:(NSString*)Company Ticket:(NSString*)Ticket notes:(NSString*)notes block:(void (^)(NSDictionary *dic, NSError *error))block;


//7.6.2、查询订单物流信息

- (void) querykeeperorderlogistictrack:(NSString*)orderId orderLogId:(NSString*)orderLogId block:(void (^)(NSDictionary *dic, NSError *error))block;

//7.5.0 分享店铺
- (void) querykeepershareshop:(NSString*)shopId block:(void (^)(NSDictionary *dic, NSError *error))block;


//7.3.0 订单转云商通

- (void) querykeeperforwardyst:(NSString*)orderId block:(void (^)(NSDictionary *dic, NSError *error))block;
//1.8.0 获取验证码图片参数

- (void) loginprepareconfusionblock:(void (^)(NSDictionary *dic, NSError *error))block;

//8.2.0 重置密码

- (void) userresetpwd:(NSString*)oldpwd newpwd:(NSString *)newpwd phoneNumber:(NSString*)phoneNumber block:(void (^)(NSDictionary *dic, NSError *error))block;

//8.2.1 变更手机号

- (void) serresetphonenumber:(NSString*)phoneNumber verifyCode:(NSString *)verifyCode block:(void (^)(NSDictionary *dic, NSError *error))block;


//8.10.2 获取分享新农宝链接的参数
- (void) xnbspreadblock:(void (^)(NSDictionary *dic, NSError *error))block;
// 8.10.3 获取分享新农宝掌柜链接的参数

- (void) xnbzgspreadblock:(void (^)(NSDictionary *dic, NSError *error))block;

//3、登录获取随机密码

- (void) logingetVerifyCode:(NSString*)phoneNumber verifyCodeType:(NSString *)verifyCodeType vid:(NSString*)vid cid:(NSString*)cid block:(void (^)(NSDictionary *dic1, NSError *error))block;


//8.2.2 变更手机号时获取验证码
- (void) getVerifyCodeForChangePhone:(NSString*)phoneNumber verifyCodeType:(NSString *)verifyCodeType vid:(NSString*)vid cid:(NSString*)cid block:(void (^)(NSDictionary *dic1, NSError *error))block;

//9.1.3、绑定推送平台的clientId

- (void) messagebinddeviceTokent:(NSString * )deviceTokent clientId:(NSString *)clientId block:(void (^)(NSDictionary *dic1, NSError *error))block;


//9.1.0、检查是否有新消息

- (void) messagecheckunreadblock:(void (^)(NSDictionary *dic1, NSError *error))block;
//9.1.1、消息列表

- (void) messageMessageListpageIndex:(NSString * )pageIndex block:(void (^)(NSDictionary *dic1, NSError *error))block;

// 9.1.2、消息详细

- (void) messageMessageDetail:(NSString * )getId block:(void (^)(NSDictionary *dic1, NSError *error))block;
// 9.1.4、上报通知的接收状态

- (void) messageReport:(NSString * )clientId msgId:(NSString*)msgId block:(void (^)(NSDictionary *dic1, NSError *error))block;


//9.1.5、上报通知的阅读状态

- (void) messagereportRead:(NSString * )msgId block:(void (^)(NSDictionary *dic1, NSError *error))block;

//商家注册
- (void) mallregister:(NSString*)oldpwd newpwd:(NSString *)newpwd phoneNumber:(NSString*)phoneNumber block:(void (^)(NSDictionary *dic, NSError *error))block;

@end
