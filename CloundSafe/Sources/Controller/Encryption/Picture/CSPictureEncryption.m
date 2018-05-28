//
//  CSPictureEncryption.m
//  CloundSafe
//
//  Created by AlanZhang on 16/7/19.
//
//

#import "CSPictureEncryption.h"
#import "UIImage+Thumbnail.h"
#import <Accelerate/Accelerate.h>
@interface CSPictureEncryption()
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) TZAssetModelMediaType assetType;
@property (nonatomic, assign) BOOL isOriginal;
@property (nonatomic, assign) int maxCount; //可选的最大图片数
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, assign) ImageType imageType;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSString *folderName;
@end
@implementation CSPictureEncryption
- (id)initWithMaxCount:(int)maxCount
{
    if (self = [super init])
    {
        self.maxCount = maxCount;
        self.superView = [[UIView alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isDelegateOriginalPic:) name:@"deleteOriginal" object:nil];
        self.state = @"NO";
        self.folderName = @"";
    }
    
    return self;
}
- (void)isDelegateOriginalPic:(NSNotification *)notification
{
    NSString *state = notification.object;
    self.state = state;
}
- (void)setResponder:(UIView *)superView
{
    self.superView = superView;
}
+ (instancetype)encryptImage:(UIImage *)image isOriginal:(BOOL)isOrigianl
{
    return [[self alloc]initWithEncryptionImage:image isOriginal:isOrigianl];
}
+ (instancetype) encryptImages:(NSArray *)images isOriginal:(BOOL)isOrigianl
{
    return [[self alloc]initWithEncryptionImages:images isOriginal:isOrigianl];
}
- (id)initWithEncryptionImage:(UIImage *)image isOriginal:(BOOL)isOrigianl
{
    if (self = [super init])
    {
        self.image = image;
        self.isOriginal = isOrigianl;
    }
    return self;
}
- (id)initWithEncryptionImages:(NSArray *)images isOriginal:(BOOL)isOrigianl
{
    if (self = [super init])
    {
        self.images = [[NSArray alloc]initWithArray:images];
        self.isOriginal = isOrigianl;
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
- (void)setPhotos:(NSArray *)photos
{
    _photos = [[NSArray alloc]initWithArray:photos];
}
- (void)setAssets:(NSArray *)assets
{
    _assets = [[NSArray alloc]initWithArray:assets];
}
- (void)setIsOriginal:(BOOL)isOriginal
{
    _isOriginal = isOriginal;
}
- (void)selectPhotos
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:self.maxCount delegate:nil AssetType:TZAssetModelMediaTypePhoto isTakePhoto:YES];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isOriginal) {
        
        self.completeSelectPhotos(photos, assets, isOriginal);
    }];
    [[self viewController] presentViewController:imagePickerVc animated:YES completion:nil];

}
- (void)beginEncryption
{
    if (self.isOriginal == YES)
    {
        for (int i = 0; i< self.assets.count; ++i)
        {
            PHAsset *asset = self.assets[i];
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
            option.synchronous = YES;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                
                //根据文件名创建文件夹，用于存放密文和缩略图
                self.folderName = [NSString stringWithFormat:@"img_%@",[[[info valueForKey:@"PHImageFileURLKey"] lastPathComponent] stringByDeletingPathExtension]];
                
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                NSString *userName = [userDefaults valueForKey:@"userName"];
                NSString *photoFolder = [NSString stringWithFormat:@"%@/%@/%@", DocumentPath,userName,self.folderName];
                if (![[NSFileManager defaultManager] fileExistsAtPath:photoFolder])
                {
                    [fileManager createDirectoryAtPath:photoFolder withIntermediateDirectories:YES attributes:nil error:nil];
                }
                else
                {
                    NSString *photoFolder = [NSString stringWithFormat:@"%@/%@/%@", DocumentPath,userName,self.folderName];
                    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:photoFolder];
                    NSString *fileName;
                    while (fileName= [dirEnum nextObject])
                    {
                        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",photoFolder,fileName] error:nil];
                    }
                }
                [self isDeleOriginalPic:asset];
                if ([[info valueForKey:@"PHImageFileUTIKey"] isEqualToString:@"public.png"])
                {
                    [self didEncrytionImage:[self saveTheImageToTheSondBox:imageData atIndex:i imageType:@"png" filePath:photoFolder]];
                }
                else if([[info valueForKey:@"PHImageFileUTIKey"] isEqualToString:@"public.jpeg"])
                {
                    [self didEncrytionImage:[self saveTheImageToTheSondBox:imageData atIndex:i imageType:@"jpg" filePath:photoFolder]];
                }
                else {
                    NSLog(@"%@",[info valueForKey:@"PHImageFileUTIKey"]);
                }
                
            }];
        }
    }else
    {
        for (int i = 0; i < self.photos.count; ++i)
        {
            id asset = self.assets[i];
            [self isDeleOriginalPic:asset];
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                //根据文件名创建文件夹，用于存放密文和缩略图
                self.folderName = [NSString stringWithFormat:@"img_%@",[[[info valueForKey:@"PHImageFileURLKey"] lastPathComponent] stringByDeletingPathExtension]];
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                NSString *userName = [userDefaults valueForKey:@"userName"];
                NSString *photoFolder = [NSString stringWithFormat:@"%@/%@/%@", DocumentPath,userName,self.folderName];
                if (![fileManager fileExistsAtPath:photoFolder])
                {
                    [fileManager createDirectoryAtPath:photoFolder withIntermediateDirectories:YES attributes:nil error:nil];
                }
                else
                {
                    NSString *photoFolder = [NSString stringWithFormat:@"%@/%@/%@", DocumentPath,userName,self.folderName];
                    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:photoFolder];
                    NSString *fileName;
                    while (fileName= [dirEnum nextObject])
                    {
                        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",photoFolder,fileName] error:nil];
                    }
                }
                NSData *imgData = UIImageJPEGRepresentation(self.photos[i], 1);
                [self didEncrytionImage:[self saveTheImageToTheSondBox:imgData atIndex:i imageType:@"jpg" filePath:photoFolder]];
            }];

        }
    }

}
#pragma mark - 删除原文件
- (void)isDeleOriginalPic:(id)obj
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
#pragma mark - 加密图片
- (void)didEncrytionImage:(NSString *)soucreImageURL
{
    //原图片路径
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *photosPath = [NSString stringWithFormat:@"%@/%@/%@", DocumentPath,userName,self.folderName];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:photosPath];
    NSString *imgURL;
    for (NSString *obj in files)
    {
        if ([[obj pathExtension] isEqualToString:@"jpg"] ||
            [[obj pathExtension] isEqualToString:@"png"])
        {
            imgURL = [NSString stringWithFormat:@"%@/%@/%@/%@", DocumentPath,userName,self.folderName,obj];
            break;
        }
    }

    //生成缩略图
    UIImage *image = [UIImage imageWithContentsOfFile:imgURL];
    UIImage *thumbImage = [image imageByScalingAndCroppingForSize:(CGSize){20, 20}];

    NSString *scaleName = [[[soucreImageURL lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"];
    NSString *imageScalePath = [NSString stringWithFormat:@"%@/%@/%@/%@",DocumentPath,userName,self.folderName,scaleName];
    NSData *imagedata = UIImagePNGRepresentation(thumbImage);
    [imagedata writeToFile:imageScalePath atomically:YES];
    
    
    
    //key路径，密文路径
    NSString *keyPath = [NSString stringWithString:[imageScalePath.stringByDeletingPathExtension stringByAppendingPathExtension:@"key"]];
    NSString *contentPath;
    if ([[soucreImageURL pathExtension] isEqualToString:@"jpg"])
    {
        contentPath = [NSString stringWithString:[[imageScalePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"]];
    }
    else
    {
        contentPath = [NSString stringWithString:[[imageScalePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"]];
    }
    //加密操作，需要待加密图片路径、加密比例、两个存储路径

    NSString *user_identity = [userDefaults valueForKey:@"content"];
    user_identity = [user_identity substringFromIndex:[user_identity rangeOfString:@"_"].location + 1];
    EncryptedThenAddInfo_pic([imgURL cStringUsingEncoding:NSASCIIStringEncoding],1,[keyPath cStringUsingEncoding:NSASCIIStringEncoding],[contentPath cStringUsingEncoding:NSASCIIStringEncoding],[[keyPath lastPathComponent] cStringUsingEncoding:NSASCIIStringEncoding],[user_identity cStringUsingEncoding:NSASCIIStringEncoding],CurrentVersion);
    
    NSString *moveToPath = [[keyPath stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension];
    NSData *contentData = [NSData dataWithContentsOfFile:contentPath];
    [contentData writeToFile:moveToPath atomically:YES];
    [[NSFileManager defaultManager] removeItemAtPath:contentPath error:nil];
    
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
    //发送请求,上传key

    [mgr POST:url parameters:datadict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:keyPath] name:@"file" fileName:keyPath mimeType:@"file"];
        NSLog(@"keypath is %@",keyPath);
        NSLog(@"formData is %@",formData);
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
            self.completeEncryptPhotos(@"employee is null");
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"Success"] &&
                 [[responseObject valueForKey:@"content"]isEqualToString:@"file is null"])//文件为空
        {
            NSLog(@"文件为空");
            self.completeEncryptPhotos(@"file is null");
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
        //加密成功发送通知刷新解密列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshPicture" object:self userInfo:nil];
        self.completeEncryptPhotos(@"EncryptSuccess");
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"上传失败:%@",error);
        [self deleteAllFile:keyPath];
        self.completeEncryptPhotos(@"TimeOut");
    }];

}
//没网加密时，删除所有加密过程生成的文件
- (void)deleteAllFile:(NSString *)path
{
    NSString *directory = [path stringByDeletingLastPathComponent];

    [[NSFileManager defaultManager] removeItemAtPath:directory error:nil];
}
//图片模糊
- (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

#pragma mark - 将图片保存到沙盒
/**
 *  将图片保存到沙盒
 *
 *  @param image 图片
 *  @param index 文件下标
 *
 *  @return 文件名
 */
-(NSString *)saveTheImageToTheSondBox:(NSData *)imageData atIndex:(int)index imageType:(NSString*) imageType filePath:(NSString *)filePath
{
    
    //获取当前时间
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    CFAbsoluteTime start = CACurrentMediaTime();
    
    long time = start * 10000;
    
    NSString *fileName;
    NSString *imageFile ;
    if ([imageType isEqualToString:@"png"])
    {
        fileName = [NSString stringWithFormat:@"%@%ld_%d.%@",locationString,time,index,@"png"];
        imageFile = [NSString stringWithFormat:@"%@/%@.png",filePath,[filePath lastPathComponent]];
    }else
    {
        fileName = [NSString stringWithFormat:@"%@%ld_%d.%@",locationString,time,index,@"jpg"];
        imageFile = [NSString stringWithFormat:@"%@/%@.jpg",filePath,[filePath lastPathComponent]];
    }
    
    [imageData writeToFile:imageFile atomically:YES];
    return fileName;
}


@end
