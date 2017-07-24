//
//  CSContactEmailCell.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/17.
//
//

#import "CSContactEmailCell.h"

@implementation CSContactEmailCell

- (id)initWithEmail:(NSString *)email
{
    if (self = [super init])
    {
        _label = [[UILabel alloc]init];
        _sendEmailButton = [[UIButton alloc]init];
        _emailAddress = email;
        _label.font = [UIFont systemFontOfSize:14];
        [_sendEmailButton addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_sendEmailButton];
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
//发送邮件
- (void)sendEmail
{
    // 获取收件人
    NSString *to = _emailAddress;

    NSString *urlStr = [NSString stringWithFormat:@"mailto:?to=%@",to];
    //转换成URL
    NSURL *url = [NSURL URLWithString:urlStr];
    //调用系统方法
    [[UIApplication sharedApplication] openURL:url];
}
- (void)configCell
{
    [_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [_sendEmailButton setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [_sendEmailButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
