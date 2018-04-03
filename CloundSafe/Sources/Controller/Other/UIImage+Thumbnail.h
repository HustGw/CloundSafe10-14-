//
//  UIImage+Thumbnail.h
//  CloundSafe
//
//  Created by AlanZhang on 2017/7/24.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumbnail)
/**
 *  返回图片的缩略图
 *
 *  @param targetSize 缩放比例
 *
 *  @return 缩略图
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
