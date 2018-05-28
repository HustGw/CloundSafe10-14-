//
//  ResetEmailViewController.m
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/23.
//

#import "ResetEmailViewController.h"
#import "MyTextField.h"

@interface ResetEmailViewController ()<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isRighrtmailbox;
@property (nonatomic, assign)  MyTextField *emailBox;

@end

@implementation ResetEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0/255.0 green:205.0/255.0 blue:111.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"邮箱修改";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    self.emailBox = [[MyTextField alloc]initWithFrame:CGRectMake(0,64, kScreenWidth, 45)];
    self.emailBox.delegate = self;
    self.emailBox.textColor = [UIColor blackColor];
    self.emailBox.font = [UIFont systemFontOfSize:14];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,10,45 )];
    self.emailBox.leftView = leftView;
    self.emailBox.leftViewMode = UITextFieldViewModeAlways;
//  self.emailBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新邮箱"        attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],                                                                               NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
//    self.emailBox.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入新邮箱" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.000],NSFontAttributeName:[UIFont italicSystemFontOfSize:14]}];
    self.emailBox.keyboardType = UIKeyboardTypeASCIICapable;
    self.emailBox.returnKeyType = UIReturnKeyGo;
    self.emailBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailBox.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailBox.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.emailBox];
}

-(void)ensure
{
    self.isRighrtmailbox = [self isValidateEmail:self.emailBox.text];
    if(self.isRighrtmailbox == NO)
        {
        [self alert:@"邮箱填写错误"];
        }else
            {
            NSString *useridentify = [userDefaults valueForKey:@"userIdentify"];
            NSLog(@"useridentify is %@",useridentify);
            NSString *url = UpdataUserInfoURL;
            NSString *emil_box = self.emailBox.text;
            NSDictionary *parameters =[[NSDictionary alloc]initWithObjectsAndKeys:useridentify, @"user_identify",emil_box,@"emp_email",nil];
            [[AFHTTPSessionManager manager]POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSString *status = [responseObject valueForKey:@"status"];
                NSString *content = [responseObject valueForKey:@"content"];
                if ([status isEqualToString:@"Success"]) {
                    if ([content isEqualToString:@"employee is null"]) {
                        [self alert:@"用户不存在"];
                    }else if([content isEqualToString:@"update success"])
                        {
                        [self alert:@"更新成功"];
                        }
                }else{
                    [self alert:@"服务器无响应"];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"网络请求失败：%@",error);
                [self alert:@"无网络连接！"];
            }];
            }
}

- (void)alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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
