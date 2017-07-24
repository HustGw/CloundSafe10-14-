//
//  CSVedioEncryption.m
//  CloundSafe
//
//  Created by Messiah_S on 7/27/16.
//
//

#import "CSVedioEncryption.h"
#import "CSEncrytionController.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "decrypt_video.h"
@interface CSVedioEncryption()
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, assign) VideoType videoType;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) id asset;
@property (nonatomic, strong) NSString *folderName;

@end
@implementation CSVedioEncryption
- (void)setCoverImage:(UIImage *)coverImage
{
    _coverImage = coverImage;
}
- (void)setAsset:(id)asset
{
    _asset = asset;
}
- (id)init
{
    if (self = [super init])
    {
        self.superView = [[UIView alloc]init];
        self.coverImage = [[UIImage alloc]init];
        self.folderName = @"";

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isDelegateOriginal:) name:@"deleteOriginal" object:nil];
    }
    return self;
}
- (UIViewController *)viewController
{
    /// Finds the view's view controller.
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self.superView;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

- (void)setResponder:(UIView *)superView
{
    self.superView = superView;
}
- (void)beginEncryption
{
    NSArray *resources = [PHAssetResource assetResourcesForAsset:self.asset];
    PHAssetResource *resource = resources.firstObject;
    self.folderName = resource.originalFilename;
    //创建文件夹
    NSString __block *sourceFileURL = [self createFileName];
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:sourceFileURL];
    NSString *originalVideo = [NSString stringWithFormat:@"%@/%@/%@/%@",DocumentPath,userName,[NSString stringWithFormat:@"video_%@",[self.folderName stringByDeletingPathExtension]],self.folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:originalVideo])
    {
        [[NSFileManager defaultManager] createFileAtPath:originalVideo contents:nil attributes:nil];
    }
    NSFileHandle *orignalHandler = [NSFileHandle fileHandleForWritingAtPath:originalVideo];
    [[PHAssetResourceManager defaultManager] requestDataForAssetResource:resource options:nil dataReceivedHandler:^(NSData * _Nonnull data) {
        [fileHandle writeData:data];
        [orignalHandler writeData:data];
    } completionHandler:^(NSError * _Nullable error) {
        [fileHandle closeFile];
        [orignalHandler closeFile];
        ///保存缩略图
        NSString *coverImageFileName = [[sourceFileURL stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:coverImageFileName])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:coverImageFileName withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSData *coverImageData = UIImageJPEGRepresentation(self.coverImage, 1);
        [coverImageData writeToFile:coverImageFileName atomically:YES];
        [self didEncrytionVideo:sourceFileURL];
        [self deleteOriginalVideo:self.asset];
    }];

}

- (void)selectVedio
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:nil AssetType:TZAssetModelMediaTypeVideo isTakePhoto:NO];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        self.completeSelection(coverImage, asset);
    }];
    // 设置是否可以选择视频/原图
    imagePickerVc.allowPickingVideo = YES;
    [[self viewController] presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - 删除原视频文件
- (void)deleteOriginalVideo:(id)obj
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:@[obj]];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success == YES)
        {
            NSLog(@"删除成功");
        }else
        {
            NSLog(@"删除失败: %@", error);
        }
    }];
}
#pragma mark - 加密视频
- (void)didEncrytionVideo:(NSString *)sourceVideoURL
{
    //NSString *vedioPath = [NSString stringWithFormat:@"%@/%@",DocumentPath, self.folderName];

    //key路径，密文路径
    NSString *keyPath = [NSString stringWithString:[sourceVideoURL.stringByDeletingPathExtension stringByAppendingPathExtension:@"key"]];
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *plainVedio = [NSString stringWithFormat:@"%@/%@/%@/%@",DocumentPath,userName,[self.folderName stringByDeletingPathExtension],self.folderName];
    NSData *data = [NSData dataWithContentsOfFile:sourceVideoURL];
    [data writeToFile:plainVedio atomically:YES];
    
    NSString *user_identity = [userDefaults valueForKey:@"content"];
    user_identity = [user_identity substringFromIndex:[user_identity rangeOfString:@"_"].location + 1];
    EncryptedThenAddInfo([sourceVideoURL cStringUsingEncoding:NSASCIIStringEncoding],[keyPath cStringUsingEncoding:NSASCIIStringEncoding],1,0.01,1,0.1,8,0,[[keyPath lastPathComponent] cStringUsingEncoding:NSASCIIStringEncoding],[user_identity cStringUsingEncoding:NSASCIIStringEncoding],CurrentVersion);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *moveToPath = [[keyPath stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension];
    NSError *error;
    BOOL isSuccess = [fileManager moveItemAtPath:sourceVideoURL toPath:moveToPath error:&error];
    if (isSuccess)
    {
        //NSLog(@"rename success");
    }else
    {
        NSLog(@"rename fail:%@",error);
    }
    
    [self uploadKey:keyPath];

}
- (void)uploadKey:(NSString *)keyPath
{
    //上传key到服务器
    NSString *url = UpLoadKeyURL;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    NSString *user_identity = [userDefaults valueForKey:@"content"];
    user_identity = [user_identity substringFromIndex:[user_identity rangeOfString:@"_"].location + 1];
    NSMutableDictionary *datadict = [[NSMutableDictionary alloc] init];
    [datadict setObject:user_identity forKey:@"user_identify"];
    [datadict setObject:[keyPath lastPathComponent] forKey:@"file_id"];
    [datadict setObject:@"1" forKey:@"fp_num"];
    //发送请求
    [mgr POST:url parameters:datadict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:keyPath] name:@"file" fileName:keyPath mimeType:@"file"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"Success"] &&
            [[responseObject valueForKey:@"content"]isEqualToString:@"uploadfile success"])//上传成功
        {
            //删除密钥
            NSLog(@"key上传成功。");
            [[NSFileManager defaultManager] removeItemAtPath:keyPath error:nil];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"Success"] &&
                  [[responseObject valueForKey:@"content"]isEqualToString:@"employee is null"])//用户信息为空
        {
            NSLog(@"用户信息为空");
            self.completeEncryption(@"employee is null");
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"Success"] &&
                 [[responseObject valueForKey:@"content"]isEqualToString:@"file is null"])//文件为空
        {
            NSLog(@"文件为空");
            self.completeEncryption(@"file is null");
        }else
        {
            ;
        }
        //创建记录用于解密的plist
        NSString *userName = [userDefaults valueForKey:@"userName"];
        NSString *pathDocuments = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
        NSString *plistPath = [pathDocuments stringByAppendingPathComponent:@"deCrypt_file.plist"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
            dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            [dict setObject:keyPath.lastPathComponent forKey:keyPath.lastPathComponent];
        } else
        {
            [dict setObject:keyPath.lastPathComponent forKey:keyPath.lastPathComponent];
        }
        [dict writeToFile:plistPath atomically:YES];
        self.completeEncryption(@"EncryptSuccess");
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"上传失败:%@",error);
        [self deleteAllFile:keyPath];
        self.completeEncryption(@"TimeOut");
    }];
    
}
//没网加密时，删除所有加密过程生成的文件
- (void)deleteAllFile:(NSString *)path
{
    NSString *directory = [path stringByDeletingLastPathComponent];
    
    [[NSFileManager defaultManager] removeItemAtPath:directory error:nil];
}
- (void)isDelegateOriginal:(NSNotification *)notification
{
    self.state = notification.object;
}
#pragma mark - 创建文件夹返回文件名
- (NSString *)createFileName
{
    //获取当前时间
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    CFAbsoluteTime start = CACurrentMediaTime();
    long time = start * 10000;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *vedioPath = [NSString stringWithFormat:@"%@/%@/%@",DocumentPath,userName, [NSString stringWithFormat:@"video_%@",[self.folderName stringByDeletingPathExtension]]];
    
    if (![fileManager fileExistsAtPath:vedioPath])
    {
        [fileManager createDirectoryAtPath:vedioPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else
    {
        NSString *vedioFolder = [NSString stringWithFormat:@"%@/%@/%@", DocumentPath,userName,[NSString stringWithFormat:@"video_%@",[self.folderName stringByDeletingPathExtension]]];
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:vedioFolder];
        NSString *fileName;
        while (fileName= [dirEnum nextObject])
        {
            [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",vedioFolder,fileName] error:nil];
        }
    }
    NSString *fileName = [NSString stringWithFormat:@"%@%ld.mov",locationString,time];
    NSString *vedioName = [vedioPath stringByAppendingPathComponent:fileName];
    if (![fileManager fileExistsAtPath:vedioName])
    {
        [fileManager createFileAtPath:vedioName contents:nil attributes:nil];
    }
    
    return vedioName;
}

@end

