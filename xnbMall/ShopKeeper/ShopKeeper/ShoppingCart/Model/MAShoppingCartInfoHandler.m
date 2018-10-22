/**
 * MAShoppingCartInfoHandler.m 16/11/15
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import "MAShoppingCartInfoHandler.h"


static NSString *const mAllUserGoodsDicKey = @"mAllUserGoodsDicKey";


//游客
static NSString *const mLastVisitorGoodsStateDicKey = @"mLastVisitorGoodsArrayKey";     //只保存了一个人的数据


@implementation MAShoppingCartInfoHandler

#pragma mark - 游客 + 登录用户

+ (void)changeSateForGoods:(NSString *)goodsSpecificationId {
    
    if ([self isGoodsSelected:goodsSpecificationId]) {
        [self setGoods:goodsSpecificationId selected:NO];
    }else {
        [self setGoods:goodsSpecificationId selected:YES];
    }
}

+ (void)setGoods:(NSString *)goodsSpecificationId selected:(BOOL)selected {
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0){
        //游客
        [self setVisitorGoods:goodsSpecificationId selected:selected];
    }else {
        //登录用户
        [self setUserGoods:goodsSpecificationId selected:selected];
    }
}

+ (BOOL)isGoodsSelected:(NSString *)goodsSpecificationId {
    
    NSString *isLoginStr = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:MALL_IS_LOGIN];
    
    NSLog(@"isLoginStr是否是商家 isLoginStr  = %@",isLoginStr);
    if(isLoginStr == nil || isLoginStr.length == 0){
        //游客
        return [self isVisitorGoodsSelected:goodsSpecificationId];
    }else {
        //登录用户
        return [self isUserGoodsSelected:goodsSpecificationId];
    }
}

#pragma mark - 登录用户

/**
 *  @author 黎国基, 16-11-15 16:11
 *
 *  调用该方法前，必须以判断此时为登录用户
 *
 *  @param goodsSpecificationId 规格id
 *  @param selected             商品选中状态
 */
+ (void)setUserGoods:(NSString *)goodsSpecificationId selected:(BOOL)selected {
    
    if (goodsSpecificationId == nil) {
        return;
    }
    
    NSString *userPhone = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_PHONE];
    
    NSMutableDictionary *mAllUserGoodsStateDic = [self allUserGoodsSelectionStateDic];//所有用户的数据
    
    NSMutableDictionary *mUserGoodsStateDic = [self mutableDicForDic:mAllUserGoodsStateDic[userPhone]];
    
    if (mUserGoodsStateDic == nil) {
        //如果还没有保存该登录用户的商品状态，先为其初始化一个mutable dic
        mUserGoodsStateDic = [[NSMutableDictionary alloc] init];
    }
    //每一个商品的选中状态是一个dic   目录：  allUserGoodsStateDic[userPhone][goodsSpecificationId]
    [mUserGoodsStateDic setObject:[NSNumber numberWithBool:selected] forKey:goodsSpecificationId];
    [mAllUserGoodsStateDic setObject:mUserGoodsStateDic forKey:userPhone];
    
    [[NSUserDefaults standardUserDefaults] setObject:mAllUserGoodsStateDic forKey:mAllUserGoodsDicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isUserGoodsSelected:(NSString *)goodsSpecificationId {
    
    if (goodsSpecificationId == nil) {
        return NO;
    }
    
    NSString *userPhone = [MyUtile getStringFromUserDefault:DICKEY_LOGIN key:LOGIN_PHONE];
    
    NSMutableDictionary *mAllUserGoodsStateDic = [self allUserGoodsSelectionStateDic];//所有用户的数据
    
    NSMutableDictionary *mUserGoodsStateDic = [self mutableDicForDic:mAllUserGoodsStateDic[userPhone]];
    
    NSNumber *stateNumber = mUserGoodsStateDic[goodsSpecificationId];
    
    if (stateNumber != nil && [stateNumber boolValue]) {
        return YES;
    }
    return NO;
}


+ (void)clearGoodsStateForAllUser {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:mAllUserGoodsDicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearGoodsStateForUser:(NSString *)phone {
    
    if (phone != nil) {
        NSMutableDictionary *mAllUserGoodsStateDic = [self allUserGoodsSelectionStateDic];//所有用户的数据
        [mAllUserGoodsStateDic removeObjectForKey:phone];
        
        [[NSUserDefaults standardUserDefaults] setObject:mAllUserGoodsStateDic forKey:mAllUserGoodsDicKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 *  @author 黎国基, 16-11-15 15:11
 *
 *  保存了所有登录的用户的 购物车 商品的 选中状态
 *
 *  @return
 */
+ (NSMutableDictionary *)allUserGoodsSelectionStateDic {
    
    NSMutableDictionary *mAllUserGoodsDic = [[NSUserDefaults standardUserDefaults] objectForKey:mAllUserGoodsDicKey];
    
    if (mAllUserGoodsDic == nil) {
        mAllUserGoodsDic = [[NSMutableDictionary alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:mAllUserGoodsDic forKey:mAllUserGoodsDicKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return [self mutableDicForDic:mAllUserGoodsDic];
}


#pragma mark - 游客
/**
 *  @author 黎国基, 16-11-15 15:11
 *
 *  保存了最后一个未登录的用户的 购物车 商品的 选中状态
 *
 *  @return
 */
+ (NSMutableDictionary *)goodsSelectionStateDicForVisitor {
    
    NSMutableDictionary *mLastVisitorGoodsStateDic = [[NSUserDefaults standardUserDefaults] objectForKey:mLastVisitorGoodsStateDicKey];
    
    if (mLastVisitorGoodsStateDic == nil) {
        mLastVisitorGoodsStateDic = [[NSMutableDictionary alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:mLastVisitorGoodsStateDic forKey:mLastVisitorGoodsStateDicKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return [self mutableDicForDic:mLastVisitorGoodsStateDic];
}

/**
 *  @author 黎国基, 16-11-15 16:11
 *
 *  清除游客数据
 */
+ (void)clearVisitorGoodsState {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:mLastVisitorGoodsStateDicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setVisitorGoods:(NSString *)goodsSpecificationId selected:(BOOL)selected {
    
    if (goodsSpecificationId == nil) {
        return;
    }
    
    NSMutableDictionary *mLastVisitorGoodsArray = [self goodsSelectionStateDicForVisitor];
    [mLastVisitorGoodsArray setObject:[NSNumber numberWithBool:selected] forKey:goodsSpecificationId];
    
    [[NSUserDefaults standardUserDefaults] setObject:mLastVisitorGoodsArray forKey:mLastVisitorGoodsStateDicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isVisitorGoodsSelected:(NSString *)goodsSpecificationId {
    
    if (goodsSpecificationId == nil) {
        return NO;
    }
    NSMutableDictionary *mLastVisitorGoodsArray = [self goodsSelectionStateDicForVisitor];
    NSNumber *stateNumber = mLastVisitorGoodsArray[goodsSpecificationId];
    if (stateNumber != nil && [stateNumber boolValue]) {
        return YES;
    }
    return NO;
}

+ (NSMutableDictionary *)mutableDicForDic:(NSDictionary *)dic {
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    return mDic;
}

@end
