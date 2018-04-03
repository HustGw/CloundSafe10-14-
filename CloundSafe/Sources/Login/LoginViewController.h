//
//  LoginViewController.h
//  rc
//
//  Created by 余笃 on 16/3/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoginViewController : UIViewController
@property (nonatomic, strong) UIButton *Checkbox;
@property (nonatomic, assign) BOOL CheckboxBtn;
@property (nonatomic, retain) UITextField *UseforForget;
- (BOOL)CheckboxClick:(UIButton*)btn;

@end
