//
//  UnfreezeViewController.m
//  CloundSafe
//
//  Created by 宁莉莎 on 2018/5/5.
//

#import "UnfreezeViewController.h"
#import "EnsureUnfreezeViewController.h"

static CGFloat const kContainViewYNormal = 70.0;
@interface UnfreezeViewController ()
@property (nonatomic, strong) UIButton  *UnEmergencyButton;
@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@end

@implementation UnfreezeViewController
static NSString *const description1 = @"您的账号已经被冻结，如果您想解冻的话请点击解冻按钮，系统会发送一个验证码到您的邮箱";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"账号解冻";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [leftButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configure
{
    self.containView = [[UIView alloc] init];
    [self.view addSubview:self.containView];
    self.containView.frame = (CGRect){0,kContainViewYNormal,kScreenWidth,kScreenHeight};
    self.UnEmergencyButton = [[UIButton alloc]init];
    self.UnEmergencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.UnEmergencyButton setTitle:@"是否解冻" forState:UIControlStateNormal];
        //self.loginButton.layer.cornerRadius = 20.0f;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame  = CGRectMake(0, 0,self.view.frame.size.width-100,45);
    gradientLayer.cornerRadius = 20.0f;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.1),@(1.0)];
    [gradientLayer setColors:@[(id)[RGB(0x31C2B1,1) CGColor],(id)[RGB(0x1C27C,1) CGColor]]];
    [self.UnEmergencyButton.layer addSublayer:gradientLayer];
    self.UnEmergencyButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.UnEmergencyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.UnEmergencyButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.UnEmergencyButton addTarget:self action:@selector(gofreeze) forControlEvents:UIControlEventTouchUpInside];
    [self.containView addSubview:self.UnEmergencyButton];
    [self.UnEmergencyButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(50);
        make.top.equalTo(self.containView.mas_top).offset(262);
        make.right.equalTo(self.containView.mas_right).offset(-50);
        make.height.equalTo(@45);
    }];
    CGSize size1 = [self sizeWithText:description1 maxSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) fontSize:14];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0,100, self.view.bounds.size.width,size1.height)];
    self.label.text = description1;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:14];
    [self.containView addSubview:self.label];
}

-(void)gofreeze
{
    NSString *username = [userDefaults valueForKey:@"userName"];
    NSLog(@"%@",username);
    NSDictionary *parameters = @{@"emp_phone":username};
    [[AFHTTPSessionManager manager]POST:AcquireEmailcodeURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        NSString *content = [responseObject valueForKey:@"content"];
        if([status isEqualToString:@"Success"])
            {
            if([content isEqualToString:@"sendcode success"])
                {
                NSLog(@"验证码发送成功");
                [self showSuccess:@"验证码发送成功"];
                [self toEnsureVC];
                }else if ([content isEqualToString:@"sendfail"])
                    {
                    NSLog(@"验证码发送失败");
                    [self showSuccess:@"验证码发送失败"];
                    }
            }else
                {
                NSLog(@"Fail 服务器内部出错，content无内容");
                }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败：%@",error);
    }];
}

- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
        //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
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

#pragma mark 到确认解冻界面
-(void)toEnsureVC
{
    EnsureUnfreezeViewController *EnsureUnfreezeVC = [[EnsureUnfreezeViewController alloc]init];
     [self.navigationController pushViewController:EnsureUnfreezeVC animated:YES];
}

- (void) back{
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
