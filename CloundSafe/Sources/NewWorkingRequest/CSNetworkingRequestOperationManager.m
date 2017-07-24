//
//  RCNetworkingRequestOperationManager.m
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CSNetworkingRequestOperationManager.h"
#define Kboundary  @"----WebKitFormBoundaryjh7urS5p3OcvqXAT"
#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

@interface CSNetworkingRequestOperationManager()
@property (nonatomic, strong) NSURL *url;
//下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *downTask;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, copy) completeDownload completeDownload;
@property (nonatomic, strong) NSURLSession * downLoadSession;


//上传任务
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;
@property (nonatomic, strong) NSURLSession * uploadSession;
@end

@implementation CSNetworkingRequestOperationManager

+ (id)request:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict operationType:(NetWorkingOpertaionType)operationType completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
{
    
    return [[self alloc]initWithRequest:requestUrl requestType:type parameters:dict operationType:operationType completeBlock:completeBlock errorBlock:errorBlock];
}

- (id)initWithRequest:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict operationType:(NetWorkingOpertaionType)operationType completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
{
    
    if (self = [super init])
    {
        self.data = [[NSMutableData alloc]init];
        self.completeBlock = [completeBlock copy];
        self.errorBlock = [errorBlock copy];
    }
    NSMutableURLRequest *request = [self requestBySerializingRequest:requestUrl requestType:type Parameters:dict operationType:operationType];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
//    [self resume:dataTask];
    [dataTask resume];
    return self;
    
}

//启动网络连接
- (void)resume:(NSURLSessionDataTask *)task
{
    [task resume];
}
/**
 *  Create and return a new request for sepcified url string with sepcified request type and operation type.
 *
 *  @param requestUrl    request for sepcified string
 *  @param type          request tyep GET or POST
 *  @param parameters    request parmaeters
 *  @param operationType operation type See NetWorkingOpertaionType
 *
 *  @return a new request
 */
- (NSMutableURLRequest *)requestBySerializingRequest:(NSString *)requestUrl requestType:(NetWorkingRequestType)type Parameters:(NSDictionary *)parameters operationType:(NetWorkingOpertaionType)operationType
{
//    NSLog(@"请示的URL：%@", requestUrl);
    NSString __block *param = @"";
    //设置请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    //设置参数
    if ([parameters count] == 0 || parameters == nil)//参数为空时
    {
        param = @"";
    }else
    {
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *temp = [NSString stringWithFormat:@"%@=%@,",key, obj];
            param = [NSString stringWithFormat:@"%@%@",param,temp];
        }];
        param = [param substringWithRange:NSMakeRange(0, [param length] - 1)];
        if (type == GET)
        {
            requestUrl = [NSString stringWithFormat:@"%@?%@",requestUrl,param];
            requestUrl = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            request.HTTPMethod = @"GET";
        }else
        {
            request.HTTPMethod = @"POST";
            request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
        }
    }

    request.URL = [NSURL URLWithString:requestUrl];
    request.timeoutInterval = 15;
    request.cachePolicy = 1;
    
    return request;
}
///网络下载
+ (instancetype)downloadTask:(NSURL *)url filePath:(NSString *)filePath complete:(completeDownload) completeDownlaod
{
    return [[self alloc] initWithDownloadTask:url filePath:filePath complete:completeDownlaod];
}
- (id)initWithDownloadTask:(NSURL *)url filePath:(NSString *)filePath complete:(completeDownload) completeDownlaod
{
    if(self = [super init])
    {
        self.url = url;
        self.filePath = filePath;
        self.completeDownload = [completeDownlaod copy];
        //参数设置类  简单的网络下载使用
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //创建网络会话
        self.downLoadSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue new]];
        
        
        //数据请求
        /*
         *@param URL 资源url
         *@param timeoutInterval 超时时长
         */
        NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:url cachePolicy:5 timeoutInterval:15.0f];
        
        //创建下载任务
        self.downTask = [self.downLoadSession downloadTaskWithRequest:downloadRequest];
        //启动下载任务
        [self.downTask resume];
    }
    return self;
}
+ (instancetype)upload:(NSString *)url parameters:(NSDictionary *)parameters fromFile:(NSString *)filePath completeHander:(completeUpload_t) completeHander
{
    return [[self alloc]initWithUploadTask:url parameters:parameters fromFile:filePath completeHander:completeHander];
}
- (id)initWithUploadTask:(NSString *)url parameters:(NSDictionary *)parameters fromFile:(NSString *)filePath completeHander:(completeUpload_t) completeHander
{
    if (self = [super init])
    {
        self.url = [NSURL URLWithString:url];
        self.completeUpload = [completeHander copy];
        //02 创建"可变"请求对象
        NSMutableURLRequest *request = [self requestBySerializingRequest:url requestType:POST Parameters:parameters operationType:UpLoadFile];
        
        //'设置请求头:告诉服务器这是一个文件上传请求,请准备接受我的数据
        //Content-Type:multipart/form-data; boundary=分隔符
        NSString *headerStr = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary];
        
        [request setValue:headerStr forHTTPHeaderField:@"Content-Type"];
        //'按照固定的格式来拼接'
//        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSData *fileData = [self getBodyData:filePath];
        
        //05 创建会话对象
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        //06 根据会话对象创建uploadTask请求
        /*
         第一个参数:请求对象
         第二个参数:要传递的是本应该设置为请求体的参数
         第三个参数:completionHandler 当上传完成的时候调用
         data:响应体
         response:响应头信息
         */
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:fileData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            self.completeUpload(data, response, error);
        }];
        
        //07 发送请求
        [uploadTask resume];
    }
    return self;
}
-(NSData *)getBodyData:(NSString *)filePath
{
    NSMutableData *data = [NSMutableData data];
    
    //01 文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="file"; filename="Snip20160716_103.png"
     Content-Type: image/png
     空行
     文件数据
     */
    NSString *fileName = [filePath lastPathComponent];
    [data appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:KNewLine];
    //file 文件参数 参数名 == username
    //filename 文件上传到服务器之后以什么名称来保存
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[NSData dataWithContentsOfFile:filePath]];
    [data appendData:KNewLine];
    //03 结尾标识
    /*
     --分隔符--
     */
    [data appendData:[[NSString stringWithFormat:@"--%@--",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //拼接
    return data;
}
/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //存储本地
    
    //1.获取Documents文件夹路径 （不要将视频、音频等较大资源存储在Caches路径下）
    NSFileManager *manager = [NSFileManager defaultManager];

    
    //删除之前相同路径的文件
    //BOOL remove  = [manager removeItemAtPath:self.filePath error:nil];
    
    //将视频资源从原有路径移动到自己指定的路径
    BOOL success = [manager copyItemAtPath:location.path toPath:self.filePath error:nil];
    
    self.completeDownload(success);

}
#pragma mark - NSURLSessionDataDelegate
//接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}
//当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if ([task isKindOfClass:[NSURLSessionDataTask class]])
    {
        if (!error)
        {
            self.completeBlock(self.data);
        }else
        {
            self.errorBlock(error);
        }
    }

}
//监视每次上传的数据大小
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
//    NSLog(@"%lld",bytesSent);
}

@end
