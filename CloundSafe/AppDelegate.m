//
//  AppDelegate.m
//  CloundSafe
//
//  Created by LittleMian on 16/6/25.
//
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "FICImageCache.h"
#import "CSHomeNavigationController.h"
//#import "UINavigationController+FDFullscreenPopGesture.h"
@interface AppDelegate ()<FICImageCacheDelegate>
@property (nonatomic, copy) NSDate *dateOfEnterbackground;
@property (nonatomic, copy) NSDate *dateOfEnterForground;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    NSMutableArray *mutableImageFormats = [NSMutableArray array];
    
    // Square image formats...
    NSInteger squareImageFormatMaximumCount = 400;
    FICImageFormatDevices squareImageFormatDevices = FICImageFormatDevicePhone | FICImageFormatDevicePad;
    
    // ...32-bit BGRA
    FICImageFormat *squareImageFormat32BitBGRA = [FICImageFormat formatWithName:FICDPhotoSquareImage32BitBGRAFormatName family:FICDPhotoImageFormatFamily imageSize:FICDPhotoSquareImageSize style:FICImageFormatStyle32BitBGRA
                                                                   maximumCount:squareImageFormatMaximumCount devices:squareImageFormatDevices];
    
    [mutableImageFormats addObject:squareImageFormat32BitBGRA];
    
    // ...32-bit BGR
    FICImageFormat *squareImageFormat32BitBGR = [FICImageFormat formatWithName:FICDPhotoSquareImage32BitBGRFormatName family:FICDPhotoImageFormatFamily imageSize:FICDPhotoSquareImageSize style:FICImageFormatStyle32BitBGR
                                                                  maximumCount:squareImageFormatMaximumCount devices:squareImageFormatDevices];
    
    [mutableImageFormats addObject:squareImageFormat32BitBGR];
    
    
    
    
    // ...16-bit BGR
    FICImageFormat *squareImageFormat16BitBGR = [FICImageFormat formatWithName:FICDPhotoSquareImage16BitBGRFormatName family:FICDPhotoImageFormatFamily imageSize:FICDPhotoSquareImageSize style:FICImageFormatStyle16BitBGR
                                                                  maximumCount:squareImageFormatMaximumCount devices:squareImageFormatDevices];
    
    [mutableImageFormats addObject:squareImageFormat16BitBGR];
    
    // ...8-bit Grayscale
    FICImageFormat *squareImageFormat8BitGrayscale = [FICImageFormat formatWithName:FICDPhotoSquareImage8BitGrayscaleFormatName family:FICDPhotoImageFormatFamily imageSize:FICDPhotoSquareImageSize style:FICImageFormatStyle8BitGrayscale
                                                                       maximumCount:squareImageFormatMaximumCount devices:squareImageFormatDevices];
    
    [mutableImageFormats addObject:squareImageFormat8BitGrayscale];
    
    if ([UIViewController instancesRespondToSelector:@selector(preferredStatusBarStyle)]) {
        // Pixel image format
        NSInteger pixelImageFormatMaximumCount = 1000;
        FICImageFormatDevices pixelImageFormatDevices = FICImageFormatDevicePhone | FICImageFormatDevicePad;
        
        FICImageFormat *pixelImageFormat = [FICImageFormat formatWithName:FICDPhotoPixelImageFormatName family:FICDPhotoImageFormatFamily imageSize:FICDPhotoPixelImageSize style:FICImageFormatStyle32BitBGR
                                                             maximumCount:pixelImageFormatMaximumCount devices:pixelImageFormatDevices];
        
        [mutableImageFormats addObject:pixelImageFormat];
    }
    
    // Configure the image cache
    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    [sharedImageCache setDelegate:self];
    [sharedImageCache setFormats:mutableImageFormats];
    _sharedImageCache=sharedImageCache;
    
//    FICDViewController *ViewController = [[FICDViewController alloc] init];
//    _FICDVC=ViewController;

    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    
//    CSHomeNavigationController *navigationVC = [[CSHomeNavigationController alloc]initWithRootViewController:loginVC];
    UINavigationController *navigationVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = navigationVC;
    [self.window makeKeyAndVisible];

    return YES;
}
#pragma mark - FICImageCacheDelegate

- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock
{
    //NSLog(@"appdelegate-->wantsSourceimageforEntity");
    // Images typically come from the Internet rather than from the app bundle directly, so this would be the place to fire off a network request to download the image.
    // For the purposes of this demo app, we'll just access images stored locally on disk.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *sourceImage = [(CSPicture *)entity sourceImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sourceImage);
        });
    
    });


}

- (BOOL)imageCache:(FICImageCache *)imageCache shouldProcessAllFormatsInFamily:(NSString *)formatFamily forEntity:(id<FICEntity>)entity
{
    BOOL shouldProcessAllFormats = [formatFamily isEqualToString:FICDPhotoImageFormatFamily];
    
    return shouldProcessAllFormats;
}

- (void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage
{
    NSLog(@"imageCache error:%@", errorMessage);
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    
    
    return YES;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    if (self.window) {
        if (url) {
            NSString *urlStr = [url absoluteString];
            NSLog(@"%@",urlStr);
            NSArray *arr=[urlStr componentsSeparatedByString:@"private"];
            NSLog(@"%@",arr);
            NSString *Str=arr[1];
            NSLog(@"Str=%@",Str);
            NSString *fileNameStr = [url lastPathComponent];
            
            NSString *Doc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/localFile"] stringByAppendingPathComponent:fileNameStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:Doc atomically:YES];
            NSLog(@"Lisa.Doc=%@",Doc);
            
            NSString *userName = [userDefaults valueForKey:@"userName"];
            NSString *photosPath = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
            NSFileManager *fileManage = [NSFileManager defaultManager];
            NSLog(@"Lisa.application.photopath=%@",photosPath);
            
            self.dateOfEnterbackground = [NSDate date];
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
            NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
            
            NSString *myDirectory = [photosPath stringByAppendingPathComponent:@"imtp_"];
            NSString *myjointDirectory = [myDirectory stringByAppendingString:currentDateStr];
            NSLog(@"Lisa.myjointDirectory=%@",myjointDirectory);
            NSString *movePath = [myjointDirectory stringByAppendingPathComponent:fileNameStr];

            
            NSLog(@"Lisa.movePath=%@",movePath);


            BOOL ok = [fileManage createDirectoryAtPath:myjointDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            if (ok) {
                NSLog(@"文件夹创建成功");
            } else {
                NSLog(@"文件夹创建失败");
            }
            
            BOOL result = [fileManage fileExistsAtPath:Doc];
            NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
            BOOL result01 = [fileManage fileExistsAtPath:urlStr];
            NSLog(@"这个文件已经存在：%@",result01?@"是的":@"不存在");
            BOOL result02 = [fileManage fileExistsAtPath:Str];
            NSLog(@"这个文件已经存在：%@",result02?@"是的":@"不存在");
            
            BOOL isMovePath = [fileManage moveItemAtPath:Str toPath:movePath error:nil];
             NSLog(@"Lisa.Doc=%@",Doc);
           
            
            if (isMovePath) {
                NSLog(@"文件移动成功");
            }
            else {
                NSLog(@"文件移动失败");
            }

        }
    }
    return YES;
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    self.dateOfEnterbackground = [NSDate date];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH-mm-ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    NSLog(@"应用进入后台的时间为：%@", currentDateStr);
    
}
//比较两个日期差
-(NSInteger)compare:(NSDate *)startTime to:(NSDate *)endTime
{
    
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startTime toDate:endTime options:0];
    NSString *time = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld",dateCom.year,dateCom.month,dateCom.day,dateCom.hour,dateCom.minute,dateCom.second];
    NSLog(@"时间差为：%@",time);
    
    return [time integerValue];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH-mm-ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    NSLog(@"应用进入前台的时间为：%@", currentDateStr);
    

    self.dateOfEnterForground = [NSDate date];
    //判断用户是否登录
    NSNumber *num = [userDefaults valueForKey:ISLOGIN];
    //这里设置了应用进入后台后，再从后台进入前台的时间间隔为10时要重新登录
    if([self compare:self.dateOfEnterbackground to:self.dateOfEnterForground] > 30 && num.boolValue){
        //这一句一定要在前面
        [userDefaults setObject:@(YES) forKey:NEEDLOGIN];
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        
        UINavigationController *navigationVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = navigationVC;
    }


}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //程序结束对数据库文件进行加密
    NSString *userName = [userDefaults valueForKey:@"userName"];
    if (userName)
    {
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@/%@",DocumentPath,userName,DBFILE_NAME];
        NSData *data = [NSData dataWithContentsOfFile:dbPath];
        
        // 或 base64EncodedStringWithOptions
        NSData *base64Data = [data base64EncodedDataWithOptions:0];
        
        // 将加密后的文件存储用户主目录下
        [base64Data writeToFile:dbPath atomically:YES];
    }
    [userDefaults setObject:@(NO) forKey:ISLOGIN];

}

@end
