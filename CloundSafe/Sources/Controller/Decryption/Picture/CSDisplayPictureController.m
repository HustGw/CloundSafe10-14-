//
//  CSDisplayPictureViewController.m
//  CloundSafe
//
//  Created by LittleMian on 16/7/11.
//
//

#import "CSDisplayPictureController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <Photos/Photos.h>
#import "MyAlbum.h"
@interface CSDisplayPictureController (){
    MyAlbum *_MyAlbum;
}
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *contentImagePath;
@property (nonatomic, assign) BOOL isSaveImage;
@property (nonatomic, strong) NSData *contentData;
@property (nonatomic, strong) NSString *contentFile;




@end

@implementation CSDisplayPictureController
- (id)initWithImage:(UIImage *)image
{
    if (self = [super init])
    {
        self.image = image;
        self.contentImagePath = @"";
        self.isSaveImage = YES;
    }
    return self;
}




- (void) setImagePath:(NSString *)path
{
    self.contentImagePath = [[path stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension];
    self.image = [UIImage imageWithContentsOfFile:self.contentImagePath];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIImage *navi_back = [UIImage imageNamed:@"navi_back"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:navi_back style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.navigationItem.title = @"解密图片";
     _MyAlbum = [[MyAlbum alloc]initWithFolderName:@"云加密"];
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.clipsToBounds  = YES;
    self.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.imageView.image = self.image;
    /*
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    CGFloat rgb = 253 / 255.0;
    bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    [self.view addSubview:bottomToolBar];
    UIButton *decrytionBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 44 - 12, 3, 44, 44)];
//    UIColor *oKButtonTitleColorNormal   = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0];
    UIColor *oKButtonTitleColorNormal   = [UIColor colorWithRed:17.0/255.0 green:205.0/255.0 blue:110.0/255.0 alpha:1.0];
  
    decrytionBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    [decrytionBtn addTarget:self action:@selector(decryptionImage:) forControlEvents:UIControlEventTouchUpInside];
    [decrytionBtn setTitle:@"解密" forState:UIControlStateNormal];
    [decrytionBtn setTitleColor:oKButtonTitleColorNormal forState:UIControlStateNormal];
    
    UIButton *shareBtn = [[UIButton alloc]init];
    [bottomToolBar addSubview:shareBtn];
    [shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomToolBar);
        make.left.equalTo(bottomToolBar).offset(10);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    [shareBtn setTitle:@"共享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:oKButtonTitleColorNormal forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *divide = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    divide.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    divide.frame = CGRectMake(0, 0, kScreenWidth, 1);
    
    [bottomToolBar addSubview:divide];
    [bottomToolBar addSubview:decrytionBtn];
     */
    self.decrytionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width*0.60, 50)];
    self.decrytionBtn.enabled = NO;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width*0.68, 50);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.1),@(1.0)];
    [gradientLayer setColors:@[(id)[RGB(0x31C2B1,1) CGColor],(id)[RGB(0x1C27C,1) CGColor]]];
    [self.decrytionBtn.layer addSublayer:gradientLayer];
    self.decrytionBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.decrytionBtn setTitle:@"解密" forState:UIControlStateNormal];
    [self.decrytionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.decrytionBtn addTarget:self action:@selector(decryptionImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.decrytionBtn setTitle:@"解密" forState:UIControlStateDisabled];
    [self.view addSubview:self.decrytionBtn];
    self.shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.6, self.view.frame.size.height-50, self.view.frame.size.width*0.4, 50)];
    self.shareBtn.enabled = NO;
    [self.shareBtn setTitle:@"共享" forState:UIControlStateNormal];
    [self.shareBtn setTitle:@"共享" forState:UIControlStateDisabled];
    self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.shareBtn.backgroundColor = [UIColor whiteColor];
    [self.shareBtn setTitleColor:RGB(0x31c27c, 1) forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareBtn];
   // [self.navigationController.navigationBar.layer addSublayer:gradientLayer];
    
}
#pragma mark - 共享
- (void)shareContent:(UIButton *)button
{
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:self.contentImagePath]] applicationActivities:nil];
    
    [self presentViewController:activity animated:YES completion:NULL];

}
/**
 *  解密图片
 *
 *  @param button 事件源
 */
- (void)decryptionImage:(UIButton *)button
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将解密后的图片保存到相册？所有解密后的图片可在最近解密中查看" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.isSaveImage = YES;
        [self beginDecryption];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.isSaveImage = NO;
        [self beginDecryption];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)beginDecryption
{
    NSString *keyFilePath = [[self.contentImagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"];
    
    NSString *url = DownLoadKeyURL;
    
    [self downLoad:url fileName:keyFilePath];
}
- (void)downLoad:(NSString *)url fileName:(NSString *)name
{
    NSString *user_identity = [userDefaults valueForKey:@"content"];
    user_identity = [user_identity substringFromIndex:[user_identity rangeOfString:@"_"].location + 1];
    
    NSMutableDictionary *datadict = [[NSMutableDictionary alloc] init];
    [datadict setObject:user_identity forKey:@"user_identify"];
    [datadict setObject:[name lastPathComponent] forKey:@"file_id"];
    
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    

    [mgr POST:url parameters:datadict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *file_content = responseObject[@"content"];
        if ([file_content isEqualToString:@"employee is null"])//用户不存在（用户信息为空）
        {
            NSLog(@"%@",file_content);
            [self alert:@"用户不存在!"];
        }else if ([file_content isEqualToString:@"file is null"])//文件为空
        {
            NSLog(@"%@",file_content);
            [self alert:@"文件为空!"];
        }else if ([file_content isEqualToString:@"request has been submitted"])//请求已经被提交至文件原拥有人
        {
            NSLog(@"%@",file_content);
            [self alert:@"请求已经被提交至文件原拥有人!"];
        }else if ([file_content isEqualToString:@"file under review"])//文件正在审核
        {
            NSLog(@"%@",file_content);
            [self alert:@"文件正在审核!"];
        }else if ([file_content isEqualToString:@"file audit not passed"])//文件审核不通过
        {
            NSLog(@"%@",file_content);
            [self alert:@"文件审核不通过!"];
        }else
        {
            NSLog(@"正在下载密钥……");
//            NSRange startrang = [file_content rangeOfString:@"http"];
//            NSRange endrang = [file_content rangeOfString:@"key"];
//            
//            NSUInteger len = endrang.location + endrang.length - startrang.location;
//            
//            NSString *fileUrl = [file_content substringWithRange:NSMakeRange(startrang.location, len)];
            //file_content为文件对象的List集合转化成的Json字符串，file_content转字典
            file_content = [file_content stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            NSData *jsonData = [file_content dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSString *fileUrl = [[dic valueForKey:@"fp_content"] lastObject];
            if(err)
            {
                NSLog(@"json解析失败：%@",err);
                
            }
//            NSLog(@"fileurl = %@",fileUrl);

            //文件下载
            NSURL    *url = [NSURL URLWithString:fileUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSError *error = nil;
            NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:nil
                                                               error:&error];
            /* 下载的数据 */
            NSLog(@"文件下载成功");
            if (data != nil)
            {
                //NSLog(@"下载成功");
                if ([data writeToFile:name atomically:YES])
                {
                    //NSLog(@"保存成功.");
                    /**
                     *  开始解密
                     */
                    [self decryption:name];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else
                {
                    //NSLog(@"保存失败.");
                }
            } else
            {
                NSLog(@"%@", error);
            }
            
        }
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"解密完成";
        [self.HUD hideAnimated:YES afterDelay:0.6];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.HUD removeFromSuperview];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}
/**
 *  解密图片
 */
- (void)decryption:(NSString *)key
{
    NSLog(@"开始解密");
    //解密
    self.contentData = [NSData dataWithContentsOfFile:self.contentImagePath];
    NSString *tempContent = [NSString stringWithFormat:@"%@/cipherText.content",[self.contentImagePath stringByDeletingLastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempContent])
    {
        [[NSFileManager defaultManager] createFileAtPath:tempContent contents:nil attributes:nil];
    }
    NSFileHandle *writeHandler = [NSFileHandle fileHandleForWritingAtPath:tempContent];
    [writeHandler writeData:self.contentData];
    [writeHandler closeFile];
   
    AgreedThenDecryption_pic([self.contentImagePath cStringUsingEncoding:NSASCIIStringEncoding],[key cStringUsingEncoding:NSASCIIStringEncoding]);
    
    //解密后照片路径
    [[NSFileManager defaultManager] moveItemAtPath:self.contentImagePath toPath:[[self.contentImagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"] error:nil];
    
    //解密成功后对密文重命名
   // [[NSFileManager defaultManager] moveItemAtPath:tempContent toPath:self.contentImagePath error:nil];

    if (self.isSaveImage == YES)
    {
//        UIImage *image = [UIImage imageWithContentsOfFile:self.contentImagePath];
//        //NSLog(@"%@",soucreImagePath);
//        void *path = (__bridge_retained void *)self.contentImagePath;
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), path);
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:[[self.contentImagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"]]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
                    [[NSFileManager defaultManager] removeItemAtPath:[[self.contentImagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"] error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:[[self.contentImagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"] error:nil];
                    //解密成功刷新解密列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshPicture" object:self userInfo:nil];
                    
                    
                    NSLog(@"保存成功！");
                } else if (error) {
                    NSLog(@"保存照片出错:%@",error.localizedDescription);
                }
            });
            
        }];

    }else
    {
        [[NSFileManager defaultManager] removeItemAtPath:[[self.contentImagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[[self.contentImagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"] error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshPicture" object:self userInfo:nil];
    }
    
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *path = (__bridge_transfer NSString *)contextInfo;
    //NSLog(@"%@",path);
    if(error != NULL)
    {
        NSLog(@"保存图片失败：%@",error);
    }else
    {
        //[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"] error:nil];
        
        //NSLog(@"保存图片成功");

        //解密成功刷新解密列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshPicture" object:self userInfo:nil];
        
    }
}

/**
 *  返回指定大小的图片
 *
 *  @param image 源图片
 *  @param size  大小
 *
 *  @return 返回指定大小的图片
 */
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage; //返回的就是已经改变的图片
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
