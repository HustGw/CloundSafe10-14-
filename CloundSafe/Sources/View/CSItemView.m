//
//  CSItemView.m
//  CloundSafe
//
//  Created by LittleMian on 16/6/27.
//
//

#import "CSItemView.h"

@implementation CSItemView

- (id)init
{
    if (self = [super init])
    {
        self.iconView = [[UIImageView alloc]init];
        self.label = [[UILabel alloc]init];
        self.label.font = [UIFont systemFontOfSize:14];
        self.iconView.userInteractionEnabled = YES;
        self.label.tag = 10;
    }
    [self addSubview:self.iconView];
    [self addSubview:self.label];
    return self;
}
- (void)addSubviewConstraint
{
    [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(0);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
    }];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconView.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(60);
    }];
}
/**
 *  计算字体的长和宽
 *
 *  @param text 待计算大小的字符串
 *
 *  @param fontSize 指定绘制字符串所用的字体大小
 *
 *  @return 字符串的大小
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

@end
