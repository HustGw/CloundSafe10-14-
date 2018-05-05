//
//  LoginViewController.m
//  rc
//
//  Created by 余笃 on 16/3/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//
#define DDHidden_TIME   3.0


#import "LoginViewController.h"
#import "MyTextField.h"
#import "RCUtils.h"
#import "NSString+MD5.h"
#import "RegisteViewController.h"
#import "ResetPasswordViewController.h"
#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "OffLinePhoneBookController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CSMyInfoController.h"
#import "CSEncrytionController.h"
#import "DHGuidePageHUD.h"
#import "EmergencyViewController.h"

static CGFloat const kContainViewYNormal = 70.0;
@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView      *containView;

@property (nonatomic, strong) UIImageView     *logoImageView;
//@property (nonatomic, strong) UILabel     *descriptionLabel;
//@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic, strong) MyTextField   *usernameField;
@property (nonatomic, strong) MyTextField   *passwordField;
@property (nonatomic, strong) UITextField   *CheckboxField;
@property (nonatomic, strong) UIImageView   *leftUsernameView;
@property (nonatomic, strong) UIImageView   *leftPasswdView;
@property (nonatomic, strong) UIButton      *forgetPwdButton;
@property (nonatomic, strong) UIButton      *loginButton;
@property (nonatomic, strong) UIButton      *rememberButton;
@property (nonatomic, strong) UIButton      *registerButton;
@property (nonatomic, strong) UIButton      *Emergency;
@property (nonatomic, assign) BOOL          isKeyboardShowing;
@property (nonatomic, assign) BOOL          isLogining;
@property (nonatomic, strong) MBProgressHUD    *HUD;


@end

@implementation LoginViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.isKeyboardShowing = NO;
        self.isLogining = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        // 静态引导页
        [self setStaticGuidePage];
        
        // 动态引导页
        // [self setDynamicGuidePage];
        
        // 视频引导页
        // [self setVideoGuidePage];
    }else{
        NSLog(@"非首次启动");
        NSArray *imageName = @[@"guideImage1.png"];
        DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageName buttonIsHidden:NO];
        [self.navigationController.view addSubview:guidePage];
        
    }
    
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0/255.0 green:205.0/255.0 blue:111.0/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureViews];
    [self configureTextField];

    if (([userDefaults valueForKey:@"userName"] == nil ||[[userDefaults valueForKey:@"userName"]isEqualToString:@""]) && ([userDefaults valueForKey:@"userPassword"] == nil ||[[userDefaults valueForKey:@"userPassword"]isEqualToString:@""]))
    {//用户未登录
        ;
    }else
    {
        //登录成功创建用户目录
        NSString *userName = [userDefaults valueForKey:@"userName"];
        NSString *userDirectory = [NSString stringWithFormat:@"%@/%@",DocumentPath, userName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory ])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.usernameField.text = userName;
        NSNumber *num = [userDefaults valueForKey:NEEDLOGIN];
        if (num.boolValue) {
            [self loginWithTouchID];
        }
        
    }
    
}

- (void)setStaticGuidePage {
        NSArray *imageNameArray = @[@"guideImage1.png",@"guideImage2.png",@"guideImage3.png",@"guideImage4.png"];
        DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:NO];
        guidePage.slideInto = YES;
        [self.navigationController.view addSubview:guidePage];
    }
//指纹登录
- (void)loginWithTouchID
{
    //1. 判断系统版本
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        //2. LAContext : 本地验证对象上下文
        LAContext *context = [LAContext new];
        
        //3. 判断是否可用
        //Evaluate: 评估  Policy: 策略,方针
        //LAPolicyDeviceOwnerAuthenticationWithBiometrics: 允许设备拥有者使用生物识别技术
        if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            NSLog(@"对不起, 指纹识别技术暂时不可用");
        }
        
        //4. 开始使用指纹识别
        //localizedReason: 指纹识别出现时的提示文字, 一般填写为什么使用指纹识别
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                NSLog(@"指纹识别成功");
                // 指纹识别成功，回主线程更新UI,弹出提示框
                dispatch_async(dispatch_get_main_queue(), ^{
                    //判断用户此时是否登录
                    NSNumber *isLogin = [userDefaults valueForKey:ISLOGIN];
                    if (isLogin.boolValue) {
                        //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                        //由storyboard根据myView的storyBoardID来获取我们要切换的视图
                        UIViewController *homeController = [story instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        appDelegate.window.rootViewController = homeController;
                        [userDefaults setObject:@(NO) forKey:NEEDLOGIN];
                    }else{
                        self.passwordField.text = [userDefaults valueForKey:@"userPassword"];
                        [self login];
                    }
                   
                });
                
            }

            
        }];
    } else {
        
        NSLog(@"对不起, 该手机不支持指纹识别");
    }

}
#pragma mark - Layout

-(void)viewWillLayoutSubviews
{
    self.backgroundImageView.frame = self.view.frame;
    
    self.containView.frame = (CGRect){0,kContainViewYNormal,kScreenWidth,kScreenHeight};
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.containView.mas_top).offset(10);
        make.centerX.equalTo(self.containView);
        make.height.mas_equalTo(88);
        make.width.mas_equalTo(88);
        
    }];
    
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGSize maxSize= CGSizeMake(screenSize.width * 0.5, MAXFLOAT);
    CGSize forgetSize = [self sizeWithText:@"忘记密码？" maxSize:maxSize fontSize:14.0];
    CGSize EnergencySize = [self sizeWithText:@"紧急冻结？" maxSize:CGSizeMake(100,100) fontSize:14.0];
    [self.usernameField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.containView.mas_top).offset(162);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
    [self.passwordField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.usernameField.mas_bottom).offset(20);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
//    [self.CheckboxField mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.containView.mas_left).offset(75);
//        make.top.equalTo(self.passwordField.mas_bottom).offset(20);
//        make.right.equalTo(self.containView.mas_right).offset(-50);
//        make.height.equalTo(@30);
//    }];
    
    [self.forgetPwdButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginButton.mas_right);
        make.bottom.equalTo(self.Checkbox.mas_bottom).offset(2);
//        make.left.equalTo(self.view).offset(10);
//        make.bottom.equalTo(self.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(forgetSize.width+10, forgetSize.height+10));
    }];
    
    [self.loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.top.equalTo(self.passwordField.mas_bottom).offset(60);
        make.height.equalTo(@45);
    }];
    
    [self.Emergency mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.top.equalTo(self.loginButton.mas_bottom).offset(60);
        make.size.mas_equalTo(CGSizeMake(EnergencySize.width+10, EnergencySize.height+10));
    }];
    CGSize registerSize = [self sizeWithText:@"新用户注册" maxSize:CGSizeMake(100,100) fontSize:14.0];
    CGSize rememberSize = [self sizeWithText:@"记住用户名" maxSize:CGSizeMake(100,100) fontSize:14.0];
    
    [self.registerButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_centerX).offset(-(int)registerSize.width/2);
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
//        make.right.equalTo(self.view).offset(-10);
//        make.bottom.equalTo(self.view).offset(-10);
        make.height.mas_equalTo((int)registerSize.height+1);
        make.width.mas_equalTo((int)registerSize.width+1);
    }];
    [self.rememberButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Checkbox.mas_right);
        make.bottom.equalTo(self.Checkbox.mas_bottom).offset(-2);
        //        make.right.equalTo(self.view).offset(-10);
        //        make.bottom.equalTo(self.view).offset(-10);
        make.height.mas_equalTo((int)rememberSize.height+1);
        make.width.mas_equalTo((int)rememberSize.width+1);
    }];
}

#pragma mark - UITextFeildDelegate
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
        if ([textField.text isEqualToString:@""])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
        }
    }else
    {
        if ([textField.text isEqualToString:@""])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码"attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
        }

    }
}


#pragma mark - Configure Views

-(void)configureViews
{
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568_blurred"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.containView = [[UIView alloc] init];
    [self.view addSubview:self.containView];

    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"login_logo"];
    [self.containView addSubview:self.logoImageView];
    
    self.rememberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rememberButton setTitleColor:RGB(0x11cd6e, 1) forState:UIControlStateNormal];
    self.rememberButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.rememberButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.rememberButton.layer.borderWidth = 0;
    [self.rememberButton setTitle:@"记住用户名" forState:UIControlStateNormal];
    [self.rememberButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    [self.containView addSubview:self.rememberButton];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.registerButton.layer.borderWidth = 0;
    [self.registerButton setTitle:@"新用户注册" forState:UIControlStateNormal];
    [self.forgetPwdButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(turnToRegisteViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.containView addSubview:self.registerButton];

}

- (void)configureTextField{
    
    self.usernameField = [[MyTextField alloc] init];
    self.usernameField.delegate = self;
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
    
    self.passwordField = [[MyTextField alloc] init];
    self.passwordField.delegate = self;
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
    
    self.Checkbox =[[UIButton alloc]initWithFrame:CGRectZero];
    _Checkbox.frame=CGRectMake(60, 265, 20, 20);
    [_Checkbox setImage:[UIImage imageNamed:@"login_xuanzhekuang_nor"] forState:UIControlStateNormal];
    [_Checkbox setImage:[UIImage imageNamed:@"login_xuanzhekuang_sel"] forState:UIControlStateSelected];
    [_Checkbox addTarget:self action:@selector(CheckboxClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [_Checkbox setSelected:NO];
    [self.containView addSubview:self.Checkbox];
    
    self.forgetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forgetPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.forgetPwdButton setTitleColor:[UIColor colorWithRed:0.4 green:0.40 blue:0.40 alpha:1] forState:UIControlStateNormal];
    self.forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.forgetPwdButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.forgetPwdButton.layer.borderWidth = 0;
    [self.containView addSubview:self.forgetPwdButton];
    
    self.Emergency = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.Emergency setTitle:@"紧急冻结?" forState:UIControlStateNormal];
    [self.Emergency setTitleColor:[UIColor colorWithRed:0.4 green:0.40 blue:0.40 alpha:1] forState:UIControlStateNormal];
    self.Emergency.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.Emergency setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.Emergency.layer.borderWidth = 0;
    [self.containView addSubview:self.Emergency];
    
    self.UseforForget=[[UITextField alloc]init];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    //self.loginButton.layer.cornerRadius = 20.0f;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame  = CGRectMake(0, 0,self.view.frame.size.width-100,45);
    gradientLayer.cornerRadius = 20.0f;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.1),@(1.0)];
    [gradientLayer setColors:@[(id)[RGB(0x31C2B1,1) CGColor],(id)[RGB(0x1C27C,1) CGColor]]];
    [self.loginButton.layer addSublayer:gradientLayer];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.containView addSubview:self.loginButton];
    [self.usernameField addTarget:self action:@selector(goPassword) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordField addTarget:self action:@selector(login) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.forgetPwdButton addTarget:self action:@selector(goResetPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.Emergency addTarget:self action:@selector(goEmergency) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)CheckboxClick:(UIButton*)btn
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    btn.selected=!btn.selected;
    if (btn.selected) {
        _CheckboxBtn =YES;
        
//       [userDefaults setObject:@(YES) forKey:CHECK];
    }else{
        _CheckboxBtn =NO;
//        [userDefaults setObject:@(NO) forKey:CHECK];
    }
     return _CheckboxBtn;
    [ud setBool:_CheckboxBtn forKey:@"hello"];
}

- (void)getContactsAuthorization
{
    //让用户给权限,没有的话会被拒的各位
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined)
    {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"获取通讯录出错:%@",error);
            }else
            {
                NSLog(@"用户已给通讯录权限 ");//用户给权限了
                
            }
            if (granted)
            {
                NSLog(@"已授权访问通讯录");
            }
        }];
    }
    
}
#pragma mare - 紧急冻结
-(void)goEmergency
{
    EmergencyViewController *emergencyViewController = [[EmergencyViewController alloc]init];
    [self.navigationController pushViewController:emergencyViewController animated:YES];
    
}
#pragma mark - Private Methods
#pragma mark - 登录
-(void)login
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setBool:_CheckboxBtn forKey:@"hello"];
    [userDefaults synchronize];
    NSLog(@"Lisa.Login.CheckboxBtn=%d",_CheckboxBtn);
    if (([self.usernameField.text isEqualToString:@""] ||
        [self.usernameField.text length] != 11))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        if ([self.passwordField.text isEqualToString:@""])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else
        {
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            self.HUD.removeFromSuperViewOnHide = YES;
            [self.view addSubview:self.HUD];
            [self.HUD showAnimated:YES];
            
            NSNumber *isLogin = [userDefaults objectForKey:ISLOGIN];
            if (isLogin.boolValue) {
                NSString *password = [userDefaults objectForKey:@"userPassword"];
                if ([password isEqualToString:self.passwordField.text]) {
                    
                    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
                    UIViewController *homeController = [story instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    appDelegate.window.rootViewController = homeController;
                    
                }else{
                    self.HUD.mode = MBProgressHUDModeCustomView;
                    self.HUD.label.text = @"用户名或密码错误！";
                    [self.HUD hideAnimated:YES afterDelay:0.6];

                }

            }else{
                
                NSDictionary *parameters =@{
                                                @"emp_phone":self.usernameField.text,
                                                @"emp_password":self.passwordField.text
                                            };
                [[AFHTTPSessionManager manager] POST:LoginURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    
                    NSString *status = [responseObject valueForKey:@"status"];
                    NSString *content  = [responseObject valueForKey:@"content"];
                    if ([status isEqualToString:@"Success"])
                    {
                        if ([content isEqualToString:@"phonenull"]) {
                            self.HUD.mode = MBProgressHUDModeCustomView;
                            self.HUD.label.text = @"用户不存在！";
                            [self.HUD hideAnimated:YES afterDelay:0.6];
                        }
                        else if ([content isEqualToString:@"passworderror"])
                        {
                            self.HUD.mode = MBProgressHUDModeCustomView;
                            self.HUD.label.text = @"用户名或密码错误！";
                            [self.HUD hideAnimated:YES afterDelay:0.6];
                        }else
                        {
                            //授权访问通讯录
                            [self getContactsAuthorization];
                            //登录成功，保存identity，解密数据库文件
                            [userDefaults setObject:content forKey:@"content"];
                            // 获得加密后的二进制数据
                            NSString *dbPath = [NSString stringWithFormat:@"%@/%@/%@",DocumentPath,self.usernameField.text,DBFILE_NAME];
                            if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath])
                            {
                                NSData *base64Data = [NSData dataWithContentsOfFile:dbPath];
                                // 解密 base64 数据
                                NSData *baseData = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
                                [baseData writeToFile:dbPath atomically:YES];
                            }
                            
                            NSLog(@"登录成功，identity = %@",content);
                            //保存用户名和密码
                            [userDefaults setObject:self.usernameField.text forKey:@"userName"];
                            [userDefaults setObject:self.passwordField.text forKey:@"userPassword"];
                            [userDefaults setObject:@(YES) forKey:ISLOGIN];
                            
                            //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                            //由storyboard根据myView的storyBoardID来获取我们要切换的视图
                            UIViewController *homeController = [story instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            appDelegate.window.rootViewController = homeController;
                            
                            //登录成功创建用户目录
                            NSString *userDirectory = [NSString stringWithFormat:@"%@/%@",DocumentPath, self.usernameField.text];
                            if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory ])
                            {
                                [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
                            }
                            [userDefaults setObject:@(NO) forKey:NEEDLOGIN];
                        }
                        
                        
                    }else
                    {
                        NSLog(@"Fail 服务器内部出错，content无内容");
                        [self.HUD hideAnimated:YES afterDelay:0.6];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    
                    NSLog(@"网络请求失败：%@",error);
                    self.HUD.label.text = @"无网络连接！";
                    [self.HUD hideAnimated:YES afterDelay:0.6];
                    //[self offlineLogin];
                }];
                

            }
            
           
        }
    }
   
}
//无网络连接情况下
- (void)offlineLogin
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前处理离线状态，是否进入通讯录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.HUD hideAnimated:YES afterDelay:0.6];
        // 获得加密后的二进制数据
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@/%@",DocumentPath,self.usernameField.text,DBFILE_NAME];
        [userDefaults setObject:self.usernameField.text forKey:@"userName"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath])
        {
            NSData *base64Data = [NSData dataWithContentsOfFile:dbPath];
            // 解密 base64 数据
            NSData *baseData = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
            [baseData writeToFile:dbPath atomically:YES];
            
        }else
        {
            NSString *userDirectory = [NSString stringWithFormat:@"%@/%@",DocumentPath,self.usernameField.text];
            if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory])
            {
                [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
                [[NSFileManager defaultManager] createFileAtPath:dbPath contents:nil attributes:nil];
            }else
            {
                [[NSFileManager defaultManager] createFileAtPath:dbPath contents:nil attributes:nil];
            }
        }
        OffLinePhoneBookController *vc = [[OffLinePhoneBookController alloc]init];
        CSHomeNavigationController *navi = [[CSHomeNavigationController alloc]initWithRootViewController:vc];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = navi;

    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.HUD hideAnimated:YES afterDelay:0.6];
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)goPassword
{
    [self.passwordField becomeFirstResponder];
}

-(void)goResetPwd{
    NSLog(@"Lisa the uesernameFieldLogin.text=%@",self.usernameField.text);
    self.UseforForget.text=self.usernameField.text;
    ResetPasswordViewController *resetViewController = [[ResetPasswordViewController alloc]init];
    resetViewController.UseforForget1=self.UseforForget;
    [self.navigationController pushViewController:resetViewController animated:YES];
}
#pragma mark - 返回上一界面
- (void)logBackToMyInfoViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 跳转至注册界面
-(void)turnToRegisteViewController
{
    RegisteViewController *registeViewController = [[RegisteViewController alloc]init];
    [self.navigationController pushViewController:registeViewController animated:YES];
}

/**
 *  计算字符串的长度
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
