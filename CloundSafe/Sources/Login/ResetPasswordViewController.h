//
//  resetPasswordViewController.h
//  rc
//
//  Created by 余笃 on 16/4/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"
typedef void(^CheckPhoneBlock)(BOOL isRegister);
@interface ResetPasswordViewController : UIViewController
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView      *containView;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) MyTextField *passwordField;
@property (nonatomic,strong) MyTextField *verifyCodeField;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic,strong) UIButton *verifyCodeButton;
@property (nonatomic,strong) UIImageView *leftUsernameView;
@property (nonatomic,strong) UIImageView *leftPasswdView;
@property (nonatomic,strong) UIImageView *leftVerifyCodeView;
@property (nonatomic, strong) UIButton    *registeButton;

@property (nonatomic, assign) BOOL isKeyboardShowing;
@property (nonatomic,assign) BOOL isReseting;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, copy) CheckPhoneBlock checkPhone_t;
@property (nonatomic,retain) UITextField* UseforForget1;
@property (nonatomic, copy) NSString *number;

- (void)viewDidLoad;
- (void)checkPhone;
-(void)sendVerifyCode;
- (void)resetButton;
-(void)checkUserIdentify:(BOOL) isRequestCode;
-(void)viewWillLayoutSubviews;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
-(void)configureViews;
- (void)configureTextField;
- (void)alert:(NSString *)msg;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)regBackToForwardViewController;
-(void)sendVerifyEmploye;
-(void)sendRsetPassword;
@end
