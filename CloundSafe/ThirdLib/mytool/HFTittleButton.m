//
//  HFTittleButton.m
//
//  Created by 覃玉红 on 16/1/14.
//  Copyright © 2016年 覃玉红. All rights reserved.
//

#import "HFTittleButton.h"
#import "UIView+Extension.h"

@implementation HFTittleButton

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //设置button颜色和状态
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置button文字格式
        self.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x=self.imageView.x;
    self.imageView.x=CGRectGetMaxX(self.titleLabel.frame)+8;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self sizeToFit];
}
@end
