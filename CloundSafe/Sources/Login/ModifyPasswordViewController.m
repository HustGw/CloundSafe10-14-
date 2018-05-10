//
//  ModifyPasswordViewController.m
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/7.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()
@property (nonatomic,strong) MyTextField *mailboxField;
@property (nonatomic,strong) UIImageView *leftMailBoxView;
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([self.navigationItem.title isEqual:@"修改密码"])
        {
        self.navigationItem.title = @"忘记密码";
        }
    [super viewDidLoad];
}


#pragma mark - 身份验证
-(void)sendVerifyEmploye
{
        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone",self.verifyCodeField.text,@"code", nil];
        NSString *url = VerifyEmployeURL;
        
        [[AFHTTPSessionManager manager] POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSString *status = [responseObject valueForKey:@"status"];
            if ([status isEqualToString:@"Fail"])
                {
                [self alert:@"服务器响应失败！" ];
                NSLog(@"身份验证服务器响应失败！");
                }
            else
                {
                NSString *content = [responseObject valueForKey:@"content"];
                if ([content isEqualToString:@"code error"])
                    {
                    [self alert:@"验证码错误！"];
                    }else if([content isEqualToString:@"code invalid"])
                        {
                        [self alert:@"验证码失效！"];
                        }else
                            {
                            [self sendRsetPassword];
                            }
                }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"网络请求失败：%@",error);
            [self alert:@"无网络连接！"];
            NSLog(@"身份验证无网络连接！");
        }];
}

-(void)sendRsetPassword
{
      if(![self.verifyCodeField.text isEqualToString:@""]&&![self.passwordField.text isEqualToString:@""]&&![self.mailboxField.text isEqualToString:@""]&&[self.usernameField.text length]==11)
          {
    NSDictionary *parametersother = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone",self.passwordField.text,@"emp_password",self.verifyCodeField.text,@"code",self.mailboxField.text,@"emp_email", nil];
    NSString *urlother = ResetPasswordURL;
    
    [[AFHTTPSessionManager manager] POST:urlother parameters:parametersother success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *statusother = [responseObject valueForKey:@"status"];
        if ([statusother isEqualToString:@"Fail"])
            {
            [self alert:@"服务器响应失败！" ];
            NSLog(@"邮箱验证服务器响应失败！");
            }
        else
            {
            NSString *contentother = [responseObject valueForKey:@"content"];
            if ([contentother isEqualToString:@"email error"])
                {
                [self alert:@"邮箱错误！"];
                }else{
                        //更新密码
                    [userDefaults setObject:self.passwordField.text forKey:@"userPassword"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功，请牢记新密码！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:nil];
                    });
                }
            }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败：%@",error);
        [self alert:@"无网络连接！"];
        NSLog(@"邮箱验证无网络连接！");
    }];
  }
}

//-(void)resetButton
//{
//    if(![self.verifyCodeField.text isEqualToString:@""]&&![self.passwordField.text isEqualToString:@""]&&![self.mailboxField.text isEqualToString:@""]&&[self.usernameField.text length]==11)
//        {
//        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone",self.verifyCodeField.text,@"code", nil];
//        NSString *url = VerifyEmployeURL;
//
//        [[AFHTTPSessionManager manager] POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            NSString *status = [responseObject valueForKey:@"status"];
//            if ([status isEqualToString:@"Fail"])
//                {
//                [self alert:@"服务器响应失败！" ];
//                }
//            else
//                {
//                NSString *content = [responseObject valueForKey:@"content"];
//                if ([content isEqualToString:@"code error"])
//                    {
//                    [self alert:@"验证码错误！"];
//                    }else if([content isEqualToString:@"code invalid"])
//                        {
//                        [self alert:@"验证码失效！"];
//                        }else
//                            {
//                            NSDictionary *parametersother = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone",self.passwordField.text,@"emp_password",self.verifyCodeField.text,@"code",self.mailboxField.text,@"emp_email", nil];
//                            NSString *urlother = ResetPasswordURL;
//
//                            [[AFHTTPSessionManager manager] POST:urlother parameters:parametersother success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//                                NSString *statusother = [responseObject valueForKey:@"status"];
//                                if ([statusother isEqualToString:@"Fail"])
//                                    {
//                                    [self alert:@"服务器响应失败！" ];
//                                    }
//                                else
//                                    {
//                                    NSString *contentother = [responseObject valueForKey:@"content"];
//                                    if ([contentother isEqualToString:@"email error"])
//                                        {
//                                        [self alert:@"邮箱错误！"];
//                                        }else{
//                                                //更新密码
//                                            [userDefaults setObject:self.passwordField.text forKey:@"userPassword"];
//                                            dispatch_async(dispatch_get_main_queue(), ^{
//                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功，请牢记新密码！" preferredStyle:UIAlertControllerStyleAlert];
//                                                UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                                                    [self.navigationController popViewControllerAnimated:YES];
//                                                }];
//                                                [alert addAction:action];
//                                                [self presentViewController:alert animated:YES completion:nil];
//                                            });
//                                            }
//                                    }
//                            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//                                NSLog(@"网络请求失败：%@",error);
//                                [self alert:@"无网络连接！"];
//                            }];
//                            }
//                }
//        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//                    NSLog(@"网络请求失败：%@",error);
//                    [self alert:@"无网络连接！"];
//        }];
//
//
//
//        }
//}

-(void)viewWillLayoutSubviews{
    self.backgroundImageView.frame = self.view.frame;
    
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"home_logo"];
    [self.view addSubview:self.logoImageView];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(102);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(67);
        make.height.mas_equalTo(67);
    }];
    
    [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(10);
        make.right.left.bottom.equalTo(self.view);
    }];
    [self.usernameField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.containView.mas_top).offset(26);
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
    [super viewWillLayoutSubviews];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
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
            }else if(textField == self.mailboxField)
                {
                if([textField.text isEqualToString:@""])
                    {
                    self.mailboxField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邮箱" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000], NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
                    }
                }else{
                if ([textField.text isEqualToString:@""]) {
                    self.verifyCodeField.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
                }
                }
}

-(void)configureTextField
{
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
    [super configureTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
