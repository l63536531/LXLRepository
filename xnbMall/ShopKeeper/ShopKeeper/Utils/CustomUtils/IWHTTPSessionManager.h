/**
 * IWHTTPSessionManager.h 16/8/8
 *
 * @Copyright 2013-2016 深圳市新农宝科技有限公司
 * 广东省深圳市南山区科技园清华信息港C栋608， 中国
 * 保留所有权利。
 *
 * 本软件是深圳市新农宝科技有限公司的机密和专有信息，
 * 您不得披露该保密信息，并只能按照您与深圳市新农宝科技有限公司签订的许可协议中的条款使用。
 *
 */

#import <AFNetworking/AFNetworking.h>

@interface IWHTTPSessionManager : AFHTTPSessionManager
/**
 *  创建一个单例对象
 */
+ (instancetype)shareSessionManager;

/**
 *  自定义GET请求
 *
 *  @param path            路径
 *  @param parasmeters     参数
 *  @param comletionHandle 完成回调
 */
- (void)GET:(NSString *)path parameters:(id)parameters token:(BOOL)token comletionHandle:(void(^)(id responseObject, NSError *error))comletionHandle;
/**
 *  自定义POST请求
 *
 *  @param path            路径
 *  @param parasmeters     参数
 *  @param comletionHandle 完成回调
 */
- (void)POST:(NSString *)path parameters:(id)parameters token:(BOOL)token comletionHandle:(void(^)(id responseObject, NSError *error))comletionHandle;
@end
