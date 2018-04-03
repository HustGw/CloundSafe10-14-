//
//  CSGestureViewController.m
//  CloundSafe
//
//  Created by Esphy on 2017/7/31.
//
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "CSGestureViewController.h"
#import "CSGesturePassWord.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CSGestureResultViewController.h"
@interface CSGestureViewController ()
@property(nonatomic,strong)CSGesturePassWord *passwordView;
@end

@implementation CSGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设置手势密码"];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [left setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = left;
    self.fd_interactivePopDisabled = YES;
    [self bulidUi];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)bulidUi{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setGesturePasswordView];
}

-(void)setGesturePasswordView{
    CSGesturePassWord *view = [[CSGesturePassWord alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH)*0.5,SCREEN_WIDTH,SCREEN_WIDTH) WithState:GestureSetPassword];
    [self.view addSubview:view];
    view.setPwdBlock =  ^(SetPwdState pwdState){
        //可以做加密处理
        NSLog(@"str is value%d",pwdState);
        switch (pwdState) {
            case FristPwd:
            {
                //第一次设置密码
                NSLog(@"第一次设置密码");
            }
                break;
            case PwdNoValue:
            {
                //二次设置不一致
                NSLog(@"二次设置不一致");
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示框"message:@"两次手势不一样，请重新设置" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                // 清空
                NSString *userName = [userDefaults valueForKey:@"userName"];
                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:userName];
            }
                break;
            case SetPwdSuccess:
            {
                //设置成功
                UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:@"提示"message:@"手势设置成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    CSGestureResultViewController *vm = [[CSGestureResultViewController alloc]init];
                    [self.navigationController pushViewController:vm animated:YES];
                }];
                [alertController1 addAction:okAction];
                [self presentViewController:alertController1 animated:YES completion:nil];
                CSGestureResultViewController *vc = [[CSGestureResultViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                NSLog(@"设置成功");
                
            }
                break;
                
            default:
                break;
        }
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
