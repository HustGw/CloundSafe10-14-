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
@property (nonatomic ,strong)UILabel *statusLabel;
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
    [self topStatusLabel];
    // Do any additional setup after loading the view.
}
-(void)topStatusLabel{
    CGSize statusLabelSize = [self sizeWithText:@"请绘制手势密码" maxSize:CGSizeMake(100,100) fontSize:16.0];
    NSLog(@"the width is %f",statusLabelSize.width);
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.navigationController.navigationBar.frame.size.height+60, 200, statusLabelSize.height)];
    self.statusLabel.text = @"请绘制手势密码";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.textColor = [UIColor colorWithRed:0.19 green:0.76 blue:0.49 alpha:1];
    self.statusLabel.font = [UIFont systemFontOfSize:16.0];
    //self.statusLabel.frame = CGRectMake(self.view.frame.size.width/2-statusLabelSize.width/2, self.navigationController.navigationBar.frame.size.height+10, 100, 50);
    [self.view addSubview:self.statusLabel];
    
    
}
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
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
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示框"message:@"手势错误" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
            self.statusLabel.text = @"手势错误！请重新输入";
            self.statusLabel.textColor = [UIColor redColor];
            [self shakeAnimationForView:self.statusLabel];
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
-(void)shakeAnimationForView:(UIView *)view{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x-10, position.y);
    CGPoint right = CGPointMake(position.x+10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
    
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
