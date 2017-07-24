//
//  CSHomeTabBarController.m
//  CloundSafe
//
//  Created by LittleMian on 16/6/27.
//
//

#import "CSHomeTabBarController.h"

@interface CSHomeTabBarController ()

@end

@implementation CSHomeTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 拿到 TabBar 在拿到想应的item
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];//加密
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];//解密
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];//我的

    // 对item设置相应地图片
    item0.selectedImage = [[UIImage imageNamed:@"encrytion_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item0.image = [[UIImage imageNamed:@"encrytion"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item1.selectedImage = [[UIImage imageNamed:@"decrytion_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item1.image = [[UIImage imageNamed:@"decrytion"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.selectedImage = [[UIImage imageNamed:@"myself_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"myself"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //这里是去掉 系统tabbar上黑线的方法
    self.tabBar.backgroundImage = [[UIImage alloc]init];
    self.tabBar.shadowImage = [[UIImage alloc]init];
//    self.tabBar.backgroundColor = [UIColor clearColor];

    //设置item字体颜色
    self.tabBar.tintColor = CSCloundSafeColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
