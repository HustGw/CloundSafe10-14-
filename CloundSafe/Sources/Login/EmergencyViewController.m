//
//  EmergencyViewController.m
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/5.
//

#import "EmergencyViewController.h"
#import "MyTextField.h"

static CGFloat const kContainViewYNormal = 70.0;
@interface EmergencyViewController ()
@property (nonatomic, strong)MyTextField *usernameField;
@property (nonatomic, strong)MyTextField *passwordField;
@property (nonatomic, strong) UIImageView   *leftUsernameView;
@property (nonatomic, strong) UIImageView   *leftPasswdView;
@property (nonatomic, strong) UIButton  *IsEmergencyButton;
@property (nonatomic, strong) UIView      *containView;
@property (nonatomic, assign) BOOL          isKeyboardShowing;
@property (nonatomic, assign) BOOL          isLogining;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@end

@implementation EmergencyViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.isKeyboardShowing = NO;
        self.isLogining = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"账号冻结";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self configureTextfield];
}
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}
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

-(void)configureTextfield
{
    self.containView = [[UIView alloc] init];
    [self.view addSubview:self.containView];
    self.containView.frame = (CGRect){0,kContainViewYNormal,kScreenWidth,kScreenHeight};
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
    
    self.IsEmergencyButton = [[UIButton alloc]init];
    self.IsEmergencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.IsEmergencyButton setTitle:@"确认冻结" forState:UIControlStateNormal];
        //self.loginButton.layer.cornerRadius = 20.0f;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame  = CGRectMake(0, 0,self.view.frame.size.width-100,45);
    gradientLayer.cornerRadius = 20.0f;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.1),@(1.0)];
    [gradientLayer setColors:@[(id)[RGB(0x31C2B1,1) CGColor],(id)[RGB(0x1C27C,1) CGColor]]];
    [self.IsEmergencyButton.layer addSublayer:gradientLayer];
    self.IsEmergencyButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.IsEmergencyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.IsEmergencyButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.IsEmergencyButton addTarget:self action:@selector(gofreeze) forControlEvents:UIControlEventTouchUpInside];
    [self.containView addSubview:self.IsEmergencyButton];
    
    
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
    
    [self.IsEmergencyButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.top.equalTo(self.passwordField.mas_bottom).offset(60);
        make.height.equalTo(@45);
    }];
}

-(void)gofreeze
{
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
                    NSDictionary *parameters =@{
                                                @"emp_phone":self.usernameField.text,
                                                @"emp_password":self.passwordField.text
                                                };
                    [[AFHTTPSessionManager manager] POST:FreezeURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        
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
                                    self.HUD.mode = MBProgressHUDModeCustomView;
                                    self.HUD.label.text = @"冻结成功！";
                                    [self.HUD hideAnimated:YES afterDelay:1.6];
                                    [self backtoLoginVC];
                                    }
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

-(void)backtoLoginVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
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
