//
//  CSContactPhoneCell.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/9.
//
//

#import "CSContactPhoneCell.h"
#import <MessageUI/MessageUI.h>


@interface CSContactPhoneCell()<MFMessageComposeViewControllerDelegate>

@end


@implementation CSContactPhoneCell

- (id)init
{
    if (self = [super init]) {
        _number = [[CNPhoneNumber alloc]init];
        _phoneLabel = [[UILabel alloc]init];
        _phoneButton = [[UIButton alloc]init];
        _messageButton = [[UIButton alloc]init];
        _segmentLineView = [[UIView alloc]init];
        
        _phoneLabel.font = [UIFont systemFontOfSize:14];
        [_phoneButton addTarget:self action:@selector(makePhoneCall:) forControlEvents:UIControlEventTouchUpInside];
        [_messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_phoneLabel];
        [self.contentView addSubview:_phoneButton];
        [self.contentView addSubview:_messageButton];
        [self.contentView addSubview:_segmentLineView];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
- (void)setNumber:(CNPhoneNumber *)number;
{
    _number = number;
    //电话号码
    _phoneLabel.text = _number.stringValue;
    [_phoneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(150, 25));
    }];
    
    //短信
    [_messageButton setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [_messageButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //分割线
    _segmentLineView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    [_segmentLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_messageButton.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(0.5, 32));
    }];
    
    //电话
    [_phoneButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [_phoneButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_segmentLineView.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
}
//打电话
- (void)makePhoneCall:(UIButton *)button
{
    UIWebView *webView = [[UIWebView alloc] init];
    NSString *string = [NSString stringWithFormat:@"tel://%@",_number.stringValue];
    NSURL *url = [NSURL URLWithString:string];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.contentView addSubview:webView];
}
//发短信
- (void)sendMessage:(UIButton *)button
{
    //显示发短信的控制器
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    
    // 设置收件人列表
    vc.recipients = @[_number.stringValue];
    // 设置代理
    vc.messageComposeDelegate = self;
    // 显示控制器
    [self.weakController presentViewController:vc animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    if(result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if(result == MessageComposeResultSent) {
        NSLog(@"已经发出");
    } else {
        NSLog(@"发送失败");
    }
}

@end
