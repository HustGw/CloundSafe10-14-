//
//  CollectionViewCell.h
//  CloundSafe
//
//  Created by LittleMian on 16/7/6.
//
//

#import <UIKit/UIKit.h>
#import "CSPicture.h"
//typedef void (^didSelectPhotoBlock)(BOOL);
@protocol CSFullScreenPictureDisplayDelegate <NSObject>
@optional
- (void)passImage:(UIImage *)image imagePath:(NSString *)path;
- (void)passimagePath:(NSString *)path;
@end

@interface CSCollectionCell : UICollectionViewCell
@property (nonatomic, weak) id<CSFullScreenPictureDisplayDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) UIButton *selectPhotoButton;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (strong, nonatomic) CSPicture *picture;
@property (nonatomic, copy) NSString *imageFormatName;
@property (nonatomic, strong) NSString *imageIdentifier;
@property (nonatomic, strong) UIImageView *playerImageView;
@property (strong, nonatomic) UIImageView *selectImageView;
@end
