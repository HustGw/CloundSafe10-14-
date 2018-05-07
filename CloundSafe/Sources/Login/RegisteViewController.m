//
//  RegisteViewController.m
//  rc
//
//  Created by 余笃 on 16/3/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RegisteViewController.h"
#import "MyTextField.h"
#import "RCUtils.h"
#import "MBProgressHUD.h"
#import "NSString+MD5.h"
#import "Masonry.h"
#import "LoginViewController.h"
static CGFloat const kContainViewYNormal = 70.0;

@interface RegisteViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView      *containView;

@property (nonatomic, strong) UILabel     *logoLabel;

@property (nonatomic, strong) MyTextField *usernameField;
@property (nonatomic, strong) MyTextField *passwordField;
@property (nonatomic,strong) MyTextField *verifyCodeField;
@property (nonatomic, strong) MyTextField *mailboxField;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic,strong) UIButton *verifyCodeButton;
@property (nonatomic,strong) UIImageView *leftUsernameView;
@property (nonatomic,strong) UIImageView *leftPasswdView;
@property (nonatomic,strong) UIImageView *leftVerifyCodeView;
@property (nonatomic,strong) UIImageView *leftMailBoxView;
@property (nonatomic, strong) UIButton    *registeButton;


@property (nonatomic, assign) BOOL isKeyboardShowing;
@property (nonatomic,assign) BOOL isRegisting;
@property (nonatomic, assign) BOOL isRighrtmailbox;

@end

@implementation RegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self configureViews];
    [self configureTextField];
}
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Layout

-(void)viewWillLayoutSubviews{
    
    self.backgroundImageView.frame = self.view.frame;
    
    self.containView.frame = (CGRect){0,kContainViewYNormal,kScreenWidth,kScreenHeight};

    [self.usernameField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.containView.mas_top).offset(162);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
    [self.verifyCodeField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.usernameField.mas_bottom).offset(20);
        make.right.equalTo(self.containView.mas_right).offset(-175);
        make.height.equalTo(@30);
    }];
    [self.verifyCodeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verifyCodeField.mas_right).offset(15);
        make.top.equalTo(self.verifyCodeField.mas_top);
        make.right.equalTo(self.usernameField.mas_right);
        make.height.equalTo(@30);
    }];
    [self.mailboxField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.verifyCodeField.mas_bottom).offset(20);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
    [self.passwordField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.mailboxField.mas_bottom).offset(20);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
    [self.registeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.passwordField.mas_bottom).offset(60);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@45);
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.placeholder = @"";
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.usernameField)
    {
        if ([textField.text isEqualToString:@""]) {
            self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
        }
    }else if (textField == self.passwordField)
    {
        if ([textField.text isEqualToString:@""]) {
            self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000], NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
        }
    }else  if(textField == self.mailboxField)
        {
        if([textField.text isEqualToString:@""]){
            self.mailboxField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入邮箱" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
        }
        }else{
        if ([textField.text isEqualToString:@""]) {
            self.verifyCodeField.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
        }
    }
}

#pragma mark - Configure Views

-(void)configureViews{
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568_blurred"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.containView = [[UIView alloc] init];
    [self.view addSubview:self.containView];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"home_logo"];
    
    [self.containView addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(102);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(67);
        make.height.mas_equalTo(67);
    }];
    
}



#pragma mark - 注册按钮
- (void)didRegister
{
    if (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]&&![self.verifyCodeField.text isEqualToString:@""] &&![self.mailboxField.text isEqualToString:@""]&& [self.usernameField.text length] == 11)
    {
        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone", nil];
        NSString *url = JudgePhoneURL;
        
        [[AFHTTPSessionManager manager] GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            NSString *status = [responseObject valueForKey:@"status"];
            if ([status isEqualToString:@"Fail"])
            {
                [self alert:@"服务器响应失败！" ];
            }
            else
            {
                NSString *content = [responseObject valueForKey:@"content"];
                if ([content isEqualToString:@"unavailable"])
                {
                    [self alert:@"该账号已经注册！"];
                }else
                {
                    [self beginRegister];
                }
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"网络请求失败：%@",error);
            [self alert:@"无网络连接！"];
        }];


    }

}
#pragma mark - 开始注册
- (void)beginRegister
{
    [userDefaults synchronize];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone",self.passwordField.text,@"emp_password",self.mailboxField.text,@"emp_email",self.verifyCodeField.text,@"code",nil];
    
    self.isRighrtmailbox = [self isValidateEmail:self.mailboxField.text];
    if(self.isRighrtmailbox == NO)
        {
        [self alert:@"邮箱填写错误"];
        }else
  {
    NSString *url = RegisterURL;

    [[AFHTTPSessionManager manager] POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"Fail"])
        {
            [self alert:@"服务器响应失败！" ];
        }else
        {
            NSString *content = [responseObject valueForKey:@"content"];
            if ([content isEqualToString:@"code error"])
            {
                [self alert:@"验证码错误！"];
            }else if ([content isEqualToString:@"code invalid"])
            {
                [self alert:@"验证码失效！"];
            }else//注册成功
            {
            [userDefaults setObject:self.mailboxField.text forKey:@"userMail"];
                [self alert:@"注册成功！"];
                
            }
            
        }

        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败：%@",error);
        [self alert:@"无网络连接！"];
    }];
  }

}

//邮箱地址的正则表达式
- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 获取验证码
-(void)sendVerifyCode
{
    //先判断手机号是否注册，如果没有注册，则可以发送验证码，如果已经注册，则不发送
    NSString *phoneText = self.usernameField.text;
    if (![phoneText isEqualToString:@""] && phoneText.length == 11)
    {
        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone", nil];
        NSString *url = JudgePhoneURL;
        
        [[AFHTTPSessionManager manager] GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
            
            NSString *status = [responseObject valueForKey:@"status"];
            if ([status isEqualToString:@"Fail"])
            {
                [self alert:@"服务器响应失败"];
            }
            else
            {
                NSString *content = [responseObject valueForKey:@"content"];
                if ([content isEqualToString:@"unavailable"])
                {
                
                    [self alert:@"该账号已经注册！"];
                    
                }else
                {
                    [self getVerifyCode];
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            
            NSLog(@"网络请求失败：%@",error);
            [self alert:@"无网络连接！"];
        }];

    }
}
#pragma mark - 若手机号未注册则获取验证码
- (void)getVerifyCode
{
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone", nil];
    NSString *url = AcquireCodeURL;
    
    [[AFHTTPSessionManager manager] GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        
        
        NSString *status = [responseObject valueForKey:@"status"];
        if ([status isEqualToString:@"Fail"])
        {
            [self alert:@"服务器响应失败"];
        }else
        {
            NSString *content = [responseObject valueForKey:@"content"];
            if ([content isEqualToString:@"sendcode fail"])
            {
                NSLog(@"验证码发送失败");
            }else
            {
                NSLog(@"验证码发送成功");
                __block int timeout = 120;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.verifyCodeButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                            self.verifyCodeButton.userInteractionEnabled = YES;
                        });
                    }else{
                        //int minutes = timeout / 60;
                        //int seconds = timeout % 60;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            [self.verifyCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重新获取",timeout] forState:UIControlStateNormal];
                            self.verifyCodeButton.userInteractionEnabled = NO;
                            
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
            }
            
        }

        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        NSLog(@"网络请求失败：%@",error);
        [self alert:@"无网络连接！"];
    }];
    

}
- (void)configureTextField{
    
    self.usernameField = [[MyTextField alloc] init];
    
    self.usernameField.textColor = [UIColor blackColor];
    self.usernameField.font = [UIFont systemFontOfSize:14];
    self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],
                                                                                            NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
    self.usernameField.keyboardType = UIKeyboardTypeNumberPad;
    self.usernameField.returnKeyType = UIReturnKeyNext;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.leftUsernameView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_icon"]];
    self.usernameField.leftView = self.leftUsernameView;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    [self.containView addSubview:self.usernameField];
    
    
    self.verifyCodeField = [[MyTextField alloc] init];
    
    self.verifyCodeField.textColor = [UIColor blackColor];
    self.verifyCodeField.font = [UIFont systemFontOfSize:14];
    self.verifyCodeField.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"请输入验证码"
                                                                                attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
    self.verifyCodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyCodeField.returnKeyType = UIReturnKeyNext;
    self.verifyCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.verifyCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verifyCodeField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.leftVerifyCodeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Pencil_icon"]];
    self.verifyCodeField.leftView = self.leftVerifyCodeView;
    self.verifyCodeField.leftViewMode = UITextFieldViewModeAlways;
    [self.containView addSubview:self.verifyCodeField];
    
    self.verifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.verifyCodeButton.layer.cornerRadius = 5.0f;
    self.verifyCodeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.verifyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.verifyCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.verifyCodeButton setBackgroundColor:RGB(0x11cd6e, 1)];
    self.verifyCodeButton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.10].CGColor;
    self.verifyCodeButton.layer.borderWidth = 0.5;
    [self.containView addSubview:self.verifyCodeButton];
    
    self.passwordField = [[MyTextField alloc] init];
    
    self.passwordField.textColor = [UIColor blackColor];
    self.passwordField.font = [UIFont systemFontOfSize:14];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码"        attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],
                                                                                                                       NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordField.returnKeyType = UIReturnKeyGo;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.leftPasswdView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_icon"]];
    self.passwordField.leftView = self.leftPasswdView;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    [self.containView addSubview:self.passwordField];
    
    self.mailboxField = [[MyTextField alloc]init];
    self.mailboxField.textColor = [UIColor blackColor];
    self.mailboxField.font = [UIFont systemFontOfSize:14];
    self.mailboxField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邮箱"        attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],
                                                                                                                       NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
//    self.mailboxField.secureTextEntry = YES;
    self.mailboxField.keyboardType = UIKeyboardTypeASCIICapable;
    self.mailboxField.returnKeyType = UIReturnKeyGo;
    self.mailboxField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mailboxField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.mailboxField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.mailboxField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mailboxField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.leftMailBoxView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_icon"]];
    self.mailboxField.leftView = self.leftMailBoxView;
    self.mailboxField.leftViewMode = UITextFieldViewModeAlways;
    [self.containView addSubview:self.mailboxField];
    
    self.registeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registeButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registeButton.layer.cornerRadius = 5.0f;
    self.registeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.registeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.registeButton setBackgroundColor:RGB(0x11cd6e, 1)];
    self.registeButton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.10].CGColor;
    self.registeButton.layer.borderWidth = 0.5;
    [self.containView addSubview:self.registeButton];
    
    
    [self.verifyCodeButton addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.registeButton addTarget:self action:@selector(didRegister) forControlEvents:UIControlEventTouchUpInside];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
     [self.mailboxField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];

}
- (void)alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)regBackToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
