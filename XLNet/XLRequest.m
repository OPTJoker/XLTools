//
//  XLRequest.m
//  iUnis
//
//  Created by 张雷 on 16/10/16.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLRequest.h"
#import <SVProgressHUD.h>
static float timeout = 9;  // 其实多一秒
@interface XLRequest(){
}


/**
 *  管理网络请求URL的数组 用于取消请求
 @  数组里存的是字典key:URL val:manager
 */
@property (nonatomic, strong)NSMutableDictionary *taskDic;

@end

@implementation XLRequest

static XLRequest *xlRequest = nil;

/**
 单利
 @return XLRquest
 */
+ (instancetype)ShareXLRquest{
    @synchronized(self){
        if (nil == xlRequest) {
            xlRequest = [[super allocWithZone:nil] init]; // 避免死循环
            xlRequest.taskDic = [NSMutableDictionary new];
        }
    }
    return xlRequest;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [XLRequest ShareXLRquest];
}

- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}


////////////////////////////////////////////////////////////////////////
////                    封装AF request 方法们                         ////
////////////////////////////////////////////////////////////////////////


/**
 GET data

 @param URLStr   GET 请求链接
 @param para     GET 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)GET:(NSString *)URLStr para:(NSDictionary *)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock{
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:timeout];
    
    // DLog(@"managers:%@",[XLRequest ShareXLRquest].requestManagers);
    NSString *uStr = [URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    // 这段转换很重要，否则异常编码的URL会让AF crash
    NSString *enURLStr = [uStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [manager GET:enURLStr parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"URL:\n%@",URLStr);
        sucBlock(responseObject);
        if (!responseObject && ![responseObject isEqual:[NSNull class]]) {
            [XLRequest cacheData:responseObject ByURL:URLStr];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSInteger errCode = error.code;
        DLog(@"NetErrCode:%ld",(long)errCode);
        
        faiBlock(error);
        
    }];
    // 添加进请求管理数组里
    [[XLRequest ShareXLRquest].taskDic setObject:task forKey:URLStr];
}


/**
 POST data
 
 @param URLStr   POST 请求链接
 @param para     POST 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)POST:(NSString *)URLStr para:(NSDictionary *)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock{
    //DLog(@"\nURL: %@\nlog para:%@",URLStr,para);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:timeout];
    
    // DLog(@"managers:%@",[XLRequest ShareXLRquest].requestManagers);
    
    NSString *uStr = [URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    // 这段转换很重要，否则异常编码的URL会让AF crash
    NSString *enURLStr = [uStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [manager POST:enURLStr parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        sucBlock(responseObject);
        if (!responseObject && ![responseObject isEqual:[NSNull class]]) {
            [XLRequest cacheData:responseObject ByURL:URLStr];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faiBlock(error);
        
    }];
    // 添加进请求管理数组里
    [[XLRequest ShareXLRquest].taskDic setObject:task forKey:URLStr];
    
}


/**
 AF3.0 POST小文件到服务器

 @param filePath 本地文件地址
 @param name 文件名
 @param fileName 带后缀的文件全名
 @param mimeType 文件类型
 @param URLStr 要上传的服务器地址
 */
+(void)UPLoadFile:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType toURLStr:(NSString *)URLStr{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *type = mimeType;
        if (![type isKindOfClass:[NSString class]]) {
            type = @"image/jpeg";
        }
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name fileName:fileName mimeType:type error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          // 更新 上传进度的 UI

                          NSString *pro = [NSString stringWithFormat:@"%.2f%%",uploadProgress.fractionCompleted*100];
                          [SVProgressHUD showImage:nil status:pro];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          DLog(@"Error: %@", error);
                      } else {
                          DLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
}

/**
 解析数据 (analyze)

 @param responsObject 带解析的数据

 @return 返回一定是字典格式
 */
+ (NSDictionary *)analyze:(id)responsObject{
    NSDictionary *dic = nil;
    if ([responsObject isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary *)responsObject;
        //DLog(@"dic:%@",dic);
        return dic;
    }else{
        DLog(@"数据非字典格式:\n%@",responsObject);
        return nil;
    }
}



/**
 缓存某些不经常变化的数据 或者没有网络时候给一下缓存数据

 @param responsObject 请求结果
 @param URLStr        请求的URL地址
 */
+ (void)cacheData:(id)responsObject ByURL:(NSString *)URLStr{
    [[NSUserDefaults standardUserDefaults] setObject:responsObject forKey:URLStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 取消网络请求

 @param URLStr 要取消的请求链接URLStr
 */
+ (void)cancleRequest:(NSString *)URLStr{
    NSURLSessionDataTask *task = (NSURLSessionDataTask *)[[XLRequest ShareXLRquest].taskDic objectForKey:URLStr];
    [task cancel];
    DLog(@"URL:[%@]已取消请求",URLStr);
}


/**
 网络请求失败的统一处理

 @param errData 错误信息
 */
+(void)dataRequestFailure:(NSError *)errData inView:(UIView *)aView{
    
    DLog(@"error：%@",errData);
    NSInteger errCode = errData.code;
    DLog(@"NetErrCode:%ld",(long)errCode);
    
    if (errCode == -1001) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"请求超时" toView:aView];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (aView) {
                [MBProgressHUD showError:@"网络请求失败" toView:aView];
            }
            
        });
    }
}
@end
