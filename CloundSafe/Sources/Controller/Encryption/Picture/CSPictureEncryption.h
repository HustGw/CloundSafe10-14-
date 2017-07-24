//
//  CSPictureEncryption.h
//  CloundSafe
//
//  Created by AlanZhang on 16/7/19.
//
//

#import <UIKit/UIKit.h>
typedef void(^completeSelectPhotos)(NSArray <UIImage *> *photos, NSArray *assets, BOOL isOriginal);
typedef void(^completeEncryptPhotos)(NSString *state);
@interface CSPictureEncryption : NSObject
@property (nonatomic, copy)completeSelectPhotos completeSelectPhotos;
@property (nonatomic, copy)completeEncryptPhotos completeEncryptPhotos;
- (id)initWithMaxCount:(int)maxCount;
- (id)initWithEncryptionImages:(NSArray *)images isOriginal:(BOOL)isOrigianl;
- (id)initWithEncryptionImage:(UIImage *)image isOriginal:(BOOL)isOrigianl;
+ (instancetype)encryptImage:(UIImage *)image isOriginal:(BOOL)isOrigianl;
+ (instancetype)encryptImages:(NSArray *)images isOriginal:(BOOL)isOrigianl;
- (void)setResponder:(UIView *)superView;
- (void)selectPhotos;
- (void)setPhotos:(NSArray *)photos;
- (void)setAssets:(NSArray *)assets;
- (void)setIsOriginal:(BOOL)isOriginal;
- (void)beginEncryption;
@end
