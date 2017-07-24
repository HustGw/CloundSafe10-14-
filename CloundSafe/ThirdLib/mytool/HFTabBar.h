//
//  HFTabBar.h
//  自定义TabBar
//  Created by 覃玉红 on 16/1/12.
//  Copyright © 2016年 覃玉红. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HFTabBar;
//因为HFTabBarDelegate继承自UITabBarDelegate,所以HFTabBar的代理也必须实现UITabBar的代理协议 
@protocol HFTabBarDelegte <UITabBarDelegate>

@optional
-(void)tabBarDidClickPlusButton:(HFTabBar*)tabBar;

@end

@interface HFTabBar : UITabBar
@property(nonatomic,weak)id<HFTabBarDelegte> delegate;
@end
