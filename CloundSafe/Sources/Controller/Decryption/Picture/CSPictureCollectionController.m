//
//  CSHomeCollectionViewController.m
//  CloundSafe
//
//  Created by LittleMian on 16/7/6.
//
//

#import "CSPictureCollectionController.h"
#import "CSCollectionCell.h"
#import "UIView+Layout.h"
#import "CSPicture.h"
#import "CSDecryptionController.h"
#import "CSDisplayPictureController.h"
#import "FICImageCache.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

NSInteger const maxCount = 9;//图片选择上限
@interface CSPictureCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CSFullScreenPictureDisplayDelegate>


@end

@implementation CSPictureCollectionController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configCollectionView];
    self.imageArr = [CSDecryptionController loadPhoto];
    self.isSaveImage = YES;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [left setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.leftBarButtonItem = left;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshPicture) name:@"refleshPicture" object:nil];
}
- (void)refleshPicture
{
    self.imageArr = [CSDecryptionController loadPhoto];
    [self.decrytionImgArr removeAllObjects];
    self.decrytionBtn.enabled = self.decrytionImgArr.count;
    self.shareBtn.enabled = self.decrytionImgArr.count;
    [self.collectionView reloadData];
}
#pragma mark - fullScreenDisplayPicture
- (void)passimagePath:(NSString *)path
{
    CSDisplayPictureController *vc = [[CSDisplayPictureController alloc]init];
    [vc setImagePath:path];
//    self.decrytionImgArr = nil;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)passImage:(UIImage *)image imagePath:(NSString *)path
{
    CSDisplayPictureController *vc = [[CSDisplayPictureController alloc]initWithImage:image];
    [vc setImagePath:path];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSCollectionCell *cell = (CSCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    __weak typeof(cell) weakCell = cell;
    CSPicture *picture = self.imageArr[indexPath.row];
    [cell setImageFormatName:self.imageFormatName];
    [cell setPicture:picture];
    cell.imageIdentifier = [[picture sourceImageURL] path];
    cell.delegate = self;
    cell.didSelectPhotoBlock = ^(BOOL isSelected){
        // 1. cancel select / 取消选择
        if (isSelected)
        {
            weakCell.selectPhotoButton.selected = NO;
            CSPicture *picture = self.imageArr[(int)indexPath.row];
            if ([weakCell.imageIdentifier isEqualToString:[[picture sourceImageURL] path]])
            {
                [self.decrytionImgArr removeObject:[picture sourceImageURL]];
            }
            
        } else
        {
        // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            if (_decrytionImgArr == nil)
            {
                _decrytionImgArr = [[NSMutableArray alloc]init];
            }
            if (self.decrytionImgArr.count < maxCount)
            {
                weakCell.selectPhotoButton.selected = YES;
                CSPicture *picture = self.imageArr[(int)indexPath.row];
                [_decrytionImgArr addObject:[picture sourceImageURL]];

            }else
            {
                NSString *msg = [NSString stringWithFormat:@"你最多只能选择%ld张照片",(long)maxCount];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        self.decrytionBtn.enabled = self.decrytionImgArr.count;
        self.shareBtn.enabled = self.decrytionImgArr.count;
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select section %ld and row %ld",indexPath.section,indexPath.row);
}
#pragma mark - 解密按钮
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
#pragma mark - 开始解密
- (void)beginDecryption
{
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
    });
    

}

- (void)downLoad:(NSString *)url fileName:(NSString *)keyFilePath soucreImagePath:(NSString *)contentImagePath group:(dispatch_group_t)group
{
    NSString *user_identity = [userDefaults valueForKey:@"content"];
    user_identity = [user_identity substringFromIndex:[user_identity rangeOfString:@"_"].location + 1];
    NSLog(@"identity = %@",user_identity);
    NSMutableDictionary *datadict = [[NSMutableDictionary alloc] init];
    [datadict setObject:user_identity forKey:@"user_identify"];
    [datadict setObject:[keyFilePath lastPathComponent] forKey:@"file_id"];

    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSLog(@"进入group");
    dispatch_group_enter(group);
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
    NSLog(@"离开group");
        dispatch_group_leave(group);
    }];
    
}
/**
 *  解密图片
 */
- (void)decryption:(NSString *)contentPath
{
    NSLog(@"开始解密");
    //解密
    NSString *keyFilePath = [[contentPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"];

    //备份密文数据
    [self saveContent:contentPath];

    AgreedThenDecryption_pic([contentPath cStringUsingEncoding:NSASCIIStringEncoding],[keyFilePath cStringUsingEncoding:NSASCIIStringEncoding]);
    //解密后照片路径
#pragma warning - 图片格式
    NSString *folderPath = [contentPath stringByDeletingLastPathComponent];
    NSString *dePic = [NSString stringWithFormat:@"%@/%@",folderPath,[[[contentPath lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"]];
    
    NSError *renameError;
    [[NSFileManager defaultManager] moveItemAtPath:contentPath toPath:dePic error:&renameError];
    if (renameError)
    {
        NSLog(@"图片重命名失败");
        NSLog(@"%@",renameError);
    }else
    {
//        NSLog(@"图片重命名成功");
    }
    
    if (self.isSaveImage == YES)
    {

        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:[[contentPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"]]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
                    [[NSFileManager defaultManager] removeItemAtPath:[[contentPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"] error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:[[contentPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"] error:nil];
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
        [[NSFileManager defaultManager] removeItemAtPath:[[contentPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[[contentPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"] error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshPicture" object:self userInfo:nil];
    }
    
}
//保存密文
- (void)saveContent:(NSString *)contentPath
{
    self.contentData = [NSData dataWithContentsOfFile:contentPath];
    NSString *tempContent = [NSString stringWithFormat:@"%@/cipherText.content",[contentPath stringByDeletingLastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempContent])
    {
        [[NSFileManager defaultManager] createFileAtPath:tempContent contents:nil attributes:nil];
    }
    NSFileHandle *writeHandler = [NSFileHandle fileHandleForWritingAtPath:tempContent];
    [writeHandler writeData:self.contentData];
    [writeHandler closeFile];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *path = (__bridge_transfer NSString *)contextInfo;
//    NSLog(@"%@",path);
    if(error != NULL)
    {
        NSLog(@"保存图片失败：%@",error);
    }else
    {
        //[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"] error:nil];
        //解密成功刷新解密列表
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshPicture" object:self userInfo:nil];

    }
}
#pragma mark - 分享密文
- (void)shareContent:(UIButton *)button
{
    NSMutableArray *shareContents = [[NSMutableArray alloc]init];
    for (NSURL *url in self.decrytionImgArr)
    {
        NSString *path = [[[url path] stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension];
        [shareContents addObject:[NSURL fileURLWithPath:path]];
    }
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:shareContents applicationActivities:nil];
    //    activity.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    [self presentViewController:activity animated:YES completion:NULL];
}
- (void)configCollectionView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:view];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 4;
    CGFloat itemWH = (kScreenWidth - 2 * margin - 4) / 4 - margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    CGFloat top = margin + 44;
    if (iOS7Later) top += 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(margin, top, kScreenWidth - 2 * margin, kScreenHeight - top - margin - 50) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    if (iOS7Later) _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    
    [_collectionView registerClass:[CSCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
    self.navigationItem.title = @"选择图片";
    
    _imageFormatName = FICDPhotoSquareImage32BitBGRAFormatName;
    
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    CGFloat rgb = 253 / 255.0;
    bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    self.decrytionBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 44 - 12, 3, 44, 44)];
    [self.view addSubview:bottomToolBar];
    
//    UIColor *oKButtonTitleColorNormal   = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0];
//    UIColor *oKButtonTitleColorDisabled = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:0.5];
    UIColor *oKButtonTitleColorNormal   = [UIColor colorWithRed:17.0/255.0 green:205.0/255.0 blue:110.0/255.0 alpha:1.0];
    UIColor *oKButtonTitleColorDisabled = [UIColor colorWithRed:17.0/255.0 green:205.0/255.0 blue:110.0/255.0 alpha:0.5];
    
    self.decrytionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.decrytionBtn.enabled = NO;
    [self.decrytionBtn addTarget:self action:@selector(decryptionImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.decrytionBtn setTitle:@"解密" forState:UIControlStateNormal];
    [self.decrytionBtn setTitle:@"解密" forState:UIControlStateDisabled];
    [self.decrytionBtn setTitleColor:oKButtonTitleColorNormal forState:UIControlStateNormal];
    [self.decrytionBtn setTitleColor:oKButtonTitleColorDisabled forState:UIControlStateDisabled];
    
    UIView *divide = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    divide.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    divide.frame = CGRectMake(0, 0, self.view.tz_width, 1);
    
    self.shareBtn = [[UIButton alloc]init];
    self.shareBtn.enabled = NO;
    [self.shareBtn setTitleColor:oKButtonTitleColorNormal forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:oKButtonTitleColorDisabled forState:UIControlStateDisabled];
    [bottomToolBar addSubview:self.shareBtn];
    [self.shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomToolBar);
        make.left.equalTo(bottomToolBar).offset(10);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    [self.shareBtn setTitle:@"共享" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:oKButtonTitleColorNormal forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomToolBar addSubview:divide];
    [bottomToolBar addSubview:self.decrytionBtn];
}
- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
