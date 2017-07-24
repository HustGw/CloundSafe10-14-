//
//  HFDropDownView.m
//
//  Created by 覃玉红 on 16/1/11.
//  Copyright © 2016年 覃玉红. All rights reserved.
//

#import "HFDropDownView.h"
#import "UIView+Extension.h"

@interface HFDropDownView()
/*
 *将来用来显示具体内容的容器
 */
@property(nonatomic,weak)UIImageView*containerView;

@end

@implementation HFDropDownView

//懒加载
-(UIImageView*)containerView{
    if (!_containerView) {
        //添加内容
        UIImageView*contentView=[[UIImageView alloc]init];
        contentView.image=[UIImage imageNamed:@"popover_background"];
        //开启交互功能
        contentView.userInteractionEnabled=YES;
        [self addSubview:contentView];
        self.containerView=contentView;
    }
    return _containerView;
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //清除颜色  添加蒙版
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

+(instancetype)menu{
    return [[self alloc]init];
}


-(void)showFrom:(UIView *)from{
    //获取最上面的窗口
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    //添加自己到窗口
    [window addSubview:self];
    //设置尺寸
    self.frame=window.bounds;
    //调整自己的位置(灰色图片)
   
    //转换坐标系，默认情况下，frame是以父控件左上角为坐标原点
    CGRect newFrame=[from convertRect:from.bounds toView:window];
    self.containerView.centerX=CGRectGetMidX(newFrame);
    self.containerView.y=CGRectGetMaxY(newFrame);
    
    if ([self.delegate respondsToSelector:@selector(DropDownViewDidShow:)]) {
        [self.delegate DropDownViewDidShow:self];
    }
    
}
-(void)dismiss{
    
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(DropDownViewDidDismiss:)]) {
        [self.delegate DropDownViewDidDismiss:self];
    }
    //通知外界被销毁
}

-(void)setContent:(UIView *)content
{
    _content=content;
    //设置内容位置
    content.x=10;
    content.y=15;
    //灰色内容宽度
    self.containerView.width=CGRectGetMaxX(content.frame)+10;
    //设置灰色高度
    self.containerView.height=CGRectGetMaxY(content.frame)+10;
    
    [self.containerView addSubview:content];
}

-(void)setContentController:(UIViewController *)contentController
{
    _contentController=contentController;
    self.content=contentController.view;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
    
}
@end
