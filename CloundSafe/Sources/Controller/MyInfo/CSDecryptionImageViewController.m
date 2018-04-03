//
//  CSDecryptionImageViewController.m
//  CloundSafe
//
//  Created by AlanZhang on 2017/7/11.
//
//

#import "CSDecryptionImageViewController.h"
#import "CSCollectionCell.h"
#import "CSPicture.h"
#import "EXTScope.h"
#import "CSDisplayPictureController.h"
#import "FICImageCache.h"
#import "UIView+Layout.h"

static BOOL hasSlectedAllPhoto = NO;
@interface CSDecryptionImageViewController ()<CSFullScreenPictureDisplayDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *imageFormatName;
@property (nonatomic, strong) UIButton *deleteImageButton;
@property (nonatomic, strong) UIButton *allChoose;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSMutableArray *selectedImages;
@end

@implementation CSDecryptionImageViewController

static NSString * const reuseIdentifier = @"DecryptionImageCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"图片";
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [left setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = left;
    [self p_configCollectionView];
    
}
- (NSMutableArray *)selectedImages
{
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
}
- (void)back
{
    hasSlectedAllPhoto = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    //NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}


- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - fullScreenDisplayPicture

- (void)passimagePath:(NSString *)path
{
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:path]];
    self.photos = @[photo];
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.navigationItem.title = @"图片";
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


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSCollectionCell *cell = (CSCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    CSPicture *picture = self.images[indexPath.row];
    [cell setImageFormatName:self.imageFormatName];
    [cell setPicture:picture];
    if (hasSlectedAllPhoto) {
        cell.selectPhotoButton.selected = YES;
    } else {
        cell.selectPhotoButton.selected = NO;
    }
    cell.selectImageView.image =  cell.selectPhotoButton.isSelected ? [UIImage imageNamed:@"photo_sel"] : [UIImage imageNamed:@"photo_des"];
    cell.imageIdentifier = [[picture sourceImageURL] path];
    cell.delegate = self;
    __weak typeof(cell) weakCell = cell;
    @weakify(self);
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        @strongify(self);
        if (isSelected) {
            weakCell.selectPhotoButton.selected = NO;
            [self.selectedImages removeObject:self.images[indexPath.row]];
        } else {
            weakCell.selectPhotoButton.selected = YES;
            [self.selectedImages addObject:self.images[indexPath.row]];
        }
        self.deleteImageButton.enabled = self.selectedImages.count;
//        self.allChoose.enabled = self.selectedImages.count;
        
    };
    return cell;
    
}

- (void)p_configCollectionView
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
    
    _imageFormatName = FICDPhotoSquareImage32BitBGRAFormatName;
    
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    CGFloat rgb = 253 / 255.0;
    bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    self.deleteImageButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 44 - 12, 3, 44, 44)];
    [self.view addSubview:bottomToolBar];
    
    
    UIColor *oKButtonTitleColorNormal   = [UIColor colorWithRed:17.0/255.0 green:205.0/255.0 blue:110.0/255.0 alpha:1.0];
    UIColor *oKButtonTitleColorDisabled = [UIColor colorWithRed:17.0/255.0 green:205.0/255.0 blue:110.0/255.0 alpha:0.5];
    
    self.deleteImageButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.deleteImageButton.enabled = NO;
    [self.deleteImageButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteImageButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteImageButton setTitle:@"删除" forState:UIControlStateDisabled];
    [self.deleteImageButton setTitleColor:oKButtonTitleColorNormal forState:UIControlStateNormal];
    [self.deleteImageButton setTitleColor:oKButtonTitleColorDisabled forState:UIControlStateDisabled];
    
    self.allChoose = [[UIButton alloc]init];
    self.allChoose.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.allChoose addTarget:self action:@selector(allChooseImage) forControlEvents:UIControlEventTouchUpInside];
//    self.allChoose.enabled = YES;
    [bottomToolBar addSubview:self.allChoose];
    [self.allChoose mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomToolBar);
        make.left.equalTo(bottomToolBar).offset(10);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    [self.allChoose setTitle:@"全选" forState:UIControlStateNormal];
    [self.allChoose setTitle:@"全选" forState:UIControlStateDisabled];
    [self.allChoose setTitleColor:oKButtonTitleColorNormal forState:
     UIControlStateNormal];
    [self.allChoose setTitleColor:oKButtonTitleColorDisabled forState:
     UIControlStateDisabled];
    
    
    UIView *divide = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    divide.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    divide.frame = CGRectMake(0, 0, self.view.tz_width, 1);
    [bottomToolBar addSubview:divide];
    [bottomToolBar addSubview:self.deleteImageButton];
}


-(void)allChooseImage
{
//    self.deleteImageButton.enabled = YES;
//    self.allChoose.enabled=NO;
    hasSlectedAllPhoto = !hasSlectedAllPhoto;
    [self.collectionView reloadData];
    self.allChoose.selected = !self.allChoose.selected && self.images.count;
    self.deleteImageButton.enabled = hasSlectedAllPhoto && self.images.count;
    if (hasSlectedAllPhoto) {
        self.selectedImages = [self.images mutableCopy];
    }

}
- (void)deleteImage
{
    NSMutableArray *images = [self.images mutableCopy];
    for (CSPicture *photo in self.selectedImages) {
        [images removeObject:photo];
        
        NSError *error;
        
        [[NSFileManager defaultManager] removeItemAtPath:[photo.sourceImageURL.path stringByDeletingLastPathComponent] error:&error];
        if (error) {
            NSLog(@"删除失败！");
        }
    }
    hasSlectedAllPhoto=NO;
    self.images = [images copy];
    [self.selectedImages removeAllObjects];
    self.deleteImageButton.enabled = NO;
//    self.allChoose.enabled=NO;
    [self.collectionView reloadData];
}

@end
