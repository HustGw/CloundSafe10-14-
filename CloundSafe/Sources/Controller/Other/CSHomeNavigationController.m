//
//  CSHomeNavigationController.m
//  CloundSafe
//
//  Created by LittleMian on 16/6/27.
//
//

#import "CSHomeNavigationController.h"

@interface CSHomeNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CSHomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    id target = self.interactivePopGestureRecognizer.delegate;
//    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    // 设置手势代理，拦截手势触发
//    pan.delegate = self;
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//    // 禁止使用系统自带的滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;
    
    //    NSLog(@"%s",__func__);
//    [self.navigationBar setBackgroundImage: [UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar lt_setBackgroundColor:CSCloundSafeColor];
//    [self.navigationBar setShadowImage:[UIImage new]];

}

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    return YES;
//}

#pragma mark 类第一次使用的时候被调用
//+(void)initialize
//{
//    // 设置主题

#pragma mark  一般设置导航条背景，不会在导航控制器的子控制器里设置
    // 1.设置导航条的背题图片 --- 设置全局
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
//    [navBar lt_setBackgroundColor:CSCloundSafeColor];
//    [navBar setShadowImage:[UIImage new]];
    
//    // 2.UIApplication设置状态栏的样式
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    
//    // 3.设置导航条标题的字体和颜色
//    NSDictionary *titleAttr = @{
//                                NSForegroundColorAttributeName:CSCloundSafeColor,
//                                NSFontAttributeName:[UIFont systemFontOfSize:18]
//                                };
//    [navBar setTitleTextAttributes:titleAttr];
//    
//    //设置返回按钮的样式
//    //tintColor是用于导航条的所有Item
//    navBar.tintColor = [UIColor blackColor];
//
//    UIBarButtonItem *navItem = [UIBarButtonItem appearance];
//    
//    //设置Item的字体大小
//    [navItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
//    
//}


#pragma mark 导航控制器的子控制器被pop[移除]的时候会调用
//-(UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    
//    return [super popViewControllerAnimated:animated];
//}

#pragma mark 导航控制器的子控制器被push 的时候会调用
//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    viewController.hidesBottomBarWhenPushed = YES;
//    return [super pushViewController:viewController animated:animated];
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
