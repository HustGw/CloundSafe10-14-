//
//  CSVedioEncryption.h
//  CloundSafe
//
//  Created by Messiah_S on 7/27/16.
//
//

#import <UIKit/UIKit.h>

typedef void(^completeSelectVedio)(UIImage *coverImage, id asset);
typedef void(^completeEncryptionVedio)(NSString *state);
@interface CSVedioEncryption : NSObject
@property (nonatomic, copy)completeSelectVedio completeSelection;
@property (nonatomic, copy)completeEncryptionVedio completeEncryption;
- (void)setResponder:(UIView *)superView;
- (void)selectVedio;
- (void)beginEncryption;
- (void)setCoverImage:(UIImage *)coverImage;
- (void)setAsset:(id)asset;
@end
