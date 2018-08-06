//
//  FJLoginViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/4.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJLoginViewController.h"
#import "FJRegisterViewController.h"
#import "FJFindPwdViewController.h"

@interface FJLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation FJLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [button setTitleColor:FJRGBColor(0, 130, 188) forState:UIControlStateNormal];
    [button sizeToFit];
    [button.titleLabel setFont:FJNavbarItemFont];
    [button addTarget:self action:@selector(onClickRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.fromRegParams) {
        self.phone.text = self.fromRegParams[@"phone"];
        self.password.text = self.fromRegParams[@"password"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.fromRegParams = nil;
    [FJProgressHUB dismiss];
    [HttpTool cancel];
}

- (IBAction)onClickLogin:(id)sender
{
    NSString* phone = self.phone.text;
    NSString* password = self.password.text;
    
    if ([phone isNullString] || phone.length != 11 || ![phone isPhoneNumber]) {
        [FJProgressHUB showInfoWithMessage:@"请输入正确的手机号" withTimeInterval:kTimeHubInfo];
        [self.phone becomeFirstResponder];
        return;
    }
    
    if ([password isNullString] || ![password isPasswordValid]) {
        [FJProgressHUB showInfoWithMessage:@"请输入正确的密码" withTimeInterval:kTimeHubInfo];
        [self.password becomeFirstResponder];
        return;
    }
    
    [HttpTool loginWithPhone:phone password:password success:^(id retObj) {
        NSDictionary* retDict = (NSDictionary*)retObj;
        if (!retObj || ![retObj isKindOfClass:[NSDictionary class]] || retDict[@"data"] == nil) {
            DLog(@"登录失败，返回数据错误 - %@", retObj);
            [FJProgressHUB showErrorWithMessage:@"登录失败，返回数据错误" withTimeInterval:kTimeHubError];
            return;
        }
    
        DLog(@"登录成功-%@", retObj);
       
        NSString* code = [NSString stringWithFormat:@"%@", retDict[@"code"]];
        NSString* message = [NSString stringWithFormat:@"%@", retDict[@"message"]];
        if ([code isEqualToString:@"1"]) { //登录成功
            [FJProgressHUB showSuccessWithMessage:@"登录成功" withTimeInterval:kTimeHubSuccess];
            UserModel* userModel = [UserModel mj_objectWithKeyValues:retDict[@"data"]];
            [UserAuth saveUserInfo:userModel] ;
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            DLog(@"登录失败-%@", code);
            [FJProgressHUB showErrorWithMessage:message withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        DLog(@"登录失败-%@", error);
        [FJProgressHUB showErrorWithMessage:@"登录失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
}

- (IBAction)onClickForgetPwd:(id)sender
{
    FJFindPwdViewController* findVC = [FJFindPwdViewController new];
    [self.navigationController pushViewController:findVC animated:YES];
}

- (void)onClickRegister:(UIButton*)sender
{
    FJRegisterViewController* registerVC = [[FJRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phone) { //next
        [self.password becomeFirstResponder];
        return NO;
    }
    [self.view endEditing:YES];
    return YES;
}

@end


