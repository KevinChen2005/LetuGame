//
//  FJModifyPwdController.m
//  LetuGame
//
//  Created by admin on 2018/7/4.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJModifyPwdController.h"
#import "FJLoginViewController.h"

@interface FJModifyPwdController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldpasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmLabel;

@end

@implementation FJModifyPwdController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"修改密码";
    self.view.backgroundColor =[UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.oldpasswordLabel becomeFirstResponder];
}

// 退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 点击提交
- (IBAction)clickRegister:(id)sender
{
    DLog(@"clickRegister");
    
    NSString* oldpassword = self.oldpasswordLabel.text;
    NSString* password = self.passwordLabel.text;
    NSString* confirm = self.confirmLabel.text;
    
    if ([oldpassword isNullString] || ![oldpassword isPasswordValid]) {
        [FJProgressHUB showInfoWithMessage:@"请输入正确的密码" withTimeInterval:kTimeHubInfo];
        [self.oldpasswordLabel becomeFirstResponder];
        return;
    }
    
    
    if ([password isNullString] || ![password isPasswordValid]) {
        [FJProgressHUB showInfoWithMessage:@"请输入正确的密码" withTimeInterval:kTimeHubInfo];
        [self.passwordLabel becomeFirstResponder];
        return;
    }
    
    if ([confirm isNullString] || ![confirm isPasswordValid]) {
        [FJProgressHUB showInfoWithMessage:@"请输入正确的密码" withTimeInterval:kTimeHubInfo];
        [self.confirmLabel becomeFirstResponder];
        return;
    }
    
    if (![password isEqualToString:confirm]) {
        [FJProgressHUB showInfoWithMessage:@"新密码两次输入不一致" withTimeInterval:kTimeHubInfo];
        [self.confirmLabel becomeFirstResponder];
        return;
    }
    
    if ([password isEqualToString:oldpassword]) {
        [FJProgressHUB showInfoWithMessage:@"新密码和旧密码不能一样" withTimeInterval:kTimeHubInfo];
        [self.passwordLabel becomeFirstResponder];
        return;
    }
    
    [HttpTool modifyPasswordWithOldPwd:oldpassword newPwd:password Success:^(id retObj) {
        NSDictionary* retDict = (NSDictionary*)retObj;
        if (!retObj || ![retObj isKindOfClass:[NSDictionary class]]) {
            DLog(@"修改失败，返回数据错误 - %@", retObj);
            [FJProgressHUB showErrorWithMessage:@"修改失败，返回数据错误" withTimeInterval:kTimeHubError];
            return;
        }
        DLog(@"修改成功-%@", retObj);
        
        NSString* code = [NSString stringWithFormat:@"%@", retDict[@"code"]];
        NSString* message = [NSString stringWithFormat:@"%@", retDict[@"message"]];
        if ([code isEqualToString:@"1"]) { //登录成功
            [FJProgressHUB showSuccessWithMessage:@"修改成功，请重新登录" withTimeInterval:kTimeHubSuccess];
            
            FJLoginViewController*loginVC= [FJLoginViewController new];
            loginVC.fromRegParams = @{
                                      @"password" : password,
                                      @"phone" : [UserAuth shared].userInfo.phone,
                                      };
            [self.navigationController pushViewController:loginVC animated:YES];
        } else {
            DLog(@"修改失败-%@", code);
            [FJProgressHUB showErrorWithMessage:message withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        DLog(@"修改失败-%@", error);
        [FJProgressHUB showErrorWithMessage:@"修改失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
}

#pragma makr - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.oldpasswordLabel) {
        [self.passwordLabel becomeFirstResponder];
        return NO;
    }
    
    if (textField == self.passwordLabel) {
        [self.confirmLabel becomeFirstResponder];
        return NO;
    }
    
    [self.view endEditing:YES];
    return YES;
}

@end
