//
//  CSHomeCollectionViewController.h
//  CloundSafe
//
//  Created by LittleMian on 16/7/6.
//
//

#import <UIKit/UIKit.h>

@interface CSPictureCollectionController : UIViewController
@property (nonatomic, strong) NSArray *imageArr;//需要解密的图片的路径
@property (nonatomic, assign) BOOL isSaveImage;
@property (nonatomic, strong) NSMutableArray *decrytionImgArr;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *imageFormatName;
//@property (nonatomic, strong) NSMutableArray *decrytionImgArr;
@property (nonatomic, strong) UIButton *decrytionBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) NSURL *soucreImageURL;
//@property (nonatomic, assign) BOOL isSaveImage;
@property (nonatomic, strong) NSString *contentFile;
@property (nonatomic, strong) NSData *contentData;
- (void)downLoad:(NSString *)url fileName:(NSString *)keyFilePath soucreImagePath:(NSString *)contentImagePath group:(dispatch_group_t)group;
- (void)decryption:(NSString *)contentPath;
- (void)decryptionImage:(UIButton *)button;
- (void)beginDecryption;
- (void)saveContent:(NSString *)contentPath;
@end
