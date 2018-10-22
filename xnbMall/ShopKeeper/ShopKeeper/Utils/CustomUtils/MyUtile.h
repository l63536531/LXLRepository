//
//  MyUtile.h
//  EditVideo
//
//  Created by oracle on 14-9-9.
//  Copyright (c) 2014年 www.gzspark.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MyUtile : NSObject

+ (void) removeLocalFile:(NSString*) filePath;
+ (void) removeMovie:(NSURL*) movieURL;
    
+ (NSString*) formatTime:(NSInteger)time;

//从本地数据删除一项
+ (void) removeObjectFromUserDefaults:(NSString*)name key:(NSString*)key;
//清空本地数据中name的字典
+ (void) cleanObjectFromUserDefaults:(NSString*)name;
//保存object到本地数据.如果已经存在，覆盖
+ (void) saveObjectToUserDefaults:(NSString*)name key:(NSString*)key object:(NSData *)object;
//保存String到本地数据.如果已经存在，覆盖
+ (void) saveStringToUserDefaults:(NSString*)name key:(NSString*)key object:(NSString *)object;
//保存Int到本地数据.如果已经存在，覆盖
+ (void) saveIntegerToUserDefaults:(NSString*)name key:(NSString*)key object:(NSInteger)object;
//保存Date到本地数据.如果已经存在，覆盖
+ (void) saveDateToUserDefaults:(NSString*)name key:(NSString*)key object:(NSDate*)object;
//从本地数据取name对应字典中key对应的object
+ (NSObject*) getObjectFromUserDefault:(NSString*)name key:(NSString*)key;
//从本地数据取name对应字典中key对应的string
+ (NSInteger) getIntegerFromUserDefault:(NSString*)name key:(NSString*)key;
//从本地数据取name对应字典中key对应的int
+ (NSString*) getStringFromUserDefault:(NSString*)name key:(NSString*)key;
//从本地数据取name对应字典中key对应的date
+ (NSDate*) getDateFromUserDefault:(NSString*)name key:(NSString*)key;
//获取本地数据中name对应的字典，没有则返回一个无数据的字典
+ (NSDictionary*) getDictionaryFromUserDefaults:(NSString*)name;
//保存字典到本地数据中name对应的
+ (void) saveDictionaryToUserDefaults:(NSString*)name dictionary:(NSDictionary*)dictionary;
//清空本地数据中name对应的字典的数据
+ (void) clearDictionaryFromUserDefaults:(NSString*)name;

+ (MBProgressHUD*) initHUD:(UIView*) parentView;
+ (MBProgressHUD*) initHUD:(UIView*) parentView labelText:(NSString*) labelText;

+ (UITableViewCell*) getCellBySubview:(UIView*) subview;

+ (UIView*) getBlurView;

+ (UIView*) getLineView:(CGRect) rect;

+ (NSString*)getPreferredLanguage;

+ (BOOL) needLogin;

+ (NSString *)generateTradeNO;

+ (NSString*) dollar2cent:(NSString*)dollar;

+ (NSString*) cent2dollar:(NSString*)cent;

+ (UIColor*) getSystemMainColor;

+ (void) showAlertViewByError:(NSError*) error vc:(UIViewController*)vc;

+ (void) showAlertViewByMsg:(NSString*) msg vc:(UIViewController*)vc;


+ (void) addGoodsToCart:(NSMutableDictionary*)goods;

+ (NSDictionary*) getGoodsFromCartByGoodsId:(NSString*)goodsId ;

+ (void) delGoodsFromCartByGoodsId:(NSString*)goodsId ;

+ (NSMutableArray*) getGoodsToCart;

+ (void) UpdateGoodsToCart:(NSMutableArray*)goodslist;

+ (id) getUserDataUiypByKey:(NSString*)ukey;
+ (BOOL) saveUserDataUiyp:(NSDictionary*)uiyp;
+ (BOOL) updateUserDataUiypByKey:(NSString*)ukey uvalue:(id)vu;
+ (BOOL) delUserDataUiyp;

+ (void) printDicToJson:(NSDictionary*)dic;

+ (NSDictionary*) getDicByJson:(NSString*)json;

+ (NSData *)imageData:(UIImage *)myimage;

+ (UILabel*) createNormalLabel:(CGRect)rect;

+ (void)clearAllUserDefaultsData;

@end
