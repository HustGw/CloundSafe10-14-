//
//  HFSearchBar.m
//
//  Created by 覃玉红 on 16/1/11.
//  Copyright © 2016年 覃玉红. All rights reserved.
//

#import "HFSearchBar.h"
#import "UIView+Extension.h"

@implementation HFSearchBar

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.font=[UIFont systemFontOfSize:13];
        self.placeholder=@"请输入搜索条件";
        self.background=[UIImage imageNamed:@"searchbar_textfield_background"];
        
        //设置左边的放大镜
        UIImageView*searchIcon=[[UIImageView alloc]init];
        searchIcon.image=[UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width=30;
        searchIcon.height=30;
        searchIcon.contentMode=UIViewContentModeCenter;
        self.leftView=searchIcon;
        self.leftViewMode=UITextFieldViewModeAlways;
    }
    return self;
}

+(instancetype)searchBar
{
    return [[self alloc]init];
}

@end
