//
//  CSPicture.h
//  CloundSafe
//
//  Created by LittleMian on 16/7/7.
//
//

#import <Foundation/Foundation.h>
#import "FICEntity.h"
extern NSString *const FICDPhotoImageFormatFamily;

extern NSString *const FICDPhotoSquareImage32BitBGRAFormatName;
extern NSString *const FICDPhotoSquareImage32BitBGRFormatName;
extern NSString *const FICDPhotoSquareImage16BitBGRFormatName;
extern NSString *const FICDPhotoSquareImage8BitGrayscaleFormatName;
extern NSString *const FICDPhotoPixelImageFormatName;

extern CGSize const FICDPhotoSquareImageSize;
extern CGSize const FICDPhotoPixelImageSize;
@interface CSPicture : NSObject<FICEntity>
@property (nonatomic, copy) NSURL *sourceImageURL;
@property (nonatomic, strong, readonly) UIImage *sourceImage;
@property (nonatomic, strong, readonly) UIImage *thumbnailImage;
@property (nonatomic, assign, readonly) BOOL thumbnailImageExists;

// Methods for demonstrating more conventional caching techniques
- (void)generateThumbnail;
- (void)deleteThumbnail;
@end
