//
//  HFNavigationController.m
//
//  Created by 覃玉红 on 15/7/12.
//  Copyright (c) 2015年 覃玉红. All rights reserved.
//

#import "HFNavigationController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+extension.h"

@interface HFNavigationController ()

@end

@implementation HFNavigationController
+(void)initialize{
//    [UINavigationBar appearance]
    
    //设置整个项目所有的 item 的主题样式
    UIBarButtonItem*item= [UIBarButtonItem appearance];
    
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]=[UIColor orangeColor];
    textAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置整个项目 item 不可用状态
    NSMutableDictionary *disableTextAttrs=[NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName]=[UIColor grayColor];
    disableTextAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];

    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

*/
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0) {
        //设置导航栏 左边按钮
        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(back)  imageName:@"navigationbar_back" Higtlightedimaged:@"navigationbar_back_highlighted"];
        
        viewController.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(more)  imageName:@"navigationbar_more" Higtlightedimaged:@"navigationbar_more_highlighted"];
        
        //自动隐藏 tabbar
        viewController.hidesBottomBarWhenPushed=YES;
    }
    
     [super pushViewController:viewController animated:animated];
}

-(void)back
{
//  注意这里不是  self .navigationController   ?????
//  因为self本来就是  navigationController
    [self popViewControllerAnimated:YES];
}

-(void)more
{
    [self popToRootViewControllerAnimated:YES];
}
@end
