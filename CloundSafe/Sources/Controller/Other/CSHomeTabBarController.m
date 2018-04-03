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
    item0.selectedImage = [[UIImage imageNamed:@"tag_jiami_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.title = nil;
    item0.image = [[UIImage imageNamed:@"tag_jiami_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item1.selectedImage = [[UIImage imageNamed:@"tag_jiemi_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"tag_jiemi_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.title = nil;
    item2.selectedImage = [[UIImage imageNamed:@"tag_my_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"tag_my_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.title = nil;
    //这里是去掉 系统tabbar上黑线的方法
    self.tabBar.backgroundImage = [[UIImage alloc]init];
    self.tabBar.shadowImage = [[UIImage alloc]init];
    //tabBar中的item图片居中显示
    item0.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0);
    item1.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0);
    item2.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0);
    
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
