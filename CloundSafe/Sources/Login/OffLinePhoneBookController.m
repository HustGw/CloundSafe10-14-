//
//  OffLinePhoneBookController.m
//  CloundSafe
//
//  Created by AlanZhang on 2016/10/26.
//
//

#import "OffLinePhoneBookController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface OffLinePhoneBookController ()

@end

@implementation OffLinePhoneBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(back)]];
    [self getContactsAuthorization];
}
- (void)getContactsAuthorization
{
    //让用户给权限,没有的话会被拒的各位
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined)
    {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {

            if (granted)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getContact];
                    self.contactAuthorizationLabel.hidden = YES;
                    [self.tableView reloadData];
                });

            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.contactAuthorizationLabel.hidden = NO;
                });
                
            }
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UINavigationController *navigationVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    appDelegate.window.rootViewController = navigationVC;
    
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
