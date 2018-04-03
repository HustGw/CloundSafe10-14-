//
//  CSVedioCollectionController.m
//  CloundSafe
//
//  Created by AlanZhang on 16/7/28.
//
//

#import "CSVedioCollectionController.h"
#import "CSCollectionCell.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
static NSString * const reuseIdentifier = @"Cell";
@interface CSVedioCollectionController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CSFullScreenPictureDisplayDelegate,MWPhotoBrowserDelegate>

@end
@implementation CSVedioCollectionController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vedioArr = [self loadVedio];
    [self configCollectionView];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backtoRoot)];
    [left setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = left;
    
    self.navigationItem.title = @"选择视频";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)backtoRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - fulldisplayDelegate
- (void)passimagePath:(NSString *)path
{
    // Single video
    NSString *vedioPath = [[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"mov"];
    NSString *coverImagePath = path;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    
   MWPhoto *photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:coverImagePath]];
    photo.videoURL = [NSURL fileURLWithPath:vedioPath];
    if (_photos == nil)
    {
        _photos = [[NSMutableArray alloc]init];
    }
    [_photos addObject:photo];
    enableGrid = NO;
    autoPlayOnAppear = YES;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.navigationItem.title = @"视频";
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:browser animated:YES];

}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.vedioArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSCollectionCell *cell = (CSCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    __weak typeof(cell) weakCell = cell;
    CSPicture *picture = self.vedioArr[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"play"];
    [weakCell setPlayerImageView:imageView];
    [weakCell setImageFormatName:self.imageFormatName];
    [weakCell setPicture:picture];
    weakCell.imageIdentifier = [[picture sourceImageURL] path];
    weakCell.delegate = self;
    weakCell.didSelectPhotoBlock = ^(BOOL isSelected){
        // 1. cancel select / 取消选择
        
        if (isSelected)
        {
            weakCell.selectPhotoButton.selected = NO;
            CSPicture *picture = self.vedioArr[(int)indexPath.row];
            if ([weakCell.imageIdentifier isEqualToString:[[picture sourceImageURL] path]])
            {
                [self.decrytionVedioArr removeObject:[picture sourceImageURL]];
            }
            
        } else
        {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            if (self.decrytionVedioArr == nil)
            {
                self.decrytionVedioArr = [[NSMutableArray alloc]init];
            }
            if (self.decrytionVedioArr.count < 1)
            {
                weakCell.selectPhotoButton.selected = YES;
                CSPicture *picture = self.vedioArr[(int)indexPath.row];
                [self.decrytionVedioArr addObject:[picture sourceImageURL]];
                
            }else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你最多只能选择1个视频文件" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        self.decrytionBtn.enabled = self.decrytionVedioArr.count;
        self.shareBtn.enabled = self.decrytionVedioArr.count;
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select section %ld and row %ld",indexPath.section,indexPath.row);
}
#pragma mark - 视频解密按钮
- (void)decryptionVedio:(UIButton *)sender
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    
    NSURL *keyFileURL = self.decrytionVedioArr.firstObject;
    NSString *keyFilePath = [[[keyFileURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"];
    dispatch_group_t group = dispatch_group_create();
    
    NSString *url = DownLoadKeyURL;
    
    [self downLoad:url fileName:keyFilePath group:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"解密完成";
        [self.HUD hideAnimated:YES afterDelay:0.6];
        self.HUD = nil;
    });

}
- (void)downLoad:(NSString *)url fileName:(NSString *)name group:(dispatch_group_t)group
{
    NSString *user_identity = [userDefaults valueForKey:@"content"];
    user_identity = [user_identity substringFromIndex:[user_identity rangeOfString:@"_"].location + 1];
    
    NSMutableDictionary *datadict = [[NSMutableDictionary alloc] init];
    [datadict setObject:user_identity forKey:@"user_identify"];
    [datadict setObject:[name lastPathComponent] forKey:@"file_id"];
    
    
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
            
            
            //文件下载
            
            NSURL    *url = [NSURL URLWithString:fileUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSError *error = nil;
            NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:nil
                                                               error:&error];
            /* 下载的数据 */
            if (data != nil)
            {
                
                if ([data writeToFile:name atomically:YES])
                {
                    NSLog(@"密钥下载成功");
                    /**
                     *  开始解密
                     */
                    [self beginDecryption:name];
                    
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
        [self alert:@"无网络连接!"];
        dispatch_group_leave(group);
    }];
    
}
- (void)saveContent:(NSString *)keyFilePath
{
    NSString *vedioPath = [[keyFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension];
    NSString *userName = [userDefaults valueForKey:@"userName"];
    self.contentFile = [NSString stringWithFormat:@"%@/%@/%@",DocumentPath,userName,[[[keyFilePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension]];
    
    [[NSFileManager defaultManager] copyItemAtPath:vedioPath toPath:self.contentFile error:nil];
    
    AgreedThenDecryption([vedioPath cStringUsingEncoding:NSASCIIStringEncoding],[keyFilePath cStringUsingEncoding:NSASCIIStringEncoding]);
    
    //解密在密文上进行，完成后更改后缀名为mov
    NSString *moveToPath = [[vedioPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"mov"];
    [[NSFileManager defaultManager] moveItemAtPath:vedioPath toPath:moveToPath error:nil];
    //解密成功后保留密文
    [[NSFileManager defaultManager] moveItemAtPath:self.contentFile toPath:[[vedioPath stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension] error:nil];
}
/**
 *  解密视频
 */
- (void)beginDecryption:(NSString *)keyFilePath
{
    NSLog(@"开始解密");
    [self saveContent:keyFilePath];

    //删除key文件
    [[NSFileManager defaultManager] removeItemAtPath:keyFilePath error:nil];

    NSString *scale = [[keyFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"];
    [[NSFileManager defaultManager] moveItemAtPath:scale toPath:[[scale stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"] error:nil];
    //更新列表
    [self.decrytionVedioArr removeAllObjects];
    self.vedioArr = [self loadVedio];
    [self.collectionView reloadData];
    NSLog(@"解密成功");

    
}

#pragma mark - 密文共享
- (void)shareContent:(UIButton *)sender
{
    NSURL *contentURL = self.decrytionVedioArr.firstObject;
    NSString *contentPath = [[[contentURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:CipherExtension];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:contentPath]] applicationActivities:nil];
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
    self.navigationItem.title = @"选择视频";
    
    _imageFormatName = FICDPhotoSquareImage32BitBGRAFormatName;
    /*
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    CGFloat rgb = 253 / 255.0;
    bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    self.decrytionBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 3, 44, 44)];
    [self.view addSubview:bottomToolBar];
//    UIColor *oKButtonTitleColorNormal   = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0];
//    UIColor *oKButtonTitleColorDisabled = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:0.5];
    UIColor *oKButtonTitleColorNormal   = [UIColor colorWithRed:17.0/255.0 green:205.0/255.0 blue:110.0/255.0 alpha:1.0];
    UIColor *oKButtonTitleColorDisabled = [UIColor colorWithRed:17.0/255.0 green:205.0/255.0 blue:110.0/255.0 alpha:0.5];
    self.decrytionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.decrytionBtn.enabled = NO;
    [self.decrytionBtn addTarget:self action:@selector(decryptionVedio:) forControlEvents:UIControlEventTouchUpInside];
    [self.decrytionBtn setTitle:@"解密" forState:UIControlStateNormal];
    [self.decrytionBtn setTitle:@"解密" forState:UIControlStateDisabled];
    [self.decrytionBtn setTitleColor:oKButtonTitleColorNormal forState:UIControlStateNormal];
    [self.decrytionBtn setTitleColor:oKButtonTitleColorDisabled forState:UIControlStateDisabled];
    
    UIView *divide = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    divide.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    divide.frame = CGRectMake(0, 0, kScreenWidth, 1);
    
    self.shareBtn = [[UIButton alloc]init];
    self.shareBtn.enabled = NO;
    [self.shareBtn setTitleColor:oKButtonTitleColorNormal forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:oKButtonTitleColorDisabled forState:UIControlStateDisabled];
    [bottomToolBar addSubview:self.shareBtn];
    [self.shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomToolBar);
        make.left.equalTo(bottomToolBar).offset(kScreenWidth-54);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    [self.shareBtn setTitle:@"共享" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:oKButtonTitleColorNormal forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomToolBar addSubview:divide];
    [bottomToolBar addSubview:self.decrytionBtn];
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
    [self.decrytionBtn addTarget:self action:@selector(decryptionVedio:) forControlEvents:UIControlEventTouchUpInside];
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
}
- (NSArray *)loadVedio
{
    //照片路径
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *photosPath = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:photosPath])
    {

        NSArray *files = [fileManage subpathsAtPath:photosPath];
        NSMutableArray *photoArr = [NSMutableArray array];
        for (NSString *obj in files)
        {
            //NSLog(@"%@",[[obj lastPathComponent] substringWithRange:NSMakeRange(0, 4)]);
            if ([[obj pathExtension] isEqualToString:@"scale"] && [[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"video"])
            {
                NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@/%@",DocumentPath,userName,[obj stringByDeletingLastPathComponent],[obj lastPathComponent]];
                NSURL *url = [NSURL URLWithString:imagePath];
                CSPicture *picture = [[CSPicture alloc] init];
                [picture setSourceImageURL:url];
                [photoArr addObject:picture];
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
