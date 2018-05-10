//
//  resetPasswordViewController.m
//  rc
//
//  Created by 余笃 on 16/4/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "LoginViewController.h"


@interface ResetPasswordViewController ()<UITextFieldDelegate>
{
    NSString *userIdentity;
}


@end

@implementation ResetPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(regBackToForwardViewController)];
    self.navigationItem.title = @"修改密码";
    [leftButton setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self configureViews];
    [self configureTextField];
}


#pragma mark - Layout


- (void)checkPhone
{
    [self checkUserIdentify:NO];
}

//#pragma mark - 密码重置按键
//- (void)resetButton
//{
//
//    if (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]&&![self.verifyCodeField.text isEqualToString:@""] && [self.usernameField.text length] == 11)
//    {
//
//        // 1.创建一个网络路径
//        NSURL *url = [NSURL URLWithString:ResetPasswordURL];
//        // 2.创建一个网络请求，分别设置请求方法、请求参数
//        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
//        request.HTTPMethod = @"POST";
//        NSString *args = [NSString stringWithFormat:@"emp_phone=%@&emp_password=%@&code=%@",self.usernameField.text, self.passwordField.text, self.verifyCodeField.text];
//        request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
//
//        // 3.获得会话对象
//        NSURLSession *session = [NSURLSession sharedSession];
//
//        // 4.根据会话对象，创建一个Task任务
//        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSLog(@"从服务器获取到数据");
//            /*
//             对从服务器获取到的数据data进行相应的处理.
//             */
//            if (error) {
//                NSLog(@"%@",error.description);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self alert:@"无网络连接！"];
//                });
//
//            }else{
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
//                NSLog(@"dict:%@", dict.description);
//                NSLog(@"response:%@", ((NSHTTPURLResponse*)response).allHeaderFields);
//                NSString *status = dict[@"status"];
//                if ([status isEqualToString:@"Success"]) {
//                    NSString *content = dict[@"content"];
//                    if ([content isEqualToString:@"code invalid"]) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self alert:@"此验码已废，请重新获取！"];
//                        });
//
//                    }else{
//                        //更新密码
//                        [userDefaults setObject:self.passwordField.text forKey:@"userPassword"];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功，请牢记新密码！" preferredStyle:UIAlertControllerStyleAlert];
//                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                                [self.navigationController popViewControllerAnimated:YES];
//                            }];
//                            [alert addAction:action];
//                            [self presentViewController:alert animated:YES completion:nil];
//                        });
//
//                    }
//                }
//
//            }
//
//        }];
//
//        //5.最后一步，执行任务，(resume也是继续执行)。
//        [sessionDataTask resume];
//    }
//}

#pragma mark - 身份验证
-(void)sendVerifyEmploye
{
    [userDefaults synchronize];
    NSString *username = [userDefaults valueForKey:@"userName"];
    NSLog(@"%@________username",username);
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:username,@"emp_phone",self.verifyCodeField.text,@"code",nil];
    
            NSString *url = VerifyEmployeURL;
            
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
                                    [self alert:@"修改成功！"];
                                    
                                    }
                        }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"网络请求失败：%@",error);
                [self alert:@"无网络连接！"];
            }];
//    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone",self.verifyCodeField.text,@"code", nil];
//    NSString *url = VerifyEmployeURL;
//    [[AFHTTPSessionManager manager]POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSString *status = [responseObject valueForKey:@"status"];
//        if ([status isEqualToString:@"Fail"]) {
//            [self alert:@"服务器响应失败"];
//        } else
//            {
//            NSString *content = [responseObject valueForKey:@"content"];
//            if ([content isEqualToString:@"code error"]) {
//                [self alert:@"验证码错误"];
//            } else if([content isEqualToString:@"code invalid"]){
//                [self alert:@"验证码失效"];
//            }else
//                {
//                userIdentity = content;
//                NSLog(@"%@",userIdentity);
//                }
//            }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//                NSLog(@"网络请求失败：%@",error);
//                [self alert:@"无网络连接！"];
//                NSLog(@"身份验证无网络连接2");
//    }];
}

#pragma mark 修改密码

//-(void)sendRsetPassword:(NSString *)userIdentify
//{
//    NSDictionary *parametersother = [[NSDictionary alloc]initWithObjectsAndKeys:self.passwordField.text,@"emp_password",userIdentify,@"user_identify", nil];
//                                    NSString *urlother = SubmitePasswordURL;
//
//                                    [[AFHTTPSessionManager manager] POST:urlother parameters:parametersother success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//                                        NSString *statusother = [responseObject valueForKey:@"status"];
//                                        if ([statusother isEqualToString:@"Fail"])
//                                            {
//                                            [self alert:@"服务器响应失败！" ];
//                                            NSLog(@"修改密码服务器错误");
//                                            }
//                                        else
//                                            {
//                                            NSString *contentother = [responseObject valueForKey:@"content"];
//                                            if ([contentother isEqualToString:@"employee is null"])
//                                                {
//                                                [self alert:@"用户为空！"];
//                                                }else{
//                                                        //更新密码
//                                                    [userDefaults setObject:self.passwordField.text forKey:@"userPassword"];
//                                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功，请牢记新密码！" preferredStyle:UIAlertControllerStyleAlert];
//                                                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                                                            [self.navigationController popViewControllerAnimated:YES];
//                                                        }];
//                                                        [alert addAction:action];
//                                                        [self presentViewController:alert animated:YES completion:nil];
//                                                    });
//                                                    }
//                                            }
//                                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//                                        NSLog(@"网络请求失败：%@",error);
//                                        [self alert:@"无网络连接！"];
//                                    }];
//}

#pragma mark - 发送验证码按钮
-(void)sendVerifyCode
{
    [self checkUserIdentify:NO];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone", nil];
    NSString *url = AcquireCodeURL;
    
    [[AFHTTPSessionManager manager] GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        
        
        if ([responseObject[@"status"] isEqualToString:@"Fail"])
        {
            [self alert:@"服务器响应失败！"];
        }else
        {
            NSString *content = [responseObject valueForKey:@"content"];
            
            if ([content isEqualToString:@"sendcode fail"])
            {
                [self alert:@"验证码发送失败！"];
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

//检查手机号是否注册
-(void)checkUserIdentify:(BOOL) isRequestCode
{
    if ([self.usernameField.text length] != 11)
    {
        [self alert:@"请输入正确的手机号！"];
    }else
    {

        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameField.text,@"emp_phone", nil];
        NSString *url = JudgePhoneURL;
        
        [[AFHTTPSessionManager manager] GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            NSString *status = [responseObject valueForKey:@"status"];
            if ([status isEqualToString:@"Fail"])
            {
                [self alert:@"服务器响应失败！"];
            }else
            {
                NSString *content = [responseObject valueForKey:@"content"];
                if ([content isEqualToString:@"available"])
                {
                    if (isRequestCode == YES)
                    {
                        self.checkPhone_t(NO);
                    }
                    [self alert:@"手机号尚未注册！"];
                }else
                {
                    NSLog(@"该手机号已注册！");
                    if (isRequestCode == YES)
                    {
                        self.checkPhone_t(YES);
                    }
                }
            }

            
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
             NSLog(@"网络请求失败：%@",error);
            
        }];

    }

}
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
    [self.passwordField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.verifyCodeField.mas_bottom).offset(20);
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.placeholder = @"";
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
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
    }else
    {
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
    
}

- (void)configureTextField
{
    
    
    self.usernameField = [[MyTextField alloc] init];
    if ([self.UseforForget1.text isEqual:@""]) {
        NSLog(@"Lisa.usernameField.text=%@",self.usernameField.text);
        self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],
                                                                                                                                                NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
    } else {
         self.usernameField.text=self.UseforForget1.text;
    }
   
    
    self.usernameField.textColor = [UIColor blackColor];
    self.usernameField.font = [UIFont systemFontOfSize:14];
//    self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
//                                                                               attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],
//                                                                                            NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
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
    NSLog(@"Lisa.usernameField.text=%@",self.usernameField.text);
    
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
    self.verifyCodeButton.layer.cornerRadius = 5.0f;
    [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
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
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码"        attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],
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
    
    self.registeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registeButton.layer.cornerRadius = 5.0f;
    [self.registeButton setTitle:@"确定" forState:UIControlStateNormal];
    self.registeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.registeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.registeButton setBackgroundColor:RGB(0x11cd6e, 1)];
    self.registeButton.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.10].CGColor;
    self.registeButton.layer.borderWidth = 0.5;
    [self.containView addSubview:self.registeButton];
    
    
    
    [self.verifyCodeButton addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
//    [self.passwordField addTarget:self action:@selector(sendVerifyEmploye) forControlEvents:UIControlEventEditingDidBegin];
//    [self.registeButton addTarget:self action:@selector(sendRsetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.registeButton addTarget:self action:@selector(sendVerifyEmploye) forControlEvents:UIControlEventTouchDown];
    
}
- (void)alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.passwordField resignFirstResponder];
//    [self.usernameField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
}



- (void)regBackToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
