//
//  EnsureUnfreezeViewController.m
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/7.
//

#import "EnsureUnfreezeViewController.h"

@interface EnsureUnfreezeViewController ()
@property (nonatomic, strong)UITextField *VerifyCode;
@property (nonatomic, strong)UIView *containView;
@property (nonatomic, strong)UIButton *EnsureButton;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@end

@implementation EnsureUnfreezeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"确认解冻";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self configure];
}

- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configure
{
    self.containView = [[UIView alloc] init];
    [self.view addSubview:self.containView];
    self.containView.frame = (CGRect){0,70.0,kScreenWidth,kScreenHeight};
    self.VerifyCode = [[UITextField alloc]init];
    self.VerifyCode.font = [UIFont systemFontOfSize:14];
    self.VerifyCode.keyboardType = UIKeyboardTypeNumberPad;
    self.VerifyCode.returnKeyType = UIReturnKeyNext;
    self.VerifyCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.VerifyCode.autocorrectionType = UITextAutocorrectionTypeNo;
    self.VerifyCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.VerifyCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.VerifyCode.rightViewMode = UITextFieldViewModeWhileEditing;
    self.VerifyCode.layer.borderWidth=1.0f;
    self.VerifyCode.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    [self.containView addSubview:self.VerifyCode];
    self.EnsureButton = [[UIButton alloc]init];
    self.EnsureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.EnsureButton setTitle:@"确认解冻" forState:UIControlStateNormal];
        //self.loginButton.layer.cornerRadius = 20.0f;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame  = CGRectMake(0, 0,self.view.frame.size.width-100,45);
    gradientLayer.cornerRadius = 20.0f;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.1),@(1.0)];
    [gradientLayer setColors:@[(id)[RGB(0x31C2B1,1) CGColor],(id)[RGB(0x1C27C,1) CGColor]]];
    [self.EnsureButton.layer addSublayer:gradientLayer];
    self.EnsureButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.EnsureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.EnsureButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.EnsureButton addTarget:self action:@selector(EnsureUnfreeze) forControlEvents:UIControlEventTouchUpInside];
    [self.containView addSubview:self.EnsureButton];
    [self.EnsureButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.containView.mas_top).offset(262);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@45);
    }];
    [self.VerifyCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.containView.mas_top).offset(162);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
}

-(void)EnsureUnfreeze
{
    NSString *code = self.VerifyCode.text;
    NSString *username = [userDefaults valueForKey:@"userName"];
    NSString *password = [userDefaults valueForKey:@"userPassword"];
    NSDictionary *parameter = @{@"emp_phone":username,@"emp_password":password,@"code":code};
    [[AFHTTPSessionManager manager]POST:UnfreezeURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        NSString *content = [responseObject valueForKey:@"content"];
        if([status isEqualToString:@"Success"])
            {
            if([content isEqualToString:@"unfreezing"])
                {
                NSLog(@"解冻成功");
                [self showSuccess:@"解冻成功"];
                [self goBcaktoLogin];
                }else if ([content isEqualToString:@"code error"])
                    {
                    NSLog(@"验证码错误");
                    [self showSuccess:@"验证码错误"];
                    }else if ([content isEqualToString:@"code invalid"])
                    {
                         NSLog(@"验证码失效");
                        [self showSuccess:@"验证码失效"];
                   }
            }else{
                 NSLog(@"Fail 服务器内部出错，content无内容");
            }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败：%@",error);
    }];
}

#pragma mark - 缓冲
-(void)showSuccess:(NSString *)success
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.label.text = success;
    [self.HUD hideAnimated:YES afterDelay:0.6];
}

-(void)goBcaktoLogin
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
