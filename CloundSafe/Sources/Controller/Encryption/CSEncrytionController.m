//
//  CSHomeEncrytionController.m
//  CloundSafe
//
//  Created by LittleMian on 16/6/27.
//
//

#import "CSEncrytionController.h"
#import "CSItemView.h"
#import "CSPictureEncryption.h"
#import <Photos/PhotosTypes.h>
#import "CSVedioEncryption.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface CSEncrytionController ()
@property (nonatomic, strong) CSItemView *picture;
@property (nonatomic, strong) CSItemView *vedio;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic, strong) UIView *picView;
@property (nonatomic, strong) UIView *videoView;
@end

@implementation CSEncrytionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubView];
    [self addConstraintForSubView];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"encrytion_background"]];
    self.view.transform=CGAffineTransformMakeScale(1.2, 1.2);
  
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)onClick:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    UIView *superView = view.superview;
    UILabel *label = [superView viewWithTag:10];
    if ([label.text isEqualToString:@"图片加密"])
    {
        CSPictureEncryption *picEncryption = [[CSPictureEncryption alloc]initWithMaxCount:9];
        [picEncryption setResponder:self.view];
        [picEncryption selectPhotos];
        CSPictureEncryption __weak *weakEncryption = picEncryption;
        picEncryption.completeSelectPhotos = ^(NSArray <UIImage *>*photos, NSArray *assets, BOOL isOriginal){
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            self.HUD.removeFromSuperViewOnHide = YES;
            [self.view addSubview:self.HUD];
            [self.HUD showAnimated:YES];

            [weakEncryption setPhotos:photos];
            [weakEncryption setAssets:assets];
            [weakEncryption setIsOriginal:isOriginal];
            [weakEncryption beginEncryption];
        };
        picEncryption.completeEncryptPhotos = ^(NSString *state){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertMsg:state];
            });
        };

    }else
    {

        CSVedioEncryption *vedioEncryption = [[CSVedioEncryption alloc]init];
        [vedioEncryption setResponder:self.view];
        [vedioEncryption selectVedio];
        
        CSVedioEncryption __weak *weakEncryption = vedioEncryption;
        vedioEncryption.completeSelection = ^(UIImage *coverImage, id asset){
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            self.HUD.removeFromSuperViewOnHide = YES;
            [self.view addSubview:self.HUD];
            [self.HUD showAnimated:YES];
            
            [weakEncryption setCoverImage:coverImage];
            [weakEncryption setAsset:asset];
            [weakEncryption beginEncryption];
        };
        
        vedioEncryption.completeEncryption = ^(NSString *state){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertMsg:state];
            });
  
        };

    }
}
- (void)alertMsg:(NSString *)state
{
    if ([state isEqualToString:@"TimeOut"])
    {
        [self.HUD removeFromSuperview];
        [self alert:@"请检查网络连接！"];
    }else if ([state isEqualToString:@"employee is null"])
    {
        [self.HUD removeFromSuperview];
        [self alert:@"key上传失败，用户信息为空！"];
    }else if ([state isEqualToString:@"file is null"])
    {
        [self.HUD removeFromSuperview];
        [self alert:@"key上传失败，文件为空！"];
    }else if ([state isEqualToString:@"EncryptSuccess"])
    {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"加密完成";
        [self.HUD hideAnimated:YES afterDelay:6];

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.HUD removeFromSuperview];
        });
        
        
    }
}
- (void)alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  返回图片的缩略图
 *
 *  @param image 图片
 *  @param asize 缩放比例
 *
 *  @return 缩略图
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image)
    {
        newimage = nil;
    }else
    {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height)
        {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }else
        {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
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
    self.picture.label.text = @"图片加密";
    self.picture.label.textColor = [UIColor colorWithRed:16.0/255.0 green:232.0/255.0 blue:96.0/255.0 alpha:1.0];
    [self.picture addSubviewConstraint];
    
    UITapGestureRecognizer *clickVedio = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick:)];
    [self.vedio.iconView addGestureRecognizer:clickVedio];
    self.vedio.iconView.image = [UIImage imageNamed:@"vedio"];
    self.vedio.label.text = @"视频加密";
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

@end
