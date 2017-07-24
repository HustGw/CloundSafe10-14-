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
    
    self.navigationItem.title = @"密码重置";
    self.usernameField.text = [userDefaults valueForKey:@"userName"];
    self.usernameField.hidden = YES;
}

@end
