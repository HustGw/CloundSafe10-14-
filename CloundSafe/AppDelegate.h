//
//  AppDelegate.h
//  CloundSafe
//
//  Created by LittleMian on 16/6/25.
//
//

#import <UIKit/UIKit.h>
#import "CSPicture.h"
//#import "FICDPhoto.h"
@class FICImageCache;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) FICImageCache *sharedImageCache;
//@property(strong,nonatomic) FICDViewController*FICDVC;
@property (nonatomic, strong) UIViewController *FICDVC;
@end

