//
//  CSGestureResultViewController.m
//  CloundSafe
//
//  Created by Esphy on 2017/7/31.
//
//

#import "CSGestureResultViewController.h"
#import "CSGesturePassWord.h"
#import "CSPictureCollectionController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIView+Layout.h"
#import "CSVedioCollectionController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface CSGestureResultViewController ()
@property(nonatomic,strong)UIButton *ForgetButton;

@end

@implementation CSGestureResultViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"手势验证"];
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [left setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = left;
    self.fd_interactivePopDisabled = YES;
    [self bttomForgetButton];
    [self bulidUi];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)bulidUi{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setGesturePasswordView];
}

-(void)setGesturePasswordView{
    CSGesturePassWord *view = [[CSGesturePassWord alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH)*0.5,SCREEN_WIDTH,SCREEN_WIDTH) WithState:GestureResultPassword];
    [self.view addSubview:view];
    view.sendReaultData = ^(NSString *str){
        NSString *userName = [userDefaults valueForKey:@"userName"];
        NSString *isPicture = [userDefaults valueForKey:@"isPicture"];
        NSLog(@"%@",isPicture);
        if([isPicture isEqualToString:@"YES"]){
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:userName]isEqualToString:str]) {
            CSPictureCollectionController *myEncryption = [[CSPictureCollectionController alloc]init];
            [self.navigationController pushViewController:myEncryption animated:YES];
            return YES;
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示框"message:@"手势错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
        
        }
        else{
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:userName]isEqualToString:str]) {
            CSVedioCollectionController *vedioC = [[CSVedioCollectionController alloc]init];
            [self.navigationController pushViewController:vedioC animated:YES];
            return YES;
            }
            else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"手势错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return NO;
        }

//            
        }return NO;
    };
}
-(void)bttomForgetButton{
    _ForgetButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-44, self.view.frame.size.height-50, 88 , 44)];
    self.ForgetButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.ForgetButton.enabled = YES;
    [self.ForgetButton addTarget:self action:@selector(ForgetGesture) forControlEvents:UIControlEventTouchUpInside];
    [self.ForgetButton setTitle:@"忘记手势?" forState:UIControlStateNormal];
    [self.ForgetButton setTitleColor:[UIColor colorWithRed:0.19 green:0.76 blue:0.49 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:_ForgetButton];
}

-(void)ForgetGesture{
    
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"重置手势" message:@"请输入登录密码" preferredStyle:UIAlertControllerStyleAlert];
    [alterController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"密码";
        textField.secureTextEntry = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *pwdAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UITextField *login = alterController.textFields.firstObject;
        NSString *containt = login.text;
        NSLog(@"输入内容为%@",containt);
        NSString *UserPwd = [userDefaults valueForKey:@"userPassword"];
        NSLog(@"%@",UserPwd);
        if([containt isEqualToString:UserPwd]){
            NSString *userName = [userDefaults valueForKey:@"userName"];
            [userDefaults setValue:nil forKey:userName];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            UIAlertController *warmController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [warmController addAction:cancelAction];
            [self presentViewController:warmController animated:YES completion:nil];
            
        }
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    pwdAction.enabled=NO;
    [alterController addAction:cancelAction];
    [alterController addAction:pwdAction];
    [self presentViewController:alterController animated:YES completion:nil];
    
}

-(void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if(alertController){
        UITextField *pwd = alertController.textFields.firstObject;
        UIAlertAction *pwdAction = alertController.actions.lastObject;
        pwdAction.enabled= pwd.text.length>0;
    }
}

@end
