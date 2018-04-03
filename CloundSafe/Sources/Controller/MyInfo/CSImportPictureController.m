//
//  CSExportPictureController.m
//  CloundSafe
//
//  Created by AlanZhang on 16/9/19.
//
//

#import "CSImportPictureController.h"
#import "CSPicture.h"
#import "CSCollectionCell.h"
#import "UIView+Layout.h"
#import "CSDisplayPictureController.h"

@interface CSImportPictureController ()

@end

@implementation CSImportPictureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [left setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:left];

    self.imageArr = [self loadPhoto];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshPicture) name:@"refleshPicture" object:nil];

}
- (void)refleshPicture
{
    self.imageArr = [self loadPhoto];
    [self.decrytionImgArr removeAllObjects];
    self.decrytionBtn.enabled = self.decrytionImgArr.count;
    self.shareBtn.enabled = self.decrytionImgArr.count;
    [self.collectionView reloadData];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)decryptionImage:(UIButton *)button
{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将解密后的图片保存到相册？" preferredStyle:UIAlertControllerStyleAlert];
    
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
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    dispatch_group_t group = dispatch_group_create();
    for (NSURL *soucreImageURL in self.decrytionImgArr)
    {
        NSString *keyFilePath = [[[soucreImageURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"];
        NSString *soucreImagePath = [[keyFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension];
        
        NSString *url = DownLoadKeyURL;
        [self downLoad:url fileName:keyFilePath soucreImagePath:soucreImagePath group:group];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"解密完成";
        [self.HUD hideAnimated:YES afterDelay:0.6];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.HUD removeFromSuperview];
        });
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshPicture" object:self userInfo:nil];
    });
    
    
}
- (void)passimagePath:(NSString *)path
{
    //覆盖父方法，禁止了点击Cell的事件，该方法为空就行，添加代码
}
- (void)saveContent:(NSString *)contentPath
{
    //覆盖父方法，不保存密文，该方法为空就行，添加代码
}
- (void)downLoad:(NSString *)url fileName:(NSString *)keyFilePath soucreImagePath:(NSString *)contentImagePath group:(dispatch_group_t)group
{
    
    char *info = (char *)malloc(sizeof(char) * 150);
    GetUserInfo([contentImagePath cStringUsingEncoding:NSASCIIStringEncoding], info);
    NSString *userInfo = [NSString stringWithFormat:@"%s",info];
    free(info);
    NSLog(@"原主人identity = %@",userInfo);
    
    NSRange fileIDRange = [userInfo rangeOfString:@"$$$$"];
    NSString *fileID = [userInfo substringWithRange:NSMakeRange(0, fileIDRange.location)];
    NSString *identityAndVersion = [userInfo substringFromIndex:fileIDRange.location+4];

    NSRange identityRange = [identityAndVersion rangeOfString:@"$$$$"];
    NSString *identity = [identityAndVersion substringWithRange:NSMakeRange(0, identityRange.location)];

    
    NSString *user_identity = [userDefaults valueForKey:@"content"];
    user_identity = [user_identity substringFromIndex:[user_identity rangeOfString:@"_"].location + 1];
    NSLog(@"开始解密共享密文，identity = %@",user_identity);
    
    NSMutableDictionary *datadict = [[NSMutableDictionary alloc] init];
    [datadict setObject:user_identity forKey:@"user_identify"];
    [datadict setObject:fileID forKey:@"file_id"];

    
    
    NSLog(@"进入group");
    dispatch_group_enter(group);
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:datadict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *file_content = responseObject[@"content"];
        if ([file_content isEqualToString:@"employee is null"])//用户不存在（用户信息为空）
        {
            NSLog(@"%@",file_content);
            [self alert:@"用户不存在！"];
        }else if ([file_content isEqualToString:@"file is null"])//文件为空
        {
            NSLog(@"%@",file_content);
            [self alert:@"文件为空！"];
        }else if ([file_content isEqualToString:@"request has been submitted"])//请求已经被提交至文件原拥有人
        {
            NSLog(@"%@",file_content);
            [self alert:@"请求已经被提交至文件原拥有人！"];
        }else if ([file_content isEqualToString:@"file under review"])//文件正在审核
        {
            NSLog(@"%@",file_content);
            [self alert:@"文件正在审核！"];
        }else if ([file_content isEqualToString:@"file audit not passed"])//文件审核不通过
        {
            NSLog(@"%@",file_content);
            [self alert:@"文件审核不通过！"];
        }else
        {
            NSLog(@"正在下载密钥……");

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
            //NSLog(@"fileurl = %@",fileUrl);
            
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
                if ([data writeToFile:keyFilePath atomically:YES])
                {
                    //NSLog(@"保存成功.");
                    /**
                     *  开始解密
                     */
                    [self decryption:contentImagePath];
                    
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
        NSLog(@"离开group");

        dispatch_group_leave(group);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        dispatch_group_leave(group);
    }];
}
- (NSArray *)loadPhoto
{
    //照片路径
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *photosPath = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSLog(@"Lisa.photopath=%@",photosPath);
    
    if ([fileManage fileExistsAtPath:photosPath])
    {
        NSArray *files = [fileManage subpathsAtPath:photosPath];
        NSMutableArray *photoArr = [NSMutableArray array];
        for (NSString *obj in files)
        {
            BOOL directory;
            NSString *importDic = [NSString stringWithFormat:@"%@/%@",photosPath, obj];
            if ([fileManage fileExistsAtPath:importDic isDirectory:&directory])
            {
                if (directory == YES && [[obj substringWithRange:ImportPicRange]isEqualToString:ImportPic])
                {
                    NSArray *importFiles = [fileManage subpathsAtPath:importDic];
                    for (NSString *importObj in importFiles)
                    {
                        if ([[importObj pathExtension] isEqualToString:CipherExtension])
                        {
                            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",importDic,importObj];
                            NSLog(@"Lisa.photopath.imagepath=%@",imagePath);
                            NSURL *url = [NSURL URLWithString:imagePath];
                            NSLog(@"Lisa.photopath.url=%@",url);
                            CSPicture *picture = [[CSPicture alloc]init];
                            [picture setSourceImageURL:url];
                            [photoArr addObject:picture];
                        }
                    }
                }
            }
            
        }
        return [[NSArray alloc]initWithArray:photoArr];
    }else
    {
        NSLog(@"文件夹不存在！");
        return nil;
    }
    
}
- (void)alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
