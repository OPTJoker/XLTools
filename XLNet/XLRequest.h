//
//  XLRequest.h
//  iUnis
//
//  Created by 张雷 on 16/10/16.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <AFNetworking.h>
#import "Control.h"
#import "Links.h"

typedef void(^AFNSucBlock)(id sucData);
typedef void(^AFNFaiBlock)(NSError *errData);

@interface XLRequest : NSObject


/**
 GET data
 
 @param URLStr   GET 请求链接
 @param para     GET 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)GET:(NSString *)URLStr para:(NSDictionary *)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock;

/**
 POST data
 
 @param URLStr   POST 请求链接
 @param para     POST 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)POST:(NSString *)URLStr para:(NSDictionary *)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock;


/**
 解析数据 (analyze)
 
 @param responsObject 带解析的数据
 
 @return 返回一定是字典格式
 */
+ (NSDictionary *)analyze:(id)responsObject;

/**
 AF3.0 POST小文件到服务器
 
 @param filePath 本地文件地址
 @param name 文件名
 @param fileName 带后缀的文件全名
 @param mimeType 文件类型
 @param URLStr 要上传的服务器地址
 */
+(void)UPLoadFile:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType toURLStr:(NSString *)URLStr;


/**
 取消网络请求
 
 @param URLStr 要取消的请求链接URLStr
 */
+ (void)cancleRequest:(NSString *)URLStr;

/**
 网络请求失败的统一处理
 
 @param errData 错误信息
 */
+(void)dataRequestFailure:(NSError *)errData inView:(UIView *)aView;

@end
