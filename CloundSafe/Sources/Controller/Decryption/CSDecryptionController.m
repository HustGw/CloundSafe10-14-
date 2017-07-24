//
//  CSHomeDecryptionController.m
//  CloundSafe
//
//  Created by LittleMian on 16/6/30.
//
//

#import "CSDecryptionController.h"
#import "AppDelegate.h"
#import "CSItemView.h"
#import "decrypt_picture.h"
#import "TZImagePickerController.h"
#import "CSNetworkingRequestOperationManager.h"
#import "CSPictureCollectionController.h"
#import "CSVedioCollectionController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface CSDecryptionController ()
@property (nonatomic, strong) CSItemView *picture;
@property (nonatomic, strong) CSItemView *vedio;
@property (nonatomic, strong) NSArray *imageArr;//需要解密的图片的路径
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSMutableArray *selections;
@property (nonatomic, strong) UIView *picView;
@property (nonatomic, strong) UIView *videoView;
@end

@implementation CSDecryptionController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPicture) name:@"refleshPicture" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.navigationController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = kScreenWidth/2;
    [self initSubView];
    [self addConstraintForSubView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"decrytion_background"]];
    self.view.transform=CGAffineTransformMakeScale(1.2, 1.2);
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0/255.0 green:205.0/255.0 blue:111.0/255.0 alpha:1.0];
//    self.imageArr = [CSDecryptionController loadPhoto];
    
}
//设置状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (NSArray *)loadDecryptedMedia
{
    //照片路径
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *photosPath = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:photosPath])
    {
        NSMutableArray *photoArr = [NSMutableArray array];
        NSArray *files = [fileManage subpathsAtPath:photosPath];
        for (NSString *obj in files)
        {
            if ([[obj pathExtension] isEqualToString:@"jpg"]&&[[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"img"] && ![[[obj lastPathComponent] substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"img"])
            {
                NSString *imagePath = [NSString stringWithFormat:@"%@/%@",photosPath,obj];
                NSURL *url = [NSURL fileURLWithPath:imagePath];
                MWPhoto *photo = [MWPhoto photoWithURL:url];
                [photoArr addObject:photo];
            }
            if ([[obj pathExtension] isEqualToString:@"mov"] &&[[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"video"])
            {
                NSString *vedioPath = [NSString stringWithFormat:@"%@/%@",photosPath,obj];
                NSURL *url = [NSURL fileURLWithPath:vedioPath];
                NSString *coverImagePath = [[vedioPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"scale"];
                NSURL *coverImageURL = [NSURL fileURLWithPath:coverImagePath];
                MWPhoto *photo = [MWPhoto photoWithURL:coverImageURL];
                photo.videoURL = url;
                [photoArr addObject:photo];
            }
        }
        return [[NSArray alloc]initWithArray:photoArr];
    }else
    {
        NSLog(@"文件夹不存在！");
        return nil;
    }

}


- (void)refreshPicture
{
    //self.imageArr = [CSDecryptionController loadPhoto];
}

+(NSArray *)loadPhoto
{
    //照片路径
    NSString *userName = [userDefaults valueForKey:@"userName"];
    NSString *photosPath = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    //NSLog(@"%@",photosPath);
    if ([fileManage fileExistsAtPath:photosPath])
    {
        NSArray *files = [fileManage subpathsAtPath:photosPath];
        
        NSMutableArray *photoArr = [NSMutableArray array];
        for (NSString *obj in files)
        {
            if ([[obj pathExtension] isEqualToString:@"scale"] && [[[obj stringByDeletingLastPathComponent] substringWithRange:NSMakeRange(0, 3)]isEqualToString:@"img"])
            {
                NSString *imagePath = [NSString stringWithFormat:@"%@/%@",photosPath,obj];
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

- (void)onClick:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    UIView *superView = view.superview;
    UILabel *label = [superView viewWithTag:10];
    if ([label.text isEqualToString:@"图片解密"])
    {
        CSPictureCollectionController *vc = [[CSPictureCollectionController alloc]init];

        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {

        CSVedioCollectionController *vc = [[CSVedioCollectionController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (void)initSubView
{

    self.picView = [[UIView alloc]init];
    self.videoView = [[UIView alloc]init];
    [self.view addSubview:self.picView];
    [self.view addSubview:self.videoView];
    [self.picView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.mas_equalTo(kScreenHeight/3);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(120);
    }];
    [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.picView);
        make.width.equalTo(self.picView);
        make.height.equalTo(self.picView);
    }];
    
    self.picture = [[CSItemView alloc]init];
    self.vedio = [[CSItemView alloc]init];
    
    [self.picView addSubview:self.picture];
    [self.videoView addSubview:self.vedio];
    
    UITapGestureRecognizer *clickPic = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick:)];
    [self.picture addGestureRecognizer:clickPic];
    self.picture.iconView.image = [UIImage imageNamed:@"picture"];
    self.picture.label.text = @"图片解密";
    self.picture.label.textColor = [UIColor colorWithRed:16.0/255.0 green:232.0/255.0 blue:96.0/255.0 alpha:1.0];
    [self.picture addSubviewConstraint];
    
    UITapGestureRecognizer *clickVedio = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick:)];
    [self.vedio.iconView addGestureRecognizer:clickVedio];
    self.vedio.iconView.image = [UIImage imageNamed:@"vedio"];
    self.vedio.label.text = @"视频解密";
    self.vedio.label.textColor = [UIColor colorWithRed:16.0/255.0 green:232.0/255.0 blue:96.0/255.0 alpha:1.0];
    [self.vedio addSubviewConstraint];

}
- (void)addConstraintForSubView
{
    
    [self.picture mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.picView).offset(15);
        make.centerY.equalTo(self.picView).offset(-30);
        make.height.mas_equalTo(120);
        make.width.mas_equalTo(120);
    }];
    [self.vedio mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoView).offset(-15);;
        make.centerY.equalTo(self.videoView).offset(-30);
        make.width.equalTo(self.picture);
        make.height.equalTo(self.picture);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
