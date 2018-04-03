//
//  CSGestureNavigationController.m
//  CloundSafe
//
//  Created by Esphy on 2017/8/2.
//
//

#import "CSGestureNavigationController.h"

@interface CSGestureNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak) UIViewController *currentShowVC;

@end

@implementation CSGestureNavigationController

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    //覆盖创建
    CSGestureNavigationController* nvc = [super initWithRootViewController:rootViewController];
    nvc.interactivePopGestureRecognizer.delegate = self;
    nvc.delegate = self;
    return nvc;
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法在视图控制器完成push的时候调用
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1){
        //如果堆栈内的视图控制器数量为1 说明只有根控制器，将currentShowVC 清空，为了下面的方法禁用侧滑手势
        self.currentShowVC = Nil;
    }
    else{
        //将push进来的视图控制器赋值给currentShowVC
        self.currentShowVC = viewController;
    }
}
//这个方法是在手势将要激活前调用：返回YES允许侧滑手势的激活，返回NO不允许侧滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //首先在这确定是不是我们需要管理的侧滑返回手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.currentShowVC == self.topViewController) {
            //如果 currentShowVC 存在说明堆栈内的控制器数量大于 1 ，允许激活侧滑手势
            return YES;
        }
        //如果 currentShowVC 不存在，禁用侧滑手势。如果在根控制器中不禁用侧滑手势，而且不小心触发了侧滑手势，会导致存放控制器的堆栈混乱，直接的效果就是你发现你的应用假死了，点哪都没反应，感兴趣是神马效果的朋友可以自己试试 = =。
        return NO;
    }
    
    //这里就是非侧滑手势调用的方法啦，统一允许激活
    return NO;
}
@end
