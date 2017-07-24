//
//  CSDisplayPictureViewController.h
//  CloundSafe
//
//  Created by LittleMian on 16/7/11.
//
//

#import <UIKit/UIKit.h>

@interface CSDisplayPictureController : UIViewController
@property (nonatomic, strong) UIImage *image;
- (id)initWithImage:(UIImage *)image;
- (void)setImagePath:(NSString *)path;
@end
