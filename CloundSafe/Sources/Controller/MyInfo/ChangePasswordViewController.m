//
//  ChangePasswordViewController.m
//  CloundSafe
//
//  Created by AlanZhang on 16/9/18.
//
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20.0/255.0 green:205.0/255.0 blue:111.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"密码重置";
    self.usernameField.text = [userDefaults valueForKey:@"userName"];
    self.usernameField.hidden = YES;
}

@end
