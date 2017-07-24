//
//  HFTabBar.m
//
//  Created by 覃玉红 on 16/1/12.
//  Copyright © 2016年 覃玉红. All rights reserved.
//

#import "HFTabBar.h"
#import "UIView+Extension.h"




@interface HFTabBar()

@property(nonatomic,strong)UIButton*plusBtn;

@end

@implementation HFTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //添加一个按钮到tabbar中
        UIButton*plusBtn=[[UIButton alloc]init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button" ] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.size=plusBtn.currentBackgroundImage.size;
        _plusBtn=plusBtn;
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        
        
    }
    return self;
}

/**
 *点击加号按钮
 */
-(void)plusBtnClick
{
   //通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.plusBtn.centerX=self.width*0.5;
    self.plusBtn.centerY=self.height*0.5;
//    NSLog(@"%@",self.subviews);
    NSInteger count = 5;
    CGFloat childWidth=self.width/5;
    NSInteger index=0;
    for (NSInteger i=0; i<count; i++) {
        UIView* child=self.subviews[i];
        Class class=NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.width=childWidth;
            child.x=childWidth*index;
            index++;
            if (index==2) {
                index++;
            }
        }
    }
}

@end
