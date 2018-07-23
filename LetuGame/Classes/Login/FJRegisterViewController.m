//
//  FJRegisterViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/4.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJRegisterViewController.h"
#import "FJWebViewController.h"
#import "FJLoginViewController.h"

@interface FJRegisterViewController () <UITextFieldDelegate>
{
    BOOL _isAgreeUserProtocol;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *authcodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmLabel;
@property (weak, nonatomic) IBOutlet UITextField *nicknameLabel;

@end

@implementation FJRegisterViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"注册";
    _isAgreeUserProtocol = NO;
    self.view.backgroundColor =[UIColor whiteColor];
}

// 退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 点击注册
- (IBAction)clickRegister:(id)sender
{
    DLog(@"clickRegister");
    
    NSString* phone = self.phoneLabel.text;
    NSString* authcode = self.authcodeLabel.text;
    NSString* nickname = self.nicknameLabel.text;
    NSString* password = self.passwordLabel.text;
    NSString* confirm = self.confirmLabel.text;
    
    if ([phone isNullString] || ![phone isPhoneNumber]) {
        [FJProgressHUB showInfoWithMessage:@"请输入正确的手机号" withTimeInterval:kTimeHubInfo];
        [self.phoneLabel becomeFirstResponder];
        return;
    }
    
    if ([authcode isNullString] || ![authcode isAuthcodeValid]) {
        [FJProgressHUB showInfoWithMessage:@"请输入正确的验证码" withTimeInterval:kTimeHubInfo];
        [self.authcodeLabel becomeFirstResponder];
        return;
    }
    
    if ([nickname isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"请输入正确的昵称" withTimeInterval:kTimeHubInfo];
        [self.nicknameLabel becomeFirstResponder];
        return;
    }
    
    if (![nickname isNicknameValid]) {
        [FJProgressHUB showInfoWithMessage:@"昵称长度错误" withTimeInterval:kTimeHubInfo];
        [self.nicknameLabel becomeFirstResponder];
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
        [FJProgressHUB showInfoWithMessage:@"两次密码输入不一致" withTimeInterval:kTimeHubInfo];
        [self.confirmLabel becomeFirstResponder];
        return;
    }
    
    if (_isAgreeUserProtocol == NO) {
        [FJProgressHUB showInfoWithMessage:@"请同意用户协议" withTimeInterval:kTimeHubInfo];
        return;
    }
    
    [HttpTool registerWithPhone:phone password:password nickname:nickname authcode:authcode success:^(id retObj) {
        NSDictionary* retDict = (NSDictionary*)retObj;
        if (!retObj || ![retObj isKindOfClass:[NSDictionary class]]) {
            DLog(@"注册失败，返回数据错误 - %@", retObj);
            [FJProgressHUB showErrorWithMessage:@"注册失败，返回数据错误" withTimeInterval:kTimeHubError];
            return;
        }
        DLog(@"注册成功-%@", retObj);
        
        NSString* code = [NSString stringWithFormat:@"%@", retDict[@"code"]];
        NSString* message = [NSString stringWithFormat:@"%@", retDict[@"message"]];
        if ([code isEqualToString:@"1"]) { //登录成功
            [FJProgressHUB showSuccessWithMessage:@"注册成功，请登录" withTimeInterval:kTimeHubSuccess];
            
            FJLoginViewController*loginVC= [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            loginVC.fromRegParams = @{
                                      @"phone"    : phone,
                                      @"password" : password,
                                      @"nickname" : nickname,
                                      @"authcode" : authcode,
                                      };
            [self.navigationController popToViewController:loginVC animated:YES];
        } else {
            DLog(@"注册失败-%@", code);
            [FJProgressHUB showErrorWithMessage:message withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        DLog(@"注册失败-%@", error);
        [FJProgressHUB showErrorWithMessage:@"注册失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
}

// 点击显示用户协议
- (IBAction)clickUserProtocol:(id)sender
{
    DLog(@"clickUserProtocol");
    
    FJWebViewController* vc = [FJWebViewController new];
    vc.htmlString = [CommTool contentForFileName:@"me_user_protocol" ofType:@"html"];
    [self.navigationController pushViewController:vc animated:YES];
}

// 同意用户协议
- (IBAction)clickAgreeProtocol:(id)sender
{
    DLog(@"clickAgreeProtocol");
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    _isAgreeUserProtocol = btn.isSelected;
}

// 获取验证码
- (IBAction)clickRequestAuthenCode:(id)sender
{
    DLog(@"clickRequestAuthenCode");
    
    NSString* phone = self.phoneLabel.text;
    
    if ([phone isNullString] || ![phone isPhoneNumber]) {
        [FJProgressHUB showInfoWithMessage:@"请输入正确的手机号" withTimeInterval:kTimeHubInfo];
        [self.phoneLabel becomeFirstResponder];
        return;
    }
    
    [self openCountdown:sender];
    
    [HttpTool fetchVerifyCodeWithPhone:phone Success:^(id retObj) {
        NSDictionary* retDict = (NSDictionary*)retObj;
        NSString* code = [NSString stringWithFormat:@"%@", retDict[@"code"]];
        NSString* message = retDict[@"message"];
        if ([code isEqualToString:@"1"]) { //获取验证码成功
            DLog(@"获取验证码成功-%@", retObj);
        } else {
            DLog(@"获取验证码失败-%@", retObj);
            [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.5f];
        }
    } failure:^(NSError *error) {
        DLog(@"fetchVerifyCode faile - %@", error);
    }];
}

// 开启倒计时效果
-(void)openCountdown:(UIButton*)btn
{
    UIColor* orgColor = btn.titleLabel.textColor;
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                [btn setTitleColor:orgColor forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [btn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma makr - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nicknameLabel) {
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
