//
//  RCNetworkingRequestOperationManager.h
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NetWorkingRequestType)
{
    POST = 0,
    GET  = 1
};
typedef NS_ENUM(NSInteger, NetWorkingOpertaionType)
{
    Register = 0,
    Login = 1,
    AcquireCode = 2,
    Judge_EmpPhone = 3,
    UpLoadFile = 4,
    VerifyEmployee = 5,
    ResetPassword = 6,
    DownLoadFile = 7,
    Logout = 8
};
typedef void(^completeDownload)(BOOL success);
typedef void(^completeBlock_t)(NSData *data);
typedef void(^errorBlock_t) (NSError *error);
typedef void(^completeUpload_t) (NSData *data , NSURLResponse *response,NSError *error);
@interface CSNetworkingRequestOperationManager : NSObject<NSURLSessionDataDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) completeBlock_t completeBlock;
@property (nonatomic, copy) errorBlock_t  errorBlock;
@property (nonatomic, copy) completeUpload_t  completeUpload;

/**
 *  类方法生成并启动网络请求
 *
 *  @param requestUrl    URL字符串
 *  @param type          网络请求类型：GET or POST
 *  @param dict          参数字典
 *  @param completeBlock 网络请求成功回调
 *  @param errorBlock    网络请求错误回调
 *
 *  @return 生成的网络请求管理对象
 */
+ (id)request:(NSString *)requestUrl requestType:(NetWorkingRequestType)requestType parameters:(NSDictionary *)dict operationType:(NetWorkingOpertaionType)operationType completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
/**
 *  类方法生成并启动网络请求
 *
 *  @param requestUrl    URL字符串
 *  @param type          网络请求类型：GET or POST
 *  @param dict          参数字典
 *  @param completeBlock 网络请求成功回调
 *  @param errorBlock    网络请求错误回调
 *
 *  @return 生成的网络请求管理对象
 */
- (id)initWithRequest:(NSString *)requestUrl requestType:(NetWorkingRequestType)requestType parameters:(NSDictionary *)dict operationType:(NetWorkingOpertaionType)operationType completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
/**
 *  文件下载
 *
 *  @param url              http地址
 *  @param filePath         下载后文件保存的路径
 *  @param completeDownlaod 下载完成后执行的回调
 *
 *  @return 返回一个CSNetworkingRequestOperationManager实例
 */
- (id)initWithDownloadTask:(NSURL *)url filePath:(NSString *)filePath complete:(completeDownload) completeDownlaod;
//类方法
+ (instancetype)downloadTask:(NSURL *)url filePath:(NSString *)filePath complete:(completeDownload) completeDownlaod;

+ (instancetype)upload:(NSString *)url parameters:(NSDictionary *)parameters fromFile:(NSString *)filePath completeHander:(completeUpload_t) completeHander;

- (id)initWithUploadTask:(NSString *)url parameters:(NSDictionary *)parameters fromFile:(NSString *)filePath completeHander:(completeUpload_t) completeHander;

@end
