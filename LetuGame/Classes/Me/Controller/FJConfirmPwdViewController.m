//
//  FJConfirmPwdViewController.m
//  LetuGame
//
//  Created by admin on 2018/12/26.
//  Copyright © 2018 com.langlun. All rights reserved.
//

#import "FJConfirmPwdViewController.h"

@interface FJConfirmPwdViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation FJConfirmPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
//    [self.passwordField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onClickCancel:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onClickConfirm:(id)sender
{
    NSString* password = self.passwordField.text;
    
    if (password == nil || [password isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"请输入密码" withTimeInterval:1.5f];
        return;
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if ([_delegate respondsToSelector:@selector(confirmPwdCallback:)]) {
        [_delegate confirmPwdCallback:password];
    }
}

@end
