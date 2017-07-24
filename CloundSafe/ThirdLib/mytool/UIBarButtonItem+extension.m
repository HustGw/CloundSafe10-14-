//
//  HFBarButtonItemTool.m
//
//  Created by 覃玉红 on 15/7/12.
//  Copyright (c) 2015年 覃玉红. All rights reserved.
//

#import "UIBarButtonItem+extension.h"


@implementation UIBarButtonItem (extension)


/*
 *  创建一个item
 *  action  点击后调用的方法
 *  image   normal 图片
 *  highImage   高亮图片
 *  return   创建好的item
 */

+(UIBarButtonItem*)itemWithTarget:(id)target  Action:(SEL)action imageName:(NSString*)imageName  Higtlightedimaged:(NSString*)highImageName;{
    //由于 Button的类型是 custom  所以大小，位置，背景图片都要重设！！！！！！！！！！！！！
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    btn.size=btn.currentBackgroundImage.size;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

@end
