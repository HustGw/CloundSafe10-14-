//
//  CSVedioCollectionController.h
//  CloundSafe
//
//  Created by AlanZhang on 16/7/28.
//
//

#import <UIKit/UIKit.h>

@interface CSVedioCollectionController : UIViewController
@property (nonatomic, strong) NSString *imageFormatName;
//@property (nonatomic, strong) NSArray *vedioArr;
@property (nonatomic, strong) NSMutableArray *decrytionVedioArr;
@property (nonatomic, strong) UIButton *decrytionBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic, strong) NSURL *soucreImageURL;
@property (nonatomic, assign) BOOL isSaveImage;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSString *contentFile;
@property (nonatomic, strong) NSArray *vedioArr;
@property (nonatomic, strong) UICollectionView *collectionView;
- (void)saveContent:(NSString *)keyFilePath;
@end
